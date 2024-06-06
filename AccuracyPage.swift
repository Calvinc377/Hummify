//
//  AccuracyPage.swift
//  HummifyWatch Watch App
//
//  Created by Calvin Christiano on 06/06/24.
//

import Foundation
import SwiftUI

struct AccuracyPage: View {
    var body: some View {
        Form {
            Section {
                VStack {
                    Text("Thinking Outloud")
                    Text("Ed Sheeran")
                    Text("Accuracy")
                }
                VStack {
                    Text("Perfect")
                    Text("Ed Sheeran")
                }
                VStack{
                    Text("Perfect")
                    Text("Ed Sheeran")
                }
//                .multilineTextAlignment(.leading)??
            }
            .font(.system(size:15))

        }
    }
}
    #Preview {
        AccuracyPage()
    }
