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
            self.output = nil
            guard let image else { return }
            self.regenerate(usingInputImage: CIImage(image: image.fixOrientation())!, effect: .none, background: .original, subjectPosition: subjectPosition)
        }
    }
    var source: ImageSourceType?
    var presentSelection: Bool = false
    var output: UIImage?
    
    var yOffset: CGFloat = 0
    var animationState: AnimationState = .ready
    var effect: Effect = .bokeh
    var background: Background = .transparent
    var subjectPosition: CGPoint? {
        didSet {
            guard let image else { return }
            self.regenerate(usingInputImage: CIImage(image: image.fixOrientation())!, effect: .none, background: .original, subjectPosition: subjectPosition)
        }
    }
    
    @ObservationIgnored
    private var processingQueue = DispatchQueue(label: "EffectsProcessing")
    
    func removeBackground() {
        guard let image else { return }
        self.animationState = .animating
        self.regenerate(usingInputImage: CIImage(image: image.fixOrientation())!, effect: effect, background: background, subjectPosition: subjectPosition)
    }
    
    private func regenerate(usingInputImage inputImage: CIImage, effect: Effect, background: Background, subjectPosition: CGPoint?) {
        processingQueue.async {
            // Generate the input-image mask.
            guard let mask = self.subjectMask(fromImage: inputImage, atPoint: subjectPosition) else {
                return
            }
            
            // Acquire the selected background image.
            let backgroundImage = self.image(forBackground: background, inputImage: inputImage)
                .cropped(to: inputImage.extent)
            
            // Apply the visual effect and composite.
            // Apply the visual effect and composite.
            let composited = self.apply(effect: effect, toInputImage: inputImage, background: backgroundImage, mask: mask)
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
    private func apply(
        effect: Effect,
        toInputImage inputImage: CIImage,
        background: CIImage,
        mask: CIImage
    ) -> CIImage {

        var postEffectBackground = background

        switch effect {
        case .none:
            break

        case .highlight:
            let filter = CIFilter.exposureAdjust()
            filter.inputImage = background
            filter.ev = -3
            postEffectBackground = filter.outputImage!

        case .bokeh:
            let filter = CIFilter.bokehBlur()
            filter.inputImage = apply(
                effect: .none,
                toInputImage: CIImage(color: .white)
                    .cropped(to: inputImage.extent),
                background: background,
                mask: mask)
            filter.ringSize = 1
            filter.ringAmount = 1
            filter.softness = 1.0
            filter.radius = 20
            postEffectBackground = filter.outputImage!

        case .noir:
            let filter = CIFilter.photoEffectNoir()
            filter.inputImage = background
            postEffectBackground = filter.outputImage!
        }

        let filter = CIFilter.blendWithMask()
        filter.inputImage = inputImage
        filter.backgroundImage = postEffectBackground
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
    
    /// Returns the image for the given background preset.
    private func image(forBackground background: Background, inputImage: CIImage) -> CIImage {
        switch background {
        case .original:
            return inputImage
        case .transparent:
            return CIImage(color: CIColor.clear)
        case .greenScreen:
            return CIImage(color: CIColor.green)
        }
    }
}
