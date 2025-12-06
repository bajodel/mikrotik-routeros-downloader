# Mikrotik RouterOS Downloader

Download Mikrotik RouterOS images and packages for a specific version in one go. Supports both Linux (bash) and Windows (PowerShell), and handles RouterOS v6 and v7.

- Linux: bash script
- Windows: PowerShell script
- RouterOS versions: v6 and v7
- Simple usage: copy/paste or download the script and run with the desired version

## Quick Start

### Linux (bash)

1) Save the bash script locally (e.g., `ros-download.sh`) and make it executable:
```bash
chmod +x ros-download.sh
```

2) Run it with your desired RouterOS version and optional destination folder:
```bash
# Download v7 to a folder named by the version
./ros-download.sh 7.20.6

# Download v6 to a specific folder
./ros-download.sh 6.49.19 /path/to/downloads
```

What it does:
- Validates the version and selects the file list for v6 or v7
- Creates the destination folder if it doesn’t exist
- Downloads files one-by-one and overwrites existing files
- Prints progress and a summary with success/failure counts

Requirements:
- bash
- curl

---

### Windows (PowerShell)

1) Save the PowerShell script locally (e.g., `ros-download.ps1`).

2) Run it from PowerShell with the version and optional destination:
```powershell
# Download v7 to a folder named by the version
powershell -ExecutionPolicy Bypass -File .\ros-download.ps1 7.20.6

# Download v6 to a specific folder
powershell -ExecutionPolicy Bypass -File .\ros-download.ps1 6.49.19 'C:\Downloads\RouterOS-6.49.19'
```

What it does:
- Detects v6 vs v7 and uses the file list for that major version
- Creates the destination folder if needed
- Downloads each file and shows progress with success/failure summary

Requirements:
- PowerShell (Windows 10/11 or PowerShell Core)
- Internet access

---

## Notes

- The scripts are intended for bulk downloading official Mikrotik RouterOS files.
- License: MIT

GitHub repository: [bajodel/mikrotik-routeros-downloader](https://github.com/bajodel/mikrotik-routeros-downloader)
