import type { TextStyle } from 'react-native';

export const typography: Record<
  'title' | 'heading' | 'body' | 'caption',
  TextStyle
> = {
  title: { fontSize: 28, fontWeight: '700' },
  heading: { fontSize: 18, fontWeight: '600' },
  body: { fontSize: 15, lineHeight: 22 },
  caption: { fontSize: 13, lineHeight: 18 },
};
