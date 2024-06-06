//
//  HumToSearch.swift
//  HummifyWatch Watch App
//
//  Created by Calvin Christiano on 06/06/24.
//

import Foundation
import SwiftUI

struct HumToSearch: View {
    @State private var gerak: Bool = false
    @State private var animationAmount = 1.0
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                Text("Tap and Start Humming")
                    .font(.system(size:16))
                    .foregroundStyle(Color.blue)
                    .padding(.bottom, 2)
                Spacer()
                Button("coba") {
                    gerak.toggle()
                    //                    animationAmount += 1 //animationAmout = animationAmount + 1
                }
                ZStack {
                    Circle()
                        .foregroundStyle(.blue)
                        .frame(height: 110)
                    Image(systemName: "waveform.circle")
                        .resizable()
                        .foregroundStyle(Color.white)
                        .frame(width: 100, height: 100)
                        .padding(20)
                    //.background(.blue)
                    
                        .symbolEffect(.bounce, options: .repeat(5), value: gerak)
                    
                }
                
                Spacer()
            }
        }
    }
}

#Preview {
    HumToSearch()
}
