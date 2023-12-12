//
//  RemoveBackgroundViewModel.swift
//  Remove-Background-Image
//
//  Created by Melih Çulha on 6.12.2023.
//

import Foundation
import SwiftUI
import Combine
import Vision
import CoreImage.CIFilterBuiltins

@Observable final class RemoveBackgroundViewModel {
    var image: UIImage? { 
        didSet { 
            subjectPosition = nil
            output = nil
        }
    }
    var source: ImageSourceType?
    var presentSelection: Bool = false
    var output: UIImage?
    
    @ObservationIgnored
    var subjectPosition: CGPoint?
    
    @ObservationIgnored
    private var processingQueue = DispatchQueue(label: "EffectsProcessing")
    
    func removeBackground() {
        guard let image else { return }
        self.regenerate(usingInputImage: CIImage(image: image)!, subjectPosition: subjectPosition)
    }
    
    private func regenerate(usingInputImage inputImage: CIImage, subjectPosition: CGPoint?) {
        processingQueue.async {
            // Generate the input-image mask.
            guard let mask = self.subjectMask(fromImage: inputImage, atPoint: subjectPosition) else {
                return
            }
            
            // Acquire the selected background image.
            let backgroundImage = CIImage(color: CIColor.clear)
                .cropped(to: inputImage.extent)
            
            // Apply the visual effect and composite.
            let composited = self.apply(toInputImage: inputImage, background: backgroundImage, mask: mask)
            let output = UIImage(cgImage: self.render(ciImage: composited))
            
            DispatchQueue.main.async {
                self.output = output
            }
        }
    }
    
    /// Returns the subject alpha mask for the given image.
    ///
    /// - parameter image: The image to extract a foreground subject from.
    /// - parameter atPoint: An optional normalized point for selecting a subject instance.
    private func subjectMask(fromImage image: CIImage, atPoint point: CGPoint?) -> CIImage? {
        // Create a request.
        let request = VNGenerateForegroundInstanceMaskRequest()
        
        // Create a request handler.
        let handler = VNImageRequestHandler(ciImage: image)
        
        // Perform the request.
        do {
            try handler.perform([request])
        } catch {
            print("Failed to perform Vision request.")
            return nil
        }
        
        // Acquire the instance mask observation.
        guard let result = request.results?.first else {
            print("No subject observations found.")
            return nil
        }
        
        let instances = instances(atPoint: point, inObservation: result)
        
        // Create a matted image with the subject isolated from the background.
        do {
            let mask = try result.generateScaledMaskForImage(forInstances: instances, from: handler)
            return CIImage(cvPixelBuffer: mask)
        } catch {
            print("Failed to generate subject mask.")
            return nil
        }
    }
    
    /// Applies the current effect and returns the composited image.
    private func apply(toInputImage inputImage: CIImage, background: CIImage, mask: CIImage) -> CIImage {
        let filter = CIFilter.blendWithMask()
        filter.inputImage = inputImage
        filter.backgroundImage = background
        filter.maskImage = mask
        return filter.outputImage!
    }
    
    /// Renders a CIImage onto a CGImage.
    private func render(ciImage img: CIImage) -> CGImage {
        guard let cgImage = CIContext(options: nil).createCGImage(img, from: img.extent) else {
            fatalError("Failed to render CIImage.")
        }
        return cgImage
    }
    
    /// Returns the indices of the instances at the given point.
    ///
    /// - parameter atPoint: A point with a top-left origin, normalized within the range [0, 1].
    /// - parameter inObservation: The observation instance to extract subject indices from.
    private func instances(atPoint maybePoint: CGPoint?, inObservation observation: VNInstanceMaskObservation) -> IndexSet {
        guard let point = maybePoint else {
            return observation.allInstances
        }
        
        // Transform the normalized UI point to an instance map pixel coordinate.
        let instanceMap = observation.instanceMask
        let coords = VNImagePointForNormalizedPoint(
            point,
            CVPixelBufferGetWidth(instanceMap) - 1,
            CVPixelBufferGetHeight(instanceMap) - 1)
        
        // Look up the instance label at the computed pixel coordinate.
        CVPixelBufferLockBaseAddress(instanceMap, .readOnly)
        guard let pixels = CVPixelBufferGetBaseAddress(instanceMap) else {
            fatalError("Failed to access instance map data.")
        }
        let bytesPerRow = CVPixelBufferGetBytesPerRow(instanceMap)
        let instanceLabel = pixels.load(
            fromByteOffset: Int(coords.y) * bytesPerRow + Int(coords.x),
            as: UInt8.self)
        CVPixelBufferUnlockBaseAddress(instanceMap, .readOnly)
        
        // If the point lies on the background, select all instances.
        // Otherwise, restrict this to just the selected instance.
        return instanceLabel == 0 ? observation.allInstances : [Int(instanceLabel)]
    }
}

enum ImageSourceType: Identifiable {
    
    var id: Self {
        return self
    }
    case gallery
    case camera
}
