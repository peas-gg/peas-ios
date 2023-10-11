//
//  SoundClient.swift
//  PEAS
//
//  Created by Kingsley Okeke on 2023-10-11.
//

import AVKit
import Foundation

@MainActor class SoundClient {
	enum Category: String {
		case record
		case playback
	}
	
	enum Sound: String {
		case order
		case cash
	}
	
	static let shared: SoundClient = SoundClient()
	
	private var player: AVAudioPlayer? = nil
	private var category: Category?
	
	init() {
		self.setAudioCategory(for: .playback)
	}
	
	func playSound(_ sound: Sound) {
		guard let url = Bundle.main.url(forResource: sound.rawValue, withExtension: ".mp3") else { return }
		self.player = try? AVAudioPlayer(contentsOf: url)
		self.player?.play()
	}
	
	func setAudioCategory(for category: Category) {
		switch category {
		case .record:
			if self.category != .record {
				try? AVAudioSession.sharedInstance().setActive(false, options: [.notifyOthersOnDeactivation])
				try? AVAudioSession.sharedInstance()
					.setCategory(
						.playAndRecord,
						options: [
							.mixWithOthers,
							.allowBluetoothA2DP,
							.defaultToSpeaker
						]
				)
				try? AVAudioSession.sharedInstance().setActive(true)
				self.category = .record
			}
		case .playback:
			if self.category != .playback {
				try? AVAudioSession.sharedInstance().setActive(false, options: [.notifyOthersOnDeactivation])
				try? AVAudioSession.sharedInstance().setCategory(.ambient)
				try? AVAudioSession.sharedInstance().setActive(true)
				self.category = .playback
			}
		}
	}
}
