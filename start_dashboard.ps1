# Local Web Server for Grafana BigData 41211036
$port = 8080
$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://localhost:${port}/")
$listener.Start()

Write-Host ""
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "  Grafana BigData 41211036 - Local Server Started" -ForegroundColor Green
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "  Local Browser URL: " -NoNewline
Write-Host "http://localhost:$port" -ForegroundColor Yellow
Write-Host "  Cloudflare URL:    " -NoNewline
Write-Host "https://grafana-bigdata-41211036.a0985481175.workers.dev" -ForegroundColor Cyan
Write-Host ""
Write-Host "  Press Ctrl+C to stop" -ForegroundColor DarkGray
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host ""

Start-Process "http://localhost:$port"

$basePath = "D:\grafana-main-41211036"
$mimeTypes = @{
    ".html" = "text/html; charset=utf-8"
    ".css"  = "text/css; charset=utf-8"
    ".js"   = "application/javascript; charset=utf-8"
    ".json" = "application/json; charset=utf-8"
    ".png"  = "image/png"
    ".jpg"  = "image/jpeg"
    ".svg"  = "image/svg+xml"
    ".ico"  = "image/x-icon"
    ".xlsx" = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
    ".csv"  = "text/csv; charset=utf-8"
}

try {
    while ($listener.IsListening) {
        $context = $listener.GetContext()
        $request = $context.Request
        $response = $context.Response

        $urlPath = $request.Url.LocalPath
        if ($urlPath -eq "/" -or $urlPath -eq "") { $urlPath = "/index.html" }

        # API Handlers
        if ($urlPath -eq "/api/health") {
            $response.ContentType = "application/json; charset=utf-8"
            $response.Headers.Add("Access-Control-Allow-Origin", "*")
            $json = [System.IO.File]::ReadAllText("D:\grafana-main-41211036\hotel_analytics_data.json")
            $msg = [System.Text.Encoding]::UTF8.GetBytes('{"status":"ok","totalHotels":165,"totalRecords":80848}')
            $response.OutputStream.Write($msg, 0, $msg.Length)
            $response.OutputStream.Close()
            continue
        }
        if ($urlPath -eq "/api/data") {
            $response.ContentType = "application/json; charset=utf-8"
            $response.Headers.Add("Access-Control-Allow-Origin", "*")
            $buf = [System.IO.File]::ReadAllBytes("D:\grafana-main-41211036\hotel_analytics_data.json")
            $response.OutputStream.Write($buf, 0, $buf.Length)
            $response.OutputStream.Close()
            continue
        }

        $filePath = Join-Path $basePath ($urlPath.TrimStart('/') -replace '/', '\')

        if (Test-Path $filePath -PathType Leaf) {
            $ext = [System.IO.Path]::GetExtension($filePath).ToLower()
            $response.ContentType = if ($mimeTypes.ContainsKey($ext)) { $mimeTypes[$ext] } else { "application/octet-stream" }
            $response.StatusCode = 200
            $response.Headers.Add("Access-Control-Allow-Origin", "*")

            $buffer = [System.IO.File]::ReadAllBytes($filePath)
            $response.ContentLength64 = $buffer.Length
            $response.OutputStream.Write($buffer, 0, $buffer.Length)
            Write-Host "[$(Get-Date -Format 'HH:mm:ss')] 200 $urlPath" -ForegroundColor Green
        } else {
            $response.StatusCode = 404
            $msg = [System.Text.Encoding]::UTF8.GetBytes("404 Not Found")
            $response.OutputStream.Write($msg, 0, $msg.Length)
            Write-Host "[$(Get-Date -Format 'HH:mm:ss')] 404 $urlPath" -ForegroundColor Red
        }

        $response.OutputStream.Close()
    }
} finally {
    $listener.Stop()
    Write-Host "Server stopped." -ForegroundColor Yellow
}
