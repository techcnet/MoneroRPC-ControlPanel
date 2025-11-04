object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'Monero Wallet RPC- Control Panel'
  ClientHeight = 291
  ClientWidth = 623
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object LogMemo: TMemo
    Left = 0
    Top = 41
    Width = 623
    Height = 250
    Align = alClient
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 0
  end
  object BtnPanel: TPanel
    Left = 0
    Top = 0
    Width = 623
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 1
    object StartButton: TButton
      Left = 0
      Top = 0
      Width = 100
      Height = 41
      Align = alLeft
      Caption = 'Start'
      TabOrder = 0
      OnClick = StartButtonClick
    end
    object StopButton: TButton
      Left = 100
      Top = 0
      Width = 100
      Height = 41
      Align = alLeft
      Caption = 'Stop'
      Enabled = False
      TabOrder = 1
      OnClick = StopButtonClick
    end
    object ConfigButton: TButton
      Left = 200
      Top = 0
      Width = 100
      Height = 41
      Align = alLeft
      Caption = 'Config'
      TabOrder = 2
      OnClick = ConfigButtonClick
    end
    object CloseButton: TButton
      Left = 500
      Top = 0
      Width = 100
      Height = 41
      Align = alLeft
      Caption = 'Close'
      TabOrder = 3
      OnClick = CloseButtonClick
    end
    object MinimizeButton: TButton
      Left = 400
      Top = 0
      Width = 100
      Height = 41
      Align = alLeft
      Caption = 'Minimize'
      TabOrder = 4
      OnClick = MinimizeButtonClick
    end
    object CurlButton: TButton
      Left = 300
      Top = 0
      Width = 100
      Height = 41
      Align = alLeft
      Caption = 'Curl'
      TabOrder = 5
      OnClick = CurlButtonClick
    end
  end
  object TrayIcon: TTrayIcon
    OnClick = TrayIconClick
    Left = 222
    Top = 84
  end
end
