import PhotosUI
import SwiftUI
import UIKit

struct ContributionView: View {
    let barcode: String
    let initialSource: ProductSource?
    let product: Product?
    let onBack: () -> Void

    @State private var form: ContributionFormData
    @State private var source: ProductSource
    @State private var isSubmitting = false
    @State private var contributionResult: ContributionResult?
    @State private var photoImages: [ProductImageType: UIImage] = [:]
    @State private var photoStates: [ProductImageType: PhotoUploadState] = [:]
    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var pendingPhotoType: ProductImageType?
    @State private var showingPhotosPicker = false
    @State private var showingCamera = false
    @State private var showingIngredientScanner = false
    @State private var isRecognizingIngredients = false
    @State private var ocrMessageKey: String?

    private let service = ContributionService()

    init(
        barcode: String,
        initialSource: ProductSource?,
        product: Product?,
        onBack: @escaping () -> Void
    ) {
        self.barcode = barcode
        self.initialSource = initialSource
        self.product = product
        self.onBack = onBack
        _form = State(initialValue: product.map(contributionFormData(from:)) ?? ContributionFormData())
        _source = State(initialValue: initialSource ?? .openFoodFacts)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                ContributionCard(title: L("contribution_title")) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(L("contribution_description"))
                            .foregroundStyle(.secondary)
                        Text(LF("contribution_barcode", barcode))
                            .font(.subheadline.weight(.semibold))
                        Text(L("contribution_anonymous_note"))
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                }

                ContributionCard(title: L("contribution_database_title")) {
                    Picker(L("contribution_database_title"), selection: $source) {
                        ForEach(ProductSource.allCases, id: \.self) { option in
                            Text(option.displayName).tag(option)
                        }
                    }
                    .pickerStyle(.menu)
                }

                contributionField("contribution_product_name", text: $form.productName)
                contributionField("contribution_brands", text: $form.brands)
                contributionField("contribution_quantity", text: $form.quantity)
                contributionField("contribution_categories", text: $form.categories)
                ingredientsField
                contributionField("contribution_labels", text: $form.labels)

                photosSection

                Button {
                    submitContribution()
                } label: {
                    Text(isSubmitting ? L("contribution_sending") : L("contribution_submit"))
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .disabled(isSubmitting)

                if let contributionResult {
                    Text(contributionMessage(contributionResult))
                        .foregroundStyle(contributionResult == .success ? .green : .red)
                }

                Button(L("cancel"), action: onBack)
                    .frame(maxWidth: .infinity)
                    .buttonStyle(.bordered)
            }
            .padding()
        }
        .navigationTitle(L("contribution_title"))
        .navigationBarTitleDisplayMode(.inline)
        .photosPicker(
            isPresented: $showingPhotosPicker,
            selection: $selectedPhotoItem,
            matching: .images
        )
        .onChange(of: selectedPhotoItem) { _, item in
            guard let item, let type = pendingPhotoType else { return }
            Task { await loadSelectedPhoto(item, type: type) }
        }
        .sheet(isPresented: $showingCamera) {
            CameraImagePicker { image in
                showingCamera = false
                if let type = pendingPhotoType {
                    handleImage(image, type: type)
                }
            }
            .ignoresSafeArea()
        }
        .sheet(isPresented: $showingIngredientScanner) {
            CameraImagePicker { image in
                showingIngredientScanner = false
                recognizeIngredients(in: image)
            }
            .ignoresSafeArea()
        }
    }

    private var ingredientsField: some View {
        HStack(alignment: .top, spacing: 10) {
            contributionField(
                "contribution_ingredients",
                text: $form.ingredientsText,
                axis: .vertical
            )
            .overlay(alignment: .topTrailing) {
                Button {
                    showingIngredientScanner = true
                } label: {
                    Image(systemName: isRecognizingIngredients ? "hourglass" : "text.viewfinder")
                }
                .padding(10)
                .disabled(isRecognizingIngredients)
                .accessibilityLabel(L("contribution_scan_ingredients"))
            }
        }
        if let ocrMessageKey {
            Text(L(ocrMessageKey))
                .font(.footnote)
                .foregroundStyle(.red)
        }
    }

    private func recognizeIngredients(in image: UIImage) {
        isRecognizingIngredients = true
        ocrMessageKey = nil
        Task {
            do {
                let text = try await IngredientOCR.recognizeText(from: image)
                await MainActor.run {
                    isRecognizingIngredients = false
                    if text.isEmpty {
                        ocrMessageKey = "contribution_ocr_no_text"
                    } else {
                        form.ingredientsText = text
                    }
                }
            } catch {
                await MainActor.run {
                    isRecognizingIngredients = false
                    ocrMessageKey = "contribution_ocr_error"
                }
            }
        }
    }

    private func contributionField(
        _ key: String,
        text: Binding<String>,
        axis: Axis = .horizontal
    ) -> some View {
        TextField(L(key), text: text, axis: axis)
            .textInputAutocapitalization(.sentences)
            .padding(12)
            .background(Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
    }

    private var photosSection: some View {
        ContributionCard(title: L("contribution_photos_title")) {
            VStack(alignment: .leading, spacing: 12) {
                Text(L("contribution_photos_description"))
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                ForEach(ProductImageType.allCases) { type in
                    ProductPhotoRow(
                        type: type,
                        image: photoImages[type],
                        state: photoStates[type] ?? .idle,
                        choosePhoto: {
                            pendingPhotoType = type
                            showingPhotosPicker = true
                        },
                        takePhoto: {
                            pendingPhotoType = type
                            showingCamera = true
                        }
                    )
                }
            }
        }
    }

    private func submitContribution() {
        isSubmitting = true
        contributionResult = nil
        Task {
            let result = await service.contribute(barcode: barcode, source: source, form: form)
            await MainActor.run {
                isSubmitting = false
                contributionResult = result
            }
        }
    }

    private func handleImage(_ image: UIImage, type: ProductImageType) {
        photoImages[type] = image
        photoStates[type] = .uploading
        guard let data = compressedJPEGData(image) else {
            photoStates[type] = .error
            return
        }
        Task {
            let result = await service.uploadImage(
                barcode: barcode,
                source: source,
                type: type,
                jpegData: data
            )
            await MainActor.run {
                photoStates[type] = result.isSuccess ? .success : .error
            }
        }
    }

    private func loadSelectedPhoto(_ item: PhotosPickerItem, type: ProductImageType) async {
        guard let data = try? await item.loadTransferable(type: Data.self),
              let image = UIImage(data: data) else {
            await MainActor.run { photoStates[type] = .error }
            return
        }
        await MainActor.run { handleImage(image, type: type) }
    }

    private func contributionMessage(_ result: ContributionResult) -> String {
        switch result {
        case .success: return L("contribution_success")
        case .offline: return L("contribution_offline")
        case .networkError: return L("contribution_network_error")
        case .serverError: return L("contribution_server_error")
        }
    }
}

private struct ContributionCard<Content: View>: View {
    let title: String
    let content: Content

    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline.bold())
            content
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
    }
}

private enum PhotoUploadState: Equatable {
    case idle
    case uploading
    case success
    case error
}

private extension ProductImageUploadResult {
    var isSuccess: Bool {
        if case .success = self { return true }
        return false
    }
}

private struct ProductPhotoRow: View {
    let type: ProductImageType
    let image: UIImage?
    let state: PhotoUploadState
    let choosePhoto: () -> Void
    let takePhoto: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Group {
                if let image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                } else {
                    Image(systemName: "photo")
                        .foregroundStyle(.secondary)
                }
            }
            .frame(width: 58, height: 58)
            .background(.quaternary)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

            VStack(alignment: .leading, spacing: 5) {
                Text(type.localizedTitle)
                    .font(.subheadline.weight(.semibold))
                Text(state.localizedStatus)
                    .font(.caption)
                    .foregroundStyle(state == .error ? .red : .secondary)
            }
            Spacer()
            Menu {
                Button(L("contribution_photo_choose"), action: choosePhoto)
                Button(L("contribution_photo_take"), action: takePhoto)
            } label: {
                Image(systemName: "ellipsis.circle")
                    .font(.title3)
            }
        }
    }
}

private extension ProductImageType {
    var localizedTitle: String {
        switch self {
        case .front: return L("contribution_photo_front")
        case .ingredients: return L("contribution_photo_ingredients")
        case .nutrition: return L("contribution_photo_nutrition")
        case .packaging: return L("contribution_photo_packaging")
        }
    }
}

private extension PhotoUploadState {
    var localizedStatus: String {
        switch self {
        case .idle: return L("contribution_photo_idle")
        case .uploading: return L("contribution_photo_uploading")
        case .success: return L("contribution_photo_uploaded")
        case .error: return L("contribution_photo_error")
        }
    }
}

private struct CameraImagePicker: UIViewControllerRepresentable {
    let onImage: (UIImage) -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(onImage: onImage)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = UIImagePickerController.isSourceTypeAvailable(.camera) ? .camera : .photoLibrary
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ controller: UIImagePickerController, context: Context) {}

    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let onImage: (UIImage) -> Void

        init(onImage: @escaping (UIImage) -> Void) {
            self.onImage = onImage
        }

        func imagePickerController(
            _ picker: UIImagePickerController,
            didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
        ) {
            if let image = info[.originalImage] as? UIImage {
                onImage(image)
            }
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }
}
