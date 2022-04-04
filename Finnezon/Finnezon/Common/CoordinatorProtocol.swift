//
//  CoordinatorProtocol.swift
//  Finnezon
//
//  Created by Saad Qureshi on 04/04/2022.
//

import UIKit

public protocol CoordinatorProtocol: AnyObject {
    /// The navigation controller this coordiantor uses to push view controllers.
    var navigationController: UINavigationController { get }

    /// A reference to the parent coordinator of this coordinator. Child coordinator
    /// use it to call `childDidFinish` if necessary.
    var parentCoordinator: CoordinatorProtocol? { get }

    /// An array containing child coordinators that this coordinator holds a
    /// reference to to keep them alive.
    var childCoordinators: [CoordinatorProtocol] { get }

    /// Called when the coordinator is asked to take over control.
    func start()

    /// Called when a child coordinator has finished.
    func childDidFinish(_ child: CoordinatorProtocol)
}

///// Extensions to `CoordinatorProtocol` that allos a coordinator to
///// show "global" UI such as alerts and loading overlays.
//extension CoordinatorProtocol {
//    /// Shows an error alert and can optionally allow the caller to assign
//    /// a retry block if the operation can be retried.
//    ///
//    /// - Parameters:
//    ///     - error: The error to display. `localizedDescription` will be used as the message.
//    ///     - retry: An optional block to execute. If present, the alert will include a retry button, and if
//    ///              pressed, the `retry` closure will be executed.
//    public func showError(_ error: Error, retry: (() -> Void)? = nil) {
//        Overlay.shared.showError(error, retry: retry)
//    }
//
//    /// Shows an alert to indicate a destructive operation is about to be performed.
//    /// The alert shows a button to perform the destructive operation and one to cancel it.
//    /// When the user pressed either button, the `completion` closure is called with
//    /// a bool indicating whether the user wanted to perform the destructive operation or not.
//    ///
//    /// - Parameters:
//    ///     - title: The title of the alert.
//    ///     - message: The message of the alert.
//    ///     - destructiveButtonTitle: The title of the destructive button.
//    ///     - cancelButtonTitle: The title of the cancel button.
//    ///     - completion: A closure to call when either button has been pressed. The `Bool` will be set to
//    ///                   `true` if the user chose to perform the destructive action.
//    public func showDestructiveAction(with title: String, message: String,
//                                      destructiveButtonTitle: String, cancelButtonTitle: String,
//                                      completion: @escaping (Bool) -> Void) {
//        Overlay.shared.showDestructiveAction(with: title, message: message,
//                                             destructiveButtonTitle: destructiveButtonTitle, cancelButtonTitle: cancelButtonTitle,
//                                             completion: completion)
//    }
//
//    /// Shows an overlaid loading indicator with a message.
//    ///
//    /// - Parameters:
//    ///     - message: The message to show in the loadnig indicator
//    public func showLoading(with message: String) {
//        Overlay.shared.showLoading(with: message)
//    }
//
//    /// Hides an overlaid loading indicator if one is shown. Safe to call
//    /// even if one is not shown.
//    public func hideLoading() {
//        Overlay.shared.hideLoading()
//    }
//}

