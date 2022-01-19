//
//  AboutView.swift
//  MyMood
//
//  Created by Kyle Shores on 1/17/22.
//

import SwiftUI

struct AboutView: View {
    @Binding var showSheetView: Bool

    var body: some View {
        NavigationView {
            Text("List of notifications")
            .navigationBarTitle(Text("About"), displayMode: .inline)
                .navigationBarItems(trailing: Button(action: {
                    self.showSheetView = false
                }) {
                    Image(systemName: "xmark")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.accentColor)
                        .padding(6)
                })
        }
    }
}

struct AboutView_Previews: PreviewProvider {
    @State static var showSheetView = true
    static var previews: some View {
        AboutView(showSheetView: $showSheetView)
    }
}
