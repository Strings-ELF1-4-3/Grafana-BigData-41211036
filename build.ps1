# Build Script for Grafana BigData Dashboard
Add-Type -AssemblyName System.Web

$jsonPath = "D:\grafana-main-41211036\hotel_analytics_data.json"
$jsonRaw = Get-Content -Path $jsonPath -Raw -Encoding utf8

$templatePath = "D:\grafana-main-41211036\template.html"
$htmlTemplate = Get-Content -Path $templatePath -Raw -Encoding utf8

$fullHtml = $htmlTemplate.Replace('__DATA_JSON_PLACEHOLDER__', $jsonRaw)
$indexPath = "D:\grafana-main-41211036\index.html"
$fullHtml | Out-File -FilePath $indexPath -Encoding utf8
Write-Host "Generated index.html ($((Get-Item $indexPath).Length) bytes)"

$workerTemplatePath = "D:\grafana-main-41211036\worker_template.js"
$workerTemplate = Get-Content -Path $workerTemplatePath -Raw -Encoding utf8

$escapedHtml = [System.Web.HttpUtility]::JavaScriptStringEncode($fullHtml)
$workerCode = $workerTemplate.Replace('__DATA_JSON_PLACEHOLDER__', $jsonRaw).Replace('__HTML_RAW_PLACEHOLDER__', "`"$escapedHtml`"")
$workerPath = "D:\grafana-main-41211036\worker.js"
$workerCode | Out-File -FilePath $workerPath -Encoding utf8
Write-Host "Generated worker.js ($((Get-Item $workerPath).Length) bytes)"
