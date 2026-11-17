# backend/AGENTS.md

Read the root `AGENTS.md` first. These rules add to it.

- Target `net10.0`. If the .NET 10 SDK is missing, stop and report; never change the target framework.
- Modular monolith. Thin controllers; logic in `Services/` (`Interfaces/` + `Implementations/`); DTOs in `DTOs/`; never return EF entities.
- Nullable reference types on. Use `async`/`await` and pass `CancellationToken`.
- `Program.cs` only composes services and middleware; registrations live in `Extensions/`.
- Settings are typed classes in `Configuration/`. Secrets (`Database:Username`, `Database:Password`) come from user-secrets or environment variables, never from committed files.
- CORS: only origins listed in `Cors:AllowedOrigins`. Swagger only in Development.
- Never expose connection strings, exception messages or stack traces in responses.
- Create folders (`Models/`, `Repositories/`, `Validators/`, `DTOs/Requests/`) only when a real feature needs them.
- Verify with `dotnet build` before reporting.
