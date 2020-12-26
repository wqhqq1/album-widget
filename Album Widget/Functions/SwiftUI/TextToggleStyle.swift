//
//  TextToggleStyle.swift
//  Album Widget
//
//  Created by wqh on 2020/12/19.
//

import SwiftUI

struct TextToggleStyle: ToggleStyle {
    @State var height: CGFloat = 30
    @State var offset: CGFloat = -20
    func makeBody(configuration: Configuration) -> some View {
        if configuration.isOn {
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
            configuration.label
            ZStack {
                Rectangle().frame(width: 80, height: self.height)
                    .foregroundColor(configuration.isOn ? .green:Color("gray"))
                    .cornerRadius(height/2)
                    .overlay(HStack {
                        if !configuration.isOn {
                            Spacer()
                        }
                        Text(configuration.isOn ? " ON":"OFF").padding(10)
                        if configuration.isOn {
                            Spacer()
                        }
                    })
                HStack {
                    Button(action: {
                        withAnimation(.easeInOut) {
                            configuration.isOn.toggle()
                        }
                    }) {
                        Circle().frame(width: self.height, height: self.height)
                            .offset(x: self.offset)
                            .foregroundColor(.white).shadow(radius: 1)
                    }.buttonStyle(OrigButtonStyle())
                }
            }
        }
    }
}
