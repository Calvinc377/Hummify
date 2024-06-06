//
//  ContentView.swift
//  HummifyWatch Watch App
//
//  Created by Calvin Christiano on 06/06/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        HStack{
            Spacer()
            VStack {
                Image(systemName: "music.mic.circle.fill")
                    .resizable()
                    .foregroundStyle(Color.white)
                    .frame(width: 70, height: 70)
                Text("Hum")
                    .font(.system(size:14))
                    .foregroundStyle(Color.white)
                    .padding(.bottom, 2)
                    .multilineTextAlignment(.center)
            }
            .padding()
            .background(.blue)
            .cornerRadius(15)
            Spacer()
            VStack {
                Image(systemName: "waveform")
                    .resizable()
                    .foregroundStyle(Color.white)
                    .frame(width: 55, height: 55)
                Text("My Vocal\n Range")
                    .font(.system(size:14))
                    .foregroundStyle(Color.white)
                    .padding(.bottom, 2)
                    .multilineTextAlignment(.center)
            }
            .padding()
            .background(.blue)
            .cornerRadius(15)
            Spacer()
        }
    }
}

#Preview {
    ContentView()
}
