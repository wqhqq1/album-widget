//
//  ContentView.swift
//  Album Widget
//
//  Created by wqh on 2020/11/17.
//

import SwiftUI
import WidgetKit

struct ContentView: View {
    @State var viewMode: ViewMode = .tableView
    @State var isSaving = false
    @State var showTools = false
    @EnvironmentObject var photoData: PhotoData
    var body: some View {
        DispatchQueue.main.async {
            self.viewMode = (viewModeConverter(str: UserDefaults.standard.string(forKey: "viewMode")) as? ViewMode) ?? .tableView
        }
        return NavigationView {
            if viewMode == .tableView {
                TableViewMode(showTools: self.$showTools, isSaving: self.$isSaving)
                    .environmentObject(self.photoData)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarItems(leading: ViewModePicker(viewMode: self.$viewMode), trailing:
                                HStack {
                                    RefreshTimeCustomizer()
                                    Button(action: {
                                        withAnimation(.easeInOut(duration: 0.3)) {
                                            self.showTools = !self.showTools
                                        }
                                    }) {
                                        Text(self.showTools ? NSLocalizedString("done", comment: ""):NSLocalizedString("edit", comment: ""))
                                    }
                                    if isSaving {
                                        ProgressView().progressViewStyle(CircularProgressViewStyle()).padding()
                                    }
                                    else {
                                        Button(action: {
                                            isSaving = true
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                                _ = self.photoData.save()
                                                WidgetCenter.shared.reloadAllTimelines()
                                                isSaving = false
                                            }
                                        }) {
                                            Text(NSLocalizedString("save", comment: ""))
                                        }
                                    }
                                }
        )
    }
}

enum ViewMode {
    case tableView
    case cardView
}

func viewModeConverter(str: String? = nil, viewMode: ViewMode? = nil) -> Any? {
    if let str = str {
        if str == "tableView" {
            return ViewMode.tableView
        }
        return ViewMode.cardView
    }
    if let viewMode = viewMode {
        if viewMode == .tableView {
            return "tableView"
        }
        return "cardView"
    }
    return nil
}
