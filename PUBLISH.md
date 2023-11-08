# Publish Notes

1. Create a script with metadata

    ```ps1
    Import-Module PowerShellGet
    ```

    ```ps1
    New-ScriptFileInfo `
        -Path .\Invoke-LinkChecker-Publish.ps1 `
        -CompanyName "Duotify Inc." `
        -Version "1.0.0" `
        -Author "Will 保哥" `
        -IconUri https://github.com/doggy8088/Learn-Git-in-30-days/assets/88981/5b488410-c647-433d-9135-fbd409a11254 `
        -Description "一個用於執行 linkchecker 命令的 PowerShell 函式，使用指定的參數 。" `
        -Copyright "Copyright (c) 2023 Will 保哥" `
        -Tags "PowerShell, LinkChecker" `
        -LicenseUri "https://choosealicense.com/licenses/mit/" `
        -ProjectUri "https://github.com/doggy8088/Invoke-LinkChecker-PS1" `
        -ReleaseNotes "Initial release" `
        -Force
    ```

2. Publish Script

    ```ps1
    Publish-Script `
        -Path .\Invoke-LinkChecker.ps1 `
        -NuGetApiKey "<YourNuGetApiKey>"
    ```
