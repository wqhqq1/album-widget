//
//  SingleAlbumView.swift
//  Album Widget
//
//  Created by wqh on 2020/11/16.
//

import SwiftUI

struct SingleAlbumView: View {
    @EnvironmentObject var photoData: PhotoData
    @State var index: Int
    @Binding var showTools: Bool
    @State var message: String = ""
    @State var title = "Fatal Error"
    @State var dismiss = "Dismiss"
    @State var newName: String = ""
    @State var showAlert: Bool = false
    @State var editingName: Bool = false
    @State var updateNow = false
    var body: some View {
        DispatchQueue.main.async {
            if self.editingName {
                self.newName = self.photoData.data[index].index
                self.updateNow = true
            }
            if !self.showTools {
                self.editingName = false
            }
        }
        return ZStack {
            NavigationLink(destination: CollectingPage(index: self.index).environmentObject(self.photoData)) {
                Rectangle()
                    .foregroundColor(.blue)
                    .overlay(Text(NSLocalizedString("noContent", comment: "")).opacity(0.8))
            }.buttonStyle(OrigButtonStyle())
            NavigationLink(destination: CollectingPage(index: self.index).environmentObject(self.photoData)) {
                if let cover = self.photoData.data[index].cover {
                    Image(uiImage: cover)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 150)
                }
            }.buttonStyle(OrigButtonStyle())
            if showTools {
                VStack {
                    Spacer()
                    ZStack{
                        Rectangle().foregroundColor(Color("normal")).frame(height: 50).opacity(0.8)
                        HStack {
                            Image(systemName: "trash.fill")
                                .onTapGesture {
//                                    print("tap")
                                    self.message = NSLocalizedString("delete", comment: "");self.title = "Tips";self.showAlert = true
                                }
                                .onLongPressGesture {
                                    let error = photoData.remove(at: index)
                                    print(photoData.data[index])
                                    if error != nil { self.message = error!.localizedDescription;self.showAlert = true }
                                }
                                .foregroundColor(.red)
                            Spacer()
                            Image(systemName: self.editingName ? "checkmark":"textbox")
                                .onTapGesture {
                                    if !UserDefaults.standard.bool(forKey: "showTip0") {
                                        self.message = NSLocalizedString("cancel", comment: "");self.title = "Tips";self.showAlert = true
                                        UserDefaults.standard.set(true, forKey: "showTip0")
                                    }
                                    if !self.editingName { self.editingName = true;return }
    //                                print(self.newName)
                                    if let error = self.photoData.rename(at: self.index, newName: self.newName)
                                    { self.message = error.localizedDescription;self.showAlert = true } else {
                                        self.newName = "";self.updateNow = true;self.editingName = false
                                    }
                                }
                                .onLongPressGesture {
                                    self.editingName = false
                                }
                        }.padding()
                    }
                }.offset(y: 1)
            }
            VStack {
                ZStack{
                    Rectangle().foregroundColor(Color("normal")).frame(height: 30).opacity(0.8)
                    if !self.editingName {
                        Text(photoData.data[index].index).frame(height: 30)
                    }
                    else {
                        NewTextField(.constant(NSLocalizedString("newName", comment: "")), text: self.$newName, updateNow: self.$updateNow).frame(height: 30)
                    }
                }
                Spacer()
            }
        }.alert(isPresented: self.$showAlert) {
            Alert(title: Text(self.title), message: Text(self.message), dismissButton: .default(Text(self.dismiss)))
        }
    }
}
