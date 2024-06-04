//
//  NavigationRouter.swift
//  demoHeadline
//
//  Created by Pavel Semenchenko on 03.06.2024.
//

import Foundation
import SwiftUI

enum NavigationRoute: Hashable {
    case splash
    case signIn
    case signUp
    case home
}

class NavigationRouter: ObservableObject {
    @Published var currentRoute: NavigationPath = NavigationPath()
    
    // добавляем на верх колоды путь
    func pushScreen(route: NavigationRoute) {
        currentRoute.append(route)
    }
    func pushHome() {
        currentRoute.removeLast(currentRoute.count)
        pushScreen(route: .home)
    }
    //назад - убираем последний слой колоды
    func popScreen() {
        currentRoute.removeLast()
    }
    //убираем все и переходим на ,,,
    func popUntilSignInScreen() {
        currentRoute.removeLast(currentRoute.count)
        pushScreen(route: .signIn)
    }
}
