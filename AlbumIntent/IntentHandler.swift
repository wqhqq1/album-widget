//
//  IntentHandler.swift
//  AlbumIntent
//
//  Created by wqh on 2020/11/22.
//

import Intents

class IntentHandler: INExtension, ConfigurationIntentHandling {
    
    func provideAlbumOptionsCollection(for intent: ConfigurationIntent, searchTerm: String?, with completion: @escaping (INObjectCollection<AlbumType>?, Error?) -> Void) {
        let data = PhotoData(path: defaultPath) ?? PhotoData()
        let albums: [AlbumType] = data.data.map { item in
            let album = AlbumType(identifier: "\(item.id)", display: item.index)
            album.index = item.id as NSNumber
            return album
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
