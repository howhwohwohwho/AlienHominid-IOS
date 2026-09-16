import AVFoundation

final class AudioManager {

    private let engine = AVAudioEngine()
    private let player = AVAudioPlayerNode()

    init() {
        engine.attach(player)
    }

    func start() {
        do {
            try engine.start()
        } catch {
            print("Audio engine failed to start: \(error)")
        }
    }

    func stop() {
        engine.stop()
        player.stop()
    }

    func playPCMBuffer(_ buffer: AVAudioPCMBuffer) {
        player.scheduleBuffer(buffer)
        player.play()
    }
}
