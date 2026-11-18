using Microsoft.AspNetCore.Mvc;
using Trackify.Api.DTOs.Responses;
using Trackify.Api.Services.Interfaces;

namespace Trackify.Api.Controllers;

[ApiController]
[Route("api/health")]
public sealed class HealthController(IHealthService healthService) : ControllerBase
{
    /// <summary>API process health. Independent of the database.</summary>
    [HttpGet]
    [ProducesResponseType(typeof(HealthResponse), StatusCodes.Status200OK)]
    public ActionResult<HealthResponse> Get() => Ok(healthService.GetHealth());

    /// <summary>Database connectivity. Returns 503 when PostgreSQL cannot be reached.</summary>
    [HttpGet("database")]
    [ProducesResponseType(typeof(DatabaseHealthResponse), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(DatabaseHealthResponse), StatusCodes.Status503ServiceUnavailable)]
    public async Task<ActionResult<DatabaseHealthResponse>> GetDatabase(CancellationToken cancellationToken)
    {
        var result = await healthService.GetDatabaseHealthAsync(cancellationToken);
        return result.Status == HealthStatuses.Healthy
            ? Ok(result)
            : StatusCode(StatusCodes.Status503ServiceUnavailable, result);
    }
}
