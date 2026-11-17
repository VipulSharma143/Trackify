using Npgsql;

namespace MyApp.Api.Configuration;

/// <summary>
/// PostgreSQL connection settings. Host/Port/Database live in appsettings.json.
/// Username and Password must come from user-secrets or environment variables
/// (Database__Username, Database__Password). Never commit them.
/// </summary>
public sealed class DatabaseSettings
{
    public const string SectionName = "Database";

    public string Host { get; set; } = "localhost";
    public int Port { get; set; } = 5432;
    public string Database { get; set; } = "my_app_dev";
    public string Username { get; set; } = "postgres";
    public string Password { get; set; } = string.Empty;

    public string BuildConnectionString() => new NpgsqlConnectionStringBuilder
    {
        Host = Host,
        Port = Port,
        Database = Database,
        Username = Username,
        Password = Password,
        Timeout = 5, // seconds to wait for a connection, so an outage is reported quickly
    }.ConnectionString;
}
