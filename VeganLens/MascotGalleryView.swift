import SwiftUI

struct MascotGalleryView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedCharacter: String?

    var body: some View {
        NavigationStack {
            Group {
                if let selectedCharacter {
                    mascotDetail(for: selectedCharacter)
                } else {
                    mascotGrid
                }
            }
            .navigationTitle(
                selectedCharacter.map { mascotNickname(for: $0) } ?? L("gallery_title")
            )
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(L("gallery_close")) {
                        if selectedCharacter != nil {
                            self.selectedCharacter = nil
                        } else {
                            dismiss()
                        }
                    }
                    .accessibilityIdentifier("mascot-gallery-close")
                }
            }
        }
        .tint(Color("AccentColor"))
        .background(PortadaColors.background)
        .presentationBackground(PortadaColors.background)
        .environment(\.colorScheme, .light)
    }

    private var mascotGrid: some View {
        ScrollView {
            LazyVGrid(
                columns: [GridItem(.adaptive(minimum: 100), spacing: 12)],
                spacing: 18
            ) {
                ForEach(portadaCharacterNames, id: \.self) { character in
                    let name = mascotName(for: character)
                    let nickname = mascotNickname(for: character)
                    Button {
                        selectedCharacter = character
                    } label: {
                        VStack(spacing: 6) {
                            Image("portada_\(character)")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 104)
                                .accessibilityLabel(name)
                            Text(nickname)
                                .appFont(.body)
                                .multilineTextAlignment(.center)
                                .foregroundStyle(PortadaColors.title)
                            Text(name)
                                .appFont(.footnote)
                                .multilineTextAlignment(.center)
                                .foregroundStyle(PortadaColors.tagline)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel(name)
                }
            }
            .padding(16)
        }
        .scrollContentBackground(.hidden)
        .background(PortadaColors.background)
    }

    private func mascotDetail(for character: String) -> some View {
        VStack(spacing: 20) {
            Image("portada_\(character)")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity, maxHeight: 520)
                .accessibilityLabel(mascotName(for: character))

            Text(mascotNickname(for: character))
                .appFont(.title2, weight: .semibold)
                .multilineTextAlignment(.center)
                .foregroundStyle(PortadaColors.title)
            Text(mascotName(for: character))
                .appFont(.footnote)
                .multilineTextAlignment(.center)
                .foregroundStyle(PortadaColors.tagline)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(24)
        .background(PortadaColors.background)
    }

    private func mascotName(for character: String) -> String {
        L("mascot_\(character)")
    }

    private func mascotNickname(for character: String) -> String {
        L("mascot_nick_\(character)")
    }
}
