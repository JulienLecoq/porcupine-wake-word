/**
 * List of built in keywords provided by Porcupine.
 */
export enum BuiltInKeyword {
    ALEXA = "ALEXA",
    AMERICANO = "AMERICANO",
    BLUEBERRY = "BLUEBERRY",
    BUMBLEBEE = "BUMBLEBEE",
    COMPUTER = "COMPUTER",
    GRAPEFRUIT = "GRAPEFRUIT",
    GRASSHOPPER = "GRASSHOPPER",
    HEY_GOOGLE = "HEY_GOOGLE",
    HEY_SIRI = "HEY_SIRI",
    JARVIS = "JARVIS",
    OK_GOOGLE = "OK_GOOGLE",
    PICOVOICE = "PICOVOICE",
    PORCUPINE = "PORCUPINE",
    TERMINATOR = "TERMINATOR"
}

export interface BuiltInKeywordInitOption {
    /**
     * Built in keyword to listen for (keyword provided by Porcupine).
     */
    keyword: BuiltInKeyword

    /** 
     * Sensitivity is the parameter that enables trading miss rate for the false alarm rate.
     * This is a floating-point number within [0, 1]. A higher sensitivity reduces the miss rate at the cost of increased false alarm rate.
     *
     * @default 0.5
     */
    sensitivity?: number
}

export interface KeywordPathInitOption {
    /**
     * Path to the trained model for the given keyword to listen for.
     */
    keywordPath: string

    /** 
     * Sensitivity is the parameter that enables trading miss rate for the false alarm rate.
     * This is a floating-point number within [0, 1]. A higher sensitivity reduces the miss rate at the cost of increased false alarm rate.
     *
     * @default 0.5
     */
    sensitivity?: number
}

export interface InitOptions {
    /**
     * Picovoice access key. The access key acts as your credentials when using Porcupine SDKs. 
     * You can get your access key for free. Make sure to keep your access key secret. 
     * Signup or Login to Picovoice Console (https://console.picovoice.ai/) to get your access key.
     */
    accessKey: string

    /**
     * The model file contains the parameters for the wake word engine. 
     * To change the language that Porcupine understands, you'll pass in a different model file.
     * By default, Porcupine will use a model file for the English language.
     */
    modelPath?: string
}

export interface KeywordPathInitOptions extends InitOptions  {
    keywordPathOpts: KeywordPathInitOption[]
}

export interface BuiltInKeywordInitOptions extends InitOptions {
    keywordOpts: BuiltInKeywordInitOption[]
}

export interface KeywordEventData {
    /**
     * The index of the keyword (index taken from the array passed during the initiliazation of Porcupine)
     * that has been detected.
     */
    index: number
}

export interface ErrorEventData {
    /**
     * The message of the error.
     */
    message: string
}

export interface PermissionBool {
    /**
     * Permission state for record_audio alias.
     */
    hasPermission: boolean
}

export interface PermissionStatus {
    /**
     * Permission state for record_audio alias.
     */
    record_audio: PermissionState
}

export interface PorcupineWakeWordPlugin {
    /**
     * Initialize Porcupine from built in keywords.
     *
     * Rejects:
     * - JSONException: if there is an error while decoding the JSON from the method parameter.
     * - PorcupineException: if there is an error while initializing Porcupine.
     *
     * Resolves when Porcupine finished its initialization.
     */
    initFromBuiltInKeywords(options: BuiltInKeywordInitOptions): Promise<void>

    /**
     * Initialize Porcupine from custom keywords (path of trained models of keywords).
     *
     * Rejects:
     * - JSONException: if there is an error while decoding the JSON from the method parameter.
     * - PorcupineException: if there is an error while initializing Porcupine.
     *
     * Resolves when Porcupine finished its initialization.
     */
    initFromCustomKeywords(options: KeywordPathInitOptions): Promise<void>

    /**
     * Starts recording audio from the microphone and monitors it for the utterances of the given set of keywords.
     *
     * Rejects:
     * - If porcupine is not initialized.
     * - If the user has not granted the record_audio permission.
     *
     * Resolves when the recording from the microphone has started, hence Porcupine listening for the utterances of the given set of keywords.
     */
    start(): Promise<void>

    /**
     * Stops recording audio from the microphone. Hence, stop listening for wake words.
     *
     * Rejects:
     * - PorcupineException: if the PorcupineManager.MicrophoneReader throws an exception while it's being stopped.
     *
     * Resolves when the recording from the microphone has stopped.
     */
    stop(): Promise<void>

    /**
     * Releases resources acquired by Porcupine. It should be called when disposing the object.
     * Resolves when resources acquired by Porcupine have been released.
     */
    delete(): Promise<void>

    /**
     * Register a callback function to run if errors occur while processing audio frames.
     */
    addListener(eventName: "error", listenerFunc: (data: ErrorEventData) => void): void

    /**
     * Register a callback function that is invoked upon detection of the keywords specified during the initialization of Porcupine.
     */
    addListener(eventName: "keywordDetected", listenerFunc: (data: KeywordEventData) => void): void

    /**
     * Remove all registered callback functions.
     */
    removeAllListeners(): Promise<void>

    /**
     * Check if the user has granted the record_audio permission.
     */
    hasPermission(): Promise<PermissionBool>

    /**
     * Check record_audio permission.
     */
    checkPermission(): Promise<PermissionStatus>

    /**
     * Request record_audio permission.
     * Resolves with the new permission status after the user has denied/granted the request.
     */
    requestPermission(): Promise<PermissionStatus>
}

