//
//  ImageToImageBaseModel.swift
//  Sapp
//
//  Created by dabby on 2019/7/19.
//  Copyright © 2019 Jam. All rights reserved.
//

import UIKit
import Vision

public typealias ImageToImageOutputHandler = ([UIImage]) -> Void

class ImageToImageBaseModel  {
    var requests = [VNRequest]()
    var outputHandler: ImageToImageOutputHandler? = nil
    var modelURL: URL {
        get {
            return Bundle.main.bundleURL
        }
    }
    
    init() {
        
    }
    
    func setup() {
        let visionModel = try? VNCoreMLModel(for: MLModel(contentsOf: self.modelURL))
        weak var weakself = self
        let objectReco = VNCoreMLRequest(model: visionModel!) { (request, error) in
            weakself?.handleResults(request.results!)
        }
        self.requests.append(objectReco)
    }
    
    func inputImage(image: UIImage, outputHandler: @escaping ImageToImageOutputHandler) {
        if self.requests.count == 0 {
            self.setup()
        }
        self.outputHandler = outputHandler
        let requestHandler = VNImageRequestHandler(cgImage: image.cgImage!, orientation: CGImagePropertyOrientation(image.imageOrientation), options: [:])
        do {
            try requestHandler.perform(self.requests)
        } catch {
            
        }
    }
    
    func handleResults(_ results: [Any]) {
        let firstObj = results.first as! VNCoreMLFeatureValueObservation
        let multiArrayValue = firstObj.featureValue.multiArrayValue
        let newImage = self.image(multiArray: multiArrayValue!)
        if ((self.outputHandler) != nil) {
            self.outputHandler!([newImage])
            self.outputHandler = nil
        }
    }
    
    func image(multiArray: MLMultiArray) -> UIImage {
        return UIImage()
    }
}

extension CGImagePropertyOrientation {
    init(_ uiOrientation: UIImage.Orientation) {
        switch uiOrientation {
        case .up: self = .up
        case .upMirrored: self = .upMirrored
        case .down: self = .down
        case .downMirrored: self = .downMirrored
        case .left: self = .left
        case .leftMirrored: self = .leftMirrored
        case .right: self = .right
        case .rightMirrored: self = .rightMirrored
        default:
            self = .up
        }
    }
}
