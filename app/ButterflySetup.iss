; Script generated by the Inno Setup Script Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

#define MyAppName "Butterfly"
#ifndef MyAppVersion
#define MyAppVersion "1.0"
#endif
#define MyAppPublisher "LinwoodCloud"
#define MyAppURL "https://www.linwood.dev"
#define MyAppExeName "butterfly.exe" 
#define BaseDirRelease "build\windows\runner\Release"
#define RunnerSourceDir "windows\runner"


[Setup]
; NOTE: The value of AppId uniquely identifies this application. Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{966CE504-4AA5-49C7-A63B-74BD6C073E5B}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
;AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={autopf}\{#MyAppPublisher}\{#MyAppName}  
DefaultGroupName={#MyAppPublisher}\{#MyAppName}
DisableProgramGroupPage=yes
LicenseFile=..\LICENSE
; Uncomment the following line to run in non administrative install mode (install for current user only.)
;PrivilegesRequired=lowest
PrivilegesRequiredOverridesAllowed=
OutputDir=build\windows
OutputBaseFilename={#MyAppName}-Setup
SetupIconFile={#RunnerSourceDir}\resources\app_icon.ico
Compression=lzma
SolidCompression=yes
WizardStyle=modern
Uninstallable=yes
ChangesAssociations=yes

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"
Name: "french"; MessagesFile: "compiler:Languages\French.isl"
Name: "german"; MessagesFile: "compiler:Languages\German.isl"

[Tasks]     
Name: "desktopicon"; Description: "Create a Desktop shortcut"
Name: "startmenu"; Description: "Create a Start Menu entry"         
Name: "bfly"; Description: "Add Butterfly file association"


[Files]
Source: "{#BaseDirRelease}\{#MyAppExeName}"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#BaseDirRelease}\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
; NOTE: Don't use "Flags: ignoreversion" on any shared system files



[Registry]
Root: HKCR; Subkey: ".bfly"; ValueType: string; ValueName: ""; ValueData: "{#MyAppName}-File"; Tasks: bfly; Flags: uninsdeletevalue
Root: HKCR; Subkey: "{#MyAppName}-File"; ValueType: string; ValueName: ""; ValueData: "{#MyAppName}-File"; Tasks: bfly; Flags: uninsdeletekey
Root: HKCR; Subkey: "{#MyAppName}-File\DefaultIcon"; ValueType: string; ValueName: ""; ValueData: "{app}\{#MyAppExeName},0"
Root: HKCR; Subkey: "{#MyAppName}-File\shell\open\command"; ValueType: string; ValueName: ""; ValueData: """{app}\{#MyAppExeName}"" ""%1"""


[Icons]
Name: "{group}\{cm:UninstallProgram,{#MyAppName}}"; Filename: "{uninstallexe}"

Name: "{group}\Visit Website"; Filename: "https://www.linwood.dev/"
Name: "{group}\Butterfly Documentation"; Filename: "https://docs.butterfly.linwood.dev/"
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent
