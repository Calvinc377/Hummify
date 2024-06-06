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
            
            Text("To Search Songs")
                .font(.system(size: 25))
                .fontWeight(.medium)
                .padding(.bottom, 10.0)
        
        }
        .padding(.bottom, 50.0)
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
        .padding(.bottom, 130.0)
//        HStack {
//            VStack {
//                Image(systemName: "music.mic")
//                    .foregroundColor(Color.black)
//                    .padding(.top, 55.0)
//                    .fixedSize()
//                    .frame(width: 44.0, height: 69.0)
//
//                Text("Hum")
//                    .font(.system(size: 20))
//                    .fontWeight(.semibold)
//
//            }
//            .padding([.top, .trailing], 80.0)
//
//            VStack {
//                Image(systemName: "waveform")
//                    .foregroundColor(/*@START_MENU_TOKEN@*/.black/*@END_MENU_TOKEN@*/)
//                    .padding(.top, 55.0)
//                    .frame(width: 44.0, height: 69.0)
//
//                Text("My Range")
//                    .font(.system(size: 20))
//                    .fontWeight(.semibold)
//            }
//            .padding(.top, 50.0)
//        }
        
            .padding()
    }
}

//#Preview {
//    ContentView()
//}
