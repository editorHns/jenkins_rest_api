param(
    [Parameter(Mandatory=$true)][string]$JenkinsUrl,
    [Parameter(Mandatory=$true)][string]$JobName,
    [Parameter(Mandatory=$true)][string]$UserName,
    [Parameter(Mandatory=$true)][string]$ApiToken,
    [string]$Message = "REST API test",
    [string]$Environment = "test",
    [bool]$Debug = $false
)

$ErrorActionPreference = "Stop"
$JenkinsUrl = $JenkinsUrl.TrimEnd("/")

$pair = "$UserName`:$ApiToken"
$base64 = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes($pair))
$headers = @{ Authorization = "Basic $base64" }

$crumb = Invoke-RestMethod `
    -Uri "$JenkinsUrl/crumbIssuer/api/json" `
    -Headers $headers -Method Get

$headers[$crumb.crumbRequestField] = $crumb.crumb

$body = @{
    MESSAGE = $Message
    ENVIRONMENT = $Environment
    DEBUG = $Debug.ToString().ToLower()
}

Write-Host "POST $JenkinsUrl/job/$JobName/buildWithParameters"
Write-Host "MESSAGE=$Message"
Write-Host "ENVIRONMENT=$Environment"
Write-Host "DEBUG=$($Debug.ToString().ToLower())"

$response = Invoke-WebRequest `
    -Uri "$JenkinsUrl/job/$JobName/buildWithParameters" `
    -Headers $headers -Method Post -Body $body

Write-Host "HTTP status: $($response.StatusCode)"
Write-Host "REST API request accepted by Jenkins."
if ($response.Headers.Location) {
    Write-Host "Queue item: $($response.Headers.Location)"
}
