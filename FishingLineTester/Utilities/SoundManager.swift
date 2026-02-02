import AVFoundation

// MARK: - Sound Manager
final class SoundManager {
    static let shared = SoundManager()
    
    private var audioPlayers: [String: AVAudioPlayer] = [:]
    private var isEnabled: Bool = true
    
    private init() {
        setupAudioSession()
        preloadSounds()
    }
    
    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to setup audio session: \(error)")
        }
    }
    
    private func preloadSounds() {
        let sounds = ["tension", "break", "catch", "splash", "button", "success", "fail"]
        for sound in sounds {
            if let url = Bundle.main.url(forResource: sound, withExtension: "wav") {
                do {
                    let player = try AVAudioPlayer(contentsOf: url)
                    player.prepareToPlay()
                    audioPlayers[sound] = player
                } catch {
                    print("Failed to load sound \(sound): \(error)")
                }
            }
        }
    }
    
    func setEnabled(_ enabled: Bool) {
        isEnabled = enabled
    }
    
    func play(_ sound: SoundEffect) {
        guard isEnabled else { return }
        
        if let player = audioPlayers[sound.rawValue] {
            player.currentTime = 0
            player.play()
        }
    }
    
    func playTension() {
        play(.tension)
    }
    
    func playBreak() {
        play(.lineBreak)
    }
    
    func playCatch() {
        play(.catch)
    }
    
    func playSplash() {
        play(.splash)
    }
    
    func playButton() {
        play(.button)
    }
    
    func playSuccess() {
        play(.success)
    }
    
    func playFail() {
        play(.fail)
    }
}

// MARK: - Sound Effects
enum SoundEffect: String {
    case tension = "tension"
    case lineBreak = "break"
    case splash = "splash"
    case button = "button"
    case success = "success"
    case fail = "fail"
    case `catch` = "catch"
}
