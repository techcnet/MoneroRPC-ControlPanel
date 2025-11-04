unit ConsoleThread;

interface

uses
  Winapi.Windows, System.SysUtils, System.Classes;

type
  TConsoleReturn = procedure(Sender: TObject; s: string) of object;
  TConsoleStart = procedure(Sender: TObject; ProcessHandle: THandle) of object;

type
  TConsoleThread = class(TThread)
    ResultString: string;
    ErrorString: string;
    FProcessHandle: THandle;
    FOnResult: TConsoleReturn;
    FOnError: TConsoleReturn;
    FOnStopped: TNotifyEvent;
    FOnStarted: TConsoleStart;
    procedure SetProcessHandle;
    procedure DoError;
    procedure DoResult;
    procedure ThreadStopped;
  protected
    procedure Execute; override;
  public
    Command: string;
    constructor Create;
  public
    property OnResult: TConsoleReturn read FOnResult write FOnResult;
    property OnError: TConsoleReturn read FOnError write FOnError;
    property OnStopped: TNotifyEvent read FOnStopped write FOnStopped;
    property OnStarted: TConsoleStart read FOnStarted write FOnStarted;
  end;

implementation

{=============================================================================}
constructor TConsoleThread.Create;
begin
  inherited Create(true);
  Self.FreeOnTerminate := true;
end;
{=============================================================================}
procedure TConsoleThread.SetProcessHandle;
begin
  if Assigned(FOnStarted)
    then FOnStarted(Self, FProcessHandle);
end;
{=============================================================================}
procedure TConsoleThread.DoError;
begin
  if Assigned(FOnError)
    then FOnError(Self, ErrorString);
end;
{=============================================================================}
procedure TConsoleThread.DoResult;
begin
  if Assigned(FOnResult)
    then FOnResult(Self, ResultString);
  ResultString := '';
end;
{=============================================================================}
procedure TConsoleThread.ThreadStopped;
begin
  if Assigned(FOnStopped)
    then FOnStopped(Self);
end;
{=============================================================================}
procedure TConsoleThread.Execute;
var
  Buffer: array[0..(1024*16)-1] of AnsiChar;
  StartupInfo: TStartupInfo;
  ProcessInformation: TProcessInformation;
  SecurityAttributes: TSecurityAttributes;
  SecurityDescriptor: TSecurityDescriptor;
  WritePipeHandle, ReadPipeHandle: THandle;
  ExitCode, BytesRead, BytesAvailable, LastError: Cardinal;
begin
  try
    GetStartupInfo(StartupInfo);
    StartupInfo.dwFlags := STARTF_USESTDHANDLES or STARTF_USESHOWWINDOW;
    StartupInfo.wShowWindow := SW_HIDE;
    StartupInfo.hStdInput := GetStdHandle(STD_INPUT_HANDLE);

    ProcessInformation := Default(TProcessInformation);
    try
      if InitializeSecurityDescriptor(@SecurityDescriptor, SECURITY_DESCRIPTOR_REVISION) = false then
        begin
          if Self.CheckTerminated = false then
            begin
              LastError := GetLastError;
              ErrorString := SysErrorMessage(LastError);
              Synchronize(DoError);
            end;
          Exit;
        end;

      if SetSecurityDescriptorDacl(@SecurityDescriptor, true, nil, false) = false then
        begin
          if Self.CheckTerminated = false then
            begin
              LastError := GetLastError;
              ErrorString := SysErrorMessage(LastError);
              Synchronize(DoError);
            end;
          Exit;
        end;

      SecurityAttributes.lpSecurityDescriptor := @SecurityDescriptor;
      SecurityAttributes.nLength := SizeOf(TSecurityAttributes);
      SecurityAttributes.bInheritHandle := true;

      if CreatePipe(ReadPipeHandle, WritePipeHandle, @SecurityAttributes, 0) = false then
        begin
          if Self.CheckTerminated = false then
            begin
              LastError := GetLastError;
              ErrorString := SysErrorMessage(LastError);
              Synchronize(DoError);
            end;
          Exit;
        end;

      StartupInfo.hStdOutput := WritePipeHandle;
      StartupInfo.hStdError := WritePipeHandle;

      UniqueString(Command);
      if CreateProcess(nil, pchar(Command), @SecurityAttributes, @SecurityAttributes, true,
         CREATE_NEW_CONSOLE,
         nil, nil, StartupInfo, ProcessInformation) = false then
        begin
          LastError := GetLastError;
          CloseHandle(ReadPipeHandle);
          CloseHandle(WritePipeHandle);
          if Self.CheckTerminated = false then
            begin
              ErrorString := SysErrorMessage(LastError);
              Synchronize(DoError);
            end;
          Exit;
        end;

      FProcessHandle := ProcessInformation.hProcess;
      Synchronize(SetProcessHandle);

      repeat
        BytesRead := 0;
        PeekNamedPipe(ReadPipeHandle, @Buffer, SizeOf(Buffer) - 1, @BytesRead, @BytesAvailable, nil);
        if BytesRead > 0 then
          begin
            Fillchar(Buffer, SizeOf(Buffer), 0);
            if ReadFile(ReadPipeHandle, Buffer, BytesRead, BytesRead, nil) = false then
              begin
                LastError := GetLastError;
                CloseHandle(ProcessInformation.hProcess);
                CloseHandle(ProcessInformation.hThread);
                CloseHandle(ReadPipeHandle);
                CloseHandle(WritePipeHandle);
                if Self.CheckTerminated = false then
                  begin
                    ErrorString := SysErrorMessage(LastError);
                    Synchronize(DoError);
                  end;
                Exit;
              end;

            if Self.CheckTerminated = false then
              begin
                ResultString := string(PAnsiChar(@Buffer[0]));
                Synchronize(DoResult);
              end;
          end;

        GetExitCodeProcess(ProcessInformation.hProcess, ExitCode);
        Sleep(100);
      until ((ExitCode <> STILL_ACTIVE) and (BytesRead = 0)) or (Self.CheckTerminated = true);

      CloseHandle(ProcessInformation.hProcess);
      CloseHandle(ProcessInformation.hThread);

      CloseHandle(ReadPipeHandle);
      CloseHandle(WritePipeHandle);
    except
      on E:Exception do
        begin
          if Self.CheckTerminated = false then
            begin
              ErrorString := E.Message;
              Synchronize(DoError);
            end;
        end;
    end;
  finally
    Synchronize(ThreadStopped);
  end;
end;
{=============================================================================}
end.
