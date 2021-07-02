//
//  ContentView.swift
//  BucketList
//
//  Created by Vladimir on 01.07.2021.
//

import SwiftUI
import MapKit
import LocalAuthentication

struct ContentView: View {
    
    @State private var showingPlaceDetail = false
    @State private var isUnlocked = false

    var body: some View {
        
            if isUnlocked {
                
            CustomMapView()
        
            } else {
                Button("Unlock Places") {
                    self.authenticate()
                }
                .padding()
                .background(Color.black.opacity(0.75))
                .foregroundColor(.white)
                .clipShape(Capsule())
            }
        
}
    func authenticate() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Please authenticate yourself to unlock the places."
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                
                DispatchQueue.main.async {
                    if success {
                        self.isUnlocked = true
                    } else {
                        // error
                    }
                }
                
            }
        } else {
            // no biometrics
        }
    }

}
