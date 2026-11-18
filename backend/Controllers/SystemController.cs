using Microsoft.AspNetCore.Mvc;
using Trackify.Api.DTOs.Responses;
using Trackify.Api.Services.Interfaces;

namespace Trackify.Api.Controllers;

[ApiController]
[Route("api/system")]
public sealed class SystemController(IHealthService healthService) : ControllerBase
{
    /// <summary>Application, runtime, environment and API version information.</summary>
    [HttpGet("info")]
    [ProducesResponseType(typeof(SystemInfoResponse), StatusCodes.Status200OK)]
    public ActionResult<SystemInfoResponse> GetInfo() => Ok(healthService.GetSystemInfo());
}
