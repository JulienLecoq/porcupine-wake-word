//
//  PorcupineWakeWordErrors.swift
//  Plugin
//
//  Created by Julien Lecoq on 28/08/2022.
//  Copyright © 2022 Max Lynch. All rights reserved.
//

import Foundation

struct InitializationError {
    func porcupineManagerInitializationFailed(_ message: String) -> CustomError {
        return CustomError("1", message)
    }
    
    func keywordOptsMissing() -> CustomError {
        return CustomError("2", "The keywordOpts parameter is missing.")
    }
    
    func keywordMissing() -> CustomError {
        return CustomError("3", "The keyword parameter is missing.")
    }
    
    func keywordPassedDoesNotExist() -> CustomError {
        return CustomError("4", "The built in keyword passed does not exist in the SDK provided by Porcupine.")
    }
    
    func accessKeyMissing() -> CustomError {
        return CustomError("5", "The access key parameter is missing.")
    }
    
    func keywordPathMissing() -> CustomError {
        return CustomError("6", "The keywordPath parameter is missing.")
    }
    
    func invalidKeywordPath() -> CustomError {
        return CustomError("7", "The keywordPath parameter is invalid, the path does not point to any file.")
    }
}

struct StartError {
    func notInitialized() -> CustomError {
        return CustomError("8", "Porcupine is not yet initialized, initialized it first.")
    }
    
    func startFailed(_ message: String) -> CustomError {
        return CustomError("9", message)
    }
}

struct PermissionError {
    func missingAudioPermission() -> CustomError {
        return CustomError("10", "Missing record audio permission")
    }
}
