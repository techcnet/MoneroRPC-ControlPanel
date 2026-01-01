unit CurlFrm;

interface

uses
  Winapi.Windows, System.SysUtils, System.Classes, Vcl.Controls, Vcl.Forms, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TCurlForm = class(TForm)
    InputPanel: TPanel;
    OutputMemo: TMemo;
    InputMemo: TMemo;
    ButtonsPanel: TPanel;
    StoreButton: TButton;
    SendButton: TButton;
    Splitter: TSplitter;
    procedure StoreButtonClick(Sender: TObject);
    procedure SendButtonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
  public
    Host: string;
  private
    ConsoleThread: TThread;
    ProcessHandle: THandle;
    procedure OnResult(Sender: TObject; s: string);
    procedure OnStarted(Sender: TObject; ProcessHandle: THandle);
    procedure OnStopped(Sender: TObject);
  end;

implementation

{$R *.dfm}

uses
  ConsoleThread;

{=============================================================================}
procedure TCurlForm.StoreButtonClick(Sender: TObject);
begin
  InputMemo.Text := '{"jsonrpc":"2.0","id":"0","method":"store"}';
end;
{=============================================================================}
procedure TCurlForm.SendButtonClick(Sender: TObject);
var
  Command: string;
begin
  SendButton.Enabled := false;

  Command := StringReplace(InputMemo.Text, #13, '', [rfReplaceAll]);
  Command := StringReplace(Command, #10, '', [rfReplaceAll]);
  Command := StringReplace(Command, '"', '\"', [rfReplaceAll]);

  ConsoleThread := TConsoleThread.Create;
  TConsoleThread(ConsoleThread).OnError := OnResult;
  TConsoleThread(ConsoleThread).OnResult := OnResult;
  TConsoleThread(ConsoleThread).OnStopped := OnStopped;
  TConsoleThread(ConsoleThread).OnStarted := OnStarted;
  TConsoleThread(ConsoleThread).Command := 'curl.exe ' + Host + '/json_rpc -d "' + Command + '" --no-progress-meter';
  TConsoleThread(ConsoleThread).Start;
end;
{=============================================================================}
procedure TCurlForm.FormClose(Sender: TObject; var Action: TCloseAction);
var
  LastError: DWord;
begin
  if ProcessHandle <> 0 then
    begin
      if Winapi.Windows.TerminateProcess(ProcessHandle, 0) = false then
        begin
          LastError := GetLastError;
          MessageBox(Self.Handle, pchar(SysErrorMessage(LastError)), pchar(Self.Caption), 16);
        end;
      ProcessHandle := 0;
    end;
end;
{=============================================================================}
procedure TCurlForm.FormCreate(Sender: TObject);
begin
  ProcessHandle := 0;
end;
{=============================================================================}
procedure TCurlForm.OnResult(Sender: TObject; s: string);
begin
  if s[length(s)] = #10
    then Delete(s, length(s), 1);

  if s[length(s)] = #13
    then Delete(s, length(s), 1);

  OutputMemo.Lines.Add(s);
end;
{=============================================================================}
procedure TCurlForm.OnStopped(Sender: TObject);
begin
  if ProcessHandle <> 0 then
    begin
      SendButton.Enabled := true;
      ProcessHandle := 0;
    end;
end;
{=============================================================================}
procedure TCurlForm.OnStarted(Sender: TObject; ProcessHandle: THandle);
begin
  Self.ProcessHandle := ProcessHandle;
end;
{=============================================================================}
end.
