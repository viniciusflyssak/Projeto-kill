object TaskKiller: TTaskKiller
  Left = 598
  Top = 266
  BorderStyle = bsSingle
  Caption = 'TaskKiller'
  ClientHeight = 138
  ClientWidth = 187
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  PixelsPerInch = 96
  TextHeight = 13
  object pnlfundo: TPanel
    Left = 0
    Top = 0
    Width = 187
    Height = 138
    Align = alClient
    TabOrder = 0
    object lblTask: TLabel
      Left = 40
      Top = 16
      Width = 26
      Height = 13
      Caption = 'Task:'
    end
    object BtnKill: TButton
      Left = 40
      Top = 81
      Width = 91
      Height = 41
      Caption = 'Kill'
      TabOrder = 1
      OnClick = BtnKillClick
    end
    object edtTask: TEdit
      Left = 40
      Top = 40
      Width = 121
      Height = 21
      TabOrder = 0
      OnKeyPress = edtTaskKeyPress
    end
  end
end
