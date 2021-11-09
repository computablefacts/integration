[CmdletBinding()]
param (

# Directory that contains SQL files for migrations
    [Parameter(
            Position = 0,
            HelpMessage = "Directory that contains SQL files for migrations.")]
    [ValidateNotNullOrEmpty()]
    [ValidateSet("Up","Down","up","down")]
    [string]
    $Direction = "Up",

# Directory that contains SQL files for migrations
    [Parameter(
            Position = 1,
            HelpMessage = "Directory that contains SQL files for migrations.")]
    [ValidateNotNullOrEmpty()]
    [string]
    $MigrationsDirectory = "Migrations",

# ComputableFacts API Key
    [Parameter(
            Mandatory = $true,
            HelpMessage = "ComputableFacts API Key."
    )]
    [ValidateNotNullOrEmpty()]
    [string]
    $CfApiKey,

# ComputableFacts API URL
    [Parameter(
            Mandatory = $true,
            HelpMessage = "ComputableFacts API URL."
    )]
    [ValidateNotNullOrEmpty()]
    [string]
    $CfApiUrl

)

Write-Debug "Direction=$Direction"
Write-Debug "MigrationsDirectory=$MigrationsDirectory"

Write-Output "Starting migrations $Direction ..."

$startTicks = (Get-Date).Ticks

$descendingOrder = $Direction.ToLower() -eq "down"

Get-ChildItem $MigrationsDirectory -Filter *.$Direction.sql |
    Sort-Object -Property @{Expression = "Name"; Descending = $descendingOrder} | 
        ForEach-Object {

            Write-Host -NoNewline "Processing $($_.Name) ... "

            $measure = Measure-Command {

                $query = Get-Content $_ -Raw
    
                $response = Invoke-WebRequest "$CfApiUrl/api/v2/public/materialize/sql" `
                -Method 'POST' `
                -ContentType 'application/json; charset=utf-8' `
                -Headers @{ 'Authorization' = "Bearer $CfApiKey" } `
                -Body (@{ 'query' = "$query"; 'catalog' = '0' }|ConvertTo-Json)

                if ($response.Content | Test-Json) {
                    $json = ($response.Content | ConvertFrom-Json -AsHashtable)

                    if ($json.containsKey('meta') -and $json.meta.containsKey('errors') -and $json.meta.errors -ne "") {
                        Write-Host
                        Write-Error "Error in $($_.Name):`n$($json.meta.errors)"
                        exit
                    }
                }

            }

            Write-Output "Done in $([math]::round($measure.TotalMilliseconds))ms."
            
        }


$endTicks = (Get-Date).Ticks

Write-Output "Terminated in $([math]::round(($endTicks - $startTicks) / 10000))ms."

