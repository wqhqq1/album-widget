//
//  ViewModePicker.swift
//  Album Widget
//
//  Created by wqh on 2020/12/26.
//

import SwiftUI

struct ViewModePicker: View {
    @Binding var viewMode: ViewMode
    @State var height: CGFloat = 30
    @State var offset: CGFloat = -20
    var body: some View {
        if self.viewMode == .cardView {
            DispatchQueue.main.async {
                withAnimation(.default) {
                    self.offset = 20
                }
            }
        }
        else {
            DispatchQueue.main.async {
                withAnimation(.default) {
                    self.offset = -20
                }
            }
        }
        return HStack{
            ZStack {
                Rectangle()
                    .foregroundColor(Color("gray"))
                    .frame(width: 70, height: self.height)
                    .cornerRadius(4)
                    .opacity(0.5)
                    .overlay(Divider())
                HStack {
                    Rectangle()
                        .foregroundColor(Color("grayWhenDark"))
                        .frame(width: self.height+5, height: self.height-1)
                        .cornerRadius(4)
                        .offset(x: self.offset)
                        .foregroundColor(.white)
                        .shadow(radius: 1)
                }
            }.overlay(HStack {
                Button(action: {
                    withAnimation(.easeInOut) {
                        self.viewMode = .tableView
                        UserDefaults.standard.set(viewModeConverter(viewMode: self.viewMode), forKey: "viewMode")
                    }
                }) {
                    Image(systemName: "tablecells.fill")
                }.buttonStyle(OrigButtonStyle())
                Spacer()
                Button(action: {
                    withAnimation(.easeInOut) {
                        self.viewMode = .cardView
                        UserDefaults.standard.set(viewModeConverter(viewMode: self.viewMode), forKey: "viewMode")
                    }
                }) {
                    Image(systemName: "creditcard.fill")
                }.buttonStyle(OrigButtonStyle())
            }.padding(3))
        }
    }
}
