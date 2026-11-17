using Microsoft.EntityFrameworkCore;

namespace MyApp.Api.Data;

/// <summary>
/// EF Core context. No business entities exist yet; add DbSet properties only when a feature requires them.
/// </summary>
public sealed class ApplicationDbContext(DbContextOptions<ApplicationDbContext> options) : DbContext(options)
{
}
