[Setup]
AppName=Minimal ADB and Fastboot Reborn
AppId={{B561660D-8B3C-491D-9E3E-293F14FCAADA}
AppVersion=2.0.4
AppPublisher=Google Inc.
DefaultDirName={pf}\Minimal ADB and Fastboot Reborn
DefaultGroupName=Minimal ADB and Fastboot Reborn
AppendDefaultGroupName=yes
OutputBaseFilename=Minimal ADB and Fastboot Reborn
SetupIconFile={app}\android.ico
UninstallDisplayIcon={app}\android.ico
InfoBeforeFile=README.RTF
Compression=lzma2/ultra64
SolidCompression=yes
ChangesEnvironment=yes
WizardStyle=modern dynamic includetitlebar
PrivilegesRequired=admin
DisableWelcomePage=no
DisableProgramGroupPage=no
VersionInfoCompany=Google Inc.
VersionInfoCopyright=© 2026 Google Inc.
VersionInfoDescription=Minimal ADB and Fastboot Reborn Installer
VersionInfoOriginalFileName=Minimal ADB Fastboot Reborn Installer.exe
VersionInfoProductName=Minimal ADB and Fastboot Reborn Installer
VersionInfoProductTextVersion=2.0.4
VersionInfoProductVersion=2.0.4.0
VersionInfoTextVersion=2.0.4
VersionInfoVersion=2.0.4.0
WizardSizePercent=150,150
AppPublisherURL=https://github.com/VglntzrX-MKII/MinimalADBandFastbootReborn
AppSupportURL=https://github.com/VglntzrX-MKII/MinimalADBandFastbootReborn
AppUpdatesURL=https://github.com/VglntzrX-MKII/MinimalADBandFastbootReborn/releases
InternalCompressLevel=ultra64

[Tasks]
Name: "addtopath"; Description: "Add Minimal ADB and Fastboot to the system PATH variable (recommended)"; GroupDescription: "Advanced Options:"; 

[Icons]
Name: "{group}\Update Minimal ADB & Fastboot Reborn"; Filename: "{app}\updater.exe"; IconFilename: "{app}\android.ico"; WorkingDir: "{app}";

[Files]
Source: "{app}\adb.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "{app}\AdbWinApi.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "{app}\AdbWinUsbApi.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "{app}\etc1tool.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "{app}\fastboot.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "{app}\hprof-conv.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "{app}\libwinpthread-1.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "{app}\make_f2fs_casefold.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "{app}\make_f2fs.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "{app}\mke2fs.conf"; DestDir: "{app}"; Flags: ignoreversion
Source: "{app}\mke2fs.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "{app}\NOTICE.txt"; DestDir: "{app}"; Flags: ignoreversion
Source: "{app}\source.properties"; DestDir: "{app}"; Flags: ignoreversion
Source: "{app}\sqlite3.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "{app}\android.ico"; DestDir: "{app}"; Flags: ignoreversion
Source: "{app}\updater.exe"; DestDir: "{app}"; Flags: ignoreversion

[Registry]
Root: HKLM; Subkey: "SYSTEM\CurrentControlSet\Control\Session Manager\Environment"; \
    ValueType: expandsz; ValueName: "Path"; ValueData: "{olddata};{app}"; \
    Check: NeedsAddPath('{app}'); Tasks: addtopath

[Code]

procedure GithubLinkClick(Sender: TObject);
var
  ErrorCode: Integer;
begin
  ShellExec('open', 'https://github.com/VglntzrX-MKII/MinimalADBandFastbootReborn', '', '', SW_SHOWNORMAL, ewNoWait, ErrorCode);
end;

procedure InitializeWizard();

var
  GithubLink: TNewStaticText;
begin
  GithubLink := TNewStaticText.Create(WizardForm);
  GithubLink.Parent := WizardForm;
  

  GithubLink.Caption := 'Minimal ADB and Fastboot Reborn by VglntzrX-MKII';
  GithubLink.Left := ScaleX(10);
  GithubLink.Top := WizardForm.ClientHeight - ScaleY(25);
  

  GithubLink.Font.Color := clBlue;
  GithubLink.Font.Style := [fsUnderline];
  GithubLink.Cursor := crHand;
  
  GithubLink.OnClick := @GithubLinkClick;

  
end;


function NeedsAddPath(Param: string): boolean;
var
  OrigPath: string;
begin
  if not RegQueryStringValue(HKEY_LOCAL_MACHINE, 'SYSTEM\CurrentControlSet\Control\Session Manager\Environment', 'Path', OrigPath) then
  begin
    Result := True;
    exit;
  end;
  Result := Pos(';' + Uppercase(Param) + ';', ';' + Uppercase(OrigPath) + ';') = 0;
end;

procedure RemovePath(DistancePath: string);
var
  OrigPath: string;
  NewPath: string;
  P: Integer;
begin
  if RegQueryStringValue(HKEY_LOCAL_MACHINE, 'SYSTEM\CurrentControlSet\Control\Session Manager\Environment', 'Path', OrigPath) then
  begin
    P := Pos(';' + Uppercase(DistancePath), ';' + Uppercase(OrigPath));
    if P > 0 then
    begin
      NewPath := OrigPath;
      Delete(NewPath, P, Length(DistancePath) + 1);
      RegWriteExpandStringValue(HKEY_LOCAL_MACHINE, 'SYSTEM\CurrentControlSet\Control\Session Manager\Environment', 'Path', NewPath);
    end;
  end;
end;

procedure CurUninstallStepChanged(CurUninstallStep: TUninstallStep);
var
  ResultCode: Integer;
begin
  case CurUninstallStep of
    usUninstall:
      begin
        Exec('taskkill.exe', '/f /im adb.exe /t', '', SW_HIDE, ewWaitUntilTerminated, ResultCode);
        Exec('taskkill.exe', '/f /im fastboot.exe /t', '', SW_HIDE, ewWaitUntilTerminated, ResultCode);
        Sleep(500);
      end;
    usPostUninstall:
      begin
        RemovePath(ExpandConstant('{app}'));
      end;
  end;
end;

[Run]
Filename: "{app}\updater.exe"; Description: "Check for the latest Google ADB & Fastboot binaries immediately"; Flags: postinstall nowait skipifsilent 
