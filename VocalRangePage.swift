//
//  VocalRangePage.swift
//  Hummify
//
//  Created by Calvin Christiano on 06/06/24.
//

import Foundation
import SwiftUI

struct VocalRangeHome: View {
    @EnvironmentObject var navigationState: NavigationState
    @State var isDone = false

    var body: some View {
        VStack {
            if(isDone){
                
                    Text("Vocal Range")
                        .font(.system(size: 32))
                        .font(.headline)
                        .fontWeight(.bold)
                        .padding(.bottom, 5.0)
                    Text("To Search Your Vocal Type")
                        .font(.system(size: 25))
                        .fontWeight(.medium)
                        .padding(.bottom, 10.0)
                    ZStack {
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.lighttgrey)
                            .frame(width: 340.0, height: 300.0)
                        Text("Your Voice Range")
                            .font(.system(size: 27))
                            .fontWeight(.semibold)
                            .padding(.bottom, 230.0)
                        Text("You haven't tried it out")
                            .font(.system(size: 20))
                            .padding(.bottom, 170.0)
                        
                        HStack {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.lightgrey)
                                    .frame(width: 106.0, height: 120.0)
                                VStack {
                                    Image(systemName: "waveform")
                                        .resizable()
                                        .foregroundColor(Color.white)
                                        .frame(width: 50.0, height: 60.0)
                                    Text("Low")
                                        .font(.system(size: 24))
                                        .fontWeight(.bold)
                                }
                            }
                            
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.lightgrey)
                                    .frame(width: 106.0, height: 120.0)
                                VStack {
                                    Image(systemName: "waveform")
                                        .resizable()
                                        .foregroundColor(Color.white)
                                        .frame(width: 50.0, height: 60.0)
                                    Text("High")
                                        .font(.system(size: 24))
                                        .fontWeight(.bold)
                                }
                            }
                        }
                        .padding(.top, 5.0)
                        VStack {
                            ZStack {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.blue)
                                    .frame(width: 115.0, height: 58.0)
                                VStack {
                                    Text("Try Now")
                                        .font(.system(size: 20))
                                        .fontWeight(.medium)
                                        .foregroundColor(Color.white)
                                }
                            }
                            .padding(.top, 197.0)
                        }
                    }
            }else{
                Text("TO BE IMPLEMENTED SOON")
                    .font(.title)
                    .fontWeight(.black)
            }
        }
    }
}

#Preview {
    VocalRangeHome()
}
