import { registerPlugin } from '@capacitor/core';
const PorcupineWakeWord = registerPlugin('PorcupineWakeWord', {
    web: () => import('./web').then(m => new m.PorcupineWakeWordWeb()),
});
export * from './definitions';
export { PorcupineWakeWord };
//# sourceMappingURL=index.js.map