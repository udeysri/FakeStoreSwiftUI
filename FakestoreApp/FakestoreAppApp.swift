//
//  FakestoreAppApp.swift
//  FakestoreApp
//
//  Created by Udaya Sri Senarathne on 2025-04-07.
//

import SwiftUI
import SwiftData

@main
struct FakestoreApp: App {
    let dependencyContainer = DependencyContainer()
    var body: some Scene {
        WindowGroup {
            ProductListView(viewModel: dependencyContainer.makeProductListViewModel())
        }
        .modelContainer(dependencyContainer.container)
    }
}
