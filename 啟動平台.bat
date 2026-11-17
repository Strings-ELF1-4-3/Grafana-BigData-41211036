@echo off
chcp 65001 >nul
title Grafana BigData 41211036
echo ==========================================================
echo   啟動 Grafana BigData 41211036 視覺化分析平台
echo ==========================================================
echo.
powershell -ExecutionPolicy Bypass -File "%~dp0start_dashboard.ps1"
pause
