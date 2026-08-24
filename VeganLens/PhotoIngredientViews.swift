import SwiftUI
import UIKit

struct PhotoIngredientOCRView: View {
    let onTextRecognized: (String) -> Void
    let onBack: () -> Void

    @State private var showingCamera = false
    @State private var isRecognizing = false
    @State private var messageKey: String?

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "text.viewfinder")
                .appIconFont(size: 54, weight: .semibold)
                .foregroundStyle(Color("AccentColor"))
            Text(L("photo_ingredients_title"))
                .appFont(.title2, weight: .bold)
                .multilineTextAlignment(.center)
            Text(L("photo_ingredients_notice"))
                .appFont(.body)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)

            if isRecognizing {
                ProgressView(L("photo_ingredients_recognizing"))
            } else {
                Button {
                    showingCamera = true
                } label: {
                    Label(L("photo_ingredients_take_photo"), systemImage: "camera")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
            }

            if let messageKey {
                Text(L(messageKey))
                    .appFont(.footnote)
                    .foregroundStyle(.red)
                    .multilineTextAlignment(.center)
            }

            Button(L("cancel"), action: onBack)
                .frame(maxWidth: .infinity)
                .buttonStyle(.bordered)
        }
        .padding(24)
        .navigationTitle(L("photo_ingredients_title"))
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingCamera) {
            CameraImagePicker { image in
                showingCamera = false
                recognizeIngredients(in: image)
            }
            .ignoresSafeArea()
        }
        .onAppear {
            if !isRecognizing {
                showingCamera = true
            }
        }
    }

    private func recognizeIngredients(in image: UIImage) {
        isRecognizing = true
        messageKey = nil
        Task {
            do {
                let text = try await IngredientOCR.recognizeText(from: image)
                await MainActor.run {
                    isRecognizing = false
                    if text.isEmpty {
                        messageKey = "photo_ingredients_no_text"
                    } else {
                        onTextRecognized(text)
                    }
                }
            } catch {
                await MainActor.run {
                    isRecognizing = false
                    messageKey = "photo_ingredients_error"
                }
            }
        }
    }
}

struct PhotoIngredientResultView: View {
    let initialText: String
    let onBack: () -> Void

    @State private var draftText: String
    @State private var analyzedText: String

    init(initialText: String, onBack: @escaping () -> Void) {
        self.initialText = initialText
        self.onBack = onBack
        _draftText = State(initialValue: initialText)
        _analyzedText = State(initialValue: initialText)
    }

    private var analysis: PhotoIngredientAnalysis {
        analyzePhotoIngredients(analyzedText)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(L("photo_result_notice"))
                    .appFont(.footnote)
                    .foregroundStyle(.secondary)
                    .accessibilityLabel(L("photo_result_notice"))

                verdictCard

                if !analysis.culprits.isEmpty {
                    resultSection(title: L("photo_culprits_title")) {
                        ForEach(Array(analysis.culprits.enumerated()), id: \.offset) { item in
                            let culprit = item.element
                            let reason = culprit.kind == .animalIngredient
                                ? L("photo_culprit_ingredient")
                                : L("photo_culprit_additive")
                            Label {
                                Text("\(culprit.label) — \(reason)")
                            } icon: {
                                Image(systemName: "xmark.circle.fill")
                            }
                            .foregroundStyle(.red)
                            .accessibilityLabel("\(culprit.label), \(reason)")
                        }
                    }
                }

                if !analysis.unrecognizedSegments.isEmpty {
                    resultSection(title: L("photo_unrecognized_title")) {
                        ForEach(analysis.unrecognizedSegments, id: \.self) { segment in
                            Label(segment, systemImage: "questionmark.circle")
                        }
                    }
                }

                if analysis.traceWarning {
                    Label(L("photo_trace_warning"), systemImage: "exclamationmark.triangle")
                        .foregroundStyle(.orange)
                        .accessibilityLabel(L("photo_trace_warning"))
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text(L("photo_text_label"))
                        .appFont(.headline, weight: .semibold)
                    TextEditor(text: $draftText)
                        .frame(minHeight: 150)
                        .padding(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.secondary.opacity(0.35))
                        )
                        .accessibilityLabel(L("photo_text_content_description"))
                    Button {
                        analyzedText = draftText
                    } label: {
                        Label(L("photo_reanalyze"), systemImage: "arrow.clockwise")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .padding()
        }
        .navigationTitle(L("photo_result_title"))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button(L("cancel"), action: onBack)
            }
        }
    }

    private var verdictCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(verdictTitle)
                .appFont(.title2, weight: .bold)
                .foregroundStyle(verdictColor)
            Text(reasonTitle)
                .appFont(.body)
            Text(L("photo_orientation_advice"))
                .appFont(.footnote)
                .foregroundStyle(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(verdictColor.opacity(0.10))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .accessibilityElement(children: .combine)
    }

    private func resultSection<Content: View>(
        title: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .appFont(.headline, weight: .semibold)
            content()
        }
    }

    private var verdictTitle: String {
        switch analysis.status {
        case .vegan: return L("photo_verdict_vegan")
        case .notVegan: return L("photo_verdict_not_vegan")
        case .review: return L("photo_verdict_review")
        }
    }

    private var reasonTitle: String {
        switch analysis.reasonSource {
        case .animalIngredient: return L("photo_reason_animal_ingredient")
        case .animalAdditive: return L("photo_reason_animal_additive")
        case .allPlantRecognized: return L("photo_reason_all_recognized")
        case .unrecognizedIngredient: return L("photo_reason_unrecognized")
        case .languageNotRecognized: return L("photo_reason_language_not_recognized")
        }
    }

    private var verdictColor: Color {
        switch analysis.status {
        case .vegan: return .green
        case .notVegan: return .red
        case .review: return .orange
        }
    }
}
