FROM mcr.microsoft.com/dotnet/aspnet:11.0 AS base
WORKDIR /app
EXPOSE 5000

ENV ASPNETCORE_URLS=http://+:5000

USER app
FROM --platform=$BUILDPLATFORM mcr.microsoft.com/dotnet/sdk:11.0 AS build
ARG configuration=Release
WORKDIR /src
COPY ["applied-skills-secured-containers.csproj", "./"]
RUN dotnet restore "applied-skills-secured-containers.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "applied-skills-secured-containers.csproj" -c $configuration -o /app/build

FROM build AS publish
ARG configuration=Release
RUN dotnet publish "applied-skills-secured-containers.csproj" -c $configuration -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "applied-skills-secured-containers.dll"]
