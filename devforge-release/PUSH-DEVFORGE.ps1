$ErrorActionPreference = 'Stop'
$release = Split-Path -Parent $MyInvocation.MyCommand.Path
$repo = Join-Path $env:USERPROFILE 'Downloads\DevForge'
$expected = 'https://github.com/Donacgreece/DevForge.git'

if (-not (Get-Command git -ErrorAction SilentlyContinue)) { throw 'Git is required.' }
if (-not (Test-Path (Join-Path $release 'src\main.tsx'))) { throw 'Missing release files. Extract the ZIP first, then run this script from the extracted folder.' }
if (-not (Test-Path (Join-Path $release '.github\workflows\deploy.yml'))) { throw 'Missing deployment workflow.' }

if (-not (Test-Path (Join-Path $repo '.git'))) {
  if (Test-Path $repo) { throw "Folder exists but is not a Git repository: $repo" }
  git clone $expected $repo
  if ($LASTEXITCODE -ne 0) { throw 'Clone failed.' }
}
$remote = (git -C $repo remote get-url origin)
if ($LASTEXITCODE -ne 0 -or $remote -notmatch '(?i)(github\.com[:/])Donacgreece/DevForge(\.git)?$') { throw 'This is not the expected DevForge repository.' }
$branch = (git -C $repo branch --show-current).Trim()
if ($branch -ne 'main') { throw "Expected main branch, got $branch" }
$dirty = @(git -C $repo status --porcelain)
if ($dirty.Count -ne 0) { throw 'Uncommitted changes detected. Commit or back up local changes before proceeding.' }

git -C $repo pull --ff-only origin main
if ($LASTEXITCODE -ne 0) { throw 'Pull failed. No files changed.' }

$paths = @('src','index.html','package.json','tsconfig.json','vite.config.ts','.github','.gitignore','LICENSE','README.md')
foreach ($name in $paths) {
  $source = Join-Path $release $name
  if (-not (Test-Path $source)) { throw "Missing required path: $name" }
}
foreach ($name in $paths) {
  $source = Join-Path $release $name
  $destination = Join-Path $repo $name
  if ((Get-Item -LiteralPath $source).PSIsContainer) {
    if (-not (Test-Path $destination)) { New-Item -ItemType Directory -Path $destination -Force | Out-Null }
    Get-ChildItem -LiteralPath $source -Force | ForEach-Object { Copy-Item -LiteralPath $_.FullName -Destination $destination -Recurse -Force }
  } else {
    Copy-Item -LiteralPath $source -Destination $destination -Force
  }
}
# Explicitly overwrite the workflow (including nested directories), which is required for the deployment repair.
$workflowFolder = Join-Path $repo '.github\workflows'
New-Item -ItemType Directory -Path $workflowFolder -Force | Out-Null
Copy-Item -LiteralPath (Join-Path $release '.github\workflows\deploy.yml') -Destination (Join-Path $workflowFolder 'deploy.yml') -Force

git -C $repo add -A
if ($LASTEXITCODE -ne 0) { throw 'Git add failed.' }
$staged = @(git -C $repo diff --cached --name-only)
if ($staged.Count -eq 0) { Write-Host 'No changes to push.' -ForegroundColor Yellow; exit 0 }
git -C $repo commit -m 'fix: deploy complete DevForge JavaScript beta'
if ($LASTEXITCODE -ne 0) { throw 'Commit failed.' }
git -C $repo push origin main
if ($LASTEXITCODE -ne 0) { throw 'Push failed. Local commit is preserved.' }
Write-Host 'SUCCESS: pushed DevForge. Check GitHub Actions.' -ForegroundColor Green
