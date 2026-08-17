# Zhaoyu KB - daily maintenance (ASCII-safe source)
# Copy this to your KB root folder and rename as needed.
# Generates a daily report in daily_reports/ folder.
$ErrorActionPreference = "SilentlyContinue"

$base = "D:\{知识库根目录}"        # 改为你的知识库实际路径
$today = (Get-Date).ToString("yyyy-MM-dd")
$reportDir = Join-Path $base "daily_reports"
$reportPath = Join-Path $reportDir ($today + ".md")

if (-not (Test-Path $reportDir)) { New-Item -ItemType Directory -Path $reportDir -Force | Out-Null }

$newFiles = @()
$rawBase = Join-Path $base "原料"
$scanDirs = @((Join-Path $rawBase "网页摘录"), (Join-Path $rawBase "灵感碎片"), (Join-Path $rawBase "工作学习笔记"))
foreach ($dir in $scanDirs) {
    if (Test-Path $dir) {
        $files = @(Get-ChildItem $dir -File -ErrorAction SilentlyContinue | Where-Object { $_.LastWriteTime -gt (Get-Date).AddDays(-1) })
        foreach ($f in $files) { $newFiles += ("- " + $f.Name + "  [" + (Split-Path $dir -Leaf) + "]") }
    }
}

if (-not (Test-Path $reportPath)) {
    $nl = [Environment]::NewLine
    $body = "# $today" + " 维护日报" + $nl
    $body += "> 由自动维护脚本生成" + $nl + $nl
    $body += "## 今日新增资料" + $nl
    if ($newFiles.Count -gt 0) { $body += ($newFiles -join $nl) } else { $body += "（无新增）" }
    $body += $nl + $nl + "## 下一步" + $nl
    $body += "把这份日报发给你的 AI 助手，说：" + $nl
    $body += "> 请执行 {知识库名} 的每日维护任务" + $nl
    $body += "> 仓库路径：" + $base + $nl
    [System.IO.File]::WriteAllText($reportPath, $body, [System.Text.UTF8Encoding]::new($false))
    Write-Output "REPORT_CREATED"
} else {
    Write-Output "REPORT_EXISTS"
}
Write-Output ("NEW_FILES=" + $newFiles.Count)