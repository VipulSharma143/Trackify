export const colors = {
  background: '#F4F6FA',
  surface: '#FFFFFF',
  border: '#E2E6EE',
  text: '#16202E',
  textMuted: '#5B6678',
  primary: '#2F5BEA',
  onPrimary: '#FFFFFF',
  success: '#1E9E5A',
  warning: '#D98A00',
  danger: '#D6393B',
  neutral: '#8A94A6',
} as const;

export type ColorName = keyof typeof colors;
