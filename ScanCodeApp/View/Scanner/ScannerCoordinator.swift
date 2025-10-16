//
//  ScannerCoordinator.swift
//  scanCodeApp
//
//  Created by Vladislav Andreev on 16.10.2025.
//

import Foundation
import AVFoundation

final class ScannerCoordinator: NSObject, AVCaptureMetadataOutputObjectsDelegate {
    var parent: CameraScannerView
    var previewLayer: AVCaptureVideoPreviewLayer?

    init(parent: CameraScannerView) {
        self.parent = parent
    }

    func metadataOutput(
        _ output: AVCaptureMetadataOutput,
        didOutput metadataObjects: [AVMetadataObject],
        from connection: AVCaptureConnection
    ) {
        guard let metadata = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
              let code = metadata.stringValue else { return }

        parent.onCodeScanned(code, metadata.type)
    }
}
