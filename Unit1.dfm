object Form1: TForm1
  Left = 95
  Top = 118
  Caption = 'PUZZLE BY FBNT'
  ClientHeight = 502
  ClientWidth = 643
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  WindowState = wsMaximized
  OnCanResize = FormCanResize
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 313
    Top = 0
    Height = 483
    ExplicitHeight = 346
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 483
    Width = 643
    Height = 19
    Panels = <>
  end
  object ScrollBox1: TScrollBox
    Left = 0
    Top = 0
    Width = 313
    Height = 483
    Align = alLeft
    TabOrder = 1
    object DrawGrid1: TDrawGrid
      Left = 0
      Top = 0
      Width = 309
      Height = 479
      Align = alClient
      ColCount = 4
      FixedCols = 0
      RowCount = 4
      FixedRows = 0
      TabOrder = 0
      OnDblClick = DrawGrid1DblClick
      OnDrawCell = DrawGrid1DrawCell
      ColWidths = (
        64
        64
        64
        64)
      RowHeights = (
        24
        24
        24
        24)
    end
  end
  object ScrollBox2: TScrollBox
    Left = 316
    Top = 0
    Width = 327
    Height = 483
    Align = alClient
    TabOrder = 2
    object Image1: TImage
      Left = 4
      Top = 3
      Width = 245
      Height = 102
      AutoSize = True
    end
    object Splitter2: TSplitter
      Left = 0
      Top = 476
      Width = 323
      Height = 3
      Cursor = crVSplit
      Align = alBottom
      ExplicitTop = 253
      ExplicitWidth = 311
    end
  end
  object MainMenu1: TMainMenu
    Left = 24
    Top = 192
    object Puzzle1: TMenuItem
      Caption = '&Puzzle'
      object MNPNew: TMenuItem
        Caption = '&'#218'j j'#225't'#233'k'
        ShortCut = 113
        OnClick = MNPNewClick
      end
      object MNPLoadImage: TMenuItem
        Caption = '&K'#233'p bet'#246'lt'#233'se'
        ShortCut = 114
        OnClick = MNPLoadImageClick
      end
      object MNPPause: TMenuItem
        Caption = '&Sz'#252'net'
        RadioItem = True
        ShortCut = 115
        OnClick = MNPPauseClick
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object MNPFinishPuzzle: TMenuItem
        Caption = 'Befejez'#233's'
        ShortCut = 121
        OnClick = MNPFinishPuzzleClick
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object MNPExit: TMenuItem
        Caption = '&Bez'#225'r'#225's'
        ShortCut = 32883
        OnClick = MNPExitClick
      end
    end
    object Help1: TMenuItem
      Caption = '&Help'
      object MNHAbout: TMenuItem
        Caption = '&About ...'
        ShortCut = 112
      end
    end
  end
  object OpenPictureDialog1: TOpenPictureDialog
    Filter = 'Bitmap Images|*.BMP'
    Left = 112
    Top = 192
  end
end
