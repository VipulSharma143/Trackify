namespace Trackify.Api.DTOs.Responses;

public static class HealthStatuses
{
    public const string Healthy = "Healthy";
    public const string Unhealthy = "Unhealthy";
}

/// <summary>Response of GET /api/health.</summary>
public sealed record HealthResponse(string Status, string ApplicationName, string Version, DateTime Timestamp);
