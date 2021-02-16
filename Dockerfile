FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build


#build実行する
WORKDIR /src
COPY ["my_docker_api.csproj", "./"]
RUN dotnet restore "my_docker_api.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "my_docker_api.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "my_docker_api.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "my_docker_api.dll"]
