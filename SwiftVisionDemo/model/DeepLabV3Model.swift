//
//  DeepLabV3Model.swift
//  Sapp
//
//  Created by dabby on 2019/7/19.
//  Copyright © 2019 Jam. All rights reserved.
//

import UIKit
import Vision

class DeepLabV3Model: ImageToImageBaseModel {
    
    override var modelURL: URL {
        get {
            return Bundle.main.url(forResource: "DeepLabV3Int8LUT", withExtension: "mlmodelc")!
        }
    }
//
//    override func imageWithMultiArray(multiArray: MLMultiArray) -> UIImage {
//        return nil
//    }
    override func image(multiArray: MLMultiArray) -> UIImage {
        let shape = multiArray.shape
        let width = shape[0].intValue
        let height = shape[1].intValue
        let bitsPerComponent = 8
        let depth = 3
        let bitsPerPixel = bitsPerComponent * depth
        let bytesPerRow = width * bitsPerPixel / 8
        
        let dataPointer = multiArray.dataPointer
        let dataCount = multiArray.count
        let data32Arr  = dataPointer.bindMemory(to: UInt32.self, capacity: dataCount);
        
        let outputLength = dataCount * depth
        let outputArr = UnsafeMutableRawPointer.allocate(byteCount: outputLength, alignment: 0).bindMemory(to: UInt8.self, capacity: outputLength)
        
        var maxvalue: UInt32 = 0
        for i in 0 ..< dataCount {
            let this = data32Arr[i]
            if (this > maxvalue) {
                maxvalue = this
            }
        }
        
        let doubleMaxValue = CGFloat(maxvalue)
        for i in 0 ..< dataCount {
            var this = CGFloat(data32Arr[i])
            this = this / CGFloat(doubleMaxValue)
            let hsv = UIColor(hue: this * 0.7, saturation: 1, brightness: this == 0 ? 0 : 1, alpha: 1)
            let components = hsv.cgColor.components
            outputArr[i * depth + 0] = UInt8(components![0] * 255)
            outputArr[i * depth + 1] = UInt8(components![1] * 255)
            outputArr[i * depth + 2] = UInt8(components![2] * 255)
//            if (this != 0) {
//                print(this)
//            }
        }
        
        let dataRef = CFDataCreate(nil, outputArr, outputLength)
        let dataProviderRef = CGDataProvider(data: dataRef!)
        
        let ref = CGImage(width: width, height: height, bitsPerComponent: bitsPerComponent, bitsPerPixel: bitsPerPixel, bytesPerRow: bytesPerRow, space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: .byteOrder16Big, provider: dataProviderRef!, decode: nil, shouldInterpolate: true, intent: .defaultIntent)
        let newImage = UIImage(cgImage: ref!)
        return newImage
    }
}
