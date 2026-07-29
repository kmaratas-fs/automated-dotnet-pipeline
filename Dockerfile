# Stage 1: Build
FROM mcr.microsoft.com/dotnet/sdk:9.0-alpine AS build

WORKDIR /src

# Copy solution and project files
COPY ["WebApplication.sln", "."]
COPY ["WebApplication/WebApplication.csproj", "WebApplication/"]

# Restore dependencies
RUN dotnet restore "WebApplication.sln"

# Copy all source code
COPY . .

# Build the solution
RUN dotnet build "WebApplication.sln" -c Release -o /app/build

# Stage 2: Publish
FROM build AS publish

RUN dotnet publish "WebApplication/WebApplication.csproj" -c Release -o /app/publish /p:UseAppHost=false

# Stage 3: Runtime
FROM mcr.microsoft.com/dotnet/aspnet:9.0-alpine AS runtime

WORKDIR /app

# Copy published application
COPY --from=publish /app/publish .

# Install curl for health checks and tzdata for timezone support
RUN apk add --no-cache curl tzdata

# Create non-root user for security
RUN addgroup -g 1001 -S appuser && \
    adduser -u 1001 -S appuser -G appuser && \
    chown -R appuser:appuser /app

USER appuser

# Expose port
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
    CMD curl -f http://localhost:8080/health || exit 1

# Set environment variables
ENV ASPNETCORE_URLS=http://+:8080 \
    ASPNETCORE_ENVIRONMENT=Production

# Run the application
ENTRYPOINT ["dotnet", "WebApplication.dll"]
