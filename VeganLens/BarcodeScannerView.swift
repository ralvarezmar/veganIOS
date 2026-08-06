import SwiftUI
import AVFoundation
import UIKit

struct BarcodeScannerView: UIViewControllerRepresentable {
    @Binding var isRunning: Bool
    let onDetected: (String) -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(onDetected: onDetected)
    }

    func makeUIViewController(context: Context) -> BarcodeScannerViewController {
        let controller = BarcodeScannerViewController()
        controller.onDetected = { code in
            context.coordinator.didDetect(code)
        }
        controller.setRunning(isRunning)
        return controller
    }

    func updateUIViewController(_ uiViewController: BarcodeScannerViewController, context: Context) {
        uiViewController.onDetected = { code in
            context.coordinator.didDetect(code)
        }
        uiViewController.setRunning(isRunning)
    }

    final class Coordinator {
        private let onDetected: (String) -> Void
        private var lastDetectedBarcode: String?
        private var lastDetectionDate: Date = .distantPast
        private let cooldown: TimeInterval = 2.0

        init(onDetected: @escaping (String) -> Void) {
            self.onDetected = onDetected
        }

        func didDetect(_ code: String) {
            let now = Date()
            if code == lastDetectedBarcode, now.timeIntervalSince(lastDetectionDate) < cooldown {
                return
            }
            lastDetectedBarcode = code
            lastDetectionDate = now
            onDetected(code)
        }
    }
}

final class BarcodeScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    var onDetected: ((String) -> Void)?

    private let session = AVCaptureSession()
    private let sessionQueue = DispatchQueue(label: "com.ralvarezmar.vcheck.camera.session")
    private let metadataOutput = AVCaptureMetadataOutput()
    private var previewLayer: AVCaptureVideoPreviewLayer?
    private var isConfigured = false
    private var shouldRunSession = false

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black

        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        self.previewLayer = previewLayer

        sessionQueue.async { [weak self] in
            self?.configureSessionIfNeeded()
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer?.frame = view.bounds
    }

    func setRunning(_ running: Bool) {
        shouldRunSession = running
        sessionQueue.async { [weak self] in
            guard let self else { return }
            self.configureSessionIfNeeded()
            if running {
                if !self.session.isRunning {
                    self.session.startRunning()
                }
            } else {
                if self.session.isRunning {
                    self.session.stopRunning()
                }
            }
        }
    }

    private func configureSessionIfNeeded() {
        guard !isConfigured else { return }

        session.beginConfiguration()
        session.sessionPreset = .high

        defer {
            session.commitConfiguration()
            isConfigured = true
            if shouldRunSession, !session.isRunning {
                session.startRunning()
            }
        }

        guard let videoDevice = AVCaptureDevice.default(for: .video),
              let videoInput = try? AVCaptureDeviceInput(device: videoDevice),
              session.canAddInput(videoInput) else {
            return
        }
        session.addInput(videoInput)

        guard session.canAddOutput(metadataOutput) else {
            return
        }
        session.addOutput(metadataOutput)
        metadataOutput.setMetadataObjectsDelegate(self, queue: .main)
        metadataOutput.metadataObjectTypes = [.ean13, .ean8, .upce]
    }

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        guard let readableObject = metadataObjects
            .compactMap({ $0 as? AVMetadataMachineReadableCodeObject })
            .first,
              let barcode = readableObject.stringValue,
              !barcode.isEmpty else {
            return
        }

        sessionQueue.async { [weak self] in
            self?.session.stopRunning()
        }

        DispatchQueue.main.async { [weak self] in
            self?.onDetected?(barcode)
        }
    }
}
