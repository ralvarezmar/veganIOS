import SwiftUI

struct SearchScreen: View {
    @State private var query = ""
    @State private var uiState: SearchUiState = .idle

    private let service = OpenFactsService()
    let onSelectBarcode: (String) -> Void

    var body: some View {
        VStack(spacing: 16) {
            searchInputCard

            content
        }
        .padding(16)
        .navigationTitle(L("search_title"))
        .navigationBarTitleDisplayMode(.inline)
    }

    private var searchInputCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(L("search_title"))
                .font(.title3.bold())

            TextField(L("search_hint"), text: $query)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .keyboardType(.default)
                .submitLabel(.search)
                .onSubmit {
                    runSearch()
                }
                .padding(12)
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))

            Button {
                runSearch()
            } label: {
                Text(L("search_button"))
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(.green)
            .disabled(query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
        .padding(18)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
    }

    @ViewBuilder
    private var content: some View {
        switch uiState {
        case .idle:
            SearchPromptState()
        case .loading:
            SearchLoadingState()
        case .empty(let query):
            SearchEmptyState(query: query)
        case .error(let message, let query):
            SearchErrorState(
                message: message,
                onRetry: {
                    self.query = query
                    runSearch()
                }
            )
        case .success(let products):
            if products.isEmpty {
                SearchEmptyState(query: query.trimmingCharacters(in: .whitespacesAndNewlines))
            } else {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(products.indices, id: \.self) { index in
                            let product = products[index]
                            Button {
                                if let code = product.code {
                                    onSelectBarcode(code)
                                }
                            } label: {
                                SearchResultCard(product: product)
                            }
                            .buttonStyle(.plain)
                            .disabled(product.code == nil)
                        }
                    }
                    .padding(.bottom, 12)
                }
            }
        }
    }

    private func runSearch() {
        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedQuery.isEmpty else {
            return
        }

        uiState = .loading

        Task { @MainActor in
            switch await service.searchByName(query: trimmedQuery) {
            case .success(let products):
                uiState = .success(products)
            case .empty:
                uiState = .empty(trimmedQuery)
            case .error(let message):
                uiState = .error(message, trimmedQuery)
            }
        }
    }
}

@ViewBuilder
private func SearchPromptState() -> some View {
    EmptyStateCard(
        icon: "magnifyingglass",
        title: L("search_prompt_title"),
        message: L("search_prompt_message")
    )
}

@ViewBuilder
private func SearchLoadingState() -> some View {
    EmptyStateCard(
        icon: nil,
        title: L("search_loading"),
        message: nil,
        loading: true
    )
}

@ViewBuilder
private func SearchEmptyState(query: String) -> some View {
    EmptyStateCard(
        icon: "magnifyingglass",
        title: L("search_empty_title"),
        message: query.isEmpty ? L("search_empty_message") : String(format: L("search_no_results_message"), query)
    )
}

@ViewBuilder
private func SearchErrorState(
    message: String,
    onRetry: @escaping () -> Void
) -> some View {
    EmptyStateCard(
        icon: "wifi.exclamationmark",
        title: L("search_error_title"),
        message: message,
        actionTitle: L("search_retry"),
        action: onRetry
    )
}

private struct EmptyStateCard: View {
    let icon: String?
    let title: String
    let message: String?
    let loading: Bool
    let actionTitle: String?
    let action: (() -> Void)?

    init(
        icon: String?,
        title: String,
        message: String?,
        loading: Bool = false,
        actionTitle: String? = nil,
        action: (() -> Void)? = nil
    ) {
        self.icon = icon
        self.title = title
        self.message = message
        self.loading = loading
        self.actionTitle = actionTitle
        self.action = action
    }

    var body: some View {
        VStack(spacing: 14) {
            if loading {
                ProgressView()
            } else if let icon {
                Image(systemName: icon)
                    .font(.system(size: 42, weight: .semibold))
                    .foregroundStyle(.green)
            }

            Text(title)
                .font(.title2.bold())
                .multilineTextAlignment(.center)

            if let message {
                Text(message)
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }

            if let actionTitle, let action {
                Button(actionTitle, action: action)
                    .buttonStyle(.borderedProminent)
                    .tint(.green)
            }
        }
        .padding(28)
        .frame(maxWidth: .infinity)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
    }
}

private struct SearchResultCard: View {
    let product: OpenFoodFactsSearchProduct

    var body: some View {
        HStack(spacing: 14) {
            SearchThumbnail(imageURLString: product.imageUrl)

            VStack(alignment: .leading, spacing: 5) {
                Text(product.productName?.isEmpty == false ? product.productName! : (product.code ?? ""))
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)

                if let brands = product.brands, !brands.isEmpty {
                    Text(brands)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Text(product.code ?? "")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .strokeBorder(Color.secondary.opacity(0.10), lineWidth: 1)
        )
    }
}

private struct SearchThumbnail: View {
    let imageURLString: String?

    var body: some View {
        Group {
            if let imageURLString, let url = URL(string: imageURLString) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        placeholder
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                    case .failure:
                        placeholder
                    @unknown default:
                        placeholder
                    }
                }
            } else {
                placeholder
            }
        }
        .frame(width: 72, height: 72)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }

    private var placeholder: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(.quaternary)
            Image(systemName: "photo")
                .font(.title3)
                .foregroundStyle(.secondary)
        }
    }
}

private enum SearchUiState {
    case idle
    case loading
    case success([OpenFoodFactsSearchProduct])
    case empty(String)
    case error(String, String)
}
