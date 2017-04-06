//
//  Vertex.swift
//  HelloMetal
//
//  Created by Timothy Raveling on 4/6/17.
//  Copyright © 2017 tsraveling. All rights reserved.
//

struct Vertex{
    
    var x,y,z: Float     // position data
    var r,g,b,a: Float   // color data
    
    func floatBuffer() -> [Float] {
        return [x,y,z,r,g,b,a]
    }
    
}
