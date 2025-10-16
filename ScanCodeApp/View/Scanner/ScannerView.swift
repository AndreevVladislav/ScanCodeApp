//
//  ScannerView.swift
//  scanCodeApp
//
//  Created by Vladislav Andreev on 16.10.2025.
//

import Foundation
import SwiftUI

struct ScannerView: View {
    @State private var isTorchOn = false
    @State private var scannedCode: String?
    @State private var isShowingResult = false

    var body: some View {
        ZStack {
            // Камера
            CameraScannerView(onCodeScanned: { value, type in
                // предотвращаем повторное срабатывание
                if scannedCode == nil {
                    scannedCode = value
                    isShowingResult = true
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
        .sheet(isPresented: $isShowingResult, onDismiss: { scannedCode = nil }) {
            if let code = scannedCode {
                ScannedCodeView(code: code)
            }
        }
    }
}





