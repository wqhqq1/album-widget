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
                    self.offset = 25
                }
            }
        }
        else {
            DispatchQueue.main.async {
                withAnimation(.default) {
                    self.offset = -25
                }
            }
        }
        return HStack{
            ZStack {
                Button(action: {
                    withAnimation(.easeInOut) {
                        self.viewMode = (self.viewMode == .tableView) ? .cardView:.tableView
                    }
                }) {
                    Rectangle().foregroundColor(Color("gray"))
                        .frame(width: 80, height: self.height)
                        .cornerRadius(height/2)
                        .overlay(HStack {
                            if !(self.viewMode == .tableView) {
                                Spacer()
                            }
                            Image(systemName: self.viewMode == .tableView ? "tablecells.fill":"creditcard.fill").padding(10)
                            if !(self.viewMode == .cardView) {
                                Spacer()
                            }
                        })
                }
                HStack {
                    Rectangle().frame(width: self.height, height: self.height)
                        .offset(x: self.offset)
                        .foregroundColor(.white).shadow(radius: 1)
                }
            }
        }
    }
}
