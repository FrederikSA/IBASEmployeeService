# BYG-DEL
FROM mcr.microsoft.com/dotnet/sdk:9.0-alpine AS build
WORKDIR /app
COPY . .
RUN dotnet restore
RUN dotnet publish -o /app/published-app

# RUNTIME-DEL
FROM mcr.microsoft.com/dotnet/aspnet:9.0-alpine AS runtime
WORKDIR /app
COPY --from=build /app/published-app /app

# API skal lytte på port 5000
EXPOSE 5000
ENV ASPNETCORE_HTTP_PORTS=5000

# Opret en ikke-root bruger → sikkerhed
RUN adduser -u 5678 --disabled-password --gecos "" appuser && chown -R appuser /app
USER appuser

# Start web API’et
ENTRYPOINT ["dotnet", "IBASEmployeeService.dll"]
