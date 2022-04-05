//
//  FinnezonApp.swift
//  Finnezon
//
//  Created by Saad Qureshi on 04/04/2022.
//

import SwiftUI

@main
struct FinnezonApp: App {
    let persistenceController = PersistenceController.shared

    var window: UIWindow? {
        guard let scene = UIApplication.shared.connectedScenes.first,
              let windowSceneDelegate = scene.delegate as? UIWindowSceneDelegate,
              let window = windowSceneDelegate.window else {
            return nil
        }
        return window
    }

    var body: some Scene {
        WindowGroup {
            Text("")
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .preferredColorScheme(.light)
                .onAppear {
                    guard let window = window else { return }
                    
                    let container = DependencyContainer()
                    let sceneCoordinator = SceneCoordinator(window: window, dependencyContainer: container)
                    sceneCoordinator.start()
                }
        }
    }
}
