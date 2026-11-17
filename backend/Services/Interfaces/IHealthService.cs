using MyApp.Api.DTOs.Responses;

namespace MyApp.Api.Services.Interfaces;

public interface IHealthService
{
    HealthResponse GetHealth();

    Task<DatabaseHealthResponse> GetDatabaseHealthAsync(CancellationToken cancellationToken);

    SystemInfoResponse GetSystemInfo();
}
