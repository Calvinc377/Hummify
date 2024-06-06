//
//  HumPage.swift
//  Hummify
//
//  Created by Calvin Christiano on 06/06/24.
//

import Foundation
import SwiftUI

struct HumPage: View {
    var body: some View {
        
        VStack {
            
            Text("Tap and Start Humming")
                .font(.system(size: 28))
                .font(.headline)
                .fontWeight(.bold)
                .padding(.bottom, -1.0)
            
            Text("to search songs")
                .font(.system(size: 25))
                .fontWeight(.light)
                .padding(.bottom, 10.0)
            ZStack {
                Circle()
                    .fill(Color.blue)
                    .frame(width: 202, height: 202)
                Circle()
                    .stroke(lineWidth: 8)
                    .fill(Color.lightgrey)
                    .frame(width: 210, height: 210)
                
                Image(systemName: "mic")
                    .resizable()
                    .frame(width: 96.0, height: 115.0)
                    .imageScale(/*@START_MENU_TOKEN@*/.medium/*@END_MENU_TOKEN@*/)
                    .foregroundColor(Color.white)
            }
            .padding()
        }
        .padding(.bottom, 50.0)
    }
}

struct TabItem: View {
    var body: some View {
        TabView {
            HumPage()
                .tabItem {
                    Label("Hum", systemImage: "music.mic")
                }
            
            
            SearchingPage()
                .tabItem {
                    Label("My Vocal Range", systemImage: "music.quarternote.3")
                }
        }
    }
}


#Preview {
    TabItem()
}
