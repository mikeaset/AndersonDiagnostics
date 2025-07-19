# QuickBooks Diagnostic Toolkit – Anderson Urgent Computer Care

This PowerShell-based toolkit performs targeted diagnostics for QuickBooks Desktop environments. Built for Anderson Urgent Computer Care to streamline field support and reduce troubleshooting time.

---

## 🚀 Features

- Checks QuickBooks Database service status  
- Scans local ports (55333–55338) for connectivity  
- Audits antivirus status  
- Verifies access to QB data paths (`ProgramData`, `Public Documents`)  
- Captures system health: RAM, CPU, disk space  
- Generates branded HTML report + diagnostic log  
- Batch launcher for one-click execution

---

## 🧰 Files Included

- `QB_DiagnosticToolkit.ps1` → Main PowerShell script  
- `Run_Toolkit.bat` → Simple batch launcher  
- `README.md` → This file you're reading

Optional files:
- `alerts.log` → Critical alerts summary  
- `diagnosticlog.txt` → Raw diagnostic output  
- `QBReport_YYYYMMDD.html` → Full diagnostic report

---

## 💼 How to Use

1. Clone or download the repo
2. Double-click `Run_Toolkit.bat`  
   *(or right-click → run as administrator for elevated scan)*  
3. View results in generated `HTML` and `TXT` files on Desktop

---

## 📄 License

This project is proprietary and intended for use by Anderson Urgent Computer Care. Contact [Mike Aset] for licensing or deployment inquiries.

---

## 🔧 Credits

Developed by [Mike Aset] and powered by PowerShell + GitHub.  
Diagnostic logic shaped by real-world QuickBooks troubleshooting.

---
