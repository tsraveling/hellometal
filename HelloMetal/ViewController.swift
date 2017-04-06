//
//  ViewController.swift
//  HelloMetal
//
//  Created by Timothy Raveling on 4/6/17.
//  Copyright © 2017 tsraveling. All rights reserved.
//

import UIKit
import Metal
var pipelineState: MTLRenderPipelineState!

class ViewController: UIViewController {
    
    // MARK: - Outlets and Vars -
    
    var device: MTLDevice!
    var metalLayer : CAMetalLayer!
    var objectToDraw: Cube!
    var commandQueue: MTLCommandQueue!
    var timer: CADisplayLink!
    
    // MARK: - Actions -
    
    // MARK: - Game Functions -
    
    func render() {
        
        guard let drawable = metalLayer?.nextDrawable() else { return }
        
        objectToDraw.render(commandQueue: commandQueue, pipelineState: pipelineState, drawable: drawable, clearColor: nil)
    }
    
    func gameloop() {
        autoreleasepool {
            self.render()
        }
    }
    
    // MARK: - VC Functions -

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Set up the Metal device
        device = MTLCreateSystemDefaultDevice()
        
        // Set up the metal layer
        metalLayer = CAMetalLayer()          // 1
        metalLayer.device = device           // 2
        metalLayer.pixelFormat = .bgra8Unorm // 3
        metalLayer.framebufferOnly = true    // 4
        metalLayer.frame = view.layer.frame  // 5
        view.layer.addSublayer(metalLayer)   // 6
        
        // Make the triangle
        objectToDraw = Cube(device: device)
        objectToDraw.positionX = -0.25
        objectToDraw.rotationZ = Matrix4.degrees(toRad: 45)
        objectToDraw.scale = 0.5
        
        // Set up render pipeline
        
        // 1
        let defaultLibrary = device.newDefaultLibrary()!
        let fragmentProgram = defaultLibrary.makeFunction(name: "basic_fragment")
        let vertexProgram = defaultLibrary.makeFunction(name: "basic_vertex")
        
        // 2
        let pipelineStateDescriptor = MTLRenderPipelineDescriptor()
        pipelineStateDescriptor.vertexFunction = vertexProgram
        pipelineStateDescriptor.fragmentFunction = fragmentProgram
        pipelineStateDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        
        // 3
        pipelineState = try! device.makeRenderPipelineState(descriptor: pipelineStateDescriptor)
        
        // Set up the command queue
        commandQueue = device.makeCommandQueue()
        
        // Set up the game loop
        timer = CADisplayLink(target: self, selector: #selector(ViewController.gameloop))
        timer.add(to: RunLoop.main, forMode: RunLoopMode.defaultRunLoopMode)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

