$ErrorActionPreference = 'Stop'
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$target = Join-Path $env:USERPROFILE 'Downloads\DevForge'
if (-not (Test-Path (Join-Path $here 'package.json'))) { throw 'Release files missing.' }
if (-not (Get-Command git -ErrorAction SilentlyContinue)) { throw 'Git is not installed.' }
if (-not (Test-Path (Join-Path $target '.git'))) {
  Write-Host 'Cloning DevForge...' -ForegroundColor Cyan
  git clone 'https://github.com/Donacgreece/DevForge.git' $target
  if ($LASTEXITCODE -ne 0) { throw 'Git clone failed' }
}
$remote = git -C $target remote get-url origin
if ($LASTEXITCODE -ne 0 -or $remote -notmatch 'Donacgreece/DevForge(\.git)?$') { throw 'Wrong Git repository. No files were copied.' }
git -C $target status --porcelain
if ($LASTEXITCODE -ne 0) { throw 'Git status failed' }
$changes = @(git -C $target status --porcelain)
if ($changes.Count -gt 0) { throw 'Uncommitted local changes found. Commit or back them up first.' }
git -C $target pull --ff-only origin main
if ($LASTEXITCODE -ne 0) { throw 'Git pull failed' }
Write-Host 'Copying DevForge v1 beta source files...' -ForegroundColor Cyan
Get-ChildItem -LiteralPath $here -Force | Where-Object { $_.Name -ne 'PUSH-DEVFORGE.ps1' -and $_.Name -notin @('node_modules','dist','.git') } | ForEach-Object {
  Copy-Item -LiteralPath $_.FullName -Destination $target -Recurse -Force
}
git -C $target add -A
$changes = @(git -C $target status --porcelain)
if ($changes.Count -eq 0) { Write-Host 'No changes to push.'; exit 0 }
git -C $target commit -m 'feat: DevForge JavaScript public beta'
if ($LASTEXITCODE -ne 0) { throw 'Commit failed' }
git -C $target push origin main
if ($LASTEXITCODE -ne 0) { throw 'Push failed' }
Write-Host 'Pushed successfully. Check GitHub Actions deployment.' -ForegroundColor Green
