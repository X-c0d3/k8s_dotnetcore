FROM microsoft/dotnet:2.1-aspnetcore-runtime AS base
WORKDIR /app
EXPOSE 81

FROM microsoft/dotnet:2.1-sdk AS build
WORKDIR /src
COPY ["K8S_Dotnet.csproj", "./"]
RUN dotnet restore "./K8S_Dotnet.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "K8S_Dotnet.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "K8S_Dotnet.csproj" -c Release -o /app
# RUN dotnet publish "K8S_Dotnet.csproj" -c Release -o /app -r linux-arm64

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "K8S_Dotnet.dll"]

# command for build
# docker build --no-cache -t k8s_dotnet .
# docker run --name newName k8s_dotnet
