import { WebPlugin } from '@capacitor/core';
import { BuiltInKeywordInitOptions, KeywordPathInitOptions, PermissionBool, PermissionStatus, PorcupineWakeWordPlugin, ValueResult } from './definitions';
export declare class PorcupineWakeWordWeb extends WebPlugin implements PorcupineWakeWordPlugin {
    initFromBuiltInKeywords(_: BuiltInKeywordInitOptions): Promise<void>;
    initFromCustomKeywords(_: KeywordPathInitOptions): Promise<void>;
    start(): Promise<void>;
    stop(): Promise<void>;
    delete(): Promise<void>;
    removeAllListeners(): Promise<void>;
    hasPermission(): Promise<PermissionBool>;
    checkPermission(): Promise<PermissionStatus>;
    requestPermission(): Promise<PermissionStatus>;
    isListening(): Promise<ValueResult<boolean>>;
}
