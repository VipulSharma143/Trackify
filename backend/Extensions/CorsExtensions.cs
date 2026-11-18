using Trackify.Api.Configuration;

namespace Trackify.Api.Extensions;

public static class CorsExtensions
{
    public const string PolicyName = "ConfiguredOrigins";

    public static IServiceCollection AddAppCors(this IServiceCollection services, IConfiguration configuration)
    {
        var settings = configuration.GetSection(CorsSettings.SectionName).Get<CorsSettings>() ?? new CorsSettings();

        services.AddCors(options =>
            options.AddPolicy(PolicyName, policy =>
                policy.WithOrigins(settings.AllowedOrigins)
                      .WithMethods("GET")
                      .AllowAnyHeader()));

        return services;
    }
}
