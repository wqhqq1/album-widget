//
//  PhotoDropDelegate.swift
//  Album Widget
//
//  Created by wqh on 2020/11/21.
//

import SwiftUI
import Foundation

struct PhotoDropDelegate: DropDelegate {
    let item: photo
    @EnvironmentObject var photoData: PhotoData
    @State var index: Int
    @Binding var current: photo?
    
    func dropEntered(info: DropInfo) {
        if item != current {
            let from = photoData.Photo[index].firstIndex(of: current!)!
            let to = photoData.Photo[index].firstIndex(of: item)!
            if photoData.Photo[index][to].id != current!.id {
                photoData.Photo[index].move(fromOffsets: IndexSet(integer: from), toOffset: to > from ? to + 1:to)
            }
            self.photoData.data[index].cover = self.photoData.getCover(index)
        }
        return
    }
    
    func dropUpdated(info: DropInfo) -> DropProposal? {
        return DropProposal(operation: .move)
    }
    
    func performDrop(info: DropInfo) -> Bool {
        self.current = nil
        return true
    }
    
}
