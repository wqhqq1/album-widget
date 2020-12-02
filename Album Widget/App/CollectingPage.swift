//
//  CollectingPage.swift
//  Album Widget
//
//  Created by wqh on 2020/11/17.
//

import SwiftUI
import UniformTypeIdentifiers

struct CollectingPage: View {
    @EnvironmentObject var photoData: PhotoData
    @State var index: Int
    @State var showPicker = false
    @State var isEditing = false
    @State var dragging: photo? = nil
    @State var showAlert = false
    var body: some View {
        DispatchQueue.main.async {
            if !UserDefaults.standard.bool(forKey: "showTip1") {
                self.showAlert = true
                UserDefaults.standard.set(true, forKey: "showTip1")
            }
        }
        return GeometryReader { geo in
            VStack {
                ScrollView {
                    LazyVGrid(columns: [GridItem](repeating: GridItem(.fixed(110)), count: Int(geo.size.width / 110) - 1)) {
                        if self.photoData.Photo[index].count != 0 {
                            ForEach(self.photoData.Photo[index]) { p in
                                if !p.isDeleted {
                                    SinglePhotoView(index: self.index, idInt: p.id, data: p.data, showTools: self.$isEditing).frame(width: 100, height: 150)
                                        .onDrag {
                                            self.dragging = p
                                            return NSItemProvider(object: "\(p.id)" as NSString)
                                        }
                                        .onDrop(of: [UTType.image], delegate: PhotoDropDelegate(item: p, photoData: self._photoData, index: self.index, current: self.$dragging))
                                        .cornerRadius(5)
                                }
                            }.animation(.default, value: self.photoData.Photo[index])
                        }
                        ZStack {
                            Button(action: {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    self.showPicker = true
                                }
                            }) {
                                ZStack {
                                    Rectangle()
                                        .foregroundColor(.blue)
                                        .overlay(Image(systemName: "plus.circle.fill").resizable().scaledToFit().foregroundColor(Color("normal")).padding(30))
                                    VStack {
                                        ZStack {
                                            Rectangle().foregroundColor(Color("normal")).opacity(0.8).frame(height: 30)
                                            Text(NSLocalizedString("import", comment: ""))
                                        }
                                        Spacer()
                                    }
                                }
                            }.buttonStyle(OrigButtonStyle())
                        }.frame(width: 100, height: 150).cornerRadius(5)
                    }.sheet(isPresented: self.$showPicker) {
                        PhotoPicker(index: self.index).environmentObject(self.photoData)
                    }
                }
                Spacer().navigationBarItems(trailing: Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        self.isEditing.toggle()
                    }
                }) {
                    Text(self.isEditing ? NSLocalizedString("done", comment: ""):NSLocalizedString("edit", comment: ""))
                })
            }.navigationBarTitle(self.photoData.data[index].index)
        }.alert(isPresented: self.$showAlert) {
            Alert(title: Text("Tips"), message: Text(NSLocalizedString("drag", comment: "")), dismissButton: .default(Text("Dismiss")))
        }
    }
}
