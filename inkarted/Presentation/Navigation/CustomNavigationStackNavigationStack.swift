////
////  ABNavigationView.swift
////  AlphaBankBusiness
////
////  Created by Georgii Lysenko on 03.05.2023.
////
// 
//import SwiftUI
// 
///// Wrapper for SwiftUI's NavigationStack that contains
///// initial configuration for it.
//struct CustomNavigationStack<Content>: View where Content: View {
//  @StateObject private var router = NavigationRouter()
//  
//  var content: Content
//  
//  init(@ViewBuilder content: () -> Content) {
//    self.content = content()
//  }
//  
//  
//}
// 
//struct NavigationView_Previews: PreviewProvider {
//  @StateObject static var router = NavigationRouter()
//  
//  static var previews: some View {
//    CustomNavigationStack {
//      Text("someText")
//    }
//  }
//}
// 
