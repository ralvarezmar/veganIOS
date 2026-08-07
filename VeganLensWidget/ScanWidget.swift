import SwiftUI
import WidgetKit

struct ScanWidgetEntry: TimelineEntry {
    let date: Date
}

struct ScanWidgetProvider: TimelineProvider {
    func placeholder(in context: Context) -> ScanWidgetEntry {
        ScanWidgetEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (ScanWidgetEntry) -> Void) {
        completion(ScanWidgetEntry(date: Date()))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<ScanWidgetEntry>) -> Void) {
        completion(Timeline(entries: [ScanWidgetEntry(date: Date())], policy: .never))
    }
}

struct ScanWidgetView: View {
    var entry: ScanWidgetEntry

    private var scanLabel: String {
        switch Locale.current.language.languageCode?.identifier {
        case "de":
            return "Scannen"
        case "en":
            return "Scan"
        case "fr":
            return "Scanner"
        default:
            return "Escanear"
        }
    }

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "qrcode.viewfinder")
                .font(.system(size: 30, weight: .semibold))
            Text(scanLabel)
                .font(.headline)
                .bold()
        }
        .foregroundStyle(.white)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.green)
        )
        .widgetURL(URL(string: "vcheck://scan"))
    }
}

struct ScanWidget: Widget {
    let kind = "ScanWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: ScanWidgetProvider()) { entry in
            ScanWidgetView(entry: entry)
        }
        .configurationDisplayName("Escanear")
        .description("Escanea un producto rápidamente")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

@main
struct VeganLensWidgetBundle: WidgetBundle {
    var body: some Widget {
        ScanWidget()
    }
}
