using Trackify.Api.DTOs.Responses;

namespace Trackify.Api.Services.Interfaces;

public interface IHealthService
{
    HealthResponse GetHealth();

    Task<DatabaseHealthResponse> GetDatabaseHealthAsync(CancellationToken cancellationToken);

    SystemInfoResponse GetSystemInfo();
}
