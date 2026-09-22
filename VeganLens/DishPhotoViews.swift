import SwiftUI
import UIKit

struct DishPhotoView: View {
    let onBack: () -> Void
    @State private var showingCamera = false
    @State private var analysis: DishPhotoAnalysis?
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
                    VStack(alignment: .leading, spacing: 12) {
                        Text(L("dish_photo_visible_foods"))
                            .appFont(.headline, weight: .semibold)
                        if analysis.visibleFoods.isEmpty {
                            Text(L("dish_photo_no_foods"))
                                .foregroundStyle(.secondary)
                        } else {
                            ForEach(analysis.visibleFoods, id: \.self) { food in
                                Label(food.capitalized, systemImage: "circle.fill")
                            }
                        }
                        Text(
                            LF(
                                "dish_photo_calories",
                                analysis.calorieRange.lowerBound,
                                analysis.calorieRange.upperBound
                            )
                        )
                        .appFont(.headline, weight: .semibold)
                        Text(L("dish_photo_uncertain"))
                            .appFont(.footnote)
                            .foregroundStyle(.secondary)
                    }
                    .padding(16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                    .accessibilityElement(children: .combine)
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
