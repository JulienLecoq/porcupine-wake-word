package com.getcapacitor.community.porcupinewakeword;

import android.Manifest;

import com.getcapacitor.JSArray;
import com.getcapacitor.JSObject;
import com.getcapacitor.Plugin;
import com.getcapacitor.PluginCall;
import com.getcapacitor.PluginMethod;
import com.getcapacitor.annotation.CapacitorPlugin;
import com.getcapacitor.annotation.Permission;

import org.json.JSONException;
import org.json.JSONObject;

import ai.picovoice.porcupine.Porcupine;
import ai.picovoice.porcupine.PorcupineException;
import ai.picovoice.porcupine.PorcupineManager;
import ai.picovoice.porcupine.PorcupineManagerCallback;
import ai.picovoice.porcupine.PorcupineManagerErrorCallback;

@CapacitorPlugin(
        name = "PorcupineWakeWord",
        permissions = {
                @Permission(
                        strings = { Manifest.permission.RECORD_AUDIO },
                        alias = "record_audio"
                ),
        }
)
public class PorcupineWakeWordPlugin extends Plugin {
    private PermissionManager permissionManager;
    private PorcupineManager porcupineManager;
    private boolean isListening_ = false;

    static final String NOT_INITIALIZED_ERROR_MSG = "Initialization failed";
    static final String NOT_INITIALIZED_ERROR_CODE = "1";
    static final String INITIALIZATION_FAILED_ERROR_CODE = "3";
    static final String STOP_ERROR_CODE = "2";
    static final String JSON_EXCEPTION_ERROR_CODE = "4";

    @Override
    public void load() {
        super.load();
        permissionManager = new PermissionManager(bridge);
    }

    @PluginMethod
    public void isListening(PluginCall call) {
        JSObject response = new JSObject();
        response.put("value", this.isListening_);
        call.resolve(response);
    }

    @PluginMethod
    public void isInitialized(PluginCall call) {
        JSObject response = new JSObject();
        response.put("value", this.porcupineManager != null);
        call.resolve(response);
    }

    /**
     * Callback function that is invoked upon detection of the keywords.
     * Notify the JS code that a keyword has been detected.
     */
    private PorcupineManagerCallback getWordDetectedCb() {
        return keywordIndex -> {
            JSObject response = new JSObject();
            response.put("index", keywordIndex);
            notifyListeners("keywordDetected", response);
        };
    }

    /**
     * Callback to run if errors occur while processing audio frames.
     * Notify the JS code that an error has occured.
     */
    private PorcupineManagerErrorCallback getErrorCb() {
        return error -> {
            JSObject response = new JSObject();
            response.put("message", error.getMessage());
            notifyListeners("error", response);
        };
    }

    /**
     * Initialize Porcupine from built in keywords.
     * Rejects:
     * - JSONException: if there is an error while decoding the JSON from the method parameter.
     * - PorcupineException: if there is an error while initializing Porcupine.
     * Resolves:
     * - When Porcupine finished its initialization.
     */
    @PluginMethod
    public void initFromBuiltInKeywords(PluginCall call) {
        JSArray keywordOpts = call.getArray("keywordOpts");
        Porcupine.BuiltInKeyword[] keywords = new Porcupine.BuiltInKeyword[keywordOpts.length()];
        float[] sensitivities = new float[keywordOpts.length()];

        for (int i = 0; i < keywordOpts.length(); i++) {
            JSONObject keywordOpt;
            try {
                keywordOpt = keywordOpts.getJSONObject(i);
            } catch (JSONException e) {
                call.reject(e.getMessage(), JSON_EXCEPTION_ERROR_CODE);
                return;
            }

            try {
                String keyword = keywordOpt.getString("keyword");
                keywords[i] = Porcupine.BuiltInKeyword.valueOf(keyword);
            } catch (Exception e) {
                call.reject(e.getMessage(), JSON_EXCEPTION_ERROR_CODE);
                return;
            }

            sensitivities[i] = (float) keywordOpt.optDouble("sensitivity", 0.5f);
        }

        PorcupineManagerCallback wordDetectedcallback = getWordDetectedCb();
        PorcupineManagerErrorCallback errorCallback = getErrorCb();

        try {
            this.porcupineManager = new PorcupineManager.Builder()
                    .setAccessKey(call.getString("accessKey"))
                    .setModelPath(call.getString("modelPath") + ".pv") // TODO: Handle the case where modelPath is null
                    .setKeywords(keywords)
                    .setSensitivities(sensitivities)
                    .setErrorCallback(errorCallback)
                    .build(getContext(), wordDetectedcallback);
        } catch (PorcupineException e) {
            call.reject(e.getMessage(), INITIALIZATION_FAILED_ERROR_CODE);
            return;
        }

        call.resolve();
    }

    /**
     * Initialize Porcupine from custom keywords (path of trained models of keywords).
     * Rejects:
     * - JSONException: if there is an error while decoding the JSON from the method parameter.
     * - PorcupineException: if there is an error while initializing Porcupine.
     * Resolves:
     * - When Porcupine finished its initialization.
     */
    @PluginMethod
    public void initFromCustomKeywords(PluginCall call) {
        JSArray keywordPathOpts = call.getArray("keywordPathOpts");
        String[] keywordPaths = new String[keywordPathOpts.length()];
        float[] sensitivities = new float[keywordPathOpts.length()];

        for (int i = 0; i < keywordPathOpts.length(); i++) {
            JSONObject keywordPathOpt;
            try {
                keywordPathOpt = keywordPathOpts.getJSONObject(i);
            } catch (JSONException e) {
                call.reject(e.getMessage(), JSON_EXCEPTION_ERROR_CODE);
                return;
            }

            try {
                keywordPaths[i] = keywordPathOpt.getString("keywordPath") + ".ppn";
            } catch (JSONException e) {
                call.reject(e.getMessage(), JSON_EXCEPTION_ERROR_CODE);
                return;
            }

            sensitivities[i] = (float) keywordPathOpt.optDouble("sensitivity", 0.5f);
        }

        PorcupineManagerCallback wordDetectedcallback = getWordDetectedCb();
        PorcupineManagerErrorCallback errorCallback = getErrorCb();

        try {
            this.porcupineManager = new PorcupineManager.Builder()
                    .setAccessKey(call.getString("accessKey"))
                    .setModelPath(call.getString("modelPath") + ".pv") // TODO: Handle the case where modelPath is null
                    .setKeywordPaths(keywordPaths)
                    .setSensitivities(sensitivities)
                    .setErrorCallback(errorCallback)
                    .build(getContext(), wordDetectedcallback);
        } catch (PorcupineException e) {
            call.reject(e.getMessage(), INITIALIZATION_FAILED_ERROR_CODE);
            return;
        }

        call.resolve();
    }

    /**
     * Starts recording audio from the microphone and monitors it for the utterances of the given set of keywords.
     * Rejects:
     * - If porcupine is not initialized.
     * - If the user has not granted the record_audio permission
     * Resolves when the recording from the microphone has started, hence Porcupine listening for the utterances of the given set of keywords.
     */
    @PluginMethod
    public void start(PluginCall call) {
        if (this.porcupineManager == null) {
            call.reject(NOT_INITIALIZED_ERROR_MSG, NOT_INITIALIZED_ERROR_CODE);
            return;
        }

        if (!this.permissionManager.hasGrantedRecordAudioPermission()) {
            call.reject(PermissionManager.MISSING_PERMISSION_MSG, PermissionManager.MISSING_PERMISSION_CODE);
            return;
        }

        this.porcupineManager.start();
        this.isListening_ = true;
        call.resolve();
    }

    /**
     * Stops recording audio from the microphone. Hence, stop listening for wake words.
     * Rejects:
     * - PorcupineException: if the PorcupineManager.MicrophoneReader throws an exception while it's being stopped
     * Resolves when the recording from the microphone has stopped.
     */
    @PluginMethod
    public void stop(PluginCall call) {
        if (this.porcupineManager == null) {
            call.resolve();
            return;
        }

        try {
            this.porcupineManager.stop();
        } catch (PorcupineException e) {
            call.reject(e.getMessage(), STOP_ERROR_CODE);
        }

        this.isListening_ = false;
        call.resolve();
    }

    /**
     * Releases resources acquired by Porcupine. It should be called when disposing the object.
     * Resolves when resources acquired by Porcupine have been released.
     */
    @PluginMethod
    public void delete(PluginCall call) {
        if (this.porcupineManager == null) {
            call.resolve();
            return;
        }

        this.porcupineManager.delete();
        this.porcupineManager = null;
        this.isListening_ = false;
        call.resolve();
    }

    /**
     * Resolves with true if the user has granted audio permission, false otherwise.
     */
    @PluginMethod
    public void hasPermission(PluginCall call) {
        boolean hasPerm = this.permissionManager.hasGrantedRecordAudioPermission();

        JSObject response = new JSObject();
        response.put("hasPermission", hasPerm);

        call.resolve(response);
    }

    /**
     * Request the record_audio permission.
     */
    @PluginMethod
    public void requestPermission(PluginCall call) {
        super.requestPermissions(call);
    }

    /**
     * Check the record_audio permission.
     */
    @PluginMethod
    public void checkPermission(PluginCall call) {
        super.checkPermissions(call);
    }
}
