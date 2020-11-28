//
//  IntentHandler.swift
//  AlbumIntent
//
//  Created by wqh on 2020/11/22.
//

import Intents

class IntentHandler: INExtension, ConfigurationIntentHandling {
    
    func provideAlbumOptionsCollection(for intent: ConfigurationIntent, searchTerm: String?, with completion: @escaping (INObjectCollection<AlbumType>?, Error?) -> Void) {
        var albums: [AlbumType] = []
        let range = try? String(contentsOf: defaultPath.appendingPathComponent("range")
                                , encoding: .utf8)
        if let range = range {
            if let range = Int(range) {
                for index in 0..<range {
                    let name = try! String(contentsOf: defaultPath.appendingPathComponent("photoConfig\(index)"), encoding: .utf8)
                    let album = AlbumType(identifier: "\(index)", display: name)
                    album.index = index as NSNumber
                    albums.append(album)
                }
            }
        }
        let objCollection = INObjectCollection(items: albums)
        completion(objCollection, nil)
    }
    
    override func handler(for intent: INIntent) -> Any {
        // This is the default implementation.  If you want different objects to handle different intents,
        // you can override this and return the handler you want for that particular intent.
        
        return self
    }
    
}
