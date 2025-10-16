//
//  CameraScannerView.swift
//  scanCodeApp
//
//  Created by Vladislav Andreev on 16.10.2025.
//

import Foundation
import AVFoundation
import SwiftUI

struct CameraScannerView: UIViewControllerRepresentable {
    
    var onCodeScanned: (String, AVMetadataObject.ObjectType) -> Void
    @Binding var isTorchOn: Bool

    func makeCoordinator() -> ScannerCoordinator {
        ScannerCoordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> UIViewController {
        let controller = UIViewController()
        controller.view.backgroundColor = .black

        let session = AVCaptureSession()
        guard let device = AVCaptureDevice.default(for: .video),
              let input = try? AVCaptureDeviceInput(device: device) else {
            return controller
        }

        let output = AVCaptureMetadataOutput()

        if session.canAddInput(input) { session.addInput(input) }
        if session.canAddOutput(output) {
            session.addOutput(output)
            output.setMetadataObjectsDelegate(context.coordinator, queue: .main)
            output.metadataObjectTypes = [.ean8, .ean13, .code128, .qr]
        }

        // Превью
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = UIScreen.main.bounds
        controller.view.layer.addSublayer(previewLayer)

        // --- 🔹 Ограничиваем область сканирования ---
        DispatchQueue.main.async {
            let screenSize = UIScreen.main.bounds.size
            let scanRectSize: CGFloat = 250
            let x = (screenSize.width - scanRectSize) / 2
            let y = (screenSize.height - scanRectSize) / 2

            // Переводим в координаты от 0 до 1 для AVCapture
            let rectOfInterest = CGRect(
                x: y / screenSize.height,
                y: 1 - ((x + scanRectSize) / screenSize.width),
                width: scanRectSize / screenSize.height,
                height: scanRectSize / screenSize.width
            )

            output.rectOfInterest = rectOfInterest
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            session.startRunning()
        }

        context.coordinator.parent = self
        context.coordinator.previewLayer = previewLayer
        return controller
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        toggleTorch(isOn: isTorchOn)
    }

    private func toggleTorch(isOn: Bool) {
        guard let device = AVCaptureDevice.default(for: .video), device.hasTorch else { return }
        try? device.lockForConfiguration()
        device.torchMode = isOn ? .on : .off
        device.unlockForConfiguration()
    }
}
