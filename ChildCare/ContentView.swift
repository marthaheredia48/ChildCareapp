//
//  ContentView.swift
//  ChildCare
//
//  Created by Martha Heredia Andrade on 19/10/25.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    @AppStorage("hasCompletedBabySetup") private var hasCompletedBabySetup = false
    
    var body: some View {
        NavigationStack { 
            Group {
                if !hasCompletedOnboarding {
                    OnboardingView()
                } else if !isLoggedIn {
                    OnboardingView()
                } else if !hasCompletedBabySetup {
                    BabyProfileSetupView()
                        .navigationBarBackButtonHidden(true)
                } else {
                    HomeView()
                }
            }
            .navigationBarHidden(true)
        }
    }
}
#Preview {
    ContentView()
}
