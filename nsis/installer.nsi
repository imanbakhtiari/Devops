!define PRODUCT_NAME "MyApp"
!define PRODUCT_VERSION "1.0"
!define PRODUCT_PUBLISHER "MyCompany"
!define PRODUCT_DIR_REGKEY "Software\\Microsoft\\Windows\\CurrentVersion\\App Paths\\MyApp.exe"
!define PRODUCT_UNINST_KEY "Software\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\MyApp"

SetCompressor lzma

Name "${PRODUCT_NAME} ${PRODUCT_VERSION}"
OutFile "MyAppInstaller.exe"
InstallDir $PROGRAMFILES\MyApp

Section "Install"
    ; Set the output path to the installation directory
    SetOutPath $INSTDIR

    ; Copy the main application file
    File "/home/iman/workplace/test/nsis/app.exe"

    ; Copy the necessary DLLs
    File "/home/iman/workplace/test/nsis/*.dll"

    ; Create a desktop shortcut
    CreateShortCut "$DESKTOP\\MyApp.lnk" "$INSTDIR\\app.exe"

    ; Create a Start Menu shortcut
    CreateDirectory "$SMPROGRAMS\\MyApp"
    CreateShortCut "$SMPROGRAMS\\MyApp\\MyApp.lnk" "$INSTDIR\\app.exe"

    ; Write the uninstall information to the registry
    WriteRegStr HKLM "${PRODUCT_UNINST_KEY}" "DisplayName" "${PRODUCT_NAME} ${PRODUCT_VERSION}"
    WriteRegStr HKLM "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\\Uninstall.exe"
    WriteUninstaller "$INSTDIR\\Uninstall.exe"
SectionEnd

Section "Uninstall"
    ; Delete the application and DLLs
    Delete "$INSTDIR\\app.exe"
    Delete "$INSTDIR\\*.dll"

    ; Remove the installation directory
    RMDir "$INSTDIR"

    ; Delete the registry keys
    DeleteRegKey HKLM "${PRODUCT_UNINST_KEY}"

    ; Remove the desktop shortcut
    Delete "$DESKTOP\\MyApp.lnk"

    ; Remove the Start Menu shortcut
    Delete "$SMPROGRAMS\\MyApp\\MyApp.lnk"
    RMDir "$SMPROGRAMS\\MyApp"
SectionEnd


