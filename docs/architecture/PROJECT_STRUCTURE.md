# Project Structure

Every directory listed here exists and contains real files.

| Path | Responsibility |
|---|---|
| `docs/` | Project documentation (architecture, database, api, development, decisions, deployment) |
| `docs/database/sql/` | PostgreSQL create/verify scripts |
| `scripts/` | `check-environment.sh`, `build-android-debug.sh` |
| `mobile/` | React Native app (entry `index.js`, `App.tsx`), `android/`, `ios/` native projects (committed) |
| `mobile/web/` | Browser preview entry: `index.html`, `main.tsx`, `vite.config.ts` |
| `mobile/__tests__/` | Jest tests |
| `mobile/src/assets/images`, `assets/icons` | PNG assets plus `index.ts` (native `require`) and `index.web.ts` (web import) |
| `mobile/src/components/common`, `components/layout` | Reusable UI building blocks and screen wrapper |
| `mobile/src/screens`, `navigation` | Home / Settings / About and React Navigation setup |
| `mobile/src/services`, `hooks` | HTTP client, health/system services, `useApiHealth` |
| `mobile/src/constants` | API configuration and route paths |
| `mobile/src/platform` | Platform-specific values (`apiHost.ts` default, `apiHost.android.ts`) |
| `mobile/src/shared` | App name/version shared across screens |
| `mobile/src/theme`, `types`, `utils` | Design tokens, TypeScript types, small helpers |
| `backend/` | ASP.NET Core Web API (`Program.cs`, `backend.csproj`) |
| `backend/Controllers`, `Services/{Interfaces,Implementations}`, `DTOs/Responses` | HTTP endpoints, business logic, contracts |
| `backend/Data`, `Configuration`, `Extensions`, `Middleware`, `Properties` | EF Core context, typed settings, DI helpers, exception middleware, launch settings |

Not created on purpose (no content yet): `backend/Models`, `Repositories`, `Validators`, `DTOs/Requests`, `mobile/src/assets/fonts`. Add them with the first feature that needs them.
