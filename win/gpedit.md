Windows Group Policies
======================

Administrative Policies on Windows are stored in the system registry,
but are normally changed not directly with `regedit` but instead the
Group Policy Editor, `gpedit.msc`. See below for example settings. This
is used to change, e.g., the [auto lock setting][autolock].


Common Settings
---------------

- `Computer Configuration/Windows Settings/Security Settings/Local
  Policies/Security Options/Interactive logon: Machine inactivity limit`

Installation on Windows Home Editions
-------------------------------------

This is not normally installed on Windows 10 Home, see:
- [How To Enable Group Policy Editor (gpedit.msc) In Windows 10 Home
  Edition][itechtics] (old solution; may not always work)
- [Enable Group Policy Editor in Windows Home using
  Powershell][gppowershell] (apparently works better)
- [Policy Plus the best alternative to Windows Group Policy
  Editor][policyplus]

Installing it may not enable policies, according to one comment above
on Policy Plus, "Most GPO policies in W10 are now restricted by Product
Policy Licenses" (though some claim a reboot will make a policy start
working on Home editions).

The batch file one downloads and runs for the "Powershell" article
above doesn't actually appear to use Powershell. It uses standard
Windows tools to install the missing packages from MS:

    @echo off 
    pushd "%~dp0" 

    dir /b %SystemRoot%\servicing\Packages\Microsoft-Windows-GroupPolicy-ClientExtensions-Package~3*.mum >List.txt 
    dir /b %SystemRoot%\servicing\Packages\Microsoft-Windows-GroupPolicy-ClientTools-Package~3*.mum >>List.txt 

    for /f %%i in ('findstr /i . List.txt 2^>nul') do dism /online /norestart /add-package:"%SystemRoot%\servicing\Packages\%%i" 
    pause



[autolock]: https://www.tenforums.com/user-accounts-family-safety/29025-screen-wont-auto-lock.html
[gppowershell]: https://www.itechtics.com/easily-enable-group-policy-editor-gpedit-msc-in-windows-10-home-edition/
[itechtics]: https://www.itechtics.com/enable-gpedit-windows-10-home/
[policyplus]: https://www.itechtics.com/best-group-policy-editor-gpedit-msc-alternative-for-windows/
