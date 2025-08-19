// MARK: - Status Badge
/// Small, colored badge for labeling statuses.
public enum StatusType {
    case success
    case alert
    case warning
    case info
    case neutral
}

/// Theme-aware status badge with semantic colors.
public struct StatusBadge: View {
    @Environment(\.colorScheme) private var scheme
    private let type: StatusType
    private let text: String
    
    public init(_ type: StatusType, _ text: String) {
        self.type = type
        self.text = text
    }
    
    public var body: some View {
        let p = AppTheme.palette(scheme)
        
        Text(text)
            .font(.caption.weight(.semibold))
            .foregroundColor(badgeTextColor(p))
            .padding(.horizontal, AppTheme.Space.sm)
            .padding(.vertical, AppTheme.Space.xs)
            .background(badgeBackground(p))
            .cornerRadius(AppTheme.Radius.sm)
    }
    
    private func badgeBackground(_ p: AppTheme.Palette) -> Color {
        switch type {
        case .success: return p.success.opacity(0.15)
        case .alert: return p.alert.opacity(0.15)
        case .warning: return p.warning.opacity(0.15)
        case .info: return p.info.opacity(0.15)
        case .neutral: return p.textSecondary.opacity(0.15)
        }
    }
    
    private func badgeTextColor(_ p: AppTheme.Palette) -> Color {
        switch type {
        case .success: return p.success
        case .alert: return p.alert
        case .warning: return p.warning
        case .info: return p.info
        case .neutral: return p.textSecondary
        }
    }
}