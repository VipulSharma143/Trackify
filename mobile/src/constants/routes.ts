import type { RootStackParamList } from '../types/navigation.types';

/** Browser URL paths for each screen (used for refresh and deep links on web). */
export const routePaths: Record<keyof RootStackParamList, string> = {
  Home: '',
  Settings: 'settings',
  About: 'about',
};
