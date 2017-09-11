//
//  UIImageConverter.swift
//  engrave
//
//  Created by 张玺 on 06/09/2017.
//  Copyright © 2017 zhangxi. All rights reserved.
//

import Foundation
import AppKit

class Converter{
    
    var originImage : NSImage!
    var resizedImage : NSImage!
    var filteredImage : NSImage
    {

        let inputRep = NSBitmapImageRep( data: resizedImage.tiffRepresentation!)
        
        let inputImage = CIImage(bitmapImageRep: inputRep!)
        
        
        let f = CIFilter( name: "CILineOverlay", withInputParameters:[kCIInputImageKey:inputImage!])
        
        let rep: NSCIImageRep = NSCIImageRep(ciImage: f!.outputImage!)
    
        var nsImage: NSImage = NSImage(size: rep.size)
        nsImage.addRepresentation(rep)
    
        return nsImage
    }
    var engraveImage : NSImage
    {
        print("filteredImage.size : \(filteredImage.size)")
        let inputRep = NSBitmapImageRep( data: filteredImage.tiffRepresentation!)
    
        for i in 0 ..< 500
        {
            var line = [Int]()
            for j in 0 ..< 500
            {
                if let color = inputRep?.colorAt(x: i, y: j)
                {
                    
                    let c = 255-(color.alphaComponent*255)/3
                    print(c)
//                    print(color.blackComponent);
                    inputRep?.setColor(NSColor(calibratedRed: c/255, green: c/255, blue: c/255, alpha: 1), atX: i, y: j)
//                    line.append(Int(c))
                }else
                {
                    line.append(0)
                }
            }
        }
        var nsImage: NSImage = NSImage(size: CGSize(width: 500, height: 500))
        nsImage.addRepresentation(inputRep!)
        return nsImage
    }
    var colorArray : [[Int]]
    {
        var result = [[Int]]()
        let inputRep = NSBitmapImageRep( data: resizedImage.tiffRepresentation!)
        
        for i in 0 ..< 500
        {
            var line = [Int]()
            for j in 0 ..< 500
            {
                if let color = inputRep?.colorAt(x: i, y: j)
                {
                    let c = 255-(color.alphaComponent*255)/3
                    line.append(Int(c))
                }else
                {
                    line.append(0)
                }
            }
            result.append(line)
        }
        return result
    }
    
    var intensity = 0.1
    
    
    init(path:URL) {
        originImage = NSImage(contentsOf: path)
        resizedImage = originImage.resizedImage(size: NSSize(width: 500, height: 500))
    }
    
    
}

extension NSImage
{
    
    func resizedImage(size:NSSize) -> NSImage {
        
        
        var ratio : CGFloat = 1
        
        let w = self.size.width
        let h = self.size.height
        
        let maxWidth = size.width
        let maxHeight = size.height
        
    
        if (w > h) { ratio = maxWidth / w;}
        else {       ratio = maxHeight / h;}
        
        
        let newWidth = w * ratio
        let newHeight = h * ratio
        
        let newSize    = NSSize(width: newWidth, height: newHeight)
        var imageRect  = NSRect(x: 0, y:0, width: self.size.width, height: self.size.height)
        
        let imageRef   = self.cgImage(forProposedRect: &imageRect, context: nil, hints: nil)
        
        
        let imageWithNewSize = NSImage(cgImage: imageRef!, size: newSize)
        
        // Return the new image
        return imageWithNewSize
    }


}
