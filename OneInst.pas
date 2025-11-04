unit OneInst;

interface

uses
  Winapi.Windows, Vcl.Forms, System.Classes, System.SysUtils;

type
  TOneInstThread = class(TThread)
  private
    StopEvent: THandle;
    ThreadStopEvent: THandle;
    ThreadInstanceEvent: THandle;
    ParentForm: TForm;
    procedure ShowWindow;
  protected
    procedure Execute; override;
  public
    procedure StopThread;
    constructor Create(fParentForm: TForm); overload;
  end;

function InstanceRunning: boolean;

implementation

uses
  MainFrm;

var
  InstanceEvent: THandle = 0;

const
  AppId = '5E75471C-DA69-4F97-871B-2C21AB4ED23B';

{=============================================================================}
function InstanceRunning: boolean;
begin
  InstanceEvent := OpenEvent(EVENT_ALL_ACCESS, false, pchar(AppId));
  if InstanceEvent <> 0
    then begin
      SetEvent(InstanceEvent);
      CloseHandle(InstanceEvent);
      Result := true;
    end
    else begin
      InstanceEvent := CreateEvent(nil, false, false, pchar(AppId));
      Result := false;
    end;
end;
{=============================================================================}
constructor TOneInstThread.Create(fParentForm: TForm);
var
  LastError: DWord;
begin
  ParentForm := fParentForm;
  Self.FreeOnTerminate := true;

  StopEvent := CreateEvent(nil, false, false, nil);
  if StopEvent = 0 then
    begin
      LastError := GetLastError;
      MessageBox(Self.Handle, pchar(SysErrorMessage(LastError)), pchar(Application.Title), 16);
    end;

  if DuplicateHandle(GetCurrentProcess,
                     StopEvent,
                     GetCurrentProcess,
                     @ThreadStopEvent,
                     0,
                     false,
                     DUPLICATE_SAME_ACCESS) = false then
    begin
      LastError := GetLastError;
      MessageBox(Self.Handle, pchar(SysErrorMessage(LastError)), pchar(Application.Title), 16);
    end;

  if InstanceEvent <> 0 then
    begin
      if DuplicateHandle(GetCurrentProcess,
                     InstanceEvent,
                     GetCurrentProcess,
                     @ThreadInstanceEvent,
                     0,
                     false,
                     DUPLICATE_SAME_ACCESS) = false then
        begin
          LastError := GetLastError;
          MessageBox(Self.Handle, pchar(SysErrorMessage(LastError)), pchar(Application.Title), 16);
        end;
    end
    else ThreadInstanceEvent := 0;

  inherited Create(false);
end;
{=============================================================================}
procedure TOneInstThread.StopThread;
begin
  if StopEvent <> 0 then
    begin
      SetEvent(StopEvent);
      CloseHandle(StopEvent);
      StopEvent := 0;
    end;
end;
{=============================================================================}
procedure TOneInstThread.ShowWindow;
begin
  TMainForm(ParentForm).TrayIconClick(nil);
end;
{=============================================================================}
procedure TOneInstThread.Execute;
var
  EventArray: array[0..1] of THandle;
begin
  EventArray[0] := ThreadInstanceEvent;
  EventArray[1] := ThreadStopEvent;
  try
    while true do
      begin
        if WaitForMultipleObjects(2, @EventArray, false, INFINITE) <> WAIT_OBJECT_0 then Break;
        Self.Synchronize(ShowWindow);
      end;
  finally
    CloseHandle(ThreadInstanceEvent);
    CloseHandle(ThreadStopEvent);
  end;
end;
{=============================================================================}
end.
