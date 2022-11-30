import Foundation
import Capacitor
import Porcupine

@objc(PorcupineWakeWordPlugin)
public class PorcupineWakeWordPlugin: CAPPlugin {
    private var isListening_ = false
    var porcupineManager: PorcupineManager?
    var permissionManager = AudioPermissionManager()
    
    // Errors
    var initializationError = InitializationError()
    var permissionError = PermissionError()
    var startError = StartError()
    
    /**
     * Callback function that is invoked upon detection of the keywords.
     * Notify the JS code that a keyword has been detected.
     */
    private func getWordDetectedCb() -> (Int32) -> Void {
        return { keywordIndex in
            self.notifyListeners("keywordDetected", data: [
                "index": keywordIndex
            ])
        }
    }

    /**
     * Callback to run if errors occur while processing audio frames.
     * Notify the JS code that an error has occured.
     */
    private func getErrorCb() -> (Error) -> Void {
        return { error in
            self.notifyListeners("error", data: [
                "message": error.localizedDescription
            ])
        }
    }
    
    private func keywordStrToBuiltInKeyword(_ keyword: String) -> Porcupine.BuiltInKeyword? {
        for builtIn in Porcupine.BuiltInKeyword.allCases {
            if keyword == builtIn.rawValue.uppercased() {
                return builtIn
            }
        }
        
        return nil
    }
    
    @objc public func isListening(_ call: CAPPluginCall) {
        call.resolve([
            "value": self.isListening_
        ])
    }
    
    /**
     * Initialize Porcupine from built in keywords.
     *
     * Rejects:
     * - If there is an error while decoding the JSON from the method parameter (missing parameter, wrong parameter format..).
     * - If the initialization from Porcupine sdk itself fails.
     *
     * Resolves:
     * - When Porcupine finished its initialization.
     */
    @objc public func initFromBuiltInKeywords(_ call: CAPPluginCall) {
        // TODO: What to do if this is an empty array?
        guard let keywordOpts = call.getArray("keywordOpts") as? [JSObject] else {
            return reject(call, self.initializationError.keywordOptsMissing())
        }
        var keywords: [Porcupine.BuiltInKeyword] = []
        var sensitivities: [Float32] = []
        
        for keywordOpt in keywordOpts {
            guard let keyword = keywordOpt["keyword"] as? String else {
                return reject(call, self.initializationError.keywordMissing())
            }
            
            guard let builtInKeyword = keywordStrToBuiltInKeyword(keyword) else {
                return reject(call, self.initializationError.keywordPassedDoesNotExist())
            }
            
            keywords.append(builtInKeyword)
            
            let sensitivity = keywordOpt["sensitivity"] as? Float32 ?? 0.5
            sensitivities.append(sensitivity)
        }

        let wordDetectedcallback = self.getWordDetectedCb()
        let errorCallback = self.getErrorCb()
        
        guard let accessKey = call.options["accessKey"] as? String else {
            return reject(call, self.initializationError.accessKeyMissing())
        }

        do {
            self.porcupineManager = try PorcupineManager(accessKey: accessKey,
                                                     keywords: keywords,
                                                     modelPath: call.getString("modelPath"),
                                                     sensitivities: sensitivities,
                                                     onDetection: wordDetectedcallback,
                                                     errorCallback: errorCallback)
        } catch {
            return reject(call, self.initializationError.porcupineManagerInitializationFailed(error.localizedDescription))
        }

        call.resolve()
    }
    
    /**
     * Initialize Porcupine from custom keywords.
     *
     * Rejects:
     * - If there is an error while decoding the JSON from the method parameter (missing parameter, wrong parameter format..).
     * - If the initialization from Porcupine sdk itself fails.
     *
     * Resolves:
     * - When Porcupine finished its initialization.
     */
    @objc public func initFromCustomKeywords(_ call: CAPPluginCall) {
        // TODO: What to do if this is an empty array?
        guard let keywordPathOpts = call.getArray("keywordPathOpts") as? [JSObject] else {
            return reject(call, self.initializationError.keywordOptsMissing())
        }
        var keywordPaths: [String] = []
        var sensitivities: [Float32] = []
        
        for keywordPathOpt in keywordPathOpts {
            guard let keywordPath = keywordPathOpt["keywordPath"] as? String else {
                return reject(call, self.initializationError.keywordPathMissing())
            }
            
            guard let keywordPathInBundle = Bundle.main.path(forResource: keywordPath, ofType: "ppn") else {
                return reject(call, self.initializationError.invalidKeywordPath())
            }
            
            keywordPaths.append(keywordPathInBundle)
            
            let sensitivity = keywordPathOpt["sensitivity"] as? Float32 ?? 0.5
            sensitivities.append(sensitivity)
        }

        let wordDetectedcallback = self.getWordDetectedCb()
        let errorCallback = self.getErrorCb()
        
        guard let accessKey = call.options["accessKey"] as? String else {
            return reject(call, self.initializationError.accessKeyMissing())
        }

        do {
            self.porcupineManager = try PorcupineManager(accessKey: accessKey,
                                                         keywordPaths: keywordPaths,
                                                         modelPath: Bundle.main.path(forResource: call.getString("modelPath"), ofType: "pv"), // TODO: Add error handling
                                                         sensitivities: sensitivities,
                                                         onDetection: wordDetectedcallback,
                                                         errorCallback: errorCallback)
        } catch {
            return reject(call, self.initializationError.porcupineManagerInitializationFailed(error.localizedDescription))
        }

        call.resolve()
    }
    
    /**
     * Starts recording audio from the microphone and monitors it for the utterances of the given set of keywords.
     *
     * Rejects:
     * - If porcupine is not initialized.
     * - If the user has not granted the record_audio permission.
     * - If the start from Porcupine sdk itself fails.
     *
     * Resolves when the recording from the microphone has started, hence Porcupine listening for the utterances of the given set of keywords.
     */
    @objc public func start(_ call: CAPPluginCall) {
        if (self.porcupineManager == nil) {
            return reject(call, self.startError.notInitialized())
        }

        if (!self.permissionManager.hasGrantedRecordAudioPermission()) {
            return reject(call, self.permissionError.missingAudioPermission())
        }

        do {
            try self.porcupineManager!.start()
        } catch {
            return reject(call, self.startError.startFailed(error.localizedDescription))
        }
        
        self.isListening_ = true
        call.resolve()
    }
    
    /**
     * Stops recording audio from the microphone. Hence, stop listening for wake words.
     * Resolves when the recording from the microphone has stopped.
     */
    @objc public func stop(_ call: CAPPluginCall) {
        if (self.porcupineManager == nil) {
            return call.resolve()
        }
        
        self.porcupineManager!.stop()
        self.isListening_ = false
        call.resolve()
    }
    
    /**
     * Releases resources acquired by Porcupine. It should be called when disposing the object.
     * Resolves when resources acquired by Porcupine have been released.
     */
    
    @objc public func delete(_ call: CAPPluginCall) {
        if (self.porcupineManager == nil) {
            return call.resolve()
        }

        self.porcupineManager!.delete()
        self.porcupineManager = nil
        self.isListening_ = false
        call.resolve()
    }
    
    /**
     * Resolves with true if the user has granted audio permission, false otherwise.
     */
    @objc public func hasPermission(_ call: CAPPluginCall) {
        let hasPerm = self.permissionManager.hasGrantedRecordAudioPermission()
        
        call.resolve([
            "hasPermission": hasPerm
        ])
    }
    
    /**
     * Request the record_audio permission.
     */
    @objc public func requestPermission(_ call: CAPPluginCall) {
        self.permissionManager.requestPermission(call)
    }
    
    /**
     * Check the record_audio permission.
     */
    @objc public func checkPermission(_ call: CAPPluginCall) {
        let status = self.permissionManager.checkPermission()
        call.resolve(status.toJSON())
    }
}
