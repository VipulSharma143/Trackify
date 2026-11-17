using System.Reflection;
using System.Runtime.InteropServices;
using Microsoft.EntityFrameworkCore;
using MyApp.Api.Data;
using MyApp.Api.DTOs.Responses;
using MyApp.Api.Services.Interfaces;

namespace MyApp.Api.Services.Implementations;

public sealed class HealthService(
    ApplicationDbContext dbContext,
    IHostEnvironment environment,
    ILogger<HealthService> logger) : IHealthService
{
    private const string ApplicationName = "my-app-api";
    private const string ApiVersion = "v1";

    private static readonly string Version =
        Assembly.GetExecutingAssembly().GetName().Version?.ToString(3) ?? "0.0.0";

    // Does not touch the database, so it stays "Healthy" while PostgreSQL is down.
    public HealthResponse GetHealth() =>
        new(HealthStatuses.Healthy, ApplicationName, Version, DateTime.UtcNow);

    public async Task<DatabaseHealthResponse> GetDatabaseHealthAsync(CancellationToken cancellationToken)
    {
        var connected = false;
        try
        {
            connected = await dbContext.Database.CanConnectAsync(cancellationToken);
        }
        catch (OperationCanceledException) when (cancellationToken.IsCancellationRequested)
        {
            throw;
        }
        catch (Exception ex)
        {
            // Log only the exception type; connection details are never exposed.
            logger.LogWarning("Database health check failed: {ExceptionType}", ex.GetType().Name);
        }

        return new DatabaseHealthResponse(
            connected ? HealthStatuses.Healthy : HealthStatuses.Unhealthy,
            dbContext.Database.ProviderName ?? "unknown",
            DateTime.UtcNow);
    }

    public SystemInfoResponse GetSystemInfo() =>
        new(ApplicationName, RuntimeInformation.FrameworkDescription, Version, environment.EnvironmentName, ApiVersion);
}
