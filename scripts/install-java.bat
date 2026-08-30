@echo off
choco install openjdk17 -y
if %errorlevel% neq 0 (
    echo Installing via winget...
    winget install EclipseFoundation.Temurin.17 -h
)
echo Done
