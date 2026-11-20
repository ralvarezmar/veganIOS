import SwiftUI

struct SearchScreen: View {
    @State private var query = ""
    @State private var mode: SearchMode = .food
    @State private var uiState: SearchUiState = .idle
    @State private var searchTask: Task<Void, Never>?

    private let service = OpenFactsService()
    private let medicineService = MedicineService()
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
                .appFont(.title3, weight: .bold)

            Picker(L("search_title"), selection: Binding(get: { mode }, set: { selectMode($0) })) {
                Text(L("search_mode_food")).tag(SearchMode.food)
                Text(L("search_mode_medicine")).tag(SearchMode.medicine)
            }
            .pickerStyle(.segmented)
            .accessibilityIdentifier("search_mode_picker")

            TextField(L(mode == .medicine ? "search_medicine_hint" : "search_hint"), text: $query)
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
            .tint(mode == .medicine ? medicineBlue : Color("AccentColor"))
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
            SearchPromptState(mode: mode)
        case .loading:
            SearchLoadingState()
        case .empty(let query):
            SearchEmptyState(query: query, mode: mode, onSearchMedicines: { selectMode(.medicine) })
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
                SearchEmptyState(
                    query: query.trimmingCharacters(in: .whitespacesAndNewlines),
                    mode: mode,
                    onSearchMedicines: { selectMode(.medicine) }
                )
            } else {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(products.indices, id: \.self) { index in
                            SearchResultRow(
                                product: products[index],
                                onSelectBarcode: onSelectBarcode
                            )
                        }
                    }
                    .padding(.bottom, 12)
                }
            }
        case .medicineSuccess(let items):
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(items) { item in
                        Button {
                            onSelectBarcode(item.code)
                        } label: {
                            MedicineSearchResultCard(item: item)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.bottom, 12)
            }
        }
    }

    private func selectMode(_ newMode: SearchMode) {
        guard mode != newMode else { return }
        mode = newMode
        if query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            searchTask?.cancel()
            uiState = .idle
        } else {
            runSearch()
        }
    }

    private func runSearch() {
        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedQuery.isEmpty else {
            return
        }

        uiState = .loading
        let searchMode = mode
        searchTask?.cancel()

        searchTask = Task { @MainActor in
            let newState: SearchUiState
            switch searchMode {
            case .food:
                switch await service.searchByName(query: trimmedQuery) {
                case .success(let products):
                    newState = .success(products)
                case .empty:
                    newState = .empty(trimmedQuery)
                case .error(let message):
                    newState = .error(message, trimmedQuery)
                }
            case .medicine:
                switch await medicineService.searchByName(query: trimmedQuery) {
                case .success(let items):
                    newState = .medicineSuccess(items)
                case .empty:
                    newState = .empty(trimmedQuery)
                case .error(let message):
                    newState = .error(message, trimmedQuery)
                }
            }
            guard !Task.isCancelled else { return }
            uiState = newState
        }
    }
}

private enum SearchMode: Hashable {
    case food
    case medicine
}

@ViewBuilder
private func SearchPromptState(mode: SearchMode) -> some View {
    if mode == .medicine {
        EmptyStateCard(
            icon: "cross.case",
            title: L("search_prompt_title"),
            message: L("search_medicine_prompt_message"),
            tint: medicineBlue
        )
    } else {
        EmptyStateCard(
            icon: "magnifyingglass",
            title: L("search_prompt_title"),
            message: L("search_prompt_message")
        )
    }
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
private func SearchEmptyState(
    query: String,
    mode: SearchMode,
    onSearchMedicines: @escaping () -> Void
) -> some View {
    if mode == .medicine {
        EmptyStateCard(
            icon: "cross.case",
            title: L("search_empty_title"),
            message: String(format: L("search_medicine_no_results_message"), query),
            tint: medicineBlue
        )
    } else {
        EmptyStateCard(
            icon: "magnifyingglass",
            title: L("search_empty_title"),
            message: query.isEmpty ? L("search_empty_message") : String(format: L("search_no_results_message"), query),
            actionTitle: query.isEmpty ? nil : L("search_try_medicines"),
            action: query.isEmpty ? nil : onSearchMedicines,
            mascot: EmptyStateMascots.search,
            tint: medicineBlue,
            actionIdentifier: "search_try_medicines_button"
        )
    }
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
    let mascot: String?
    let tint: Color?
    let actionIdentifier: String?

    init(
        icon: String?,
        title: String,
        message: String?,
        loading: Bool = false,
        actionTitle: String? = nil,
        action: (() -> Void)? = nil,
        mascot: String? = nil,
        tint: Color? = nil,
        actionIdentifier: String? = nil
    ) {
        self.icon = icon
        self.title = title
        self.message = message
        self.loading = loading
        self.actionTitle = actionTitle
        self.action = action
        self.mascot = mascot
        self.tint = tint
        self.actionIdentifier = actionIdentifier
    }

    var body: some View {
        VStack(spacing: 14) {
            if loading {
                ProgressView()
            } else if let mascot {
                Image("portada_\(mascot)")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 96, height: 96)
                    .accessibilityLabel(L("portada_image_description"))
            } else if let icon {
                Image(systemName: icon)
                    .appIconFont(size: 42, weight: .semibold)
                    .foregroundStyle(tint ?? .green)
            }

            Text(title)
                .appFont(.title2, weight: .bold)
                .multilineTextAlignment(.center)

            if let message {
                Text(message)
                    .appFont(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }

            if let actionTitle, let action {
                Button(actionTitle, action: action)
                    .buttonStyle(.borderedProminent)
                    .tint(tint ?? Color("AccentColor"))
                    .accessibilityIdentifier(actionIdentifier ?? "")
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
                    .appFont(.headline, weight: .semibold)
                    .foregroundStyle(.primary)

                if let brands = product.brands, !brands.isEmpty {
                    Text(brands)
                        .appFont(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Text(product.code ?? "")
                    .appFont(.caption)
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

private struct MedicineSearchResultCard: View {
    let item: MedicineSearchItem

    var body: some View {
        HStack(spacing: 14) {
            if item.imageURL != nil {
                SearchThumbnail(imageURLString: item.imageURL)
            } else {
                Image("medicine_pill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 72, height: 72)
                    .accessibilityLabel(L("medicine_mascot_description"))
            }

            VStack(alignment: .leading, spacing: 5) {
                Text(item.name)
                    .appFont(.headline, weight: .semibold)
                    .foregroundStyle(Color(red: 0x0D / 255, green: 0x47 / 255, blue: 0xA1 / 255))

                if let laboratory = item.laboratory {
                    Text(laboratory)
                        .appFont(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Text(LF("medicine_source", item.source.displayName))
                    .appFont(.caption)
                    .foregroundStyle(medicineBlue)
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(red: 0xE3 / 255, green: 0xF2 / 255, blue: 0xFD / 255))
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .strokeBorder(medicineBlue.opacity(0.25), lineWidth: 1)
        )
        .accessibilityIdentifier("medicine_search_result")
    }
}

private struct SearchResultRow: View {
    let product: OpenFoodFactsSearchProduct
    let onSelectBarcode: (String) -> Void

    var body: some View {
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
                .appFont(.title3)
                .foregroundStyle(.secondary)
        }
    }
}

private enum SearchUiState {
    case idle
    case loading
    case success([OpenFoodFactsSearchProduct])
    case medicineSuccess([MedicineSearchItem])
    case empty(String)
    case error(String, String)
}
