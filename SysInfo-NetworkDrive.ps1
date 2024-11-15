# Liste de TOUTES les varriables pour TOUT prendre sur le PC
$computerSystem = Get-WmiObject CIM_ComputerSystem
$computerBIOS = Get-WmiObject CIM_BIOSElement
$computerOS = Get-CimInstance CIM_OperatingSystem
$computerCPU = Get-WmiObject CIM_Processor
$computerHDD = Get-WmiObject Win32_LogicalDisk -Filter "DeviceID = 'C:'"
$Disk = Get-Disk -Partition (Get-Partition | Where-Object { $_.DriveLetter -eq "C" })
$DiskInfo = Get-PhysicalDisk | Where-Object { $_.FriendlyName -eq $Disk.FriendlyName }
$whoami = whoami
$AV = Get-WmiObject -Namespace "root\SecurityCenter2" -Class AntiVirusProduct | Select-Object -ExpandProperty displayName
$date = Get-Date -Format "dd-MM-yyyy"
$networkShare = "\\SERVER\SHARE"

#Clear de la fenetre PowerSHell
Clear-Host

Write-Host "Information copié"

function Sysinfo {
    $info = @(
        "Nom du PC: " + $computerSystem.Name
        "Fabricant: " + $computerSystem.Manufacturer
        "Model: " + $computerSystem.Model
        "Numero de serie: " + $computerBIOS.SerialNumber
        "OS: " + $computerOS.Caption
        "Service Pack: " + $computerOS.ServicePackMajorVersion
        "CPU: " + $computerCPU.Name
        "RAM: " + "{0:N2}" -f ($computerSystem.TotalPhysicalMemory/1GB) + "GB"
        "Type de disque: " + $DiskInfo.MediaType
        "Taille de C: "  + "{0:N2}" -f ($computerHDD.Size/1GB) + "GB"
        "Espace disque: " + "{0:P2}" -f ($computerHDD.FreeSpace/$computerHDD.Size) + " libre (" + "{0:N2}" -f ($computerHDD.FreeSpace/1GB) + "GB)"
        "Dernier reboot: " + $computerOS.LastBootUpTime
        "Utilisateur: " + $whoami
        "Antivirus: " + $AV
        "Localisation: "
        "-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+"
    )
    $info -join "`n"
}

# Rename du fichier avec le nom du PC et de la date
$outputFile = Join-Path $networkShare ($computerSystem.Name + "_" + $date + ".txt")

# Envoie des infos vers le fichiers txt
Sysinfo | Out-File $outputFile

# Print completion message in green text
Write-Host "Info enregistré vers $outputFile"

# Clear de la fenetre PowerShell
Clear-Host

Write-Host "Fin du script!"

# Ouvrir le txt si besoin
# Start-Process notepad $outputFile
    
