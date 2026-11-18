# System Architecture

```
React Native client (Android, iOS, browser preview)
        |  REST + JSON (HTTPS in production)
        v
ASP.NET Core Web API (controllers -> services)
        |  EF Core
        v
Npgsql provider
        |
        v
PostgreSQL
```

## Components
- **Mobile client** (`mobile/`): React Native + TypeScript (community CLI, no Expo). Browser preview through React Native Web served by Vite. Talks to the API through one centralized `fetch` client (`src/services/api.ts`).
- **API** (`backend/`): ASP.NET Core Web API, a modular monolith. Thin controllers call services; DTOs define the contract.
- **Data access**: EF Core with the Npgsql provider. Migrations define schema.
- **Database**: PostgreSQL, the only database.

## Current state
Only the foundation is in scope: three health/system endpoints and a sample UI. No business features exist. See README for verified status.

## Principles
Modular monolith, DTO contracts, async I/O, no secrets in Git, explicit CORS origins.

## Technology stack
React Native (community CLI, no Expo) + TypeScript · React Native Web + Vite · ASP.NET Core Web API (C#, .NET 10) · PostgreSQL, EF Core, Npgsql · REST/JSON · GitHub Actions.

Installed mobile versions (from `mobile/package.json`): React Native 0.88.1, React 19.3.0, TypeScript ^6.0.3, react-native-web ^0.21.4, Vite ^8.3.8, React Navigation ^7, Jest ^29.
