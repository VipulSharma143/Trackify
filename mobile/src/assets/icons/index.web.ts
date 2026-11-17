import type { ImageSourcePropType } from 'react-native';
import ok from './status-ok.png';
import error from './status-error.png';
import pending from './status-pending.png';

export const statusIcons: Record<
  'ok' | 'error' | 'pending',
  ImageSourcePropType
> = {
  ok: { uri: ok },
  error: { uri: error },
  pending: { uri: pending },
};
