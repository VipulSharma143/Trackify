# mobile/AGENTS.md

Read the root `AGENTS.md` first. These rules add to it.

- Plain React Native (community CLI). **Do not add Expo.**
- TypeScript only for app source: `.tsx` components/screens, `.ts` logic. Tool-required JS files (`index.js`, `babel.config.js`, `metro.config.js`, `jest.config.js`, `.eslintrc.js`, `.prettierrc.js`) are the only exceptions.
- `strict` TypeScript; avoid `any`; explicit types on public functions.
- Browser preview uses React Native Web + Vite (`web/`). Keep logic shared; use `.android.ts`/`.ios.ts`/`.web.ts` only where behavior truly differs.
- Styling uses `src/theme` tokens; no fixed sizes that break narrow screens.
- API host comes from `src/constants/config.ts` and `src/platform/apiHost*.ts`. No secrets in app source.
- No new dependency without need and an explanation. No Redux/Zustand/TanStack Query/UI kits.
- Do not create empty folders or empty files.
- Native projects (`android/`, `ios/`) are committed; keep manual edits minimal and documented in `docs/development/NATIVE_DEVELOPMENT.md`.
- Verify with `npm run typecheck` and `npm test`.
