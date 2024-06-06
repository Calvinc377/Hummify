//
//  VocalRange.swift
//  HummifyWatch Watch App
//
//  Created by Calvin Christiano on 06/06/24.
//

import Foundation
import SwiftUI

struct VocalRange: View {
    var body: some View {
        NavigationView {
            VStack{
                HStack {
                    VStack {
                        Image(systemName: "music.mic.circle")
                            .resizable()
                            .foregroundStyle(Color.white)
                            .frame(width: 50, height: 50)
                        Text("Lowest\nVoice")
                            .font(.system(size:16))
                            .foregroundStyle(Color.blue)
                            .padding(.bottom, 2)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                    .background(.purple)
                    .cornerRadius(15)
                    
                    VStack {
                        Image(systemName: "music.mic.circle.fill")
                            .resizable()
                            .foregroundStyle(Color.white)
                            .frame(width: 50, height: 50)
                        Text("Highest\nVoice")
                            .font(.system(size:16))
                            .foregroundStyle(Color.purple)
                            .padding(.bottom, 2)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                    .background(.blue)
                    .cornerRadius(15)
                }
                Text("Your Voice Range is")
                
                HStack {
                    Spacer()
                    Text("C#2")
                        .padding()
                        .background(.gray)
                        .cornerRadius(10)
                    Spacer()
                    Text("C4")
                        .padding()
                        .background(.gray)
                        .cornerRadius(10)
                    Spacer()
                }
            }
        }
    }
}
    
#Preview {
    VocalRange()
}
