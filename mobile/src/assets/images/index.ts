import type { ImageSourcePropType } from 'react-native';

// Native (Metro) resolves images with require(). Web uses index.web.ts.
export const logo: ImageSourcePropType = require('./logo.png');
