//
//  FoodCameraViewController.swift
//  SmartFit
//
//  Created by Manas Salimzhan on 09.03.2026.
//

import UIKit
import SnapKit
import PanModal
import AVFoundation

protocol FoodCameraDelegate: AnyObject {
    
    func didCaptureFood(image: UIImage)
}


final class FoodCameraViewController: UIViewController {

    private let session = AVCaptureSession()
    private let photoOutput = AVCapturePhotoOutput()
    private var previewLayer: AVCaptureVideoPreviewLayer!

    private let scanFrameView = UIView()
    weak var delegate: FoodCameraDelegate?
    var resultVC: NutritionResultViewController?
    
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        button.layer.cornerRadius = 20
        return button
    }()

    private let scanButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "camera.fill"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 32
        return button
    }()

    private let scanLabel: UILabel = {
        let label = UILabel()
        label.text = "Scan food"
        label.textColor = .white
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .center
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black

        setupCamera()
        setupUI()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        drawScannerCorners()
    }

    // MARK: Camera

    private func setupCamera() {

        guard
            let device = AVCaptureDevice.default(for: .video),
            let input = try? AVCaptureDeviceInput(device: device)
        else { return }

        session.beginConfiguration()

        session.addInput(input)
        session.addOutput(photoOutput)

        session.commitConfiguration()

        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = view.bounds

        view.layer.addSublayer(previewLayer)

        session.startRunning()
    }

    // MARK: UI

    private func setupUI() {

        view.addSubview(scanFrameView)

        scanFrameView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(300)
        }

        view.addSubview(backButton)

        backButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.width.height.equalTo(40)
        }

        backButton.addTarget(self, action: #selector(backTap), for: .touchUpInside)

        let stack = UIStackView(arrangedSubviews: [scanButton, scanLabel])
        stack.axis = .vertical
        stack.spacing = 8
        stack.alignment = .center

        scanButton.snp.makeConstraints {
            $0.width.height.equalTo(64)
        }

        view.addSubview(stack)

        stack.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(80)
        }

        scanButton.addTarget(self, action: #selector(scanTap), for: .touchUpInside)
    }

    // MARK: Scanner corners

    private func drawScannerCorners() {

        scanFrameView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }

        let cornerLength: CGFloat = 40
        let lineWidth: CGFloat = 6
        let radius: CGFloat = 12

        let path = UIBezierPath()

        let w = scanFrameView.bounds.width
        let h = scanFrameView.bounds.height

        // top left
        path.move(to: CGPoint(x: 0, y: cornerLength))
        path.addLine(to: CGPoint(x: 0, y: radius))
        path.addArc(
            withCenter: CGPoint(x: radius, y: radius),
            radius: radius,
            startAngle: .pi,
            endAngle: -.pi/2,
            clockwise: true
        )
        path.addLine(to: CGPoint(x: cornerLength, y: 0))

        // top right
        path.move(to: CGPoint(x: w - cornerLength, y: 0))
        path.addLine(to: CGPoint(x: w - radius, y: 0))
        path.addArc(
            withCenter: CGPoint(x: w - radius, y: radius),
            radius: radius,
            startAngle: -.pi/2,
            endAngle: 0,
            clockwise: true
        )
        path.addLine(to: CGPoint(x: w, y: cornerLength))

        // bottom left
        path.move(to: CGPoint(x: 0, y: h - cornerLength))
        path.addLine(to: CGPoint(x: 0, y: h - radius))
        path.addArc(
            withCenter: CGPoint(x: radius, y: h - radius),
            radius: radius,
            startAngle: .pi,
            endAngle: .pi/2,
            clockwise: false
        )
        path.addLine(to: CGPoint(x: cornerLength, y: h))

        // bottom right
        path.move(to: CGPoint(x: w - cornerLength, y: h))
        path.addLine(to: CGPoint(x: w - radius, y: h))
        path.addArc(
            withCenter: CGPoint(x: w - radius, y: h - radius),
            radius: radius,
            startAngle: .pi/2,
            endAngle: 0,
            clockwise: false
        )
        path.addLine(to: CGPoint(x: w, y: h - cornerLength))

        let shape = CAShapeLayer()
        shape.path = path.cgPath
        shape.strokeColor = UIColor.systemBlue.cgColor
        shape.lineWidth = lineWidth
        shape.fillColor = UIColor.clear.cgColor

        scanFrameView.layer.addSublayer(shape)
    }

    // MARK: Capture

    @objc private func scanTap() {

        let settings = AVCapturePhotoSettings()
        photoOutput.capturePhoto(with: settings, delegate: self)
    }

    @objc private func backTap() {
        dismiss(animated: true)
    }
    
    private func freezeCamera() {
        session.stopRunning()
    }
    
    func showResult(_ result: NutritionResponse) {
        resultVC?.showResult(result)
    }
    
    func resumeCamera() {
        if !session.isRunning {
            session.startRunning()
        }
    }
}

extension FoodCameraViewController: AVCapturePhotoCaptureDelegate {

    func photoOutput(
        _ output: AVCapturePhotoOutput,
        didFinishProcessingPhoto photo: AVCapturePhoto,
        error: Error?
    ) {
        guard
            error == nil,
            let data = photo.fileDataRepresentation(),
            let image = UIImage(data: data)
        else { return }

        let finalImage = image
            .cropToSquare()?
            .resizeTo512()

        guard let finalImage else { return }

        delegate?.didCaptureFood(image: finalImage)

        freezeCamera()

        let vc = NutritionResultViewController()
        vc.delegate = self
        resultVC = vc

        presentPanModal(vc)
    }
    
    func dismissResult(message: String) {
        resultVC?.dismiss(animated: true)
        
        let alert = UIAlertController(
            title: "Error",
            message: message,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        present(alert, animated: true)
    }
}


extension FoodCameraViewController: NutritionResultViewControllerDelegate {
    
    func presenterViewClosed() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.session.startRunning()
        }
    }
}
