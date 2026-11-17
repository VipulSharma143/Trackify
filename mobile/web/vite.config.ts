import react from '@vitejs/plugin-react';
import path from 'node:path';
import { defineConfig } from 'vite';

const projectRoot = path.resolve(__dirname, '..');
const extensions = [
  '.web.tsx',
  '.web.ts',
  '.web.js',
  '.tsx',
  '.ts',
  '.js',
  '.json',
];

// Runs the React Native app in the browser through react-native-web.
export default defineConfig({
  root: __dirname, // index.html lives in web/
  plugins: [react()],
  resolve: {
    alias: { 'react-native': 'react-native-web' },
    extensions,
  },
  define: { __DEV__: JSON.stringify(process.env.NODE_ENV !== 'production') },
  optimizeDeps: {
    esbuildOptions: { resolveExtensions: extensions, loader: { '.js': 'jsx' } },
  },
  server: { port: 5173, strictPort: true, fs: { allow: [projectRoot] } },
  build: { outDir: path.resolve(projectRoot, 'dist-web'), emptyOutDir: true },
});
