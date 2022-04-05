//
//  CoordinatorProtocol.swift
//  Finnezon
//
//  Created by Saad Qureshi on 04/04/2022.
//

import UIKit

public protocol CoordinatorProtocol: AnyObject {
    // The navigation controller this coordiantor uses to push view controllers.
    var navigationController: UINavigationController { get }

    // A reference to the parent coordinator of this coordinator. Child coordinator
    var parentCoordinator: CoordinatorProtocol? { get }

    // An array containing child coordinators that this coordinator holds a
    var childCoordinators: [CoordinatorProtocol] { get }

    // Called when the coordinator is asked to take over control.
    func start()

    // Called when a child coordinator has finished.
    func childDidFinish(_ child: CoordinatorProtocol)
}
