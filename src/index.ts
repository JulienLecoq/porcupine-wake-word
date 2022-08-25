import { registerPlugin } from '@capacitor/core';

import type { PorcupineWakeWordPlugin } from './definitions';

const PorcupineWakeWord = registerPlugin<PorcupineWakeWordPlugin>(
  'PorcupineWakeWord',
  {
    web: () => import('./web').then(m => new m.PorcupineWakeWordWeb()),
  },
);

export * from './definitions';
export { PorcupineWakeWord };
