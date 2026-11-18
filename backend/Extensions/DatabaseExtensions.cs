using Microsoft.EntityFrameworkCore;
using Trackify.Api.Configuration;
using Trackify.Api.Data;

namespace Trackify.Api.Extensions;

public static class DatabaseExtensions
{
    public static IServiceCollection AddDatabase(this IServiceCollection services, IConfiguration configuration)
    {
        var settings = configuration.GetSection(DatabaseSettings.SectionName).Get<DatabaseSettings>()
                       ?? new DatabaseSettings();

        services.AddDbContext<ApplicationDbContext>(options =>
            options.UseNpgsql(settings.BuildConnectionString()));

        return services;
    }
}
