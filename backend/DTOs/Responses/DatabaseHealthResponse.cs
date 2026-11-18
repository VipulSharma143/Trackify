namespace Trackify.Api.DTOs.Responses;

/// <summary>Response of GET /api/health/database.</summary>
public sealed record DatabaseHealthResponse(string Status, string Provider, DateTime Timestamp);
