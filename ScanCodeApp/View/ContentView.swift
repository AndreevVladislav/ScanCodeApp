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
            NavigationView {
                ScannerView()
            }
            .tabItem {
                Label("Сканер", systemImage: "barcode.viewfinder")
            }

            NavigationView {
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
