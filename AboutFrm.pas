unit AboutFrm;

interface

uses
  System.SysUtils, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms,
  Vcl.StdCtrls, Vcl.Imaging.pngimage, Vcl.ExtCtrls;

type
  TAboutForm = class(TForm)
    LogoImage: TImage;
    Label43: TLabel;
    Label55: TLabel;
    LabelVersion: TLabel;
    LabelUrl: TLabel;
    Label56: TLabel;
    DonateImage: TImage;
    DisclaimerMemo: TMemo;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure LabelUrlClick(Sender: TObject);
    procedure DonateImageClick(Sender: TObject);
    procedure LabelUrlMouseEnter(Sender: TObject);
    procedure LabelUrlMouseLeave(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  end;

implementation

{$R *.dfm}

uses
  WinApi.ShellApi;

{=============================================================================}
procedure TAboutForm.Button1Click(Sender: TObject);
begin
  Self.Close;
end;
{=============================================================================}
procedure TAboutForm.DonateImageClick(Sender: TObject);
begin
  ShellExecute(0, PChar('open'), PChar('https://tech-c.net/donation/'), nil, nil, 1);
end;
{=============================================================================}
procedure TAboutForm.FormCreate(Sender: TObject);
begin
  LabelUrl.Font.Color := clBlue;
  //DisclaimerMemo.WordWrap := true;
end;
{=============================================================================}
procedure TAboutForm.LabelUrlClick(Sender: TObject);
begin
  ShellExecute(0, PChar('open'), PChar('https://tech-c.net/posts/monero-rpc-control-panel/'), nil, nil, 1);
end;
{=============================================================================}
procedure TAboutForm.LabelUrlMouseEnter(Sender: TObject);
begin
  LabelUrl.Font.Style := [TFontStyle.fsUnderline];
end;
{=============================================================================}
procedure TAboutForm.LabelUrlMouseLeave(Sender: TObject);
begin
  LabelUrl.Font.Style := [];
end;
{=============================================================================}
end.
