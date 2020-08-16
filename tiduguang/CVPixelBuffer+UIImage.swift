//
//  CVPixelBuffer+UIImage.swift
//  tiduguang
//
//  Created by Wangyiwei on 2020/8/15.
//

import UIKit
import CoreMedia

extension CVPixelBuffer{
    func convert(scale: CGFloat = 1.0) -> UIImage{
        let input = CIImage(cvPixelBuffer: self)
        let tmpContext = CIContext()
        let rect = CGRect(x: 0, y: 0, width: CVPixelBufferGetWidth(self), height: CVPixelBufferGetHeight(self))
        let cgImage = tmpContext.createCGImage(input, from: rect)!
        
        let uiImage = UIImage(cgImage: cgImage, scale: scale, orientation: .right)
        return uiImage
    }
}

//extension CMSampleBuffer {
//    var uiImage: UIImage {
//        let imageBuffer = CMSampleBufferGetImageBuffer(self);
//        CVPixelBufferLockBaseAddress(imageBuffer, 0);
//
//        // 得到pixel buffer的基地址
//        void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
//
//        // 得到pixel buffer的行字节数
//        size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
//        // 得到pixel buffer的宽和高
//        size_t width = CVPixelBufferGetWidth(imageBuffer);
//        size_t height = CVPixelBufferGetHeight(imageBuffer);
//
//        // 创建一个依赖于设备的RGB颜色空间
//        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//
//        // 用抽样缓存的数据创建一个位图格式的图形上下文（graphics context）对象
//        CGContextRef context = CGBitmapContextCreate(baseAddress, width, height, 8,
//                                                     bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
//        // 根据这个位图context中的像素数据创建一个Quartz image对象
//        CGImageRef quartzImage = CGBitmapContextCreateImage(context);
//        // 解锁pixel buffer
//        CVPixelBufferUnlockBaseAddress(imageBuffer,0);
//
//        // 释放context和颜色空间
//        CGContextRelease(context);
//        CGColorSpaceRelease(colorSpace);
//
//        // 用Quartz image创建一个UIImage对象image
//        UIImage *image = [UIImage imageWithCGImage:quartzImage];
//
//        // 释放Quartz image对象
//        CGImageRelease(quartzImage);
//
//        return (image);
//    }
//}
