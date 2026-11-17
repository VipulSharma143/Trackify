# Coding Standards

## TypeScript
- `strict: true`; avoid `any`; explicit types on public functions and data structures.
- `.tsx` for components, `.ts` for logic. No `.js`/`.jsx` app source (tool-required files such as `index.js`, `babel.config.js`, `metro.config.js`, `jest.config.js` are the exception).
- Styling through `theme/` tokens; no magic numbers in components.

## C#
- Nullable reference types on; `async`/`await` with `CancellationToken`.
- Thin controllers, services hold logic, DTOs for contracts.
- PascalCase types/members, `_camelCase` private fields, interfaces prefixed `I`.

## SQL
- `snake_case` identifiers, uppercase keywords, comment every script, never drop existing databases.

## General
- Match existing style, keep changes minimal, no speculative code.
