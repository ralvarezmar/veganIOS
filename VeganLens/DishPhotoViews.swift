import PhotosUI
import SwiftUI
import UIKit

struct DishPhotoView: View {
    let onBack: () -> Void
    @State private var showingCamera = false
    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var analysis: DishPhotoAnalysis?
    @State private var portion: DishPortion = .normal
    @State private var isAnalyzing = false
    @State private var errorMessage: String?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                Label(L("dish_photo_experimental"), systemImage: "fork.knife")
                    .appFont(.title2, weight: .bold)
                Text(L("dish_photo_notice"))
                    .appFont(.body)
                    .foregroundStyle(.secondary)

                if let analysis {
                    resultCard(analysis)
                }

                if isAnalyzing {
                    ProgressView(L("dish_photo_analyzing"))
                } else {
                    Button {
                        showingCamera = true
                    } label: {
                        Label(L("dish_photo_take_photo"), systemImage: "camera")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)

                    PhotosPicker(selection: $selectedPhotoItem, matching: .images) {
                        Label(L("dish_photo_pick_gallery"), systemImage: "photo.on.rectangle")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                }

                if let errorMessage {
                    Text(errorMessage)
                        .foregroundStyle(.red)
                }

                Text(L("dish_photo_limitations"))
                    .appFont(.footnote)
                    .foregroundStyle(.secondary)
            }
            .padding(20)
        }
        .navigationTitle(L("dish_photo_title"))
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingCamera) {
            CameraImagePicker { image in
                showingCamera = false
                analyze(image)
            }
            .ignoresSafeArea()
        }
        .onChange(of: selectedPhotoItem) { _, item in
            guard let item else { return }
            loadPhoto(item)
        }
    }

    @ViewBuilder
    private func resultCard(_ analysis: DishPhotoAnalysis) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(L("dish_photo_visible_foods"))
                .appFont(.headline, weight: .semibold)
            if analysis.visibleFoods.isEmpty {
                Text(L("dish_photo_no_foods"))
                    .foregroundStyle(.secondary)
            } else {
                ForEach(analysis.visibleFoods, id: \.self) { food in
                    let range = DishPhotoAnalyzer.calories(for: food, portion: portion)
                    Label(
                        LF("dish_photo_food_kcal", foodName(food), range.lowerBound, range.upperBound),
                        systemImage: "circle.fill"
                    )
                }

                Picker(L("dish_photo_portion"), selection: $portion) {
                    ForEach(DishPortion.allCases, id: \.self) { option in
                        Text(L(option.localizationKey)).tag(option)
                    }
                }
                .pickerStyle(.segmented)
                .accessibilityLabel(L("dish_photo_portion"))

                if let total = DishPhotoAnalyzer.totalCalories(for: analysis.visibleFoods, portion: portion) {
                    Text(LF("dish_photo_calories", total.lowerBound, total.upperBound))
                        .appFont(.headline, weight: .semibold)
                    Text(L("dish_photo_uncertain"))
                        .appFont(.footnote)
                        .foregroundStyle(.secondary)
                }

                switch DishPhotoAnalyzer.veganHint(for: analysis.visibleFoods) {
                case .animal:
                    let animalFoods = analysis.visibleFoods
                        .filter { $0.hint == .animal }
                        .map(foodName)
                        .joined(separator: ", ")
                    Label(LF("dish_photo_hint_animal", animalFoods), systemImage: "exclamationmark.triangle")
                case .plant:
                    Label(L("dish_photo_hint_plant"), systemImage: "leaf")
                case nil:
                    EmptyView()
                }
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }

    private func foodName(_ food: DishFood) -> String {
        let name = L(food.localizationKey)
        return name.prefix(1).uppercased() + name.dropFirst()
    }

    private func loadPhoto(_ item: PhotosPickerItem) {
        isAnalyzing = true
        errorMessage = nil
        Task {
            let data = try? await item.loadTransferable(type: Data.self)
            await MainActor.run {
                selectedPhotoItem = nil
                if let data, let image = UIImage(data: data) {
                    analyze(image)
                } else {
                    errorMessage = L("dish_photo_error")
                    isAnalyzing = false
                }
            }
        }
    }

    private func analyze(_ image: UIImage) {
        isAnalyzing = true
        errorMessage = nil
        Task {
            do {
                let result = try await DishPhotoAnalyzer.analyze(image)
                await MainActor.run {
                    analysis = result
                    isAnalyzing = false
                }
            } catch {
                await MainActor.run {
                    errorMessage = L("dish_photo_error")
                    isAnalyzing = false
                }
            }
        }
    }
}
