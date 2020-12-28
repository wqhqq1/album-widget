//
//  GetPreferredColor.swift
//  Album Widget
//
//  Created by wqh on 2020/12/27.
//

import SwiftUI

extension UIImage {
    func getPointColor(point: CGPoint) -> [CGFloat]? {
        guard CGRect(origin: CGPoint(x: 0, y: 0), size: self.size).contains(point) else {
            return nil
        }
        
        let pointX = trunc(point.x);
        let pointY = trunc(point.y);
        
        let width = self.size.width;
        let height = self.size.height;
        let colorSpace = CGColorSpaceCreateDeviceRGB();
        var pixelData: [UInt8] = [0, 0, 0, 0]
        
        pixelData.withUnsafeMutableBytes { pointer in
            if let context = CGContext(data: pointer.baseAddress, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue), let cgImage = self.cgImage {
                context.setBlendMode(.copy)
                context.translateBy(x: -pointX, y: pointY - height)
                context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
            }
        }
        
        let red = CGFloat(pixelData[0]) / CGFloat(255.0)
        let green = CGFloat(pixelData[1]) / CGFloat(255.0)
        let blue = CGFloat(pixelData[2]) / CGFloat(255.0)
        let alpha = CGFloat(pixelData[3]) / CGFloat(255.0)
        
        return [red, green, blue, alpha]
    }
    
    func getPreferredColor() -> CGFloat? {
        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: self.size)
        let x = Int(rect.maxX)-1, yRange = 1..<Int(rect.maxY)
        print("xRange:1..<\(rect.maxX)\nyRange:1..<\(rect.maxY)")
        var col: CGFloat = 0
        for y in yRange {
            let colors = self.getPointColor(point: CGPoint(x: x, y: y))
            if let colors = colors {
                for color in colors {
                    col += color
                }
            }
            else {
                return nil
            }
        }
        col = col / 5 / rect.maxY
//        print("DEBUG: col=\(col)")
        return col
    }
}
