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
    @State var idInt: Int
    @State var data: UIImage
    @Binding var showTools: Bool
    var body: some View {
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
        }
        .frame(width: 100, height: 150)
    }
}

