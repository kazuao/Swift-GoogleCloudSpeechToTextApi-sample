//
//  ViewController.swift
//  GoogleCloudSpeechToText-sample
//
//  Created by kazunori.aoki on 2021/12/02.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    // MARK: UI
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var processButton: UIButton!


    // MARK: Property
    private let model = Model()
    private var recorder: AVAudioRecorder!

    private let sampleLate = 16000

    private enum RecordingStatus: String {
        case start = "Recording start"
        case stop = "Recording stop"
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        statusLabel.text = RecordingStatus.stop.rawValue

        setupRecording()
    }


    @IBAction func tapRecord(_ sender: Any) {
        tapStop(sender)

        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playAndRecord, mode: .default)
            try audioSession.setActive(true)

            print("start")
            statusLabel.text = RecordingStatus.start.rawValue
            recorder.record()
        } catch {
            print("Error:", error.localizedDescription)
        }
    }

    @IBAction func tapStop(_ sender: Any) {
        print("stop")
        statusLabel.text = RecordingStatus.stop.rawValue
        recorder.stop()
    }

    @IBAction func tapProcess(_ sender: Any) {
        tapStop(sender)

        // リクエスト
        Task {
            do {
                // Alamofireを使う方法だと失敗する
//                let res = try await model.request(soundFilePath: soundFilePath())
//
//                res.forEach { result in
//                    result.alternatives.forEach { alternative in
//                        alternative.transcript.forEach { trans in
//                            self.textView.text += "\n\(trans)"
//                        }
//                    }
//                }

                let res = try await model.request2(soundFilePath: soundFilePath())

                if let transcript = res.alternatives.first?.transcript {
                    self.textView.text += "\n\(transcript)"
                } else {
                    print("none")
                }

            } catch {
                print("Error:", error.localizedDescription)
            }
        }
    }
}


// MARK: - Private
private extension ViewController {

    func setupRecording() {
        let recordingSettings: [String: Any] = [
            AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue,
            AVEncoderBitRateKey: 16,
            AVNumberOfChannelsKey: 1,
            AVSampleRateKey: sampleLate,
        ]

        do {
            recorder = try AVAudioRecorder(url: soundFilePath(), settings: recordingSettings)
            recorder.delegate = self
        } catch {
            print("Error:", error.localizedDescription)
        }
    }

    func soundFilePath() -> URL {
        let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDir = documentPath[0]
        return documentDir.appendingPathComponent("sound.caf")
    }
}


extension ViewController: AVAudioRecorderDelegate {

}
