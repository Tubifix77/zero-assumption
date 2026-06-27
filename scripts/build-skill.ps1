# Regenerate dist/zero-assumption.skill from skills/zero-assumption/.
# The .skill is a renamed .zip with the skill folder at the archive root.
# Run after editing the skill (i.e. after editing references/contract.md).
#
#   pwsh scripts/build-skill.ps1
#
$ErrorActionPreference = "Stop"
$root  = Split-Path $PSScriptRoot -Parent
$src   = Join-Path $root "skills\zero-assumption"
$zip   = Join-Path $root "dist\zero-assumption.zip"
$skill = Join-Path $root "dist\zero-assumption.skill"

New-Item -ItemType Directory -Force (Join-Path $root "dist") | Out-Null
if (Test-Path $zip)   { Remove-Item $zip }
if (Test-Path $skill) { Remove-Item $skill }

Compress-Archive -Path $src -DestinationPath $zip
Move-Item $zip $skill
Write-Output "Built $skill"
