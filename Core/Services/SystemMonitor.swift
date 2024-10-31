import Foundation
import UIKit

final class SystemMonitor {
    static let shared = SystemMonitor()
    
    private var timer: Timer?
    private var observers: [(SystemStatus) -> Void] = []
    
    private init() {
        startMonitoring()
    }
    
    func observe(_ callback: @escaping (SystemStatus) -> Void) {
        observers.append(callback)
    }
    
    private func startMonitoring() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateStatus()
        }
    }
    
    private func updateStatus() {
        let status = SystemStatus(
            cpuUsage: getCPUUsage(),
            memoryUsage: getMemoryUsage(),
            diskSpace: getDiskSpace(),
            batteryLevel: getBatteryLevel(),
            networkStatus: getNetworkStatus(),
            temperature: getDeviceTemperature()
        )
        
        observers.forEach { $0(status) }
    }
    
    private func getCPUUsage() -> Double {
        var totalUsageOfCPU: Double = 0.0
        var threadsList: thread_act_array_t?
        var threadsCount = mach_msg_type_number_t(0)
        let threadsResult = withUnsafeMutablePointer(to: &threadsList) {
            $0.withMemoryRebound(to: thread_act_array_t?.self, capacity: 1) {
                task_threads(mach_task_self_, $0, &threadsCount)
            }
        }
        
        if threadsResult == KERN_SUCCESS, let threadsList = threadsList {
            for index in 0..<threadsCount {
                var threadInfo = thread_basic_info()
                var threadInfoCount = mach_msg_type_number_t(THREAD_INFO_MAX)
                let infoResult = withUnsafeMutablePointer(to: &threadInfo) {
                    $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                        thread_info(threadsList[Int(index)], thread_flavor_t(THREAD_BASIC_INFO), $0, &threadInfoCount)
                    }
                }
                
                if infoResult == KERN_SUCCESS {
                    totalUsageOfCPU = (Double(threadInfo.cpu_usage) / Double(TH_USAGE_SCALE)) * 100.0
                }
            }
            
            vm_deallocate(mach_task_self_, vm_address_t(UInt(bitPattern: threadsList)), vm_size_t(Int(threadsCount) * MemoryLayout<thread_t>.stride))
        }
        
        return totalUsageOfCPU
    }
    
    private func getMemoryUsage() -> MemoryUsage {
        var taskInfo = task_vm_info_data_t()
        var count = mach_msg_type_number_t(MemoryLayout<task_vm_info>.size / MemoryLayout<natural_t>.size)
        let result = withUnsafeMutablePointer(to: &taskInfo) {
            $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                task_info(mach_task_self_, task_flavor_t(TASK_VM_INFO), $0, &count)
            }
        }
        
        let used = Double(taskInfo.phys_footprint) / 1024.0 / 1024.0
        let total = Double(ProcessInfo.processInfo.physicalMemory) / 1024.0 / 1024.0
        
        return MemoryUsage(used: used, total: total)
    }
    
    private func getDiskSpace() -> DiskSpace {
        let fileManager = FileManager.default
        guard let path = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first?.path else {
            return DiskSpace(used: 0, total: 0)
        }
        
        do {
            let attributes = try fileManager.attributesOfFileSystem(forPath: path)
            let total = (attributes[.systemSize] as? NSNumber)?.doubleValue ?? 0
            let free = (attributes[.systemFreeSize] as? NSNumber)?.doubleValue ?? 0
            let used = total - free
            return DiskSpace(used: used / 1024.0 / 1024.0, total: total / 1024.0 / 1024.0)
        } catch {
            return DiskSpace(used: 0, total: 0)
        }
    }
    
    private func getBatteryLevel() -> Double {
        UIDevice.current.isBatteryMonitoringEnabled = true
        return Double(UIDevice.current.batteryLevel * 100)
    }
    
    private func getNetworkStatus() -> NetworkStatus {
        // In a real app, you'd implement proper network monitoring
        return NetworkStatus(type: .wifi, strength: 0.85)
    }
    
    private func getDeviceTemperature() -> Double {
        // This would require private APIs in a real app
        return Double.random(in: 30...45)
    }
}