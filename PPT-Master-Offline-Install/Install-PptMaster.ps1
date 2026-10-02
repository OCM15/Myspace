param(
    [string]$InstallPath = (Join-Path $HOME '.agents\skills\ppt-master'),
    [switch]$Force,
    [switch]$InstallPythonDependencies
)

$ErrorActionPreference = 'Stop'
$archivePath = Join-Path $PSScriptRoot 'ppt-master-skill-v6.6.0.zip'
$requiredEntries = @(
    'ppt-master/skills/ppt-master/SKILL.md',
    'ppt-master/skills/ppt-master/requirements.txt',
    'ppt-master/skills/ppt-master/workflows/routing.md',
    'ppt-master/skills/ppt-master/scripts/attribution_guard.py'
)

if (-not (Test-Path -LiteralPath $archivePath -PathType Leaf)) {
    throw "Package archive not found: $archivePath"
}

Add-Type -AssemblyName System.IO.Compression.FileSystem
$archive = [System.IO.Compression.ZipFile]::OpenRead($archivePath)
try {
    foreach ($entryName in $requiredEntries) {
        if ($null -eq $archive.GetEntry($entryName)) {
            throw "The package is incomplete. Missing archive entry: $entryName"
        }
    }
}
finally {
    $archive.Dispose()
}

$targetPath = [System.IO.Path]::GetFullPath($InstallPath)
$targetParent = Split-Path -Parent $targetPath
$backupPath = $null
$tempPath = Join-Path ([System.IO.Path]::GetTempPath()) ([guid]::NewGuid().ToString('N'))

try {
    Expand-Archive -LiteralPath $archivePath -DestinationPath $tempPath
    $sourcePath = Join-Path $tempPath 'ppt-master\skills\ppt-master'

    if (Test-Path -LiteralPath $targetPath) {
        if (-not $Force) {
            throw "Install path already exists: $targetPath. Use -Force to move it to a timestamped backup first."
        }

        $backupPath = "$targetPath.backup-$(Get-Date -Format 'yyyyMMdd-HHmmss')"
        Move-Item -LiteralPath $targetPath -Destination $backupPath
    }

    New-Item -ItemType Directory -Path $targetParent -Force | Out-Null
    Copy-Item -LiteralPath $sourcePath -Destination $targetPath -Recurse

    if ($InstallPythonDependencies) {
        $wheelhousePath = Join-Path $PSScriptRoot 'wheelhouse'
        $wheels = @(Get-ChildItem -LiteralPath $wheelhousePath -Filter '*.whl' -File -ErrorAction SilentlyContinue)
        if ($wheels.Count -eq 0) {
            throw "No Python wheels found in $wheelhousePath. Prepare a wheelhouse for this PC as described in README-JA.md."
        }

        $python = Get-Command python -ErrorAction SilentlyContinue
        if ($null -eq $python) {
            throw 'Python 3.10+ was not found. Install Python first, then rerun this command.'
        }

        & $python.Source -m pip install --no-index --find-links $wheelhousePath -r (Join-Path $targetPath 'requirements.txt')
        if ($LASTEXITCODE -ne 0) {
            throw 'Offline Python dependency installation failed. Check the wheelhouse instructions and Python version.'
        }
    }

    Write-Host "PPT Master v6.6.0 installed to: $targetPath"
    if ($backupPath) {
        Write-Host "Previous installation preserved at: $backupPath"
    }
    if (-not $InstallPythonDependencies) {
        Write-Host 'Python dependencies were not installed. See README-JA.md for optional offline setup.'
    }
    Write-Host 'Restart the AI editor, then verify with: python scripts\attribution_guard.py'
}
finally {
    if (Test-Path -LiteralPath $tempPath) {
        Remove-Item -LiteralPath $tempPath -Recurse -Force
    }
}