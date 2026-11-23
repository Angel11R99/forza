param([string]$Repository = "Angel11R99/forza")
$ErrorActionPreference = "Stop"
$labels = Get-Content (Join-Path $PSScriptRoot "../.github/labels.json") -Raw | ConvertFrom-Json
foreach ($label in $labels) {
    gh label create $label.name --repo $Repository --color $label.color --description $label.description --force
    if ($LASTEXITCODE -ne 0) { throw "Could not synchronize label $($label.name)" }
}
Write-Output "Synchronized $($labels.Count) labels in $Repository (existing labels were preserved)."
