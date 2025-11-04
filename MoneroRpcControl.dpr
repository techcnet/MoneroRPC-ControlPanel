program MoneroRpcControl;

uses
  Winapi.Windows,
  Vcl.Forms,
  OneInst,
  MainFrm in 'MainFrm.pas' {MainForm};

{$R *.res}

begin
  if InstanceRunning = true
    then Exit;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
