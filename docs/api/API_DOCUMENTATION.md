# API Documentation

## Conventions
- Base path `/api`; JSON request/response; `camelCase` property names.
- Timestamps are ISO 8601 UTC.
- Status codes: `200` OK, `400` invalid request, `404` not found, `503` dependency unavailable, `500` unexpected (generic body, no internals).
- Contracts are DTOs; EF entities are never returned.
- Errors never include stack traces, connection strings or internal messages.

## Endpoints (source written, not yet compiled or run)
| Method | Path | Purpose |
|---|---|---|
| GET | `/api/health` | API process status: status, application name, version, UTC timestamp |
| GET | `/api/health/database` | Database connectivity: status, provider name, UTC timestamp |
| GET | `/api/system/info` | Application name, runtime, version, environment, API version |

`/api/health` must stay `200` when the database is down; only `/api/health/database` reports database outage (`503`).

## Status
Implemented in `backend/` but **Not Verified**: the .NET 10 SDK was unavailable when it was written, so it has never been built or run. Swagger UI: `http://localhost:5000/swagger` (Development only).

## Contract assumed by the mobile client (Phase 7)
The mobile client and the backend DTOs use these JSON shapes (camelCase). They have not been tested against each other.

- `GET /api/health` -> `{ status, applicationName, version, timestamp }`, HTTP 200. Status text `Healthy`/`ok` is shown as up.
- `GET /api/health/database` -> `{ status, provider, timestamp }`; HTTP 200 when connected, HTTP 503 (with the same body shape, status e.g. `Unhealthy`) when not.
- `GET /api/system/info` -> `{ applicationName, runtime, version, environment, apiVersion }`.
