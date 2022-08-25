# @capacitor-community/porcupine-wake-word

This plugin is a bridge to the native SDKs provided by Picovoice on iOS and Android for their product called [Porcupine Wake Word](https://picovoice.ai/platform/porcupine/).

A **wake word** is a special word or phrase that is meant to activate a device when spoken. It is also referred to as 'hotword', 'trigger word', and 'wake up word'.

This plugin is a perfect fit to combine with the [speech-recognition](https://github.com/capacitor-community/speech-recognition) plugin to allow always listening feature in a power efficient manner.

> :warning: **Never use speech-recognition alone to mimic always listening feature**: doing that will result in a very high power consumption (see: [Apple documentation on their Speech native API](https://developer.apple.com/documentation/speech/sfspeechrecognizer) which says in section: Create a Great User Experience for Speech Recognition): 

>*Speech recognition places a relatively high burden on battery life and network usage*.

## Supported platforms

| Name   | Android | iOS | Web |
| :------| :------ | :-- | :-- |
| Status |    ✅   |  ❌ |  ❌ |

## Install

```bash
npm install @capacitor-community/porcupine-wake-word
npx cap sync
```

## Android

### Permissions

This API requires the following permissions be added to your `AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.RECORD_AUDIO" />
```

Read about [Setting Permissions](https://capacitorjs.com/docs/android/configuration#setting-permissions) in the [Android Guide](https://capacitorjs.com/docs/android) for more information on setting Android permissions.

The ``RECORD_AUDIO`` permission is a runtime permission that must be granted by the user before any usage of ``PorcupineWakeWord.start()`` (which will record audio from the user's device).

### Plugin registration

Make sure to register the plugin in your main activity. This is a file placed at: ``/android/app/src/main/java/domainNameOfYourApp/MainActivity.java`` from the root of your project.

```java
package io.ionic.starter;

import android.os.Bundle;

import com.getcapacitor.BridgeActivity;
import com.getcapacitor.community.porcupinewakeword.PorcupineWakeWordPlugin;

public class MainActivity extends BridgeActivity {
    @Override
    public void onCreate(Bundle savedInstanceState) {
        registerPlugin(PorcupineWakeWordPlugin.class);
        super.onCreate(savedInstanceState);
    }
}
```

### Configuration

The root path for finding models is: ``/android/app/src/main/assets/``. Hence, the following call will search for ``models/myKeywordModel.ppn`` in ``/android/app/src/main/assets/models/myKeywordModel.ppn``.
The same rule apply for ``models/myModel.pv``.

```ts
PorcupineWakeWord.initFromCustomKeywords({
    accessKey: "myAccessKey",
    keywordPathOpts: [{
        keywordPath: "models/myKeywordModel.ppn",
        sensitivity: 0.8
    }],
    modelPath: "models/myModel.pv",
})
```

## Usage

Example usage using a custom keyword.

```ts
import { PorcupineWakeWord, KeywordEventData, ErrorEventData } from 'capacitor-porcupine-wake-word';

async function listenForWakeWord(): Promise<void> {
    await PorcupineWakeWord.initFromCustomKeywords({
        accessKey: "myAccessKey",
        keywordPathOpts: [{
            keywordPath: "models/myKeywordModel.ppn",
            sensitivity: 0.8
        }],
        modelPath: "models/myModel.pv",
    })

    PorcupineWakeWord.addListener("keywordDetected", (keyword: KeywordEventData) => {
        console.log('Keyword detected:', keyword)
    })

    PorcupineWakeWord.addListener("error", (error: ErrorEventData) => {
        console.log('Error detected:', error.message)
    })

    return PorcupineWakeWord.start()
}

function main() {
    const result = await PorcupineWakeWord.hasPermission()

    if (result.hasPermission) {
        this.listenForWakeWord()
    } else {
        const permissionStatus = await PorcupineWakeWord.requestPermission()
        if (permissionStatus.record_audio === "granted") {
            this.listenForWakeWord()
        }
    }
}
```

Example usage using a built in keyword.

```ts
import { PorcupineWakeWord, BuiltInKeyword, KeywordEventData, ErrorEventData } from 'capacitor-porcupine-wake-word';

async function listenForWakeWord(): Promise<void> {
    await PorcupineWakeWord.initFromBuiltInKeywords({
        accessKey: "myAccessKey",
        keywordOpts: [{
            keyword: BuiltInKeyword.OK_GOOGLE,
        }],
    })

    PorcupineWakeWord.addListener("keywordDetected", (keyword: KeywordEventData) => {
        console.log('Keyword detected:', keyword)
    })

    PorcupineWakeWord.addListener("error", (error: ErrorEventData) => {
        console.log('Error detected:', error.message)
    })

    return PorcupineWakeWord.start()
}

function main() {
    const result = await PorcupineWakeWord.hasPermission()

    if (result.hasPermission) {
        this.listenForWakeWord()
    } else {
        const permissionStatus = await PorcupineWakeWord.requestPermission()
        if (permissionStatus.record_audio === "granted") {
            this.listenForWakeWord()
        }
    }
}
```

## API

<docgen-index>

* [`initFromBuiltInKeywords(...)`](#initfrombuiltinkeywords)
* [`initFromCustomKeywords(...)`](#initfromcustomkeywords)
* [`start()`](#start)
* [`stop()`](#stop)
* [`delete()`](#delete)
* [`addListener('error', ...)`](#addlistenererror)
* [`addListener('keywordDetected', ...)`](#addlistenerkeyworddetected)
* [`removeAllListeners()`](#removealllisteners)
* [`hasPermission()`](#haspermission)
* [`checkPermission()`](#checkpermission)
* [`requestPermission()`](#requestpermission)
* [Interfaces](#interfaces)
* [Type Aliases](#type-aliases)
* [Enums](#enums)

</docgen-index>

<docgen-api>
<!--Update the source file JSDoc comments and rerun docgen to update the docs below-->

### initFromBuiltInKeywords(...)

```typescript
initFromBuiltInKeywords(options: BuiltInKeywordInitOptions) => Promise<void>
```

Initialize Porcupine from built in keywords.

Rejects:
- JSONException: if there is an error while decoding the JSON from the method parameter.
- PorcupineException: if there is an error while initializing Porcupine.

Resolves when Porcupine finished its initialization.

| Param         | Type                                                                            |
| ------------- | ------------------------------------------------------------------------------- |
| **`options`** | <code><a href="#builtinkeywordinitoptions">BuiltInKeywordInitOptions</a></code> |

--------------------


### initFromCustomKeywords(...)

```typescript
initFromCustomKeywords(options: KeywordPathInitOptions) => Promise<void>
```

Initialize Porcupine from custom keywords (path of trained models of keywords).

Rejects:
- JSONException: if there is an error while decoding the JSON from the method parameter.
- PorcupineException: if there is an error while initializing Porcupine.

Resolves when Porcupine finished its initialization.

| Param         | Type                                                                      |
| ------------- | ------------------------------------------------------------------------- |
| **`options`** | <code><a href="#keywordpathinitoptions">KeywordPathInitOptions</a></code> |

--------------------


### start()

```typescript
start() => Promise<void>
```

Starts recording audio from the microphone and monitors it for the utterances of the given set of keywords.

Rejects:
- If porcupine is not initialized.
- If the user has not granted the record_audio permission.

Resolves when the recording from the microphone has started, hence Porcupine listening for the utterances of the given set of keywords.

--------------------


### stop()

```typescript
stop() => Promise<void>
```

Stops recording audio from the microphone. Hence, stop listening for wake words.

Rejects:
- PorcupineException: if the PorcupineManager.MicrophoneReader throws an exception while it's being stopped.

Resolves when the recording from the microphone has stopped.

--------------------


### delete()

```typescript
delete() => Promise<void>
```

Releases resources acquired by Porcupine. It should be called when disposing the object.
Resolves when resources acquired by Porcupine have been released.

--------------------


### addListener('error', ...)

```typescript
addListener(eventName: "error", listenerFunc: (data: ErrorEventData) => void) => void
```

Register a callback function to run if errors occur while processing audio frames.

| Param              | Type                                                                         |
| ------------------ | ---------------------------------------------------------------------------- |
| **`eventName`**    | <code>'error'</code>                                                         |
| **`listenerFunc`** | <code>(data: <a href="#erroreventdata">ErrorEventData</a>) =&gt; void</code> |

--------------------


### addListener('keywordDetected', ...)

```typescript
addListener(eventName: "keywordDetected", listenerFunc: (data: KeywordEventData) => void) => void
```

Register a callback function that is invoked upon detection of the keywords specified during the initialization of Porcupine.

| Param              | Type                                                                             |
| ------------------ | -------------------------------------------------------------------------------- |
| **`eventName`**    | <code>'keywordDetected'</code>                                                   |
| **`listenerFunc`** | <code>(data: <a href="#keywordeventdata">KeywordEventData</a>) =&gt; void</code> |

--------------------


### removeAllListeners()

```typescript
removeAllListeners() => Promise<void>
```

Remove all registered callback functions.

--------------------


### hasPermission()

```typescript
hasPermission() => Promise<PermissionBool>
```

Check if the user has granted the record_audio permission.

**Returns:** <code>Promise&lt;<a href="#permissionbool">PermissionBool</a>&gt;</code>

--------------------


### checkPermission()

```typescript
checkPermission() => Promise<PermissionStatus>
```

Check record_audio permission.

**Returns:** <code>Promise&lt;<a href="#permissionstatus">PermissionStatus</a>&gt;</code>

--------------------


### requestPermission()

```typescript
requestPermission() => Promise<PermissionStatus>
```

Request record_audio permission.
Resolves with the new permission status after the user has denied/granted the request.

**Returns:** <code>Promise&lt;<a href="#permissionstatus">PermissionStatus</a>&gt;</code>

--------------------


### Interfaces


#### BuiltInKeywordInitOptions

| Prop              | Type                                    |
| ----------------- | --------------------------------------- |
| **`keywordOpts`** | <code>BuiltInKeywordInitOption[]</code> |


#### BuiltInKeywordInitOption

| Prop              | Type                                                      | Description                                                                                                                                                                                                                | Default          |
| ----------------- | --------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------- |
| **`keyword`**     | <code><a href="#builtinkeyword">BuiltInKeyword</a></code> | Built in keyword to listen for (keyword provided by Porcupine).                                                                                                                                                            |                  |
| **`sensitivity`** | <code>number</code>                                       | Sensitivity is the parameter that enables trading miss rate for the false alarm rate. This is a floating-point number within [0, 1]. A higher sensitivity reduces the miss rate at the cost of increased false alarm rate. | <code>0.5</code> |


#### KeywordPathInitOptions

| Prop                  | Type                                 |
| --------------------- | ------------------------------------ |
| **`keywordPathOpts`** | <code>KeywordPathInitOption[]</code> |


#### KeywordPathInitOption

| Prop              | Type                | Description                                                                                                                                                                                                                | Default          |
| ----------------- | ------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------- |
| **`keywordPath`** | <code>string</code> | Path to the trained model for the given keyword to listen for.                                                                                                                                                             |                  |
| **`sensitivity`** | <code>number</code> | Sensitivity is the parameter that enables trading miss rate for the false alarm rate. This is a floating-point number within [0, 1]. A higher sensitivity reduces the miss rate at the cost of increased false alarm rate. | <code>0.5</code> |


#### ErrorEventData

| Prop          | Type                | Description               |
| ------------- | ------------------- | ------------------------- |
| **`message`** | <code>string</code> | The message of the error. |


#### KeywordEventData

| Prop        | Type                | Description                                                                                                                 |
| ----------- | ------------------- | --------------------------------------------------------------------------------------------------------------------------- |
| **`index`** | <code>number</code> | The index of the keyword (index taken from the array passed during the initiliazation of Porcupine) that has been detected. |


#### PermissionBool

| Prop                | Type                 | Description                              |
| ------------------- | -------------------- | ---------------------------------------- |
| **`hasPermission`** | <code>boolean</code> | Permission state for record_audio alias. |


#### PermissionStatus

| Prop               | Type                                                        | Description                              |
| ------------------ | ----------------------------------------------------------- | ---------------------------------------- |
| **`record_audio`** | <code><a href="#permissionstate">PermissionState</a></code> | Permission state for record_audio alias. |


### Type Aliases


#### PermissionState

<code>'prompt' | 'prompt-with-rationale' | 'granted' | 'denied'</code>


### Enums


#### BuiltInKeyword

| Members           | Value                      |
| ----------------- | -------------------------- |
| **`ALEXA`**       | <code>"ALEXA"</code>       |
| **`AMERICANO`**   | <code>"AMERICANO"</code>   |
| **`BLUEBERRY`**   | <code>"BLUEBERRY"</code>   |
| **`BUMBLEBEE`**   | <code>"BUMBLEBEE"</code>   |
| **`COMPUTER`**    | <code>"COMPUTER"</code>    |
| **`GRAPEFRUIT`**  | <code>"GRAPEFRUIT"</code>  |
| **`GRASSHOPPER`** | <code>"GRASSHOPPER"</code> |
| **`HEY_GOOGLE`**  | <code>"HEY_GOOGLE"</code>  |
| **`HEY_SIRI`**    | <code>"HEY_SIRI"</code>    |
| **`JARVIS`**      | <code>"JARVIS"</code>      |
| **`OK_GOOGLE`**   | <code>"OK_GOOGLE"</code>   |
| **`PICOVOICE`**   | <code>"PICOVOICE"</code>   |
| **`PORCUPINE`**   | <code>"PORCUPINE"</code>   |
| **`TERMINATOR`**  | <code>"TERMINATOR"</code>  |

</docgen-api>
