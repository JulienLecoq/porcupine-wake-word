#import <Foundation/Foundation.h>
#import <Capacitor/Capacitor.h>

// Define the plugin using the CAP_PLUGIN Macro, and
// each method the plugin supports using the CAP_PLUGIN_METHOD macro.
CAP_PLUGIN(PorcupineWakeWordPlugin, "PorcupineWakeWord",
           CAP_PLUGIN_METHOD(initFromBuiltInKeywords, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(initFromCustomKeywords, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(start, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(stop, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(delete, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(hasPermission, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(requestPermission, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(checkPermission, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(removeAllListeners, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(isListening, CAPPluginReturnPromise);
)
