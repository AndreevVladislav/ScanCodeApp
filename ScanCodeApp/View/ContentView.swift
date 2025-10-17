//
//  ContentView.swift
//  scanCodeApp
//
//  Created by Vladislav Andreev on 16.10.2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            NavigationStack {
                ScannerView()
            }
            .tabItem {
                Label("Сканер", systemImage: "barcode.viewfinder")
            }

            NavigationStack {
                HistoryView()
            }
            .tabItem {
                Label("История", systemImage: "list.bullet")
            }
        }
    }
}

#Preview {
    ContentView()
}
