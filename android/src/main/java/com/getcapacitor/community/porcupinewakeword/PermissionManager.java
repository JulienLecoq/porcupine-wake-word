package com.getcapacitor.community.porcupinewakeword;

import android.Manifest;
import android.content.pm.PackageManager;
import android.os.Build;

import androidx.core.content.ContextCompat;

import com.getcapacitor.Bridge;

public class PermissionManager {
    static final String MISSING_PERMISSION_CODE = "5";
    static final String MISSING_PERMISSION_MSG = "Missing permission";

    private Bridge bridge;

    public PermissionManager(Bridge bridge) {
        this.bridge = bridge;
    }

    /**
     * Return true if the user has granted audio permission, false otherwise.
     */
    public boolean hasGrantedRecordAudioPermission() {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.M) {
            return true;
        }

        int hasPerm = ContextCompat.checkSelfPermission(this.bridge.getContext(), Manifest.permission.RECORD_AUDIO);
        return hasPerm == PackageManager.PERMISSION_GRANTED;
    }
}