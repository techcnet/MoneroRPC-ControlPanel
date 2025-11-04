unit MainFrm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes,
  Vcl.Controls, Vcl.Forms, Vcl.StdCtrls, System.IniFiles, Vcl.ExtCtrls;

type
  TMainForm = class(TForm)
    StartButton: TButton;
    StopButton: TButton;
    LogMemo: TMemo;
    BtnPanel: TPanel;
    ConfigButton: TButton;
    TrayIcon: TTrayIcon;
    CloseButton: TButton;
    MinimizeButton: TButton;
    CurlButton: TButton;
    procedure StartButtonClick(Sender: TObject);
    procedure StopButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ConfigButtonClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CloseButtonClick(Sender: TObject);
    procedure TrayIconClick(Sender: TObject);
    procedure MinimizeButtonClick(Sender: TObject);
    procedure CurlButtonClick(Sender: TObject);
  private
    ConsoleThread: TThread;
    OneInstThread: TThread;
    ProcessHandle: THandle;
    ExeFile: string;
    ConfigFile: string;
    MaxLines: Integer;
    IniFile: TIniFile;
    ReallyClose: boolean;
    procedure GenerateConfigFile;
    procedure OnResult(Sender: TObject; s: string);
    procedure OnStopped(Sender: TObject);
    procedure OnStarted(Sender: TObject; ProcessHandle: THandle);
    procedure WMQueryEndSession(var Msg: TWMQueryEndSession); message WM_QUERYENDSESSION;
    procedure WMSysCommand(var Msg: TWMSysCommand); message WM_SysCommand;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

uses
  ConfigFrm, CurlFrm, ConsoleThread, OneInst, System.Win.Registry;

{=============================================================================}
procedure TMainForm.StartButtonClick(Sender: TObject);
begin
  if FileExists(ExeFile) = false then
    begin
      MessageBox(Self.Handle, pchar('monero-wallet-rpc.exe not found!'), pchar(Self.Caption), 16);
      ConfigButton.Click;
      Exit;
    end;

  if FileExists(IniFile.ReadString('wallet', 'file', '')) = false then
    begin
      MessageBox(Self.Handle, pchar('Wallet file not found!'), pchar(Self.Caption), 16);
      ConfigButton.Click;
      Exit;
    end;

  StartButton.Enabled := false;

  GenerateConfigFile;

  ConsoleThread := TConsoleThread.Create;
  TConsoleThread(ConsoleThread).OnError := OnResult;
  TConsoleThread(ConsoleThread).OnResult := OnResult;
  TConsoleThread(ConsoleThread).OnStopped := OnStopped;
  TConsoleThread(ConsoleThread).OnStarted := OnStarted;
  TConsoleThread(ConsoleThread).Command := ExeFile + ' --config-file="' + ConfigFile + '"';
  TConsoleThread(ConsoleThread).Start;

  StopButton.Enabled := true;
end;
{=============================================================================}
procedure TMainForm.StopButtonClick(Sender: TObject);
var
  LastError: DWord;
begin
  StopButton.Enabled := false;
  if Winapi.Windows.TerminateProcess(ProcessHandle, 0) = false then
    begin
      LastError := GetLastError;
      MessageBox(Self.Handle, pchar(SysErrorMessage(LastError)), pchar(Self.Caption), 16);
    end;
end;
{=============================================================================}
function SeparateLeft(const Value, Delimiter: string): string;
var
  x: integer;
begin
  x := Pos(Delimiter, Value);
  if x < 1
    then Result := Value
    else Result := Copy(Value, 1, x - 1);
end;
{=============================================================================}
function SeparateRight(const Value, Delimiter: string): string;
var
  x: integer;
begin
  x := Pos(Delimiter, Value);
  if x > 0
    then x := x + Length(Delimiter) - 1;
  Result := Copy(Value, x + 1, Length(Value) - x);
end;
{=============================================================================}
procedure TMainForm.ConfigButtonClick(Sender: TObject);
var
  ConfigForm: TConfigForm;
  RegIniFile: TRegIniFile;
  AddLst: TStringList;
  i: integer;
  Key, Value: string;
begin
  ConfigForm := TConfigForm.Create(Self);
  try
    ConfigForm.Top := IniFile.ReadInteger('config-form', 'top', ConfigForm.Top);
    ConfigForm.Left := IniFile.ReadInteger('config-form', 'left', ConfigForm.Left);
    ConfigForm.Width := IniFile.ReadInteger('config-form', 'width', ConfigForm.Width);
    ConfigForm.Height := IniFile.ReadInteger('config-form', 'height', ConfigForm.Height);
    if IniFile.ReadInteger('config-form', 'maximized', 0) = 1
      then ConfigForm.WindowState := TWindowState.wsMaximized;

    ConfigForm.InitialDir := IniFile.ReadString('config', 'InitialDir', ExtractFilePath(paramstr(0)));
    ConfigForm.ExeFileEdit.Text := ExeFile;
    ConfigForm.ConfigFileEdit.Text := ConfigFile;
    ConfigForm.MaxLogLinesEdit.Text := IntToStr(MaxLines);
    ConfigForm.WalletFileEdit.Text := IniFile.ReadString('wallet', 'file', '');
    ConfigForm.WalletPasswordEdit.Text := IniFile.ReadString('wallet', 'password', '');


    ConfigForm.RpcIpEdit.Text := IniFile.ReadString('local', 'rpc-bind-ip', '127.0.0.1');
    ConfigForm.RpcPortEdit.Text := IniFile.ReadString('local', 'rpc-bind-port', '18081');
    ConfigForm.DisableSslCheckBox.Checked := IniFile.ReadBool('local', 'rpc-ssl', true);
    ConfigForm.DisableLoginCheckBox.Checked := IniFile.ReadBool('local', 'disable-rpc-login', true);
    ConfigForm.NoInitSyncCheckBox.Checked := IniFile.ReadBool('local', 'no-initial-sync', true);

    ConfigForm.RemoteNodeEdit.Text := IniFile.ReadString('remote', 'daemon-address', 'https://xmr-node.cakewallet.com:18081');

    ConfigForm.StartLoginCheckBox.Checked := IniFile.ReadBool('config', 'auto-start', false);
    ConfigForm.StartRpcCheckBox.Checked := IniFile.ReadBool('config', 'start-rpc', false);
    ConfigForm.StartMinimizedCheckBox.Checked := IniFile.ReadBool('config', 'start-mini', false);

    ConfigForm.NoLogFileCheckBox.Checked := IniFile.ReadBool('log', 'no-log-file', true);
    ConfigForm.LogLevelComboBox.ItemIndex := IniFile.ReadInteger('log', 'log-level', 2);

    AddLst := TStringList.Create;
    try
      IniFile.ReadSection('additional', AddLst);
      for i := 0 to AddLst.Count-1 do
        begin
          ConfigForm.AddOptionsMemo.Lines.Add(AddLst.Strings[i] + '=' + IniFile.ReadString('additional', AddLst.Strings[i], ''));
        end;
    finally
      AddLst.Free;
    end;

    if ConfigForm.ShowModal = mrOk then
      begin
        IniFile.WriteString('config', 'InitialDir', ConfigForm.InitialDir);
        ExeFile := ConfigForm.ExeFileEdit.Text;
        ConfigFile := ConfigForm.ConfigFileEdit.Text;
        MaxLines := StrToIntDef(ConfigForm.MaxLogLinesEdit.Text, 10);
        IniFile.WriteString('config', 'exe', ExeFile);
        IniFile.WriteString('config', 'cfg', ConfigFile);

        IniFile.WriteInteger('log', 'maxlines', MaxLines);
        IniFile.WriteInteger('log', 'log-level', ConfigForm.LogLevelComboBox.ItemIndex);
        IniFile.WriteBool('log', 'no-log-file', ConfigForm.NoLogFileCheckBox.Checked);

        IniFile.WriteString('wallet', 'file', ConfigForm.WalletFileEdit.Text);
        IniFile.WriteString('wallet', 'password', ConfigForm.WalletPasswordEdit.Text);

        IniFile.WriteString('local', 'rpc-bind-ip', ConfigForm.RpcIpEdit.Text);
        IniFile.WriteString('local', 'rpc-bind-port', ConfigForm.RpcPortEdit.Text);
        IniFile.WriteBool('local', 'rpc-ssl', ConfigForm.DisableSslCheckBox.Checked);
        IniFile.WriteBool('local', 'disable-rpc-login', ConfigForm.DisableLoginCheckBox.Checked);
        IniFile.WriteBool('config', 'no-initial-sync', ConfigForm.NoInitSyncCheckBox.Checked);

        IniFile.WriteString('remote', 'daemon-address', ConfigForm.RemoteNodeEdit.Text);

        IniFile.WriteBool('config', 'auto-start', ConfigForm.StartLoginCheckBox.Checked);
        IniFile.WriteBool('config', 'start-rpc', ConfigForm.StartRpcCheckBox.Checked);
        IniFile.WriteBool('config', 'start-mini', ConfigForm.StartMinimizedCheckBox.Checked);

        IniFile.EraseSection('additional');
        for i := 0 to ConfigForm.AddOptionsMemo.Lines.Count-1 do
          begin
            Key := SeparateLeft(ConfigForm.AddOptionsMemo.Lines[i], '=');
            Value := SeparateRight(ConfigForm.AddOptionsMemo.Lines[i], '=');
            if Key <> ''
              then IniFile.WriteString('additional', Key, Value);
          end;

        GenerateConfigFile;

         RegIniFile := TRegIniFile.Create('');
         try
           RegIniFile.RootKey := HKEY_CURRENT_USER;
           if ConfigForm.StartLoginCheckBox.Checked = true
             then RegIniFile.WriteString('Software\Microsoft\Windows\CurrentVersion\Run', 'MoneroRpcControl', paramstr(0))
             else RegIniFile.DeleteKey('Software\Microsoft\Windows\CurrentVersion\Run', 'MoneroRpcControl');
         finally
           RegIniFile.Free;
         end;
      end;

    if ConfigForm.WindowState <> TWindowState.wsMaximized then
      begin
        IniFile.WriteInteger('config-form', 'top', ConfigForm.Top);
        IniFile.WriteInteger('config-form', 'left', ConfigForm.Left);
        IniFile.WriteInteger('config-form', 'width', ConfigForm.Width);
        IniFile.WriteInteger('config-form', 'height', ConfigForm.Height);
        IniFile.WriteInteger('config-form', 'maximized', 0);
      end
      else IniFile.WriteInteger('config-form', 'maximized', 1);
  finally
    ConfigForm.Free;
  end;
end;
{=============================================================================}
procedure TMainForm.CloseButtonClick(Sender: TObject);
begin
  ReallyClose := true;
  Self.Close;
end;
{=============================================================================}
procedure TMainForm.MinimizeButtonClick(Sender: TObject);
begin
  Self.Hide;
end;
{=============================================================================}
procedure TMainForm.CurlButtonClick(Sender: TObject);
var
  CurlForm: TCurlForm;
begin
  CurlForm := TCurlForm.Create(Self);
  try
    CurlForm.Top := IniFile.ReadInteger('curl-form', 'top', CurlForm.Top);
    CurlForm.Left := IniFile.ReadInteger('curl-form', 'left', CurlForm.Left);
    CurlForm.Width := IniFile.ReadInteger('curl-form', 'width', CurlForm.Width);
    CurlForm.Height := IniFile.ReadInteger('curl-form', 'height', CurlForm.Height);
    if IniFile.ReadInteger('curl-form', 'maximized', 0) = 1
      then CurlForm.WindowState := TWindowState.wsMaximized;

    if IniFile.ReadBool('local', 'rpc-ssl', true) = true
      then CurlForm.Host := 'http://'
      else CurlForm.Host := 'https://';
    CurlForm.Host := CurlForm.Host + IniFile.ReadString('local', 'rpc-bind-ip', '127.0.0.1') + ':' + IniFile.ReadString('local', 'rpc-bind-port', '18081');

    CurlForm.ShowModal;

    if CurlForm.WindowState <> TWindowState.wsMaximized then
      begin
        IniFile.WriteInteger('curl-form', 'top', CurlForm.Top);
        IniFile.WriteInteger('curl-form', 'left', CurlForm.Left);
        IniFile.WriteInteger('curl-form', 'width', CurlForm.Width);
        IniFile.WriteInteger('curl-form', 'height', CurlForm.Height);
        IniFile.WriteInteger('curl-form', 'maximized', 0);
      end
      else IniFile.WriteInteger('curl-form', 'maximized', 1);
  finally
    CurlForm.Free;
  end;
end;
{=============================================================================}
procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if ReallyClose = false then
    begin
      Action := caNone;
      SendMessage(Self.Handle, WM_SYSCOMMAND, SC_MINIMIZE, 0);
      Exit;
    end;

  if StopButton.Enabled = true
    then StopButton.Click;

  try
    TrayIcon.Visible := false;
  except
  end;

  if Self.WindowState <> TWindowState.wsMaximized then
    begin
      IniFile.WriteInteger('main-form', 'top', Self.Top);
      IniFile.WriteInteger('main-form', 'left', Self.Left);
      IniFile.WriteInteger('main-form', 'width', Self.Width);
      IniFile.WriteInteger('main-form', 'height', Self.Height);
      IniFile.WriteInteger('main-form', 'maximized', 0);
    end
    else IniFile.WriteInteger('main-form', 'maximized', 1);

  TOneInstThread(OneInstThread).StopThread;
end;
{=============================================================================}
procedure TMainForm.FormCreate(Sender: TObject);
begin
  ReallyClose := false;

  OneInstThread := TOneInstThread.Create(Self);

  IniFile := TIniFile.Create(ChangeFileExt(paramstr(0), '.ini'));

  ExeFile := IniFile.ReadString('config', 'exe', ExtractFilePath(paramstr(0)) + 'monero-wallet-rpc.exe');
  ConfigFile := IniFile.ReadString('config', 'cfg', ExtractFilePath(paramstr(0)) + 'monero-wallet-rpc.cfg');
  MaxLines := IniFile.ReadInteger('log', 'maxlines', 100);

  Self.Top := IniFile.ReadInteger('main-form', 'top', Self.Top);
  Self.Left := IniFile.ReadInteger('main-form', 'left', Self.Left);
  Self.Width := IniFile.ReadInteger('main-form', 'width', Self.Width);
  Self.Height := IniFile.ReadInteger('main-form', 'height', Self.Height);
  if IniFile.ReadInteger('main-form', 'maximized', 0) = 1
    then Self.WindowState := TWindowState.wsMaximized;

  TrayIcon.Hint := Self.Caption;
  TrayIcon.Icon.Handle := 0;
  try
    TrayIcon.Visible := true;
  except
  end;

  if IniFile.ReadBool('config', 'start-mini', false) = true
    then Self.WindowState := TWindowState.wsMinimized;

  if IniFile.ReadBool('config', 'start-rpc', false) = true
    then StartButton.Click;
end;
{=============================================================================}
procedure TMainForm.WMQueryEndSession(var Msg: TWMQueryEndSession);
begin
  ReallyClose := true;
  if Self.CloseQuery = true then
    begin
      Self.Close;
      inherited;
    end;
end;
{=============================================================================}
procedure TMainForm.FormDestroy(Sender: TObject);
begin
  IniFile.Free;
end;
{=============================================================================}
procedure TMainForm.FormShow(Sender: TObject);
begin
  DrawAnimatedRects(Self.Handle, 3, Rect(Screen.Width-20, Screen.Height, Screen.Width-10, Screen.Height), Self.BoundsRect);
  ShowWindow(Application.Handle, SW_SHOW);
end;
{=============================================================================}
procedure TMainForm.OnStopped(Sender: TObject);
begin
  StopButton.Enabled := false;
  StartButton.Enabled := true;
end;
{=============================================================================}
procedure TMainForm.OnStarted(Sender: TObject; ProcessHandle: THandle);
begin
  Self.ProcessHandle := ProcessHandle;
end;
{=============================================================================}
procedure TMainForm.OnResult(Sender: TObject; s: string);
begin
  if s[length(s)] = #10
    then Delete(s, length(s), 1);

  if s[length(s)] = #13
    then Delete(s, length(s), 1);

  LogMemo.Lines.Add(s);

  LogMemo.Lines.BeginUpdate;
  try
    while LogMemo.Lines.Count > MaxLines do
      begin
        LogMemo.Lines.Delete(0);
      end;
  finally
    LogMemo.Lines.EndUpdate;
  end;

  SendMessage(LogMemo.Handle, EM_LINESCROLL, 0, LogMemo.Lines.Count);
end;
{=============================================================================}
procedure TMainForm.TrayIconClick(Sender: TObject);
var
  Th1, Th2: DWord;
begin
  if IsIconic(Application.Handle)
    then Application.Restore;
  if Self.WindowState = wsMinimized
    then Self.WindowState := wsNormal;
  Self.Show;
  Th1 := GetCurrentThreadId;
  Th2 := GetWindowThreadProcessId(GetForegroundWindow, nil);
  AttachThreadInput(Th2, Th1, true);
  try
    SetForegroundWindow(Application.Handle);
  finally
    AttachThreadInput(Th2, Th1, false);
  end;
end;
{=============================================================================}
procedure TMainForm.WMSysCommand(var Msg: TWMSysCommand);
begin
  if (Msg.CmdType and $FFF0 = SC_MINIMIZE) then
    begin
      ShowWindow(Application.Handle, SW_HIDE);
      Self.Hide;
      DrawAnimatedRects(Self.Handle, 3, Self.BoundsRect, Rect(Screen.Width-20, Screen.Height, Screen.Width-10, Screen.Height));
    end
    else inherited;
end;
{=============================================================================}
procedure TMainForm.GenerateConfigFile;
var
  StrLst: TStringList;
  AddLst: TStringList;
  i: integer;
begin
  if FileExists(ConfigFile)
    then WinApi.Windows.DeleteFile(pchar(ConfigFile));

  StrLst := TStringList.Create;
  try
    StrLst.Add('wallet-file=' + IniFile.ReadString('wallet', 'file', ''));
    StrLst.Add('password=' + IniFile.ReadString('wallet', 'password', ''));
    StrLst.Add('rpc-bind-ip=' + IniFile.ReadString('local', 'rpc-bind-ip', '127.0.0.1'));
    StrLst.Add('rpc-bind-port=' + IniFile.ReadString('local', 'rpc-bind-port', '18081'));
    StrLst.Add('daemon-address=' + IniFile.ReadString('remote', 'daemon-address', 'https://xmr-node.cakewallet.com:18081'));
    StrLst.Add('log-level=' + IniFile.ReadString('log', 'log-level', '2'));
    if IniFile.ReadBool('local', 'no-initial-sync', true) = true
      then StrLst.Add('no-initial-sync=');
    if IniFile.ReadBool('log', 'no-log-file', true) = true
      then StrLst.Add('log-file=');
    if IniFile.ReadBool('local', 'disable-rpc-login', true) = true
      then StrLst.Add('disable-rpc-login=');
    if IniFile.ReadBool('local', 'rpc-ssl', true) = true
      then StrLst.Add('rpc-ssl=disabled');

    AddLst := TStringList.Create;
    try
      IniFile.ReadSection('additional', AddLst);
      for i := 0 to AddLst.Count-1 do
        begin
           StrLst.Add(AddLst.Strings[i] + '=' + IniFile.ReadString('additional', AddLst.Strings[i], ''));
        end;
    finally
      AddLst.Free;
    end;
    StrLst.SaveToFile(ConfigFile);
  finally
    StrLst.Free;
  end;
end;
{=============================================================================}
end.
