//
//  Photo Data.swift
//  Album Widget
//
//  Created by wqh on 2020/11/16.
//

import SwiftUI

let encoder = JSONEncoder(), decoder = JSONDecoder()
let defaultPath = FileManager().containerURL(forSecurityApplicationGroupIdentifier: "group.kirin.lottery")!.appendingPathComponent("photoConfigs")
let photoPath = FileManager().containerURL(forSecurityApplicationGroupIdentifier: "group.kirin.lottery")!.appendingPathComponent("photos")

class PhotoData: ObservableObject {
    @Published var data: [pData] = []
    @Published var Photo: [[photo]] = []
    var count = 0
    
    init() { _ = self.append(data: pData(id: 0, index: "Template")) }
    init?(path: URL, photourl: URL = photoPath) {
        let origData = try? Data(contentsOf: path)
        if origData == nil { return nil }
        let converedData = try? decoder.decode([pDataS].self, from: origData!)
        if converedData == nil { return nil }
        for item in converedData! {
            self.data.append(pData(id: item.id, index: item.index, cover: item.cover == nil ? nil:UIImage(data: item.cover!), isDeleted: item.isDeleted))
        }
        for i in 0..<self.data.count {
            self.data[i].id = self.count
            count += 1
        }
        let origPhoto = try? Data(contentsOf: photourl)
        if origPhoto == nil { return nil }
        let converedPhoto = try? decoder.decode([[photoS]].self, from: origPhoto!)
        if converedPhoto == nil { return nil }
        for item in converedPhoto! {
            var pho: [photo] = []
            for item in item {
                pho.append(photo(id: item.id, data: UIImage(data: item.data)!, isDeleted: item.isDeleted))
            }
            self.Photo.append(pho)
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
                pho.append(photoS(id: item.id, data: item.data.jpegData(compressionQuality: 0.9)!, isDeleted: item.isDeleted))
            }
            converedPhoto.append(pho)
        }
        let encodedData = try? encoder.encode(converedData)
        let encodedPhoto = try? encoder.encode(converedPhoto)
        if encodedData == nil || encodedPhoto == nil { return NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey:"Failed to convert data!"])}
        do { try encodedData!.write(to: path);try encodedPhoto!.write(to: photo) }
        catch { return NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey:"Failed to write object!"]) }
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
