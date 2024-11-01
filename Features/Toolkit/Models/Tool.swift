import Foundation

struct Tool: Identifiable {
    let id: String
    let name: String
    let description: String
    let category: ToolCategory
    let impact: SecurityImpact
    var isEnabled: Bool
}

enum ToolCategory: String, CaseIterable {
    case system = "System"
    case security = "Security"
    case network = "Network"
    case performance = "Performance"
    
    var icon: String {
        switch self {
        case .system: return "cpu"
        case .security: return "lock.shield"
        case .network: return "network"
        case .performance: return "gauge"
        }
    }
}

enum SecurityImpact: String {
    case low = "Low"
    case medium = "Medium"
    case high = "High"
    
    var color: Color {
        switch self {
        case .low: return .green
        case .medium: return .yellow
        case .high: return .red
        }
    }
}