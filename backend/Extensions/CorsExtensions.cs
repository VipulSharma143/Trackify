using MyApp.Api.Configuration;

namespace MyApp.Api.Extensions;

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
