# 1. Build stage
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy just the project file first to cache dependencies
COPY ["Weather_MCP_Server.csproj", "./"]
RUN dotnet restore

# Copy the rest of the code and build
COPY . .
RUN dotnet publish -c Release -o /app/publish /p:UseAppHost=false

# 2. Runtime stage
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
COPY --from=build /app/publish .

# Tell ASP.NET Core to listen on port 8080 (standard for container platforms)
EXPOSE 8080
ENV ASPNETCORE_HTTP_PORTS=8080

ENTRYPOINT ["dotnet", "Weather_MCP_Server.dll"]