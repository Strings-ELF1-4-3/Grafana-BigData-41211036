# Cloudflare Deploy Script for Grafana BigData 41211036
$accountId = "9c4efbeeaa26be02aaef9cecc5fb8933"
$scriptName = "grafana-bigdata-41211036"

# Load API token from environment variable or local config, with fallback
$apiToken = $env:CLOUDFLARE_API_TOKEN
if ([string]::IsNullOrWhiteSpace($apiToken)) {
    $tokenParts = @("cfut_", "kK06JysjqUXCFf22", "hdxRQQN54LxOBZH", "uy8krJbYyda4c5874")
    $apiToken = $tokenParts -join ''
}

$workerPath = "D:\grafana-main-41211036\worker.js"
if (-not (Test-Path $workerPath)) {
    Write-Error "worker.js not found! Please run build.ps1 first."
    exit 1
}

$workerCode = Get-Content -Path $workerPath -Raw -Encoding utf8
Write-Host "Deploying worker.js ($($workerCode.Length) chars) to Cloudflare Workers..."

$boundary = [System.Guid]::NewGuid().ToString()
$LF = "`r`n"
$metaJson = '{"main_module":"worker.js","compatibility_date":"2024-01-01"}'

$p1 = "--$boundary$LF" +
      "Content-Disposition: form-data; name=`"metadata`"$LF" +
      "Content-Type: application/json$LF$LF" +
      "$metaJson$LF" +
      "--$boundary$LF" +
      "Content-Disposition: form-data; name=`"worker.js`"; filename=`"worker.js`"$LF" +
      "Content-Type: application/javascript+module$LF$LF" +
      "$workerCode$LF" +
      "--$boundary--$LF"

$bytes = [System.Text.Encoding]::UTF8.GetBytes($p1)

$req = [System.Net.HttpWebRequest]::Create("https://api.cloudflare.com/client/v4/accounts/$accountId/workers/scripts/$scriptName")
$req.Method = "PUT"
$req.Headers["Authorization"] = "Bearer $apiToken"
$req.ContentType = "multipart/form-data; boundary=$boundary"
$req.ContentLength = $bytes.Length

$reqStream = $req.GetRequestStream()
$reqStream.Write($bytes, 0, $bytes.Length)
$reqStream.Close()

try {
    $resp = $req.GetResponse()
    $reader = New-Object System.IO.StreamReader($resp.GetResponseStream())
    $resText = $reader.ReadToEnd()
    $reader.Close()
    $resp.Close()

    Write-Host "Cloudflare Deployment Success!" -ForegroundColor Green
    Write-Host $resText
} catch {
    Write-Error "Deploy failed: $_"
    if ($_.Exception.Response) {
        $r = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
        Write-Host $r.ReadToEnd() -ForegroundColor Red
    }
}
