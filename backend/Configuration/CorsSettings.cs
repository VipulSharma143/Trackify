namespace Trackify.Api.Configuration;

public sealed class CorsSettings
{
    public const string SectionName = "Cors";

    /// <summary>Exact browser origins allowed to call the API. Empty means no browser origin is allowed.</summary>
    public string[] AllowedOrigins { get; set; } = [];
}
