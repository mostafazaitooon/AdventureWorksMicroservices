# Use the official .NET SDK image to build the app
FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src

# Copy the project file and restore any dependencies
COPY ["AdventureWorksAPI/AdventureWorksAPI.csproj", "AdventureWorksAPI/"]
RUN dotnet restore "AdventureWorksAPI/AdventureWorksAPI.csproj"

# Copy the rest of the code and build the app
COPY . .
WORKDIR "/src/AdventureWorksAPI"
RUN dotnet build "AdventureWorksAPI.csproj" -c Release -o /app/build

# Publish the app to a folder
RUN dotnet publish "AdventureWorksAPI.csproj" -c Release -o /app/publish

# Set the runtime image to run the app
FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base
WORKDIR /app
EXPOSE 80
COPY ["AdventureWorksAPI/AdventureWorksAPI.csproj", "AdventureWorksAPI/"]


# Define the entry point for the application
ENTRYPOINT ["dotnet", "AdventureWorksAPI.dll"]
