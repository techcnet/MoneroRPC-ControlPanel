object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'Monero Wallet RPC- Control Panel'
  ClientHeight = 323
  ClientWidth = 740
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
    Width = 740
    Height = 282
    Align = alClient
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 0
    ExplicitWidth = 623
    ExplicitHeight = 250
  end
  object BtnPanel: TPanel
    Left = 0
    Top = 0
    Width = 740
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 1
    ExplicitTop = -6
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
      ExplicitLeft = 506
      ExplicitTop = -6
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
    object AboutButton: TButton
      Left = 600
      Top = 0
      Width = 100
      Height = 41
      Align = alLeft
      Caption = 'About'
      TabOrder = 6
      OnClick = AboutButtonClick
      ExplicitTop = -6
    end
  end
  object TrayIcon: TTrayIcon
    PopupMenu = TrayMenu
    OnClick = TrayIconClick
    Left = 222
    Top = 84
  end
  object TrayMenu: TPopupMenu
    Left = 288
    Top = 88
    object Show1: TMenuItem
      Caption = 'Show'
      OnClick = TrayIconClick
    end
    object About1: TMenuItem
      Caption = 'About'
      OnClick = AboutButtonClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object Close1: TMenuItem
      Caption = 'Close'
      OnClick = CloseButtonClick
    end
  end
end
