
<#PSScriptInfo

.VERSION 1.0.3

.GUID 4af1455f-a896-4209-a17c-b8750b80859c

.AUTHOR Will 保哥

.COMPANYNAME Duotify Inc.

.COPYRIGHT Copyright (c) 2023 Will 保哥

.TAGS PowerShell, LinkChecker

.LICENSEURI https://choosealicense.com/licenses/mit/

.PROJECTURI https://github.com/doggy8088/Invoke-LinkChecker-PS1

.ICONURI https://raw.githubusercontent.com/doggy8088/Invoke-LinkChecker-PS1/main/icon.jpg

.EXTERNALMODULEDEPENDENCIES

.REQUIREDSCRIPTS

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES
    - 1.0.3
        - Update DESCRIPTION.

    - 1.0.2
        - Add more description on the script.

    - 1.0.1
        - Change `iconUrl` to GitHub Repo itself.

    - 1.0.0
        - Initial release.

.PRIVATEDATA

#>

<#

.SYNOPSIS
    一個用於執行 linkchecker 命令的 PowerShell 函式，使用指定的參數。

.DESCRIPTION
    一個用於執行 linkchecker 命令的 PowerShell 函式，使用指定的參數。

    安裝步驟

    1. 先安裝 Python 3.8 以上版本

    2. 安裝 linkchecker 工具

        pip3 install linkchecker

    3. 安裝 `Invoke-LinkChecker.ps1` 腳本

        Install-Script -Name Invoke-LinkChecker

    4. 執行

        Invoke-LinkChecker -Url "https://example.com" -v -NoRobots

    GitHub Repo: https://github.com/doggy8088/Invoke-LinkChecker-PS1

.PARAMETER Url
    要檢查的 URL。

.PARAMETER Config
    使用 FILENAME 作為配置文件。

.PARAMETER Threads
    生成不超過給定數量的執行緒。

.PARAMETER Version
    顯示版本並退出。

.PARAMETER ListPlugins
    顯示可用的檢查外掛並退出。

# .PARAMETER Stdin
#     從 stdin 讀取空格分隔的要檢查的 URL 列表。

.PARAMETER DebugLogger
    為給定的記錄器偵錯輸出。選項：'cmdline'，'checking'，'cache'，'thread'，'plugin'，'all'。

.PARAMETER FileOutput
    輸出到文件 linkchecker-out.TYPE，$XDG_DATA_HOME/linkchecker/failures 用於 'failures' 輸出，或者指定的 FILENAME。

.PARAMETER NoStatus
    不顯示檢查狀態訊息。

.PARAMETER NoWarnings
    不記錄警告。

.PARAMETER Output
    指定輸出格式為 'csv'，'xml'，'dot'，'failures'，'gml'，'gxml'，'html'，'none'，'sitemap'，'sql'，'text'。

.PARAMETER Quiet
    靜音操作，'-o none' 的別名。

.PARAMETER LogAll
    記錄所有 URL。

.PARAMETER CookieFile
    讀取包含初始 cookie 資料的文件。

.PARAMETER NoRobots
    禁用 robots.txt 檢查。

.PARAMETER CheckExtern
    檢查外部 URL。

.PARAMETER IgnoreUrl
    只檢查與給定正則表達式匹配的 URL 的語法。

.PARAMETER NoFollowUrl
    檢查但不遞迴進入與給定正則表達式匹配的 URL。

.PARAMETER Password
    從控制台讀取密碼並用於 HTTP 和 FTP 授權。

.PARAMETER RecursionLevel
    遞迴檢查所有連結，直至給定深度。

.PARAMETER Timeout
    設定連接嘗試的超時時間（秒）。

.PARAMETER User
    嘗試用於 HTTP 和 FTP 授權的給定用戶名。

.PARAMETER UserAgent
    指定要發送到 HTTP 伺服器的 User-Agent 字串。

.EXAMPLE
    Invoke-LinkChecker -Url "https://example.com" -v -NoRobots
#>
[CmdletBinding()]
param (
    [Parameter(HelpMessage = "要檢查的 URL。")]
    [string]$Url,

    [Parameter(HelpMessage = "使用 FILENAME 作為配置文件。")]
    [string]$Config,

    [Parameter(HelpMessage = "生成不超過給定數量的執行緒。")]
    [int]$Threads,

    [Parameter(HelpMessage = "顯示版本並退出。")]
    [switch]$Version,

    [Parameter(HelpMessage = "顯示可用的檢查外掛並退出。")]
    [switch]$ListPlugins,

    # [Parameter(HelpMessage = "從 stdin 讀取空格分隔的要檢查的 URL 列表。")]
    # [switch]$Stdin,

    [Parameter(HelpMessage = "為給定的記錄器偵錯輸出。選項：'cmdline'，'checking'，'cache'，'thread'，'plugin'，'all'")]
    [Alias('D')]
    [ValidateSet('cmdline', 'checking', 'cache', 'thread', 'plugin', 'all')]
    [string]$DebugLogger,

    [Parameter(HelpMessage = "輸出到文件 linkchecker-out.TYPE，`$XDG_DATA_HOME/linkchecker/failures 用於錯誤時的輸出，或者指定的 FILENAME。")]
    [Alias('F')]
    [string]$FileOutput,

    [Parameter(HelpMessage = "不顯示檢查狀態訊息。")]
    [switch]$NoStatus,

    [Parameter(HelpMessage = "不記錄警告。")]
    [switch]$NoWarnings,

    [Parameter(HelpMessage = "指定輸出格式為 'csv'，'xml'，'dot'，'failures'，'gml'，'gxml'，'html'，'none'，'sitemap'，'sql'，'text'。")]
    [ValidateSet('csv', 'xml', 'dot', 'failures', 'gml', 'gxml', 'html', 'none', 'sitemap', 'sql', 'text')]
    [Alias('o')]
    [string]$Output,

    [Parameter(HelpMessage = "不輸出任何訊息到 Console，不可以跟 -Output 一起使用。")]
    [Alias('q')]
    [switch]$Quiet,

    [Parameter(HelpMessage = "記錄所有 URL，包含 HTTP 200 回應的連結。")]
    [Alias('v')]
    [switch]$LogAll,

    [Parameter(HelpMessage = "讀取包含初始 cookie 資料的文件。")]
    [string]$CookieFile,

    [Parameter(HelpMessage = "忽略 robots.txt 限制。")]
    [switch]$NoRobots,

    [Parameter(HelpMessage = "檢查外部 URL。")]
    [switch]$CheckExtern,

    [Parameter(HelpMessage = "只檢查與給定正則表達式匹配的 URL 的語法。")]
    [string]$IgnoreUrl,

    [Parameter(HelpMessage = "檢查但不遞迴進入與給定正則表達式匹配的 URL。")]
    [string]$NoFollowUrl,

    [Parameter(HelpMessage = "從控制台讀取密碼並用於 HTTP 和 FTP 授權。")]
    [Alias('p')]
    [switch]$Password,

    [Parameter(HelpMessage = "遞迴檢查所有連結，直至給定深度。")]
    [Alias('r')]
    [int]$RecursionLevel = 1,

    [Parameter(HelpMessage = "設定連接嘗試的超時時間（秒）。")]
    [int]$Timeout,

    [Parameter(HelpMessage = "嘗試用於 HTTP 和 FTP 授權的給定使用者名稱。")]
    [Alias('u')]
    [string]$User,

    [Parameter(HelpMessage = "指定要發送到 HTTP 伺服器的 User-Agent 字串。")]
    [string]$UserAgent
)

$arguments = @()

if ($Config) { $arguments += "-f", $Config }
if ($Threads) { $arguments += "-t", $Threads }
if ($Version) { $arguments += "-V" }
if ($ListPlugins) { $arguments += "--list-plugins" }

# if ($Stdin) { $arguments += "--stdin" }

if ($DebugLogger) { $arguments += "-D", $DebugLogger }
if ($FileOutput) { $arguments += "-F", $FileOutput }

if ($NoStatus) { $arguments += "--no-status" }
if ($NoWarnings) { $arguments += "--no-warnings" }

if ($Output) { $arguments += "-o", $Output }
if ($Quiet) { $arguments += "-o none" }

if ($LogAll) { $arguments += "--verbose" }
if ($CookieFile) { $arguments += "--cookiefile", $CookieFile }
if ($NoRobots) { $arguments += "--no-robots" }
if ($CheckExtern) { $arguments += "--check-extern" }
if ($IgnoreUrl) { $arguments += "--ignore-url", $IgnoreUrl }
if ($NoFollowUrl) { $arguments += "--no-follow-url", $NoFollowUrl }
if ($Password) { $arguments += "-p" }
if ($RecursionLevel) { $arguments += "-r", $RecursionLevel }
if ($Timeout) { $arguments += "--timeout", $Timeout }
if ($User) { $arguments += "-u", $User }
if ($UserAgent) { $arguments += "--user-agent", $UserAgent }

if ($Url) { $arguments += $Url }

& "linkchecker.exe" $arguments
