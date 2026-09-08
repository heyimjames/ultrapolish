import SwiftUI

/*
 SheetPresets.swift

 One modifier that applies the project's sheet chrome so every sheet agrees:
 detents, corner radius, drag indicator, background interaction, and inherited
 tint and colour scheme.

 Set `SheetChrome.radius` once from the design contract (row 11). System default
 is 10pt; most projects want 20–36.

 Usage:
   .sheet(isPresented: $showFilters) {
       FiltersView().sheetChrome(.browse)
   }
 */

enum SheetChrome {
    /// The project's sheet corner radius. Name it once; never type a literal at a call site.
    static var radius: CGFloat = 28

    /// Detent sets by job. Stacked sheets must differ in height by at least 25%.
    enum Job {
        /// One or two actions, a confirmation.
        case confirm
        /// A picker or a short list.
        case picker
        /// Filters or a browsable list; content behind stays interactive at medium.
        case browse
        /// A form or composer.
        case form
        /// A full takeover with its own Close button.
        case takeover

        var detents: Set<PresentationDetent> {
            switch self {
            case .confirm:  return [.height(220)]
            case .picker:   return [.medium]
            case .browse:   return [.medium, .large]
            case .form:     return [.large]
            case .takeover: return [.large]
            }
        }

        var showsDragIndicator: Visibility {
            switch self {
            case .confirm, .picker, .browse: return .visible
            case .form, .takeover: return .hidden
            }
        }

        var backgroundInteraction: PresentationBackgroundInteraction {
            switch self {
            case .browse: return .enabled(upThrough: .medium)
            default: return .disabled
            }
        }
    }
}

private struct SheetChromeModifier: ViewModifier {
    let job: SheetChrome.Job
    let radius: CGFloat

    @Environment(\.colorScheme) private var scheme

    func body(content: Content) -> some View {
        content
            .presentationDetents(job.detents)
            .presentationCornerRadius(radius)
            .presentationDragIndicator(job.showsDragIndicator)
            .presentationBackgroundInteraction(job.backgroundInteraction)
            .presentationContentInteraction(.scrolls)
            // Trays adopt the environment: the sheet keeps the presenter's scheme.
            .preferredColorScheme(scheme)
    }
}

extension View {
    /// Apply the project's sheet chrome for a given job.
    func sheetChrome(_ job: SheetChrome.Job, radius: CGFloat = SheetChrome.radius) -> some View {
        modifier(SheetChromeModifier(job: job, radius: radius))
    }
}
