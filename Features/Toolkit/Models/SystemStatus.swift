import Foundation

struct SystemStatus {
    let cpuUsage: Double
    let memoryUsage: MemoryUsage
    let diskSpace: DiskSpace
    let batteryLevel: Double
    let networkStatus: NetworkStatus
    let temperature: Double
    
    var formattedCPUUsage: String {
        String(format: "%.1f%%", cpuUsage)
    }
    
    var formattedMemoryUsage: String {
        String(format: "%.1f GB / %.1f GB", memoryUsage.used, memoryUsage.total)
    }
    
    var formattedDiskSpace: String {
        String(format: "%.1f GB / %.1f GB", diskSpace.used, diskSpace.total)
    }
    
    var formattedBatteryLevel: String {
        String(format: "%.0f%%", batteryLevel)
    }
    
    var formattedTemperature: String {
        String(format: "%.1f°C", temperature)
    }
}

struct MemoryUsage {
    let used: Double
    let total: Double
}

struct DiskSpace {
    let used: Double
    let total: Double
}

struct NetworkStatus {
    enum ConnectionType {
        case wifi
        case cellular
        case none
    }
    
    let type: ConnectionType
    let strength: Double
}
