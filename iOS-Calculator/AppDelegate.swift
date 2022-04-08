//
//  AppDelegate.swift
//  iOS-Calculator
//
//  Created by Oscar Cabanillas on 06/04/2022.
//

import UIKit

@main

final class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

    // Setup
    setupView()

    return true
  }

  // MARK: - Private methods

  private func setupView() {

    let vc = HomeViewController()
    self.window = UIWindow(frame: UIScreen.main.bounds)
    window?.rootViewController = vc
    window?.makeKeyAndVisible()

  }
}

