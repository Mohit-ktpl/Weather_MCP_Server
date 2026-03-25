using Microsoft.AspNetCore.Builder;
using Microsoft.Extensions.DependencyInjection;
using System.Net.Http.Headers;

var builder = WebApplication.CreateBuilder(args);

// 1. Add the MCP server. 
// The AspNetCore package automatically registers the required HTTP/SSE transport services.
builder.Services.AddMcpServer()
    .WithHttpTransport()
    .WithToolsFromAssembly();

// 2. Register your Weather API client
builder.Services.AddSingleton(_ =>
{
    var client = new HttpClient() { BaseAddress = new Uri("https://api.weather.gov") };
    client.DefaultRequestHeaders.UserAgent.Add(new ProductInfoHeaderValue("weather-tool", "1.0"));
    return client;
});

var app = builder.Build();

// 3. Map the MCP endpoints 
// This automatically exposes the `/sse` and `/message` endpoints required for Streamable HTTP/SSE transport.
app.MapMcp("/sse");

await app.RunAsync();
