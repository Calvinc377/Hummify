//
//  SearchingPage.swift
//  Hummify
//
//  Created by Calvin Christiano on 06/06/24.
//

import Foundation
import SwiftUI

struct SearchingPage: View {
    var body: some View {
        VStack {
    
            Text("Listening....")
                .font(.system(size: 28))
                .font(.headline)
                .fontWeight(.bold)
                .padding(.bottom, 10.0)
            
            ZStack {
                
                Circle()
                    .fill(Color.blue)
                    .frame(width: 202, height: 202)
                
                Circle()
                    .stroke(lineWidth: 8)
                    .fill(Color.gray)
                    .frame(width: 210, height: 210)
                
                Image(systemName: "mic.fill")
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

#Preview {
    SearchingPage()
}
