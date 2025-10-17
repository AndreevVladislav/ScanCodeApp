//
//  ScannerView.swift
//  scanCodeApp
//
//  Created by Vladislav Andreev on 16.10.2025.
//

import Foundation
import SwiftUI
import AVFoundation

struct ScannerView: View {
    @State private var isTorchOn = false
    @State private var scannedCode: ScannedCodeItem?

    var body: some View {
        ZStack {
            // Камера
            CameraScannerView(onCodeScanned: { value, type in
                if scannedCode == nil {
                    scannedCode = ScannedCodeItem(value: value, type: type.rawValue)
                }
            }, isTorchOn: $isTorchOn)
            .edgesIgnoringSafeArea(.all)

            // Рамка области сканирования
            RoundedRectangle(cornerRadius: 12)
                .stroke(AnyShapeStyle(LinearGradient(
                    gradient: Gradient(colors: [Color.green, Color.blue]),
                    startPoint: .leading,
                    endPoint: .trailing
                )), lineWidth: 3)
                .frame(width: 250, height: 250)
                .opacity(0.7)

            // Кнопка фонарика
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: { isTorchOn.toggle() }) {
                        Image(systemName: isTorchOn ? "flashlight.on.fill" : "flashlight.off.fill")
                            .font(.title2)
                            .padding()
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                    }
                    .padding()
                }
            }
        }
        .navigationTitle("Сканирование")
        .sheet(item: $scannedCode, onDismiss: { scannedCode = nil }) { codeItem in
            ScannedCodeView(code: codeItem.value)
        }
    }
}





