//
//  NavigationStack.swift
//  inkarted
//
//  Created by Mohammad_Shehab on 21/11/2023.
//

import SwiftUI

@MainActor
final class NavigationRouter: ObservableObject {
    @Published var path = [any View]()

    func push<T: View>(_ destination: T) {
        path.append(AnyView(destination))
    }

    func pop() {
        _ = path.popLast()
    }

    func moveTo<T: View>(_ destination: T) {
        path = [AnyView(destination)]
    }

    func popToRoot() {
        path = []
    }
}
