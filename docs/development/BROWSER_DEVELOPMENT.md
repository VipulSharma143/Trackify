# Browser Development (React Native Web + Vite)

```
npm install --prefix mobile
npm run dev          # http://localhost:5173
```
- The browser runs the same `App.tsx` as Android/iOS through `react-native-web` (alias in `mobile/web/vite.config.ts`).
- Routes: `/`, `/settings`, `/about` (refresh and deep links work through the navigation `linking` config on web).
- API URL is set in `mobile/src/constants/config.ts` (browser default `http://localhost:5000`). The backend allows `http://localhost:5173` through `Cors:AllowedOrigins` in `appsettings.Development.json`.
- `npm run build:web --prefix mobile` creates `mobile/dist-web/`.
- Image/icon files use `index.web.ts` variants (Vite imports URLs; Metro uses `require`).
