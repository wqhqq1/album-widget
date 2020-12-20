//
//  RefreshTimeCustomizer.swift
//  Album Widget
//
//  Created by wqh on 2020/12/20.
//

import SwiftUI

struct RefreshTimeCustomizer: View {
    @State var refreshTime: String = "1"
    @State var once = false
    var body: some View {
        DispatchQueue.main.async {
            if !once {
                refreshTime = (try? String(contentsOf: defaultPath.appendingPathComponent("refreshTime"))) ?? "1"
                self.once = true
            }
        }
        return HStack {
            Text(NSLocalizedString("refresh01", comment: ""))
            HStack {
                Button(action: {
                    self.refreshTime = String(Int(self.refreshTime)! + 1)
                    try! String(self.refreshTime).write(to: defaultPath.appendingPathComponent("refreshTime")
                                                   , atomically: true, encoding: .utf8)
                }) {
                    Image(systemName: "plus.square.fill")
                        .foregroundColor(Color("gray"))
                }
                Text(String(self.refreshTime))
                Button(action: {
                    self.refreshTime = String(Int(self.refreshTime)! - 1)
                    try! String(self.refreshTime).write(to: defaultPath.appendingPathComponent("refreshTime")
                                                   , atomically: true, encoding: .utf8)
                }) {
                    Image(systemName: "minus.square.fill")
                        .foregroundColor(Color("gray"))
                }
            }
            Text(NSLocalizedString("refresh02", comment: ""))
        }
    }
}
