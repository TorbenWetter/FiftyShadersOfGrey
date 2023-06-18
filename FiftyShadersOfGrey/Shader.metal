//
//  Shader.metal
//  FiftyShadersOfGrey
//
//  Created by Torben Wetter on 15.06.23.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

// Cubic Bezier function.
float cubic_bezier(float t, float a, float b, float c, float d) {
    float t1 = 1.0 - t;
    return 3.0 * a * pow(t1, 2.0) * t + 3.0 * b * t1 * pow(t, 2.0) + pow(t, 3.0) * d;
}

[[ stitchable ]] half4 shader(float2 position, SwiftUI::Layer layer, float4 bounds, float seconds) {
    // Define the maximum offset.
    float maxOffset = 25.0;
    
    // Adjust the seconds variable to oscillate between 0 and 1.
    float t = (sin(seconds) + 1.0) / 2.0;
    
    // Create an offset for red, green, and blue channels.
    vector_float2 redOffset = vector_float2(cubic_bezier(t, 0.0, 0.8, 0.2, 0.0) * maxOffset, cubic_bezier(t, 0.0, 0.6, 0.4, 0.0) * maxOffset);
    vector_float2 greenOffset = vector_float2(cubic_bezier(t, 0.0, 0.1, 0.9, 1.0) * maxOffset, cubic_bezier(t, 0.0, 0.2, 0.8, 1.0) * maxOffset);
    vector_float2 blueOffset = vector_float2(cubic_bezier(t, 0.5, 0.0, 0.0, 0.5) * maxOffset, cubic_bezier(t, 0.3, 0.0, 0.0, 0.7) * maxOffset);
    
    // Sample the original image at the offset positions.
    half4 redChannel = layer.sample(position + redOffset);
    half4 greenChannel = layer.sample(position + greenOffset);
    half4 blueChannel = layer.sample(position + blueOffset);

    // Create the final color by combining the samples.
    half4 color = half4(redChannel.r, greenChannel.g, blueChannel.b, 1.0);

    return color;
}
