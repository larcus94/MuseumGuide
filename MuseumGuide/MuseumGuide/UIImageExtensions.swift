//
//  UIImageExtensions.swift
//  MuseumGuide
//
//  Created by Laurin Brandner on 26/07/2015.
//  Copyright © 2015 Laurin Brandner. All rights reserved.
//

import UIKit
import CoreImage

extension UIImage {
    
    func detectFaces() -> [ImageFaceAccessibility] {
        guard let image = CoreImage.CIImage(image: self) else {
            return []
        }
        
        var faceFrameTransform = CGAffineTransformMakeTranslation(0, size.height)
        faceFrameTransform = CGAffineTransformScale(faceFrameTransform, 1, -1)
        
        let detector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: [CIDetectorAccuracy: CIDetectorAccuracyLow])
        let options: [String : AnyObject] = [CIDetectorSmile: true, CIDetectorEyeBlink: true]
        
        return detector.featuresInImage(image, options: options)
                       .flatMap { feature in
                           return (feature as? CIFaceFeature).map { ImageFaceAccessibility(faceFeature: $0, transform: faceFrameTransform) }
                       }
                       .sort { $0.frame.minX < $1.frame.minX }
    }
    
}
