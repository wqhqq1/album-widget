//
//  Photo Data.swift
//  Album Widget
//
//  Created by wqh on 2020/11/16.
//

import SwiftUI

let defaultPath = FileManager().containerURL(forSecurityApplicationGroupIdentifier: "group.kirin.lottery")!
let photoPath = FileManager().containerURL(forSecurityApplicationGroupIdentifier: "group.kirin.lottery")!

class PhotoData: ObservableObject {
    @Published var data: [pData] = []
    @Published var Photo: [[photo]] = []
    var count = 0
    
    init() { _ = self.append(data: pData(id: 0, index: "Template")) }
    init?(path: URL, photourl: URL = photoPath) {
        let range = try? String(contentsOf: defaultPath.appendingPathComponent("range")
                                , encoding: .utf8)
        guard let tmpR = range else { return nil }
        guard let rangeInt = Int(tmpR) else { return nil }
        for index in 0..<rangeInt {
            let name = try? String(contentsOf: defaultPath.appendingPathComponent("photoConfig\(index)")
                              , encoding: .utf8)
            let cover = try? Data(contentsOf: defaultPath.appendingPathComponent("cover\(index)"))
            if name == nil || cover == nil { return nil }
            data.append(pData(id: index, index: name!, cover: UIImage(data: cover!)))
            var tmpPhoto: [photo] = []
            let rge = try? String(contentsOf: defaultPath.appendingPathComponent("range\(index)")
                                  , encoding: .utf8)
            if rge == nil { self.Photo.append(tmpPhoto);continue }
            let rgeInt = Int(rge!)!
            for idx in 0..<rgeInt {
                let pho = try? Data(contentsOf: defaultPath.appendingPathComponent("photo\(index).\(idx)"))
                tmpPhoto.append(photo(data: UIImage(data: pho!)!))
            }
            self.Photo.append(tmpPhoto)
        }
//        print(self.data)
    }
    
    func save(path: URL = defaultPath, photo: URL = photoPath) -> NSError? {
        print("saving")
        var removedData: [pData] = []
        var removedPhoto: [[photo]] = []
        for album in self.data {
            if !album.isDeleted { removedData.append(album) }
        }
        
        for i in 0..<self.Photo.count {
            var tmp: [photo] = []
            if self.data[i].isDeleted { continue }
            for j in self.Photo[i] {
                if !j.isDeleted {
                    tmp.append(j)
                }
            }
            removedPhoto.append(tmp)
        }
        for i in 0..<removedData.count {
            removedData[i].id = i
        }
        var converedData: [pDataS] = []
        var converedPhoto: [[photoS]] = []
        for (index, item) in removedData.enumerated() {
            converedData.append(pDataS(id: item.id, index: item.index, cover: item.cover?.pngData(), isDeleted: item.isDeleted))
            var pho: [photoS] = []
            for item in removedPhoto[index] {
                pho.append(photoS(id: item.id, data: item.data.resizeImage()!, isDeleted: item.isDeleted))
            }
            converedPhoto.append(pho)
        }
        try! "\(converedData.count)".write(to: defaultPath.appendingPathComponent("range")
                                      , atomically: true, encoding: .utf8)
        for (index, item) in converedData.enumerated() {
            try! item.index.write(to: defaultPath.appendingPathComponent("photoConfig\(index)"),
                             atomically: true, encoding: .utf8)
            if let cover = item.cover { try! cover.write(to: defaultPath.appendingPathComponent("cover\(index)")) }
            try! "\(converedPhoto[index].count)".write(to: defaultPath.appendingPathComponent("range\(index)")
                                       , atomically: true, encoding: .utf8)
            for (idx, item) in converedPhoto[index].enumerated() {
                try! item.data.write(to: defaultPath.appendingPathComponent("photo\(index).\(idx)"))
            }
        }
//        print(converedData)
        return nil
    }
    
    func append(data: pData, photos: [photo] = [], path: URL = defaultPath) -> NSError? {
        if data.index == "" { return NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey:"Name cannot be empty!"]) }
        if let error = checkIfReuse(data.index) { return error }
        withAnimation(.easeInOut(duration: 0.3)) {
            self.data.append(pData(id: count, index: data.index, isDeleted: data.isDeleted))
            self.Photo.append(photos)
        }
        count += 1
        return nil
    }
    
    func appendPhoto(at index: Int, photos: photo) -> NSError? {
        withAnimation(.easeInOut(duration: 0.3)) {
            self.Photo[index].append(photos)
        }
        self.data[index].cover = getCover(index)
        return nil
    }
    
    func rename(at id: Int, newName: String) -> NSError? {
        if newName == data[id].index { return save() }
        if let error = checkIfReuse(newName) { return error }
        if newName == "" { return NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey:"Name cannot be empty!"]) }
        data[id].index = newName
        return nil
    }
    
    func remove(at id: Int) -> NSError? {
        if !self.data[id].isDeleted {
            withAnimation(.easeInOut(duration: 0.3)) {
                self.data[id].isDeleted = true
            }
        }
        return nil
    }
    
    func removePhoto(index: Int, id: Int) -> NSError? {
        if !self.Photo[index][id].isDeleted {
            withAnimation(.easeInOut(duration: 0.3)) {
                self.Photo[index][id].isDeleted = true
            }
        }
        self.data[index].cover = getCover(index)
        return nil
    }
    
    private func checkIfReuse(_ newName: String) -> NSError? {
        for name in self.data {
            if name.index == newName && !name.isDeleted { return NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey:"This album name was already used!"])}
        }
        return nil
    }
    
    func getCover(_ index: Int) -> UIImage? {
        for p in self.Photo[index] {
            if !p.isDeleted {
                return p.data
            }
        }
        return nil
    }
    
    func getData(in index: Int, at idx: Int?) -> Any {
        guard let idx = idx else {
            return try! String(contentsOf: defaultPath.appendingPathComponent("photoConfig\(index)"), encoding: .utf8)
        }
        return try! Data(contentsOf: defaultPath.appendingPathComponent("photo\(index).\(idx)"))
    }
}

struct photo: Identifiable, Equatable {
    var id: UUID = UUID()
    var data: UIImage
    var isDeleted = false
}

struct pData: Identifiable {
    var id: Int = 0
    var index: String = ""
    var cover: UIImage? = nil
    var isDeleted = false
}

struct photoS: Identifiable, Equatable, Codable {
    var id: UUID = UUID()
    var data: Data
    var isDeleted = false
}

struct pDataS: Identifiable, Codable {
    var id: Int = 0
    var index: String = ""
    var cover: Data? = nil
    var isDeleted = false
}

extension UIImage {
    func resizeImage() -> Data? {
            let originalImg = self
            //prepare constants
            let width = originalImg.size.width
            let height = originalImg.size.height
            let scale = width/height
            
            var sizeChange = CGSize()
            
            if width <= 1280 && height <= 1280{ //a，图片宽或者高均小于或等于1280时图片尺寸保持不变，不改变图片大小
                return originalImg.pngData()
            }else if width > 1280 || height > 1280 {//b,宽或者高大于1280，但是图片宽度高度比小于或等于2，则将图片宽或者高取大的等比压缩至1280
                
                if scale <= 2 && scale >= 1 {
                    let changedWidth:CGFloat = 1280
                    let changedheight:CGFloat = changedWidth / scale
                    sizeChange = CGSize(width: changedWidth, height: changedheight)
                
                }else if scale >= 0.5 && scale <= 1 {
                    
                    let changedheight:CGFloat = 1280
                    let changedWidth:CGFloat = changedheight * scale
                    sizeChange = CGSize(width: changedWidth, height: changedheight)
                    
                }else if width > 1280 && height > 1280 {//宽以及高均大于1280，但是图片宽高比大于2时，则宽或者高取小的等比压缩至1280
                    
                    if scale > 2 {//高的值比较小
                        
                        let changedheight:CGFloat = 1280
                        let changedWidth:CGFloat = changedheight * scale
                        sizeChange = CGSize(width: changedWidth, height: changedheight)
                        
                    }else if scale < 0.5{//宽的值比较小
                        
                        let changedWidth:CGFloat = 1280
                        let changedheight:CGFloat = changedWidth / scale
                        sizeChange = CGSize(width: changedWidth, height: changedheight)
                        
                    }
                }else {//d, 宽或者高，只有一个大于1280，并且宽高比超过2，不改变图片大小
                    return originalImg.pngData()
                }
            }

            UIGraphicsBeginImageContext(sizeChange)
            
            //draw resized image on Context
            originalImg.draw(in: CGRect(x: 0, y: 0, width: sizeChange.width, height: sizeChange.height))

            //create UIImage
            let resizedImg = UIGraphicsGetImageFromCurrentImageContext()
            
            UIGraphicsEndImageContext()
            
        return resizedImg?.pngData()
            
    }
}
