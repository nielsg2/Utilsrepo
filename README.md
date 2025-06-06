# Utilsrepo 🚀  
_A collection of PowerShell utilities for system management and optimization._

## 📌 Overview  
Utilsrepo provides **PowerShell scripts** designed for managing system configurations, optimizing PATH variables, and handling disk operations.  

## 🔧 Included Scripts  

| Script Name                    | Description |
|--------------------------------|-------------|
| **BackupPath.ps1**             | Saves the current system PATH to a backup file for restoration. |
| **CentralizePaths.ps1**        | Optimizes PATH variables by consolidating redundant entries. |
| **ComparePATHtoBackup.ps1**    | Compares current PATH settings against a saved backup to detect changes. |
| **ListVolumesAndSetDisksOffline.ps1** | Identifies disk volumes and manages offline settings. |
| **RestorePath.ps1**            | Restores the system PATH from a backup file. |
| **SetDisksOfflineIfEmptyVolumes.ps1** | Sets disks offline if they contain empty volumes. |
| **SetEmptyDrivesOffline.ps1**  | Detects and disables drives that are empty. |
| **SetOfflineDisksOnline.ps1**  | Brings offline disks back online. |
| **SimulateOutput.ps1**         | Runs a **non-destructive** simulation of PATH optimization, creating symbolic links in a dedicated directory (`C:\OptimizedPaths`) without modifying the actual PATH. |

## 💾 Installation  
1️⃣ Clone the repository:
   ```powershell
   git clone https://github.com/nielsg2/Utilsrepo.git
   cd Utilsrepo