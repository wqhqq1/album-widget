//
//  AutoRefreshToggle.swift
//  Album Widget
//
//  Created by wqh on 2020/12/19.
//

import SwiftUI

struct AutoRefreshToggle: View {
    @State var isOn = false
    @State var once = false
    var body: some View {
        DispatchQueue.main.async {
            if !once {
                self.isOn = (try? String(contentsOf: defaultPath.appendingPathComponent("autoRefresh"))) == "false" ? false:true
                once.toggle()
            }
        }
        if once {
            if isOn {
                try! String(isOn).write(to: defaultPath.appendingPathComponent("autoRefresh"), atomically: true, encoding: .utf8)
            }
            else {
                try! String(isOn).write(to: defaultPath.appendingPathComponent("autoRefresh"), atomically: true, encoding: .utf8)
            }
        }
        return Toggle(NSLocalizedString("autoRefresh", comment: ""), isOn: self.$isOn)
    }
}
