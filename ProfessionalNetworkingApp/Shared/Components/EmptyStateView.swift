// MARK: - Empty State
/// Friendly placeholder for empty lists or error states.
public struct EmptyStateView: View {
    @Environment(\.colorScheme) private var scheme
    private let icon: String
    private let title: String
    private let message: String
    private let actionTitle: String?
    private let action: (() -> Void)?
    
    public init(
        icon: String,
        title: String,
        message: String,
        actionTitle: String? = nil,
        action: (() -> Void)? = nil
    ) {
        self.icon = icon
        self.title = title
        self.message = message
        self.actionTitle = actionTitle
        self.action = action
    }
    
    public var body: some View {
        let p = AppTheme.palette(scheme)
        
        VStack(spacing: AppTheme.Space.lg) {
            Image(systemName: icon)
                .font(.system(size: 48, weight: .medium))
                .foregroundColor(p.textSecondary)
            
            VStack(spacing: AppTheme.Space.sm) {
                Text(title)
                    .styled(.headline)
                
                Text(message)
                    .styled(.body, color: p.textSecondary)
                    .multilineTextAlignment(.center)
            }
            
            if let actionTitle = actionTitle, let action = action {
                Button(actionTitle, action: action)
                    .buttonStyle(OutlineButtonStyle())
                    .frame(maxWidth: 200)
            }
        }
        .padding(AppTheme.Space.xl)
    }
}