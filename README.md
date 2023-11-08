# Invoke-LinkChecker.ps1

一個用於執行 [linkchecker](https://linkchecker.github.io/linkchecker/) 命令的 PowerShell 函式，使用指定的參數。

## 安裝

1. 先安裝 Python 3.8 以上版本

2. 安裝 linkchecker 工具

    ```sh
    pip3 install linkchecker
    ```

3. 安裝 `Invoke-LinkChecker.ps1` 腳本

    ```ps1
    Install-Script -Name Invoke-LinkChecker
    ```

## 執行

```ps1
Invoke-LinkChecker -Url "https://example.com" -v -NoRobots
```
