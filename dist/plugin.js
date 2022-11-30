var capacitorPorcupineWakeWord = (function (exports, core) {
    'use strict';

    /**
     * List of built in keywords provided by Porcupine.
     */
    exports.BuiltInKeyword = void 0;
    (function (BuiltInKeyword) {
        BuiltInKeyword["ALEXA"] = "ALEXA";
        BuiltInKeyword["AMERICANO"] = "AMERICANO";
        BuiltInKeyword["BLUEBERRY"] = "BLUEBERRY";
        BuiltInKeyword["BUMBLEBEE"] = "BUMBLEBEE";
        BuiltInKeyword["COMPUTER"] = "COMPUTER";
        BuiltInKeyword["GRAPEFRUIT"] = "GRAPEFRUIT";
        BuiltInKeyword["GRASSHOPPER"] = "GRASSHOPPER";
        BuiltInKeyword["HEY_GOOGLE"] = "HEY_GOOGLE";
        BuiltInKeyword["HEY_SIRI"] = "HEY_SIRI";
        BuiltInKeyword["JARVIS"] = "JARVIS";
        BuiltInKeyword["OK_GOOGLE"] = "OK_GOOGLE";
        BuiltInKeyword["PICOVOICE"] = "PICOVOICE";
        BuiltInKeyword["PORCUPINE"] = "PORCUPINE";
        BuiltInKeyword["TERMINATOR"] = "TERMINATOR";
    })(exports.BuiltInKeyword || (exports.BuiltInKeyword = {}));

    const PorcupineWakeWord = core.registerPlugin('PorcupineWakeWord', {
        web: () => Promise.resolve().then(function () { return web; }).then(m => new m.PorcupineWakeWordWeb()),
    });

    class PorcupineWakeWordWeb extends core.WebPlugin {
        initFromBuiltInKeywords(_) {
            throw this.unimplemented('Method not implemented on web.');
        }
        initFromCustomKeywords(_) {
            throw this.unimplemented('Method not implemented on web.');
        }
        start() {
            throw this.unimplemented('Method not implemented on web.');
        }
        stop() {
            throw this.unimplemented('Method not implemented on web.');
        }
        delete() {
            throw this.unimplemented('Method not implemented on web.');
        }
        removeAllListeners() {
            throw this.unimplemented('Method not implemented on web.');
        }
        hasPermission() {
            throw this.unimplemented('Method not implemented on web.');
        }
        checkPermission() {
            throw this.unimplemented('Method not implemented on web.');
        }
        requestPermission() {
            throw this.unimplemented('Method not implemented on web.');
        }
        isListening() {
            throw this.unimplemented('Method not implemented on web.');
        }
        isInitialized() {
            throw this.unimplemented('Method not implemented on web.');
        }
    }

    var web = /*#__PURE__*/Object.freeze({
        __proto__: null,
        PorcupineWakeWordWeb: PorcupineWakeWordWeb
    });

    exports.PorcupineWakeWord = PorcupineWakeWord;

    Object.defineProperty(exports, '__esModule', { value: true });

    return exports;

})({}, capacitorExports);
//# sourceMappingURL=plugin.js.map
