import SwiftUI

/*
 LoadingButton.swift

 A primary button with all six states and no layout shift:
 rest → pressed → loading (width locked, label swaps for a spinner in the same
 frame) → success (symbol replace, auto-reverts after 1.5s) → disabled (with a
 reason) → error (inline copy under the control).

 Requires Motion.swift, Haptics.swift, PressableButtonStyle.swift.
 Style it with the project's own colours via `.tint` and `.buttonBorderShape`.

 Usage:
   LoadingButton("Save changes", state: $state, disabledReason: "Add a title first") {
       try await save()
   }
 */

enum LoadingButtonState: Equatable {
    case idle
    case loading
    case success
    case error(String)
}

struct LoadingButton: View {
    let title: String
    @Binding var state: LoadingButtonState
    var disabledReason: String? = nil
    var successTitle: String = "Saved"
    var action: () async throws -> Void

    @State private var lockedWidth: CGFloat?
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    init(_ title: String,
         state: Binding<LoadingButtonState>,
         disabledReason: String? = nil,
         successTitle: String = "Saved",
         action: @escaping () async throws -> Void) {
        self.title = title
        self._state = state
        self.disabledReason = disabledReason
        self.successTitle = successTitle
        self.action = action
    }

    private var isDisabled: Bool { disabledReason != nil }
    private var isBusy: Bool { state == .loading }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Button {
                Task { await run() }
            } label: {
                ZStack {
                    // The rest label reserves the width; nothing else may change it.
                    Text(title)
                        .opacity(state == .idle || isDisabled ? 1 : 0)

                    if isBusy {
                        ProgressView().progressViewStyle(.circular)
                    }

                    if state == .success {
                        Label(successTitle, systemImage: "checkmark")
                            .contentTransition(.symbolEffect(.replace))
                    }
                }
                .font(.body.weight(.semibold))
                .frame(maxWidth: .infinity, minHeight: 52)
                .frame(width: lockedWidth)
                .onGeometryChange(for: CGFloat.self) { $0.size.width } action: { width in
                    if state == .idle { lockedWidth = width }
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(.pressable)
            .disabled(isDisabled || isBusy)
            // Disabled is transparency, not grey, and it always comes with a reason.
            .opacity(isDisabled ? 0.4 : 1)
            .animation(reduceMotion ? Motion.reduced : Motion.state, value: state)
            .sensoryFeedback(Haptic.success, trigger: state == .success) { _, new in new }
            .sensoryFeedback(Haptic.error, trigger: isError) { _, new in new }

            if let disabledReason {
                Text(disabledReason)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }

            if case .error(let message) = state {
                Text(message)
                    .font(.footnote)
                    .foregroundStyle(.red)
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
    }

    private var isError: Bool {
        if case .error = state { return true }
        return false
    }

    @MainActor
    private func run() async {
        guard state == .idle else { return }
        state = .loading
        do {
            try await action()
            state = .success
            try? await Task.sleep(for: .seconds(1.5))
            if state == .success { state = .idle }
        } catch {
            state = .error(error.localizedDescription)
        }
    }
}
