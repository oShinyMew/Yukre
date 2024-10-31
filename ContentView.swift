import SwiftUI
import CryptoSwift
import KeychainAccess

struct ContentView: View {
    @StateObject private var viewModel = ToolkitViewModel()
    @State private var showSettings = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    SystemStatusView(systemMonitor: viewModel.systemMonitor)
                        .padding(.horizontal)
                    
                    CategoryTabView(selectedCategory: $viewModel.selectedCategory)
                    
                    ToolListView(viewModel: viewModel)
                }
            }
            .navigationTitle("Yukre Toolkit")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showSettings.toggle()
                    } label: {
                        Image(systemName: "gear")
                            .foregroundColor(.primary)
                    }
                }
            }
            .sheet(isPresented: $showSettings) {
                SettingsView()
            }
            .overlay {
                if viewModel.isProcessing {
                    ProcessingOverlay()
                }
            }
        }
    }
}