//
//  HummifyApp.swift
//  Hummify
//
//  Created by Calvin Christiano on 06/06/24.
//

import SwiftUI
import MusicKit

@main
struct HummifyApp: App {
    @StateObject private var musicAuthorizationManager = MusicAuthorizationManager()
    
    var body: some Scene {
        WindowGroup {
            MiddleGround()
                .environmentObject(musicAuthorizationManager)
                .onAppear(){
                    Task{
                        await musicAuthorizationManager.requestAuthorization()
                    }
                }
        }
    }
}

class MusicAuthorizationManager: ObservableObject {
    @Published var isAuthorized: Bool = false
    
    func requestAuthorization() async {
        let status = await MusicAuthorization.request()
        DispatchQueue.main.async {
            self.isAuthorized = (status == .authorized)
        }
    }
}
