//
//  PermissionManager.swift
//  Plugin
//
//  Created by Julien Lecoq on 28/08/2022.
//  Copyright © 2022 Max Lynch. All rights reserved.
//

import Foundation
import Speech
import Capacitor

struct PermissionStatus {
    var record_audio: PermissionState
    
    init(_ record_audio: PermissionState) {
        self.record_audio = record_audio
    }
    
    func toJSON() -> [String: PermissionState.RawValue] {
        return [
            "record_audio": self.record_audio.rawValue
        ]
    }
}

enum PermissionState: String {
    case prompt = "prompt"
    case granted = "granted"
    case denied = "denied"
}

struct AudioPermissionManager {
    
    /**
     * Return true if the user has granted audio permission, false otherwise.
     */
    func hasGrantedRecordAudioPermission() -> Bool {
        return AVCaptureDevice.authorizationStatus(for: .audio) == .authorized
    }
    
    /**
     * Check the record_audio permission.
     */
    func checkPermission() -> PermissionStatus {
        let status = AVCaptureDevice.authorizationStatus(for: .audio)
        
        switch status {
        case .notDetermined:
            return PermissionStatus(PermissionState.prompt)
        case .restricted, .denied:
            return PermissionStatus(PermissionState.denied)
        case .authorized:
            return PermissionStatus(PermissionState.granted)
        @unknown default:
            return PermissionStatus(PermissionState.prompt)
        }
    }
    
    /**
     * Request the record_audio permission.
     */
    func requestPermission(_ call: CAPPluginCall) {
         AVCaptureDevice.requestAccess(for: .audio) { (_: Bool) in
             let status = self.checkPermission()
             call.resolve(status.toJSON())
         }
    }
}
