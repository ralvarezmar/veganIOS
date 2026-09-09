import SwiftUI
import AVFoundation
import UIKit

struct BarcodeScannerView: UIViewControllerRepresentable {
    @Binding var isRunning: Bool
    @Binding var torchOn: Bool
    @Binding var zoomFactor: CGFloat
    let onDetected: (String) -> Void
    let onCameraReady: (Bool, CGFloat, CGFloat) -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(onDetected: onDetected)
    }

    func makeUIViewController(context: Context) -> BarcodeScannerViewController {
        let controller = BarcodeScannerViewController()
        controller.onDetected = { code in
            context.coordinator.didDetect(code)
        }
        controller.onCameraReady = onCameraReady
        controller.setRunning(isRunning)
        controller.setTorch(torchOn)
        controller.setZoomFactor(zoomFactor)
        return controller
    }

    func updateUIViewController(_ uiViewController: BarcodeScannerViewController, context: Context) {
        uiViewController.onDetected = { code in
            context.coordinator.didDetect(code)
        }
        uiViewController.onCameraReady = onCameraReady
        uiViewController.setRunning(isRunning)
        uiViewController.setTorch(torchOn)
        uiViewController.setZoomFactor(zoomFactor)
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
    var onCameraReady: ((Bool, CGFloat, CGFloat) -> Void)?

    private let session = AVCaptureSession()
    private let sessionQueue = DispatchQueue(label: "com.ralvarezmar.vcheck.camera.session")
    private let metadataOutput = AVCaptureMetadataOutput()
    private var previewLayer: AVCaptureVideoPreviewLayer?
    private var videoDevice: AVCaptureDevice?
    private var isConfigured = false
    private var shouldRunSession = false

    var hasTorch: Bool {
        guard let videoDevice else { return false }
        return videoDevice.hasTorch && videoDevice.isTorchAvailable
    }

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
                self.setTorchLocked(false)
                if self.session.isRunning {
                    self.session.stopRunning()
                }
            }
        }
    }

    func setTorch(_ on: Bool) {
        guard videoDevice != nil else { return }
        sessionQueue.async { [weak self] in
            self?.setTorchLocked(on)
        }
    }

    func setZoomFactor(_ factor: CGFloat) {
        guard videoDevice != nil else { return }
        sessionQueue.async { [weak self] in
            self?.setZoomFactorLocked(factor)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sessionQueue.async { [weak self] in
            guard let self else { return }
            self.setTorchLocked(false)
            if self.session.isRunning {
                self.session.stopRunning()
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
        self.videoDevice = videoDevice
        setTorchLocked(false)
        setZoomFactorLocked(1)
        session.addInput(videoInput)

        guard session.canAddOutput(metadataOutput) else {
            return
        }
        session.addOutput(metadataOutput)
        metadataOutput.setMetadataObjectsDelegate(self, queue: .main)
        metadataOutput.metadataObjectTypes = [.ean13, .ean8, .upce]
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.onCameraReady?(
                self.hasTorch,
                videoDevice.minAvailableVideoZoomFactor,
                min(videoDevice.maxAvailableVideoZoomFactor, 5)
            )
        }
    }

    private func setTorchLocked(_ on: Bool) {
        guard let videoDevice, videoDevice.hasTorch, videoDevice.isTorchAvailable else { return }
        do {
            try videoDevice.lockForConfiguration()
            defer { videoDevice.unlockForConfiguration() }
            videoDevice.torchMode = on ? .on : .off
        } catch {
            return
        }
    }

    private func setZoomFactorLocked(_ factor: CGFloat) {
        guard let videoDevice else { return }
        do {
            try videoDevice.lockForConfiguration()
            defer { videoDevice.unlockForConfiguration() }
            videoDevice.videoZoomFactor = clampedZoomFactor(
                factor,
                deviceMin: videoDevice.minAvailableVideoZoomFactor,
                deviceMax: min(videoDevice.maxAvailableVideoZoomFactor, 5)
            )
        } catch {
            return
        }
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
            guard let self else { return }
            self.setTorchLocked(false)
            self.session.stopRunning()
        }

        DispatchQueue.main.async { [weak self] in
            self?.onDetected?(barcode)
        }
    }
}
