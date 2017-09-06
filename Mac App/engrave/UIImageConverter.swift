//
//  UIImageConverter.swift
//  engrave
//
//  Created by 张玺 on 06/09/2017.
//  Copyright © 2017 zhangxi. All rights reserved.
//

import Foundation
import AppKit


extension NSImage
{
    func pixelData() -> [Int] {
        var bmp = self.representations[0] as! NSBitmapImageRep
        
        print(bmp.size)
        
        print(bmp.colorAt(x: 100, y: 100))
        
        var data: UnsafeMutablePointer<UInt8> = bmp.bitmapData!
        
        var r, g, b, a: UInt8
        var pixels: [Int] = []
        

        return pixels
    }


}
