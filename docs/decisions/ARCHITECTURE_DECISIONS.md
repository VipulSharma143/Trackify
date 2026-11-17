# Architecture Decisions

| # | Decision | Reason |
|---|---|---|
| 1 | React Native (community CLI, no Expo) + React Native Web/Vite | One codebase for Android, iOS and browser preview; native projects are committed and editable; no Expo dependency. Chosen by the project owner. |
| 2 | TypeScript (strict) | Compile-time safety and clearer contracts. |
| 3 | ASP.NET Core Web API (C#, .NET 10 LTS) | Mature, long-term supported framework with first-class DI and OpenAPI tooling. |
| 4 | PostgreSQL | Robust open-source relational database; a single database keeps the system simple. |
| 5 | EF Core + Npgsql | Standard .NET ORM with migrations and a well-maintained PostgreSQL provider. |
| 6 | Monorepo | Mobile, backend, docs and scripts change together; simpler coordination. |
| 7 | Modular monolith | Avoids microservice overhead until scale demands it. |
| 8 | REST + JSON | Simple, widely supported, easy to test with Swagger and browsers. |
