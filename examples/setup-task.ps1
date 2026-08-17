# Zhaoyu KB - create scheduled task (ASCII-safe)
# Copy this file to your KB root folder together with set-daily-task.bat.
# Run set-daily-task.bat (double-click) to register the daily 22:00 task.
$ErrorActionPreference = "Continue"
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

Write-Host '========================================' -ForegroundColor Cyan
Write-Host '  KB Manager - Create daily task (22:00)' -ForegroundColor Cyan
Write-Host '========================================' -ForegroundColor Cyan
Write-Host ''

$taskName = 'KB_DailyMaintenance'
$scriptPath = Join-Path $PSScriptRoot 'daily-maintenance.ps1'
$action = New-ScheduledTaskAction -Execute 'powershell.exe' -Argument ("-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File `"$scriptPath`"")
$trigger = New-ScheduledTaskTrigger -Daily -At 22:00

try {
    Register-ScheduledTask -TaskName $taskName -Action $action -Trigger $trigger -Force -Description 'KB daily maintenance'
    Write-Host '[OK] Task created! Runs daily at 22:00.' -ForegroundColor Green
    Write-Host ''
    Write-Host 'Check: Win+R -> taskschd.msc -> Enter' -ForegroundColor Yellow
    Write-Host 'To test now: right-click the task -> Run' -ForegroundColor Yellow
} catch {
    Write-Host ("[FAIL] " + $_.Exception.Message) -ForegroundColor Red
    Write-Host 'Tip: right-click set-daily-task.bat -> Run as administrator.' -ForegroundColor Yellow
}

Write-Host ''
Read-Host 'Press Enter to exit'