// MARK: - Loading Button
/// Button that runs an async action and shows a spinner while waiting.
public struct LoadingButton<Label: View>: View {
    @Environment(\.colorScheme) private var scheme
    private let action: () async -> Void
    private let label: () -> Label
    @State private var isLoading = false
    
    public init(action: @escaping () async -> Void, @ViewBuilder label: @escaping () -> Label) {
        self.action = action
        self.label = label
    }
    
    public var body: some View {
        Button {
            Task {
                isLoading = true
                await action()
                isLoading = false
            }
        } label: {
            HStack(spacing: AppTheme.Space.sm) {
                if isLoading {
                    ProgressView()
                        .scaleEffect(0.8)
                        .progressViewStyle(CircularProgressViewStyle(tint: AppTheme.palette(scheme).secondary))
                } else {
                    label()
                }
            }
        }
        .disabled(isLoading)
    }
}

/// Convenience initializer for text-only loading buttons.
public extension LoadingButton where Label == Text {
    init(_ title: String, action: @escaping () async -> Void) {
        self.init(action: action) {
            Text(title)
        }
    }
}