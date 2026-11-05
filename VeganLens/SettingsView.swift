import SwiftUI
import SwiftData
import UserNotifications
import UniformTypeIdentifiers

struct SettingsView: View {
    @Environment(\.openURL) private var openURL
    @Environment(\.modelContext) private var modelContext
    @State private var showingClearCacheConfirmation = false
    @State private var showingCredits = false
    @State private var showingMascotGallery = false
    @State private var versionTapCount = 0
    @State private var showingBackupExporter = false
    @State private var showingBackupImporter = false
    @State private var backupDocument: BackupDocument?
    @State private var backupStatus: String?
    @State private var lastVersionTap: Date?
    @AppStorage(AccessibilityPreferences.colorblindPaletteKey) private var colorblindSafePalette = false
    @AppStorage(AccessibilityPreferences.textSizeKey) private var textSize = AccessibilityTextSize.normal.rawValue
    @AppStorage(AccessibilityPreferences.highLegibilityFontKey) private var highLegibilityFont = false
    @AppStorage(ScannerPreferences.hapticsEnabledKey) private var scannerHapticsEnabled = true
    @AppStorage(ScannerPreferences.soundEnabledKey) private var scannerSoundEnabled = false
    @AppStorage(B12ReminderSettings.enabledKey) private var b12ReminderEnabled = false
    @AppStorage(B12ReminderSettings.hourKey) private var b12ReminderHour = 9
    @AppStorage(B12ReminderSettings.minuteKey) private var b12ReminderMinute = 0
    @AppStorage(B12ReminderSettings.intervalDaysKey) private var b12ReminderIntervalDays = 7

    private let privacyURL = URL(string: "https://ralvarezmar.github.io/veganIOS/")!

    var body: some View {
        List {
            Section {
                Button {
                    openURL(privacyURL)
                } label: {
                    Label {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(L("privacy_policy_title"))
                            Text(L("privacy_policy_description"))
                                .appFont(.footnote)
                                .foregroundStyle(.secondary)
                        }
                    } icon: {
                        Image(systemName: "hand.raised")
                    }
                }
                .accessibilityIdentifier("privacy-policy-row")

                Button {
                    showingCredits = true
                } label: {
                    Label {
                        Text(L("credits_title"))
                            .appFont(.body)
                    } icon: {
                        Image(systemName: "heart")
                    }
                }
                .accessibilityIdentifier("credits-row")
            } header: {
                Text(L("privacy_section_title"))
            }

            Section {
                Toggle(L("accessibility_colorblind_title"), isOn: $colorblindSafePalette)
                    .accessibilityIdentifier("accessibility-colorblind-toggle")

                Toggle(L("accessibility_font_title"), isOn: $highLegibilityFont)
                    .accessibilityIdentifier("accessibility-font-toggle")

                Picker(L("accessibility_text_size_title"), selection: $textSize) {
                    Text(L("accessibility_text_size_normal"))
                        .tag(AccessibilityTextSize.normal.rawValue)
                    Text(L("accessibility_text_size_large"))
                        .tag(AccessibilityTextSize.large.rawValue)
                    Text(L("accessibility_text_size_extra_large"))
                        .tag(AccessibilityTextSize.extraLarge.rawValue)
                }
                .accessibilityIdentifier("accessibility-text-size-picker")
            } header: {
                Text(L("accessibility_title"))
            } footer: {
                Text(L("accessibility_description"))
            }

            Section {
                Toggle(L("scanner_haptics_title"), isOn: $scannerHapticsEnabled)
                Toggle(L("scanner_sound_title"), isOn: $scannerSoundEnabled)
            } header: {
                Text(L("scanner_feedback_title"))
            } footer: {
                Text(L("scanner_feedback_description"))
            }

            Section {
                Toggle(L("b12_reminder_title"), isOn: $b12ReminderEnabled)

                DatePicker(
                    L("b12_reminder_time"),
                    selection: reminderTime,
                    displayedComponents: [.hourAndMinute]
                )

                Picker(L("b12_reminder_frequency"), selection: $b12ReminderIntervalDays) {
                    Text(L("b12_reminder_every_day")).tag(1)
                    Text(L("b12_reminder_every_2_days")).tag(2)
                    Text(L("b12_reminder_every_3_days")).tag(3)
                    Text(L("b12_reminder_every_week")).tag(7)
                }
                .pickerStyle(.menu)
            }
            .onChange(of: b12ReminderEnabled) { _, enabled in
                if enabled {
                    Task {
                        let granted = (try? await UNUserNotificationCenter.current().requestAuthorization(
                            options: [.alert, .sound]
                        )) == true
                        if granted {
                            await B12ReminderScheduler.refresh()
                        } else {
                            await MainActor.run {
                                b12ReminderEnabled = false
                            }
                        }
                    }
                } else {
                    Task {
                        await B12ReminderScheduler.removePendingReminders()
                    }
                }
            }
            .onChange(of: b12ReminderHour) { _, _ in
                if b12ReminderEnabled {
                    B12ReminderScheduler.refreshIfEnabled()
                }
            }
            .onChange(of: b12ReminderMinute) { _, _ in
                if b12ReminderEnabled {
                    B12ReminderScheduler.refreshIfEnabled()
                }
            }
            .onChange(of: b12ReminderIntervalDays) { _, _ in
                if b12ReminderEnabled {
                    B12ReminderScheduler.refreshIfEnabled()
                }
            }

            Section {
                NavigationLink {
                    StatsScreen()
                } label: {
                    Label(L("stats_action"), systemImage: "chart.bar")
                }
                .accessibilityIdentifier("stats-row")
                NavigationLink {
                    GlossaryScreen()
                } label: {
                    Label(L("glossary_action"), systemImage: "book")
                }
                .accessibilityIdentifier("glossary-row")
            }

            Section {
                Button {
                    exportBackup()
                } label: {
                    Label(L("backup_export"), systemImage: "square.and.arrow.up")
                }
                .accessibilityIdentifier("backup-export-row")
                Button {
                    showingBackupImporter = true
                } label: {
                    Label(L("backup_import"), systemImage: "square.and.arrow.down")
                }
                .accessibilityIdentifier("backup-import-row")
                if let backupStatus {
                    Text(backupStatus)
                        .appFont(.footnote)
                        .foregroundStyle(.secondary)
                }
            } header: {
                Text(L("backup_section_title"))
            } footer: {
                Text(L("backup_description"))
            }
            .fileImporter(isPresented: $showingBackupImporter, allowedContentTypes: [.json]) { result in
                handleBackupImport(result)
            }

            Section {
                Button(role: .destructive) {
                    showingClearCacheConfirmation = true
                } label: {
                    Label(L("clear_cache"), systemImage: "trash")
                }
            } header: {
                Text(L("cache_section_title"))
            }

            Section {
                Text(versionText)
                    .appFont(.footnote)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)
                    .contentShape(Rectangle())
                    .accessibilityIdentifier("mascot-gallery-version")
                    .accessibilityLabel(versionText)
                    .onTapGesture(perform: registerVersionTap)
            }
        }
        .navigationTitle(L("settings_title"))
        .navigationBarTitleDisplayMode(.inline)
        .confirmationDialog(
            L("clear_cache_confirmation"),
            isPresented: $showingClearCacheConfirmation,
            titleVisibility: .visible
        ) {
            Button(L("clear_cache"), role: .destructive, action: clearCache)
            Button(L("cancel"), role: .cancel) {}
        }
        .alert(L("credits_title"), isPresented: $showingCredits) {
            Button(L("gallery_close"), role: .cancel) {}
        } message: {
            Text(L("credits_body"))
                .appFont(.body)
        }
        .sheet(isPresented: $showingMascotGallery) {
            MascotGalleryView()
        }
        .fileExporter(
            isPresented: $showingBackupExporter,
            document: backupDocument,
            contentType: .json,
            defaultFilename: "veganlens-backup"
        ) { result in
            backupStatus = (try? result.get()) != nil ? L("backup_export_done") : L("backup_error")
            backupDocument = nil
        }
    }

    private var reminderTime: Binding<Date> {
        Binding(
            get: {
                let calendar = Calendar.current
                let startOfDay = calendar.startOfDay(for: Date())
                return calendar.date(
                    bySettingHour: b12ReminderHour,
                    minute: b12ReminderMinute,
                    second: 0,
                    of: startOfDay
                ) ?? Date()
            },
            set: { date in
                let components = Calendar.current.dateComponents([.hour, .minute], from: date)
                b12ReminderHour = components.hour ?? b12ReminderHour
                b12ReminderMinute = components.minute ?? b12ReminderMinute
            }
        )
    }

    private var versionText: String {
        let info = Bundle.main.infoDictionary ?? [:]
        let version = info["CFBundleShortVersionString"] as? String ?? "?"
        let build = info["CFBundleVersion"] as? String ?? "?"
        return LF("gallery_version", L("app_name"), version, build)
    }

    private func registerVersionTap() {
        let now = Date()
        if let lastVersionTap, now.timeIntervalSince(lastVersionTap) > 2 {
            versionTapCount = 0
        }
        versionTapCount += 1
        lastVersionTap = now
        if versionTapCount == 7 {
            versionTapCount = 0
            lastVersionTap = nil
            showingMascotGallery = true
        }
    }

    private func exportBackup() {
        do {
            backupDocument = BackupDocument(data: try makeBackupData(context: modelContext))
            showingBackupExporter = true
        } catch {
            backupStatus = L("backup_error")
        }
    }

    private func handleBackupImport(_ result: Result<URL, Error>) {
        do {
            let url = try result.get()
            let accessing = url.startAccessingSecurityScopedResource()
            defer {
                if accessing { url.stopAccessingSecurityScopedResource() }
            }
            let plan = try importBackup(try Data(contentsOf: url), context: modelContext)
            backupStatus = LF(
                "backup_import_done",
                plan.historyCount,
                plan.favoritesToInsert.count,
                plan.shoppingToInsert.count
            )
        } catch {
            backupStatus = L("backup_error")
        }
    }

    private func clearCache() {
        do {
            let cachedProducts = try modelContext.fetch(FetchDescriptor<CachedProduct>())
            cachedProducts.forEach(modelContext.delete)
            try modelContext.save()
        } catch {
            print("No se pudo borrar la caché: \(error)")
        }
    }
}
