import Flutter
import AVFoundation

class MultiQrTrackerCamera: NSObject, FlutterTexture, AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureMetadataOutputObjectsDelegate {
    private let registry: FlutterTextureRegistry
    private let channel: FlutterMethodChannel
    private var textureId: Int64?
    private var captureSession: AVCaptureSession?
    private var device: AVCaptureDevice?
    private var latestBuffer: CVPixelBuffer?
    private let queue = DispatchQueue(label: "com.github.dhia_bechattaoui.multi_qr_tracker.camera")
    private var isScanning = false
    private var lastDetectionTime: Date?
    private var frameCount = 0
    
    // Image dimensions (Portrait)
    private let targetWidth = 1080
    private let targetHeight = 1920
    
    init(registry: FlutterTextureRegistry, messenger: FlutterBinaryMessenger, channel: FlutterMethodChannel) {
        self.registry = registry
        self.channel = channel
        super.init()
    }

    func initialize(orientation: String, result: @escaping FlutterResult) {
        // Check camera permission
        let authStatus = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch authStatus {
        case .authorized:
            // Permission already granted, proceed with setup
            setupCamera(orientation: orientation, result: result)
            
        case .notDetermined:
            // Request permission
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                DispatchQueue.main.async {
                    if granted {
                        self?.setupCamera(orientation: orientation, result: result)
                    } else {
                        result(FlutterError(code: "PERMISSION_DENIED", message: "Camera permission denied", details: nil))
                    }
                }
            }
            
        case .denied, .restricted:
            result(FlutterError(code: "PERMISSION_DENIED", message: "Camera permission denied. Please enable camera access in Settings.", details: nil))
            
        @unknown default:
            result(FlutterError(code: "PERMISSION_ERROR", message: "Unknown permission status", details: nil))
        }
    }
    
    private func setupCamera(orientation: String, result: @escaping FlutterResult) {
        // Setup capture session
        let session = AVCaptureSession()
        session.sessionPreset = .hd1920x1080 
        
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
            result(FlutterError(code: "CAMERA_UNAVAILABLE", message: "Back camera not found", details: nil))
            return
        }
        self.device = device
        
        do {
            let input = try AVCaptureDeviceInput(device: device)
            if session.canAddInput(input) {
                session.addInput(input)
            }
            
            // Video Output for Texture
            let videoOutput = AVCaptureVideoDataOutput()
            videoOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA]
            videoOutput.setSampleBufferDelegate(self, queue: queue)
            if session.canAddOutput(videoOutput) {
                session.addOutput(videoOutput)
                
                // Set orientation to Portrait
                if let connection = videoOutput.connection(with: .video) {
                    connection.videoOrientation = .portrait
                    if connection.isVideoMirroringSupported && device.position == .front {
                        connection.isVideoMirrored = true
                    }
                }
            }
            
            // Metadata Output for QR Codes
            let metadataOutput = AVCaptureMetadataOutput()
            if session.canAddOutput(metadataOutput) {
                session.addOutput(metadataOutput)
                metadataOutput.setMetadataObjectsDelegate(self, queue: queue)
                metadataOutput.metadataObjectTypes = [.qr]
            }
            
            self.captureSession = session
            self.textureId = registry.register(self)
            
            result([
                "textureId": textureId,
                "width": Double(targetWidth),
                "height": Double(targetHeight)
            ])
            
        } catch {
            result(FlutterError(code: "CAMERA_ERROR", message: error.localizedDescription, details: nil))
        }
    }

    func start(result: @escaping FlutterResult) {
        queue.async {
            if let session = self.captureSession, !session.isRunning {
                session.startRunning()
            }
            self.isScanning = true
            DispatchQueue.main.async {
                result(true)
            }
        }
    }

    func stop(result: @escaping FlutterResult) {
        queue.async {
            if let session = self.captureSession, session.isRunning {
                session.stopRunning()
            }
            self.isScanning = false
            DispatchQueue.main.async {
                result(true)
            }
        }
    }

    func dispose() {
        stop { _ in }
        if let textureId = textureId {
            registry.unregisterTexture(textureId)
        }
        captureSession = nil
        latestBuffer = nil
    }

    func enableTorch(enabled: Bool, result: @escaping FlutterResult) {
        guard let device = device, device.hasTorch else {
            result(false)
            return
        }
        
        do {
            try device.lockForConfiguration()
            device.torchMode = enabled ? .on : .off
            device.unlockForConfiguration()
            result(true)
        } catch {
            result(FlutterError(code: "TORCH_ERROR", message: error.localizedDescription, details: nil))
        }
    }

    func getLightLevel(result: @escaping FlutterResult) {
        // iOS doesn't expose light level directly.
        // We can use ISO and exposure duration to estimate, or just return 0.
        // Returning 0 means auto-torch feature might not work as expected on iOS,
        // but it prevents crashes.
        result(0.0) 
    }

    // MARK: - FlutterTexture
    public func copyPixelBuffer() -> Unmanaged<CVPixelBuffer>? {
        guard let buffer = latestBuffer else { return nil }
        return Unmanaged.passRetained(buffer)
    }

    // MARK: - AVCaptureVideoDataOutputSampleBufferDelegate
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        self.latestBuffer = pixelBuffer
        registry.textureFrameAvailable(textureId ?? 0)
        
        // Send periodic empty updates if no QR codes detected recently
        // This ensures borders are cleared when QR codes disappear
        frameCount += 1
        if frameCount % 15 == 0 { // Every ~15 frames (~0.5s at 30fps)
            if let lastTime = lastDetectionTime {
                let timeSinceDetection = Date().timeIntervalSince(lastTime)
                // If no detection for more than 0.3 seconds, send empty update
                if timeSinceDetection > 0.3 {
                    let emptyData: [String: Any] = [
                        "barcodes": [],
                        "imageWidth": targetWidth,
                        "imageHeight": targetHeight
                    ]
                    DispatchQueue.main.async {
                        self.channel.invokeMethod("onBarcodesDetected", arguments: emptyData)
                    }
                }
            }
        }
    }

    // MARK: - AVCaptureMetadataOutputObjectsDelegate
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        var barcodes: [[String: Any]] = []
        
        for object in metadataObjects {
            if let code = object as? AVMetadataMachineReadableCodeObject, let value = code.stringValue {
                // Transform corners
                // Assuming sensor coordinates (landscape) -> Portrait image
                // x' = (1 - y) * width
                // y' = x * height
                
                let corners = code.corners.map { point in
                    return [
                        "x": (1.0 - point.y) * Double(targetWidth),
                        "y": point.x * Double(targetHeight)
                    ]
                }
                
                barcodes.append([
                    "value": value,
                    "corners": corners
                ])
            }
        }
        
        // Update last detection time
        if !barcodes.isEmpty {
            lastDetectionTime = Date()
        }
        
        // Always send updates, even when empty, so Flutter can clear old borders
        let data: [String: Any] = [
            "barcodes": barcodes,
            "imageWidth": targetWidth,
            "imageHeight": targetHeight
        ]
        DispatchQueue.main.async {
            self.channel.invokeMethod("onBarcodesDetected", arguments: data)
        }
    }
}
