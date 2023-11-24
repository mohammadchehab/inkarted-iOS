//
//  NavigationStateManager.swift
//  inkarted
//
//  Created by Mohammad_Shehab on 23/11/2023.
//

import Foundation
import Combine
import SwiftUI

class NavigationStateManager : ObservableObject {
    @Published var selectionPath = [ScreenType]()
    
    var data : Data? {
        get {
            try? JSONEncoder().encode(selectionPath)
        }
        set {
            guard let data = newValue,
                  let path = try? JSONDecoder().decode([ScreenType].self, from: data) else {
                
                return
            }
            self.selectionPath = path
        }
    }
    
    func popToRoot () {
        self.selectionPath = []
    }
    
    func go (to: ScreenType) {
        self.selectionPath = [to]
    }
    
    var objectWillChangeSequence: AsyncPublisher<Publishers.Buffer<ObservableObjectPublisher>> {
        objectWillChange
            .buffer(size: 1, prefetch:  .byRequest, whenFull: .dropOldest)
            .values
    }
}
