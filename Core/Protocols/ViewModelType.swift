import Foundation
import Combine

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}

protocol CoordinatorType: AnyObject {
    var navigationController: UINavigationController { get }
    var childCoordinators: [CoordinatorType] { get set }
    
    func start()
    func coordinate(to coordinator: CoordinatorType)
}