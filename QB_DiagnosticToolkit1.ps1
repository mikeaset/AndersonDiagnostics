# QB_DiagnosticToolkit.ps1
# Anderson Urgent Computer Care – Diagnostic Toolkit v1.0

param (
    [switch]$SilentMode = $false
)

# ========== CONFIG ==========
$ReportPath = "$env:USERPROFILE\Desktop\Anderson_QBReport_$(Get-Date -Format 'yyyyMMdd').html"
$LogPath = "$env:USERPROFILE\Desktop\Anderson_DiagnosticLog_$(Get-Date -Format 'yyyyMMdd').txt"
$AlertLog = "$env:USERPROFILE\Desktop\Anderson_CriticalAlerts.log"

# ========== MODULES ==========

function Check-QBService {
    $service = Get-Service -Name "QBCFMonitorService" -ErrorAction SilentlyContinue
    if ($null -eq $service) {
        Add-Content $AlertLog "❌ QuickBooks Service Missing"
        return "<li style='color:red;'>QuickBooks DB Service: <strong>Not Found</strong></li>"
    }
    if ($service.Status -ne "Running") {
        Add-Content $AlertLog "⚠️ QuickBooks Service Not Running"
        return "<li style='color:orange;'>QuickBooks DB Service: <strong>Stopped</strong></li>"
    }
    return "<li style='color:green;'>QuickBooks DB Service: Running</li>"
}

function Scan-QBPorts {
    $ports = 55333..55338
    $results = foreach ($p in $ports) {
        $test = Test-NetConnection -Port $p -ComputerName "localhost"
        if ($test.TcpTestSucceeded) {
            "<li style='color:green;'>Port $p: Open</li>"
        } else {
            Add-Content $AlertLog "❌ Port $p blocked"
            "<li style='color:red;'>Port $p: Blocked</li>"
        }
    }
    return $results -join "`n"
}

function Audit-Antivirus {
    $products = Get-CimInstance -Namespace root\SecurityCenter2 -ClassName AntiVirusProduct
    if ($products.Count -eq 0) {
        Add-Content $AlertLog "❌ No antivirus detected"
        return "<li style='color:red;'>Antivirus: <strong>Not Found</strong></li>"
    }
    return "<li style='color:green;'>Antivirus Installed: $($products.displayName)</li>"
}

function Check-CompanyFileAccess {
    $paths = @("C:\Users\Public\Documents\Intuit", "C:\ProgramData\Intuit")
    $results = foreach ($p in $paths) {
        if (Test-Path $p) {
            "<li style='color:green;'>Access: $p</li>"
        } else {
            Add-Content $AlertLog "⚠️ Missing Access Path: $p"
            "<li style='color:orange;'>Missing Path: $p</li>"
        }
    }
    return $results -join "`n"
}

function System-HealthCheck {
    $disk = Get-WmiObject Win32_LogicalDisk -Filter "DriveType=3"
    $cpu = Get-WmiObject Win32_Processor
    $ram = (Get-WmiObject Win32_OperatingSystem).FreePhysicalMemory

    $diskFree = [math]::Round(($disk.FreeSpace / 1GB),2)
    $ramGB = [math]::Round($ram / 1MB,2)

    Add-Content $LogPath "Disk Free: $diskFree GB"
    Add-Content $LogPath "RAM Free: $ramGB GB"

    return @"
<li>CPU: $($cpu.Name)</li>
<li>Disk Free: $diskFree GB</li>
<li>RAM Free: $ramGB GB</li>
"@
}

# ========== REPORT BUILDER ==========
function Generate-HTMLReport {
    $html = @"
<html>
<head><title>Diagnostic Report – Anderson Urgent Computer Care</title></head>
<body style='font-family:sans-serif'>
<h2 style='color:#2E8B57;'>QuickBooks Diagnostic Summary</h2>
<ul>
$(Check-QBService)
$(Scan-QBPorts)
$(Audit-Antivirus)
$(Check-CompanyFileAccess)
$(System-HealthCheck)
</ul>
<footer style='margin-top:30px;font-size:small;color:#888;'>
Prepared by Anderson Urgent Computer Care | Powered by Diagnostic Toolkit v1.0
</footer>
</body>
</html>
"@
    $html | Out-File $ReportPath
    if (-not $SilentMode) {
        Start-Process $ReportPath
    }
}

# ========== EXECUTE ==========
Generate-HTMLReport
Add-Content $LogPath "Diagnostics completed: $(Get-Date)"
if (-not $SilentMode) {
    [System.Windows.Forms.MessageBox]::Show("Diagnostics completed.","Toolkit")
}
