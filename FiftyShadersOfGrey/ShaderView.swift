//
//  ShaderView.swift
//  FiftyShadersOfGrey
//
//  Created by Torben Wetter on 15.06.23.
//

import SwiftUI

struct ShaderView: View {
    let start = Date()

    var body: some View {
        VStack {
            TimelineView(.animation) { context in
                Image("Background")
                    .applyShader(
                        seconds: context.date.timeIntervalSince1970 - self.start.timeIntervalSince1970
                    )
            }
        }
        .padding()
    }
}

extension View {
    func applyShader(seconds: Double) -> some View {
        self
            .layerEffect(
                ShaderLibrary.default.shader(.boundingRect, .float(seconds)), maxSampleOffset: CGSize(width: 25, height: 25)
            )
    }
}

#Preview {
    ShaderView()
}
