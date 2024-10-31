import SwiftUI
import Combine

struct ToolkitView: View {
    @StateObject private var viewModel: ToolkitViewModel
    private let input: ToolkitViewModel.Input
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: ToolkitViewModel = ToolkitViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
        
        let viewDidLoad = PassthroughSubject<Void, Never>()
        let toolSelected = PassthroughSubject<String, Never>()
        let categorySelected = PassthroughSubject<ToolCategory?, Never>()
        
        input = ToolkitViewModel.Input(
            viewDidLoad: viewDidLoad.eraseToAnyPublisher(),
            toolSelected: toolSelected.eraseToAnyPublisher(),
            categorySelected: categorySelected.eraseToAnyPublisher()
        )
        
        let output = viewModel.transform(input: input)
        
        // Handle outputs
        output.systemStatus
            .receive(on: DispatchQueue.main)
            .sink { status in
                // Update UI with system status
            }
            .store(in: &cancellables)
        
        output.error
            .receive(on: DispatchQueue.main)
            .sink { error in
                // Handle error
            }
            .store(in: &cancellables)
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    SystemStatusView()
                        .padding(.horizontal)
                    
                    CategoryTabView()
                    
                    ToolListView()
                }
            }
            .navigationTitle("Yukre Toolkit")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { }) {
                        Image(systemName: "gear")
                    }
                }
            }
        }
        .onAppear {
            input.viewDidLoad.send(())
        }
    }
}