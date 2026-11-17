module.exports = {
  preset: '@react-native/jest-preset',
  // These packages ship ES modules and must be transformed by Babel.
  transformIgnorePatterns: [
    'node_modules/(?!((jest-)?react-native|@react-native(-community)?|@react-navigation|react-native-screens|react-native-safe-area-context)/)',
  ],
};
