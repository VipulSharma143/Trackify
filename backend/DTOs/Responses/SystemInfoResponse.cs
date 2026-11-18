namespace Trackify.Api.DTOs.Responses;

/// <summary>Response of GET /api/system/info.</summary>
public sealed record SystemInfoResponse(
    string ApplicationName,
    string Runtime,
    string Version,
    string Environment,
    string ApiVersion);
