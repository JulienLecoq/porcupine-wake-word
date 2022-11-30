import { WebPlugin } from '@capacitor/core'

import { BuiltInKeywordInitOptions, KeywordPathInitOptions, PermissionBool, PermissionStatus, PorcupineWakeWordPlugin, ValueResult } from './definitions'

export class PorcupineWakeWordWeb
    extends WebPlugin
    implements PorcupineWakeWordPlugin {

    initFromBuiltInKeywords(_: BuiltInKeywordInitOptions): Promise<void> {
        throw this.unimplemented('Method not implemented on web.')
    }

    initFromCustomKeywords(_: KeywordPathInitOptions): Promise<void> {
        throw this.unimplemented('Method not implemented on web.')
    }

    start(): Promise<void> {
        throw this.unimplemented('Method not implemented on web.')
    }

    stop(): Promise<void> {
        throw this.unimplemented('Method not implemented on web.')
    }

    delete(): Promise<void> {
        throw this.unimplemented('Method not implemented on web.')
    }

    removeAllListeners(): Promise<void> {
        throw this.unimplemented('Method not implemented on web.')
    }

    hasPermission(): Promise<PermissionBool> {
        throw this.unimplemented('Method not implemented on web.')
    }

    checkPermission(): Promise<PermissionStatus> {
        throw this.unimplemented('Method not implemented on web.')
    }

    requestPermission(): Promise<PermissionStatus> {
        throw this.unimplemented('Method not implemented on web.')
    }

    isListening(): Promise<ValueResult<boolean>> {
        throw this.unimplemented('Method not implemented on web.')
    }
}
