//
//  SinglePhotoView.swift
//  Album Widget
//
//  Created by wqh on 2020/11/18.
//

import SwiftUI

struct SinglePhotoView: View {
    @EnvironmentObject var photoData: PhotoData
    @State var index: Int
    @State var id: UUID
    @State var data: UIImage
    @Binding var showTools: Bool
    var body: some View {
        var idInt = 0
        DispatchQueue.main.async {
            for i in 0..<photoData.Photo[index].count {
                if self.id == photoData.Photo[index][i].id { idInt = i;break }
            }
        }
        return ZStack {
            Image(uiImage: self.data).resizable().frame(width: 100, height: 150).scaledToFill()
            if self.showTools {
                VStack {
                    Spacer()
                    ZStack {
                        Rectangle().foregroundColor(Color("normal")).opacity(0.8).frame(height: 30)
                        Button(action: {
                            _ = self.photoData.removePhoto(index: self.index, id: idInt)
                        }) {
                            Image(systemName: "trash.fill")
                        }.buttonStyle(OrigButtonStyle())
                    }
                }
            }
        }.frame(width: 100, height: 150)
    }
}

