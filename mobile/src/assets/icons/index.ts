import type { ImageSourcePropType } from 'react-native';

export const statusIcons: Record<
  'ok' | 'error' | 'pending',
  ImageSourcePropType
> = {
  ok: require('./status-ok.png'),
  error: require('./status-error.png'),
  pending: require('./status-pending.png'),
};
