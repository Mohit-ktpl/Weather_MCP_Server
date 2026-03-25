# 1. Build stage
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Look inside the subfolder for the project file
COPY ["Weather_MCP_Server/Weather_MCP_Server.csproj", "Weather_MCP_Server/"]
RUN dotnet restore "Weather_MCP_Server/Weather_MCP_Server.csproj"

# Copy everything from the root
COPY . .

# Change working directory to where the project code actually sits
WORKDIR "/src/Weather_MCP_Server"
RUN dotnet publish "Weather_MCP_Server.csproj" -c Release -o /app/publish /p:UseAppHost=false

# 2. Runtime stage
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
COPY --from=build /app/publish .

EXPOSE 8080
ENV ASPNETCORE_HTTP_PORTS=8080

# Ensure this matches the DLL name generated in the publish folder
ENTRYPOINT ["dotnet", "Weather_MCP_Server.dll"]
