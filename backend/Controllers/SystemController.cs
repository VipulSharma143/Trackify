using Microsoft.AspNetCore.Mvc;
using MyApp.Api.DTOs.Responses;
using MyApp.Api.Services.Interfaces;

namespace MyApp.Api.Controllers;

[ApiController]
[Route("api/system")]
public sealed class SystemController(IHealthService healthService) : ControllerBase
{
    /// <summary>Application, runtime, environment and API version information.</summary>
    [HttpGet("info")]
    [ProducesResponseType(typeof(SystemInfoResponse), StatusCodes.Status200OK)]
    public ActionResult<SystemInfoResponse> GetInfo() => Ok(healthService.GetSystemInfo());
}
