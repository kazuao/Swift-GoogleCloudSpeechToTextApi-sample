//
//  PowerLevel.swift
//  GoogleCloudSpeechToText-sample
//
//  Created by kazunori.aoki on 2021/12/09.
//

import Foundation
import AVFoundation

// ref: `https://swiftlife.hatenablog.jp/entry/2016/04/11/135251`

final class PowerLevel: NSObject {

    private let captureSession = AVCaptureSession()
    private let serialQueue = DispatchQueue(label: "com.swift3.imageQueue")

    override init() {
        super.init()

        do {
            try setupCaptureRoute()
        } catch {
            print("Error", error)
        }
    }

    func setupCaptureRoute() throws {

        if let audioDevice = AVCaptureDevice.default(for: .audio) {
            let audioInput = try AVCaptureDeviceInput(device: audioDevice)

            let audioDataOut = AVCaptureAudioDataOutput()
            audioDataOut.setSampleBufferDelegate(self, queue: serialQueue)

            captureSession.addOutput(audioDataOut)
            captureSession.addInput(audioInput)
        }
    }

    func start() {
        captureSession.startRunning()
    }

    func stop() {
        captureSession.stopRunning()
    }
}

extension PowerLevel: AVCaptureAudioDataOutputSampleBufferDelegate {

    func captureOutput(_ output: AVCaptureOutput,
                       didOutput sampleBuffer: CMSampleBuffer,
                       from connection: AVCaptureConnection)
    {
        let audioChannels = connection.audioChannels

        if !audioChannels.isEmpty {
            let averagePowerLevel = audioChannels.reduce(0.0){ $0 + $1.averagePowerLevel }
                / Float(audioChannels.count)
            let peakHoldLevel = audioChannels.reduce(0.0){ $0 + $1.peakHoldLevel }
                / Float(audioChannels.count)
            print("\(averagePowerLevel) / \(peakHoldLevel)")
        }
    }
}
