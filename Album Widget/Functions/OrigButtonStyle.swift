//
//  OrigButtonStyle.swift
//  Album Widget
//
//  Created by wqh on 2020/11/17.
//

import SwiftUI

struct OrigButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        return configuration.label
    }
}
