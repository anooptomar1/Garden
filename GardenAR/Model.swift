//
//  Model.swift
//  GardenAR
//
//  Created by Jennifer Vilanda Hasler on 8/5/2560 BE.
//  Copyright © 2560 Jennifer Vilanda Hasler. All rights reserved.
//

import Foundation











import MetalKit

struct Vertex {
    var position: float4
}

let cubeVertices = [
    Vertex(position: float4( -1,  1, 1, 1)),
    Vertex(position: float4( -1, -1, 1, 1)),
    Vertex(position: float4(  1, -1, 1, 1)),
    Vertex(position: float4(  1,  1, 1, 1)),
    Vertex(position: float4( -1,  1,-1, 1)),
    Vertex(position: float4( -1, -1,-1, 1)),
    Vertex(position: float4(  1, -1,-1, 1)),
    Vertex(position: float4(  1,  1,-1, 1)),
]


let cubeIndices: [UInt16] = [
    3, 2, 6, 6, 7, 3,
    4, 5, 1, 1, 0, 4,
    4, 0, 3, 3, 7, 4,
    1, 5, 6, 6, 2, 1,
    0, 1, 2, 2, 3, 0,
    7, 6, 5, 5, 4, 7,
]


var planeVertices = [
    Vertex(position: float4(-1, 1, 0, 1)),
    Vertex(position: float4(-1, -1, 0, 1)),
    Vertex(position: float4(1, -1, 0, 1)),
    Vertex(position: float4(1, 1, 0, 1))
]

var planeIndices: [UInt16] = [
    0, 1, 2,
    2, 3, 0]

