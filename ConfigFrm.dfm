object ConfigForm: TConfigForm
  Left = 0
  Top = 0
  Caption = 'Config'
  ClientHeight = 435
  ClientWidth = 422
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel: TPanel
    AlignWithMargins = True
    Left = 10
    Top = 389
    Width = 402
    Height = 36
    Margins.Left = 10
    Margins.Right = 10
    Margins.Bottom = 10
    Align = alBottom
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 0
    object CancelButton: TButton
      AlignWithMargins = True
      Left = 299
      Top = 3
      Width = 100
      Height = 30
      Align = alRight
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 0
    end
    object OkButton: TButton
      AlignWithMargins = True
      Left = 193
      Top = 3
      Width = 100
      Height = 30
      Align = alRight
      Caption = 'Ok'
      ModalResult = 1
      TabOrder = 1
    end
  end
  object ScrollBox: TScrollBox
    Left = 0
    Top = 0
    Width = 422
    Height = 386
    Margins.Left = 10
    HorzScrollBar.Visible = False
    VertScrollBar.Tracking = True
    Align = alClient
    BorderStyle = bsNone
    ParentBackground = True
    TabOrder = 1
    OnMouseWheel = ScrollBoxMouseWheel
    object Label12: TLabel
      AlignWithMargins = True
      Left = 10
      Top = 10
      Width = 392
      Height = 13
      Margins.Left = 10
      Margins.Top = 10
      Align = alTop
      Caption = 'Program'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      ExplicitLeft = 3
      ExplicitTop = 3
      ExplicitWidth = 49
    end
    object Label1: TLabel
      AlignWithMargins = True
      Left = 10
      Top = 124
      Width = 392
      Height = 13
      Margins.Left = 10
      Margins.Bottom = 0
      Align = alTop
      Caption = 'Path to monero-wallet-rpc.exe'
      ExplicitTop = 110
      ExplicitWidth = 147
    end
    object Label10: TLabel
      AlignWithMargins = True
      Left = 10
      Top = 365
      Width = 392
      Height = 13
      Margins.Left = 10
      Margins.Bottom = 0
      Align = alTop
      Caption = 'Additional options'
      ExplicitTop = 351
      ExplicitWidth = 85
    end
    object Label11: TLabel
      AlignWithMargins = True
      Left = 10
      Top = 705
      Width = 392
      Height = 13
      Margins.Left = 10
      Margins.Bottom = 0
      Align = alTop
      Caption = 'Log level'
      ExplicitTop = 670
      ExplicitWidth = 42
    end
    object Label2: TLabel
      AlignWithMargins = True
      Left = 10
      Top = 167
      Width = 392
      Height = 13
      Margins.Left = 10
      Margins.Bottom = 0
      Align = alTop
      Caption = 'Path to monero-wallet-rpc.cfg'
      ExplicitTop = 153
      ExplicitWidth = 144
    end
    object Label3: TLabel
      AlignWithMargins = True
      Left = 10
      Top = 550
      Width = 392
      Height = 13
      Margins.Left = 10
      Margins.Bottom = 0
      Align = alTop
      Caption = 'Path to wallet file'
      ExplicitTop = 522
      ExplicitWidth = 83
    end
    object Label4: TLabel
      AlignWithMargins = True
      Left = 10
      Top = 662
      Width = 392
      Height = 13
      Margins.Left = 10
      Margins.Bottom = 0
      Align = alTop
      Caption = 'Max lines in log'
      ExplicitTop = 627
      ExplicitWidth = 72
    end
    object Label5: TLabel
      AlignWithMargins = True
      Left = 10
      Top = 593
      Width = 392
      Height = 13
      Margins.Left = 10
      Margins.Bottom = 0
      Align = alTop
      Caption = 'Password for wallet file'
      ExplicitTop = 565
      ExplicitWidth = 111
    end
    object Label6: TLabel
      AlignWithMargins = True
      Left = 10
      Top = 210
      Width = 392
      Height = 13
      Margins.Left = 10
      Margins.Bottom = 0
      Align = alTop
      Caption = 'rpc-bind-ip (default 127.0.0.1)'
      ExplicitTop = 196
      ExplicitWidth = 147
    end
    object Label7: TLabel
      AlignWithMargins = True
      Left = 10
      Top = 253
      Width = 392
      Height = 13
      Margins.Left = 10
      Margins.Bottom = 0
      Align = alTop
      Caption = 'rpc-bind-port (default 18081)'
      ExplicitTop = 239
      ExplicitWidth = 141
    end
    object Label8: TLabel
      AlignWithMargins = True
      Left = 10
      Top = 462
      Width = 392
      Height = 13
      Margins.Left = 10
      Margins.Bottom = 0
      Align = alTop
      Caption = 'Remote daemon-address'
      ExplicitTop = 441
      ExplicitWidth = 120
    end
    object Label9: TLabel
      AlignWithMargins = True
      Left = 10
      Top = 505
      Width = 392
      Height = 13
      Cursor = crHandPoint
      Margins.Left = 10
      Align = alTop
      Caption = 'Public Monero Remote Nodes List: xmr.ditatompel.com'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsUnderline]
      ParentFont = False
      OnClick = Label9Click
      ExplicitTop = 484
      ExplicitWidth = 260
    end
    object Label13: TLabel
      AlignWithMargins = True
      Left = 10
      Top = 82
      Width = 392
      Height = 13
      Margins.Left = 10
      Margins.Top = 10
      Align = alTop
      Caption = 'RPC'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      ExplicitLeft = 3
      ExplicitTop = 68
      ExplicitWidth = 22
    end
    object Label14: TLabel
      AlignWithMargins = True
      Left = 10
      Top = 531
      Width = 392
      Height = 13
      Margins.Left = 10
      Margins.Top = 10
      Align = alTop
      Caption = 'Wallet'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      ExplicitLeft = 3
      ExplicitTop = 503
      ExplicitWidth = 36
    end
    object Label15: TLabel
      AlignWithMargins = True
      Left = 10
      Top = 443
      Width = 392
      Height = 13
      Margins.Left = 10
      Margins.Top = 10
      Align = alTop
      Caption = 'Remote node'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      ExplicitLeft = 3
      ExplicitTop = 422
      ExplicitWidth = 76
    end
    object Label16: TLabel
      AlignWithMargins = True
      Left = 10
      Top = 643
      Width = 392
      Height = 13
      Margins.Left = 10
      Margins.Top = 10
      Align = alTop
      Caption = 'Log'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      ExplicitLeft = 3
      ExplicitTop = 608
      ExplicitWidth = 20
    end
    object Label17: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 771
      Width = 399
      Height = 13
      Align = alTop
      Caption = ' '
      ExplicitTop = 736
      ExplicitWidth = 3
    end
    object NoInitSyncCheckBox: TCheckBox
      AlignWithMargins = True
      Left = 10
      Top = 342
      Width = 392
      Height = 17
      Margins.Left = 10
      Align = alTop
      Caption = 'No initial sync'
      Checked = True
      State = cbChecked
      TabOrder = 0
    end
    object NoLogFileCheckBox: TCheckBox
      AlignWithMargins = True
      Left = 10
      Top = 748
      Width = 392
      Height = 17
      Margins.Left = 10
      Align = alTop
      Caption = 'No log file'
      Checked = True
      State = cbChecked
      TabOrder = 1
    end
    object DisableLoginCheckBox: TCheckBox
      AlignWithMargins = True
      Left = 10
      Top = 319
      Width = 392
      Height = 17
      Margins.Left = 10
      Align = alTop
      Caption = 'Disable RPC login'
      Checked = True
      State = cbChecked
      TabOrder = 2
    end
    object StartLoginCheckBox: TCheckBox
      AlignWithMargins = True
      Left = 10
      Top = 29
      Width = 392
      Height = 17
      Margins.Left = 10
      Align = alTop
      Caption = 'Start by login'
      TabOrder = 3
    end
    object StartRpcCheckBox: TCheckBox
      AlignWithMargins = True
      Left = 10
      Top = 101
      Width = 392
      Height = 17
      Margins.Left = 10
      Align = alTop
      Caption = 'Start RPC at program start'
      TabOrder = 4
    end
    object StartMinimizedCheckBox: TCheckBox
      AlignWithMargins = True
      Left = 10
      Top = 52
      Width = 392
      Height = 17
      Margins.Left = 10
      Align = alTop
      Caption = 'Start minimized'
      TabOrder = 5
    end
    object DisableSslCheckBox: TCheckBox
      AlignWithMargins = True
      Left = 10
      Top = 296
      Width = 392
      Height = 17
      Margins.Left = 10
      Align = alTop
      Caption = 'Disable RPC SSL'
      Checked = True
      State = cbChecked
      TabOrder = 6
    end
    object LogLevelComboBox: TComboBox
      AlignWithMargins = True
      Left = 10
      Top = 721
      Width = 385
      Height = 21
      Margins.Left = 10
      Margins.Right = 10
      Align = alTop
      Style = csDropDownList
      TabOrder = 7
      Items.Strings = (
        '0'
        '1'
        '2'
        '3'
        '4')
    end
    object WalletPasswordEdit: TEdit
      AlignWithMargins = True
      Left = 10
      Top = 609
      Width = 385
      Height = 21
      Margins.Left = 10
      Margins.Right = 10
      Align = alTop
      PasswordChar = '*'
      TabOrder = 8
    end
    object RpcIpEdit: TEdit
      AlignWithMargins = True
      Left = 10
      Top = 226
      Width = 385
      Height = 21
      Margins.Left = 10
      Margins.Right = 10
      Align = alTop
      TabOrder = 9
      Text = '127.0.0.1'
    end
    object RpcPortEdit: TEdit
      AlignWithMargins = True
      Left = 10
      Top = 269
      Width = 385
      Height = 21
      Margins.Left = 10
      Margins.Right = 10
      Align = alTop
      TabOrder = 10
      Text = '18081'
    end
    object RemoteNodeEdit: TEdit
      AlignWithMargins = True
      Left = 10
      Top = 478
      Width = 385
      Height = 21
      Margins.Left = 10
      Margins.Right = 10
      Align = alTop
      TabOrder = 11
      Text = 'https://xmr-node.cakewallet.com:18081'
    end
    object MaxLogLinesEdit: TEdit
      AlignWithMargins = True
      Left = 10
      Top = 678
      Width = 385
      Height = 21
      Margins.Left = 10
      Margins.Right = 10
      Align = alTop
      NumbersOnly = True
      TabOrder = 12
      Text = '500'
    end
    object AddOptionsMemo: TMemo
      AlignWithMargins = True
      Left = 10
      Top = 381
      Width = 385
      Height = 49
      Margins.Left = 10
      Margins.Right = 10
      Align = alTop
      ScrollBars = ssBoth
      TabOrder = 13
    end
    object ExeFileEdit: TEdit
      AlignWithMargins = True
      Left = 10
      Top = 140
      Width = 385
      Height = 21
      Margins.Left = 10
      Margins.Right = 10
      Align = alTop
      TabOrder = 14
    end
    object SelectExeButton: TButton
      Left = 166
      Top = 713
      Width = 24
      Height = 24
      Caption = '...'
      TabOrder = 15
      OnClick = SelectExeButtonClick
    end
    object ConfigFileEdit: TEdit
      AlignWithMargins = True
      Left = 10
      Top = 183
      Width = 385
      Height = 21
      Margins.Left = 10
      Margins.Right = 10
      Align = alTop
      TabOrder = 16
    end
    object SelectConfigButton: TButton
      Left = 196
      Top = 713
      Width = 24
      Height = 24
      Caption = '...'
      TabOrder = 17
      OnClick = SelectConfigButtonClick
    end
    object SelectWalletButton: TButton
      Left = 136
      Top = 713
      Width = 24
      Height = 24
      Caption = '...'
      TabOrder = 18
      OnClick = SelectWalletButtonClick
    end
    object WalletFileEdit: TEdit
      AlignWithMargins = True
      Left = 10
      Top = 566
      Width = 385
      Height = 21
      Margins.Left = 10
      Margins.Right = 10
      Align = alTop
      TabOrder = 19
    end
  end
end
