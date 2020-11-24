//
//  ContentView.swift
//  Album Widget
//
//  Created by wqh on 2020/11/17.
//

import SwiftUI
import WidgetKit

struct ContentView: View {
    @EnvironmentObject var photoData: PhotoData
    @State var showTools = false
    @State var isEditing = false
    @State var albumName = ""
    @State var message = ""
    @State var showError = false
    @State var updateNName = false
    var body: some View {
        GeometryReader { geo in
            NavigationView {
                VStack {
                    ScrollView {
                        LazyVGrid(columns: [GridItem](repeating: GridItem(.fixed(110)), count: Int(geo.size.width / 110) - 1)) {
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
                                                    NewTextField(.constant("Name"), text: self.$albumName, updateNow: self.$updateNName).frame(height: 30)
                                                }
                                                else {
                                                    Text("New Album")
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
                                                                self.isEditing = false
                                                            }
                                                        }
                                                        Spacer()
                                                        Image(systemName: "checkmark").onTapGesture {
                                                            if let error = self.photoData.append(data: pData(index: self.albumName))
                                                            { self.message = error.localizedDescription;self.showError = true;return }
                                                            self.albumName = ""
                                                            self.updateNName = true
                                                            withAnimation(.easeInOut(duration: 0.3)) {
                                                                self.isEditing = false
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
                        .padding().navigationBarTitle(Text("My Albums")).navigationBarItems(trailing:
                        HStack {
                            Button(action: {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    self.showTools = !self.showTools
                                }
                            }) {
                                Text(self.showTools ? "Done":"Edit")
                            }
                            Button(action: {
                                _ = self.photoData.save()
                                WidgetCenter.shared.reloadAllTimelines()
                            }) {
                                Text("Save")
                            }
                        }
                        )
                        Text("").frame(width: 0).alert(isPresented: self.$showError) {
                            Alert(title: Text("Fatal Error"), message: Text(self.message), dismissButton: .default(Text("OK")))
                        }
                    }
                    Spacer()
                }.transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.3)))
            }.navigationViewStyle(StackNavigationViewStyle())
        }
    }
}
