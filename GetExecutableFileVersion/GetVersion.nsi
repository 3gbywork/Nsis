!include "FileFunc.nsh"

!define ExeFileName "GetVersion.exe"
!define Version     "1.2.7.666"
!define CompanyName "3gbywork"
!define Usage       "Usage: ${ExeFileName} /ExecFile[xxx.exe or xxx.dll] /OutFile[xxx.*]"

OutFile "${ExeFileName}"

SilentInstall silent

# 版本信息
VIProductVersion "${Version}"
VIAddVersionKey "ProductVersion" "${Version}"
# VIAddVersionKey "Comments" "获取可执行文件的版本号"
VIAddVersionKey "CompanyName" "${CompanyName}"
VIAddVersionKey "FileDescription" "获取可执行文件的版本号"
VIAddVersionKey "FileVersion" "${Version}"
VIAddVersionKey "LegalCopyright" "Copyright © 2017"
VIAddVersionKey "LegalTrademarks" "${CompanyName} Inc."
VIAddVersionKey "ProductName" "什么版本？"

Var CmdParameters
Var SrcFilePath
Var DstFilePath

Section "GetExecutableFileVersion"
    # your code here
    ClearErrors
    # 获取命令行参数
    ${GetParameters} $CmdParameters
    StrCmp $CmdParameters "" HowToUse
    # 解析输入文件路径
    ${GetOptions} "$CmdParameters" "/ExecFile" $SrcFilePath
    IfErrors SrcNotSet
    # 解析输出文件路径
    ${GetOptions} "$CmdParameters" "/OutFile" $DstFilePath
    IfErrors DstNotSet

    ${GetFileVersion} "$SrcFilePath" $R1
    IfErrors CantGetVersion

    FileOpen $R2 "$DstFilePath" w
        FileWrite $R2 '!define Version "$R1"'
        IfErrors WriteFileFailed End
    FileClose $R2

    HowToUse:
        MessageBox MB_OK "${Usage}"
        Goto End

    SrcNotSet:
        MessageBox MB_OK "/ExecFile required.$\r$\n ${Usage}"
        Goto End

    DstNotSet:
        MessageBox MB_OK "/OutFile required.$\r$\n ${Usage}"
        Goto End

    CantGetVersion:
        MessageBox MB_OK "$SrcFilePath doesn't exist or doesn't contain version information." 
        Goto End

    WriteFileFailed:
        MessageBox MB_OK "write $DstFilePath failed."
        Goto End
    
    End:
SectionEnd