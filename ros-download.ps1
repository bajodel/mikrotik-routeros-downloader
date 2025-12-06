# Mikrotik RouterOS Downloader Script (PowerShell) v1.0
# Usage:
#   powershell -ExecutionPolicy Bypass -File .\ros-download.ps1 <version> [dest]
# Examples:
#   powershell -ExecutionPolicy Bypass -File .\ros-download.ps1 7.20.6
#   powershell -ExecutionPolicy Bypass -File .\ros-download.ps1 6.49.19 'C:\Downloads\RouterOS-6.49.19'
# Notes:
# - Supports RouterOS v6 and v7; picks the appropriate full URL list.
# - Creates the destination directory if missing; shows progress and summary.
# License: MIT
# GitHub: https://github.com/bajodel/mikrotik-routeros-downloader

Param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$version,
    [string]$dest = $version
)

if (!(Test-Path $dest)) {
    Write-Host "Destination directory '$dest' does not exist. Creating.."
    New-Item -ItemType Directory -Path $dest | Out-Null
}

if ($version -match '^6') {
    Write-Host "Detected RouterOS v6, using full v6 URL list."
    $urls = @(
        "https://download.mikrotik.com/routeros/$version/chr-$version.img.zip",
        "https://download.mikrotik.com/routeros/$version/chr-$version.vdi.zip",
        "https://download.mikrotik.com/routeros/$version/chr-$version.vhdx.zip",
        "https://download.mikrotik.com/routeros/$version/chr-$version.ova",
        "https://download.mikrotik.com/routeros/$version/chr-$version.vhd.zip",
        "https://download.mikrotik.com/routeros/$version/chr-$version.vmdk.zip",
        # CHR ARM64 not available for v6
        # ISO ARM64 not available for v6
        "https://download.mikrotik.com/routeros/$version/routeros-x86-$version.npk",
        "https://download.mikrotik.com/routeros/$version/mikrotik-$version.iso",
        "https://download.mikrotik.com/routeros/$version/install-image-$version.zip",
        "https://download.mikrotik.com/routeros/$version/all_packages-x86-$version.zip",
        "https://download.mikrotik.com/routeros/$version/all_packages-arm64-$version.zip",
        "https://download.mikrotik.com/routeros/$version/routeros-arm-$version.npk",
        "https://download.mikrotik.com/routeros/$version/all_packages-arm-$version.zip",
        "https://download.mikrotik.com/routeros/$version/routeros-mipsbe-$version.npk",
        "https://download.mikrotik.com/routeros/$version/all_packages-mipsbe-$version.zip",
        "https://download.mikrotik.com/routeros/$version/routeros-mmips-$version.npk",
        "https://download.mikrotik.com/routeros/$version/all_packages-mmips-$version.zip",
        "https://download.mikrotik.com/routeros/$version/routeros-powerpc-$version.npk",
        "https://download.mikrotik.com/routeros/$version/all_packages-ppc-$version.zip",
        "https://download.mikrotik.com/routeros/$version/routeros-smips-$version.npk",
        "https://download.mikrotik.com/routeros/$version/all_packages-smips-$version.zip",
        "https://download.mikrotik.com/routeros/$version/routeros-tile-$version.npk",
        "https://download.mikrotik.com/routeros/$version/all_packages-tile-$version.zip",
        "https://download.mikrotik.com/routeros/$version/netinstall64-$version.zip",
        "https://download.mikrotik.com/routeros/$version/netinstall-$version.zip",
        "https://download.mikrotik.com/routeros/$version/netinstall-$version.tar.gz",
        "https://download.mikrotik.com/routeros/$version/mikrotik.mib",
        "https://download.mikrotik.com/routeros/$version/dude-install-$version.exe",
        "https://download.mikrotik.com/routeros/$version/dude-install-$version.exe",
        "https://download.mikrotik.com/routeros/$version/btest.exe",
        "https://download.mikrotik.com/routeros/$version/flashfig.exe"
    )
} elseif ($version -match '^7') {
    Write-Host "Detected RouterOS v7, using full v7 URL list."
    $urls = @(
        "https://download.mikrotik.com/routeros/$version/chr-$version.img.zip",
        "https://download.mikrotik.com/routeros/$version/chr-$version.vdi.zip",
        "https://download.mikrotik.com/routeros/$version/chr-$version.vhdx.zip",
        "https://download.mikrotik.com/routeros/$version/chr-$version.ova",
        "https://download.mikrotik.com/routeros/$version/chr-$version.vhd.zip",
        "https://download.mikrotik.com/routeros/$version/chr-$version.vmdk.zip",
        "https://download.mikrotik.com/routeros/$version/chr-$version-arm64.img.zip",
        "https://download.mikrotik.com/routeros/$version/chr-$version-arm64.vdi.zip",
        "https://download.mikrotik.com/routeros/$version/routeros-$version.npk",
        "https://download.mikrotik.com/routeros/$version/mikrotik-$version.iso",
        "https://download.mikrotik.com/routeros/$version/install-image-$version.zip",
        "https://download.mikrotik.com/routeros/$version/all_packages-x86-$version.zip",
        "https://download.mikrotik.com/routeros/$version/routeros-$version-arm64.npk"
        "https://download.mikrotik.com/routeros/$version/mikrotik-$version-arm64.iso",
        "https://download.mikrotik.com/routeros/$version/all_packages-arm64-$version.zip",
        "https://download.mikrotik.com/routeros/$version/routeros-$version-arm.npk",
        "https://download.mikrotik.com/routeros/$version/all_packages-arm-$version.zip",
        "https://download.mikrotik.com/routeros/$version/routeros-$version-mipsbe.npk",
        "https://download.mikrotik.com/routeros/$version/all_packages-mipsbe-$version.zip",
        "https://download.mikrotik.com/routeros/$version/routeros-$version-mmips.npk",
        "https://download.mikrotik.com/routeros/$version/all_packages-mmips-$version.zip",
        "https://download.mikrotik.com/routeros/$version/routeros-$version-ppc.npk",
        "https://download.mikrotik.com/routeros/$version/all_packages-ppc-$version.zip",
        "https://download.mikrotik.com/routeros/$version/routeros-$version-smips.npk",
        "https://download.mikrotik.com/routeros/$version/all_packages-smips-$version.zip",
        "https://download.mikrotik.com/routeros/$version/routeros-$version-tile.npk",
        "https://download.mikrotik.com/routeros/$version/all_packages-tile-$version.zip",
        "https://download.mikrotik.com/routeros/$version/netinstall64-$version.zip",
        "https://download.mikrotik.com/routeros/$version/netinstall-$version.zip",
        "https://download.mikrotik.com/routeros/$version/netinstall-$version.tar.gz",
        "https://download.mikrotik.com/routeros/$version/mikrotik.mib",
        "https://download.mikrotik.com/routeros/$version/dude-install-$version.exe",
        "https://download.mikrotik.com/routeros/$version/dude-install-$version.exe",
        "https://download.mikrotik.com/routeros/$version/btest.exe",
        "https://download.mikrotik.com/routeros/$version/flashfig.exe"
    )
} else {
    Write-Host "Error: Only RouterOS major versions 6 or 7 are supported."
    exit 1
}

$total = $urls.Count
$success = 0
$fail = 0

Write-Host "Starting downloads for version '$version' to destination '$dest'.."
Write-Host "Total files to download: $total"

for ($i=0; $i -lt $total; $i++) {
    $url = $urls[$i]
    $fname = Split-Path $url -Leaf
    Write-Host "[$($i+1)/$total] Downloading $fname .."
    try {
        Invoke-WebRequest -Uri $url -OutFile (Join-Path $dest $fname) -ErrorAction Stop
        Write-Host "    Done: $fname"
        $success++
    } catch {
        Write-Host "    Failed: $fname"
        $fail++
    }
}

Write-Host "`nDownload summary:"
Write-Host "---------------------------"
Write-Host "Total files listed         : $total"
Write-Host "Successfully downloaded    : $success"
Write-Host "Failed downloads           : $fail"
if ($fail -gt 0) {
    Write-Host "WARNING: There were $fail failed downloads."
}
Write-Host "All downloads completed."

