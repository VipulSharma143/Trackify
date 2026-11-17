/// <reference lib="dom" />
import { AppRegistry, type RootTag } from 'react-native';
import App from '../App';

// Browser entry point: mounts the same App used on Android and iOS via react-native-web.
const container = document.getElementById('root');
if (!container) {
  throw new Error('Root element #root not found');
}

AppRegistry.registerComponent('MyApp', () => App);
// react-native-web accepts a DOM element as the root tag.
AppRegistry.runApplication('MyApp', {
  initialProps: {},
  rootTag: container as unknown as RootTag,
});
