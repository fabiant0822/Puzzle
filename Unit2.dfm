object NewPuzzleForm: TNewPuzzleForm
  Left = 192
  Top = 114
  BorderStyle = bsDialog
  Caption = 'New Game'
  ClientHeight = 78
  ClientWidth = 215
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 16
    Width = 47
    Height = 18
    Caption = 'Feloszt'#225's:'
  end
  object Label2: TLabel
    Left = 126
    Top = 18
    Width = 7
    Height = 13
    Caption = 'X'
  end
  object SpinEdit1: TSpinEdit
    Left = 64
    Top = 13
    Width = 56
    Height = 22
    MaxValue = 0
    MinValue = 1
    TabOrder = 1
    Value = 1
  end
  object SpinEdit2: TSpinEdit
    Left = 140
    Top = 13
    Width = 56
    Height = 22
    MaxValue = 0
    MinValue = 1
    TabOrder = 2
    Value = 1
  end
  object Button1: TButton
    Left = 120
    Top = 40
    Width = 75
    Height = 25
    Caption = '&Ok'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 32
    Top = 40
    Width = 75
    Height = 25
    Caption = '&Cancel'
    TabOrder = 3
    OnClick = Button2Click
  end
end
