//
//  TableViewMode.swift
//  Album Widget
//
//  Created by wqh on 2020/12/26.
//

import SwiftUI
import WidgetKit

struct TableViewMode: View {
    @EnvironmentObject var photoData: PhotoData
    @Binding var showTools: Bool
    @State var isEditing = false
    @State var albumName = ""
    @State var message = ""
    @State var showError = false
    @State var updateNName = false
    @Binding var isSaving: Bool
    @State var isMac = false
    var body: some View {
        DispatchQueue.main.async {
            #if targetEnvironment(macCatalyst)
            do {
                self.isEditing = true
                self.isMac = true
            }
            #endif
        }
        return GeometryReader { geo in
                VStack {
                    ScrollView {
                        LazyVGrid(columns: [GridItem](repeating: GridItem(.fixed(110)), count: (Int(geo.size.width / 110) - 1) > 0 ? (Int(geo.size.width / 110) - 1):1)) {
                            ForEach(self.photoData.data) { album in
                                if !album.isDeleted {
                                    SingleAlbumView(index: album.id, showTools: self.$showTools).environmentObject(self.photoData).cornerRadius(5)
                                }
                            }
                            ZStack {
                                Button(action: {
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        self.isEditing = true
                                    }
                                }) {
                                    ZStack {
                                        Rectangle()
                                            .foregroundColor(.blue)
                                            .overlay(self.isEditing ? nil:Image(systemName: "plus.circle.fill").resizable().scaledToFit().foregroundColor(Color("normal")).padding(30))
                                        VStack {
                                            ZStack {
                                                Rectangle().foregroundColor(Color("normal")).frame(height: 30).opacity(0.8)
                                                if self.isEditing {
                                                    NewTextField(.constant(NSLocalizedString("name", comment: "")), text: self.$albumName, updateNow: self.$updateNName).frame(height: 30)
                                                }
                                                else {
                                                    Text(NSLocalizedString("new", comment: ""))
                                                }
                                            }
                                            Spacer()
                                            if self.isEditing {
                                                ZStack {
                                                    Rectangle()
                                                        .foregroundColor(Color("normal")).frame(height: 30).opacity(0.8)
                                                    HStack {
                                                        Image(systemName: "xmark").onTapGesture {
                                                            withAnimation(.easeInOut(duration: 0.3)) {
                                                                if !isMac {
                                                                    self.isEditing = false
                                                                }
                                                            }
                                                        }
                                                        Spacer()
                                                        Image(systemName: "checkmark").onTapGesture {
                                                            if let error = self.photoData.append(data: pData(index: self.albumName))
                                                            { self.message = error.localizedDescription;self.showError = true;return }
                                                            self.albumName = ""
                                                            self.updateNName = true
                                                            withAnimation(.easeInOut(duration: 0.3)) {
                                                                if !isMac {
                                                                    self.isEditing = false
                                                                }
                                                            }
                                                        }
                                                    }.offset(y: 1).padding([.leading, .trailing])
                                                }
                                            }
                                        }
                                    }
                                }.buttonStyle(OrigButtonStyle())
                            }.frame(width: 100, height: 150).cornerRadius(5)
                            
                        }
                        .frame(width: geo.size.width)
                        .padding().navigationBarTitle(Text(NSLocalizedString("nvTitle", comment: "")))
                        Text("").frame(width: 0).alert(isPresented: self.$showError) {
                            Alert(title: Text("Fatal Error"), message: Text(self.message), dismissButton: .default(Text("OK")))
                        }
                    }
                    Spacer()
                }.transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.3)))
        }
    }
}

