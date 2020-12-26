//
//  CardViewMode.swift
//  Album Widget
//
//  Created by wqh on 2020/12/27.
//

import SwiftUI

struct CardViewMode: View {
    @EnvironmentObject var photoData: PhotoData
    @Binding var showTools: Bool
    var body: some View {
        VStack {
            Text("CardViewMode")
        }
    }
}
