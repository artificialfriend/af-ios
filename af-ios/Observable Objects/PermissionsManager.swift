//
//  PermissionsManager.swift
//  af-ios
//
//  Created by Cam Crain on 2023-03-22.
//

//import SwiftUI
//import Combine
//import AVFoundation
//
//class MicrophonePermissionManager: ObservableObject {
//    @Published var hasPermission: Bool = false
//    
//    private var permissionObserver = Set<AnyCancellable>()
//    
//    init() {
//        checkMicrophonePermission()
//        
//        NotificationCenter.default.publisher(for: AVAudioSession.sharedInstance().statusPublisher)
//            .sink { [weak self] _ in
//                self?.checkMicrophonePermission()
//            }
//            .store(in: &permissionObserver)
//    }
//    
//    private func checkMicrophonePermission() {
//        let status = AVAudioSession.sharedInstance().recordPermission
//        
//        switch status {
//        case .granted:
//            hasPermission = true
//        case .denied, .undetermined:
//            hasPermission = false
//        @unknown default:
//            hasPermission = false
//        }
//    }
//}
//
//
//extension AVAudioSession {
//    var statusPublisher: NSNotification.Name {
//        if #available(iOS 15.0, *) {
//            return .AVAudioSessionRecordPermissionDidChange
//        } else {
//            return AVAudioSession.interruptionNotification
//        }
//    }
//}

