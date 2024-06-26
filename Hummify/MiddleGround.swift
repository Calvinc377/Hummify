//
//  MiddleGround.swift
//  Hummify
//
//  Created by Rifqie Tilqa Reamizard on 06/06/24.
//

import Foundation
import SwiftUI

struct MiddleGround: View {
    @EnvironmentObject private var musicAuthorizationManager: MusicAuthorizationManager

    var body: some View {
        if musicAuthorizationManager.isAuthorized {
            TabItem()
        } else {
            Text("Authorization required to access this app.")
                .padding()
        }
    }
}
