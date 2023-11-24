//
//  LoginRootView.swift
//  inkarted
//
//  Created by Mohammad_Shehab on 23/11/2023.
//

import Foundation
import SwiftUI
import Combine


struct LandingView : View {
    
    @StateObject var navigationStateManager  = NavigationStateManager()
    @State var otp : String = "";
    
    var body :  some View {
        NavigationStack(path: $navigationStateManager.selectionPath) {
            LoginView()
                .navigationDestination(for: ScreenType.self){ state in
                    switch (state) {
                    case .OTPView:
                        OTPView(otpCode: $otp, otpCodeLength: 4, textColor: .black, textSize: 20)
                    }
                }
                .environmentObject(navigationStateManager)
        }
        
    }
}


struct LandingView_Preview :PreviewProvider {
    static var previews: some View {
        LandingView()
    }
}
