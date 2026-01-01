unit ConfigFrm;

interface

uses
  Winapi.Windows, Winapi.ShellApi, System.SysUtils, System.Classes,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TConfigForm = class(TForm)
    Panel: TPanel;
    CancelButton: TButton;
    OkButton: TButton;
    ExeFileEdit: TEdit;
    SelectExeButton: TButton;
    SelectConfigButton: TButton;
    ConfigFileEdit: TEdit;
    MaxLogLinesEdit: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    WalletFileEdit: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    WalletPasswordEdit: TEdit;
    Label6: TLabel;
    RpcIpEdit: TEdit;
    Label7: TLabel;
    RpcPortEdit: TEdit;
    Label8: TLabel;
    RemoteNodeEdit: TEdit;
    Label9: TLabel;
    NoInitSyncCheckBox: TCheckBox;
    NoLogFileCheckBox: TCheckBox;
    AddOptionsMemo: TMemo;
    Label10: TLabel;
    SelectWalletButton: TButton;
    DisableLoginCheckBox: TCheckBox;
    Label11: TLabel;
    LogLevelComboBox: TComboBox;
    StartLoginCheckBox: TCheckBox;
    StartRpcCheckBox: TCheckBox;
    StartMinimizedCheckBox: TCheckBox;
    DisableSslCheckBox: TCheckBox;
    ScrollBox: TScrollBox;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    procedure SelectExeButtonClick(Sender: TObject);
    procedure SelectConfigButtonClick(Sender: TObject);
    procedure Label9Click(Sender: TObject);
    procedure SelectWalletButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ScrollBoxMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
  public
    InitialDir: string;
  end;

implementation

{$R *.dfm}

uses
  System.Math;

{=============================================================================}
procedure TConfigForm.SelectExeButtonClick(Sender: TObject);
var
  OpenDialog: TOpenDialog;
begin
  OpenDialog := TOpenDialog.Create(Application.MainForm);
  try
    OpenDialog.Options := [ofOverwritePrompt,ofHideReadOnly,ofPathMustExist,ofNoReadOnlyReturn,ofNoDereferenceLinks,ofEnableSizing];
    OpenDialog.Filter := 'EXE' + ' (*.exe)|*.exe';
    OpenDialog.DefaultExt := 'exe';
    OpenDialog.FilterIndex := 1;
    OpenDialog.FileName := ExtractFilePath(paramstr(0)) + 'monero-wallet-rpc.exe';
    OpenDialog.InitialDir := InitialDir;
    if OpenDialog.Execute = false
      then Exit;
    InitialDir := ExtractFilePath(OpenDialog.FileName);
    ExeFileEdit.Text := OpenDialog.FileName;
  finally
    OpenDialog.Free;
  end;
end;
{=============================================================================}
procedure TConfigForm.SelectConfigButtonClick(Sender: TObject);
var
  OpenDialog: TOpenDialog;
begin
  OpenDialog := TOpenDialog.Create(Application.MainForm);
  try
    OpenDialog.Options := [ofOverwritePrompt,ofHideReadOnly,ofPathMustExist,ofNoReadOnlyReturn,ofNoDereferenceLinks,ofEnableSizing];
    OpenDialog.Filter := '';
    OpenDialog.DefaultExt := '';
    OpenDialog.FilterIndex := 0;
    OpenDialog.FileName := ExtractFilePath(paramstr(0)) + 'monero-wallet-rpc.cfg';
    OpenDialog.InitialDir := InitialDir;
    if OpenDialog.Execute = false
      then Exit;
    InitialDir := ExtractFilePath(OpenDialog.FileName);
    ConfigFileEdit.Text := OpenDialog.FileName;
  finally
    OpenDialog.Free;
  end;
end;
{=============================================================================}
procedure TConfigForm.SelectWalletButtonClick(Sender: TObject);
var
  OpenDialog: TOpenDialog;
begin
  OpenDialog := TOpenDialog.Create(Application.MainForm);
  try
    OpenDialog.Options := [ofOverwritePrompt,ofHideReadOnly,ofPathMustExist,ofNoReadOnlyReturn,ofNoDereferenceLinks,ofEnableSizing];
    OpenDialog.Filter := '';
    OpenDialog.DefaultExt := '';
    OpenDialog.FilterIndex := 0;
    OpenDialog.FileName := '';
    OpenDialog.InitialDir := InitialDir;
    if OpenDialog.Execute = false
      then Exit;
    InitialDir := ExtractFilePath(OpenDialog.FileName);
    WalletFileEdit.Text := OpenDialog.FileName;
  finally
    OpenDialog.Free;
  end;
end;
{=============================================================================}
procedure TConfigForm.FormCreate(Sender: TObject);
begin
  ScrollBox.RemoveControl(SelectExeButton);
  ExeFileEdit.InsertControl(SelectExeButton);
  SelectExeButton.Align := TAlign.alRight;

  ScrollBox.RemoveControl(SelectConfigButton);
  ConfigFileEdit.InsertControl(SelectConfigButton);
  SelectConfigButton.Align := TAlign.alRight;

  ScrollBox.RemoveControl(SelectWalletButton);
  WalletFileEdit.InsertControl(SelectWalletButton);
  SelectWalletButton.Align := TAlign.alRight;
end;
{=============================================================================}
procedure TConfigForm.Label9Click(Sender: TObject);
begin
  ShellExecute(0, pchar('open'), pchar('https://xmr.ditatompel.com/remote-nodes'), nil, nil, 1);
end;
{=============================================================================}
procedure TConfigForm.ScrollBoxMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
var
  NewPos: Integer;
begin
  NewPos := TScrollBox(Sender).VertScrollBar.Position - WheelDelta;
  NewPos := Max(NewPos, 0);
  NewPos := Min(NewPos, TScrollBox(Sender).VertScrollBar.Range);
  TScrollBox(Sender).VertScrollBar.Position := NewPos;
  Handled := True;
end;
{=============================================================================}
end.
