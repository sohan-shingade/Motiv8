//
//  Utilities.swift
//  Motivate
//
//  Created by Sohan Shingade on 4/16/20.
//  Copyright © 2020 Sohan Shingade. All rights reserved.
//

import Foundation
import SwiftUI

struct GeometryGetter: View {
    @Binding var rect: CGRect

    var body: some View {
        GeometryReader { geometry in
            Group { () -> AnyView in
                DispatchQueue.main.async {
                    self.rect = geometry.frame(in: .global)
                }

                return AnyView(Color.clear)
            }
        }
    }
}
