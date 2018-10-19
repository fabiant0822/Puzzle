unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Grids, StdCtrls, Buttons, Menus, ComCtrls, ActnList,
  ExtDlgs, MMSystem;

type
  TForm1 = class(TForm)
    MainMenu1: TMainMenu;
    Puzzle1: TMenuItem;
    MNPNew: TMenuItem;
    N1: TMenuItem;
    MNPExit: TMenuItem;
    StatusBar1: TStatusBar;
    ScrollBox1: TScrollBox;
    DrawGrid1: TDrawGrid;
    Splitter1: TSplitter;
    ScrollBox2: TScrollBox;
    Image1: TImage;
    MNPLoadImage: TMenuItem;
    OpenPictureDialog1: TOpenPictureDialog;
    Splitter2: TSplitter;
    MNPPause: TMenuItem;
    Help1: TMenuItem;
    MNHAbout: TMenuItem;
    N2: TMenuItem;
    MNPFinishPuzzle: TMenuItem;
    procedure MNPExitClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCanResize(Sender: TObject; var NewWidth,
      NewHeight: Integer; var Resize: Boolean);
    procedure DrawGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
      vRect: TRect; State: TGridDrawState);
    procedure DrawGrid1DblClick(Sender: TObject);
    procedure MNPLoadImageClick(Sender: TObject);
    procedure MNPNewClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure MNPPauseClick(Sender: TObject);
    procedure MNPFinishPuzzleClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TPointRecord=Record
   X,Y,
   SortIndex:Integer;
   Empty:Boolean;
  end;

Const
  MaxWidth:Integer=370;
  MaxHeight:Integer=370;

var
  Form1: TForm1;

  Main:Record
   ColCount,
   RowCount,
   ColWidth,
   RowHeight:Integer;
   Points:Array of Array of TPointRecord;
   Bitmap:TBitmap;
  end;

  PuzzleCell:Array of Array of TPointRecord;
  ClippedCell :TPoint;
  Clipped     :Boolean;
  GameStatue  :(GameFinished,GameWinned,GamePlaying,GamePaused);
  SCBLastWidth,
  Second      :Integer;

  procedure ShufflePuzzle;
  procedure PlayWave(SEF:String);

implementation

uses Math, Unit2;

{$R *.dfm}
{$R BITMAP.RES}
{$R WAVES.RES}

function SoundEnabled:Boolean;
begin
 Result:=(waveOutGetNumDevs > 0);
end;

procedure PlayWave(SEF:String);
begin
 if SoundEnabled then PlaySound(PChar(SEF),HInstance,SND_ASYNC
                                 or SND_MEMORY or SND_RESOURCE);
end;

function ResizeBitmap(vBitmap:TBitmap;vWidth,vHeight:Integer):TBitmap;
begin
 Result:=TBitmap.Create;
 Result.Width:=vWidth;
 Result.Height:=vHeight;
 SetStretchBltMode(Result.Canvas.Handle,COLORONCOLOR);
 StretchBlt(Result.Canvas.Handle,0,0,vWidth,vHeight,vBitmap.Canvas.Handle,0,0,vBitmap.Width,vBitmap.Height,SRCCOPY);
end;

procedure ShufflePuzzle;
var Col,Row,SI,C,R:Integer;
begin
 with Form1,Main do
  begin
   Randomize;
   ColWidth:=Bitmap.Width Div ColCount;
   RowHeight:=Bitmap.Height Div RowCount;
   SetLength(Main.Points,ColCount,RowCount);
   SetLength(PuzzleCell,ColCount,RowCount);
   SI:=0;
   for Row:=0 to RowCount-1 do
    begin
     for Col:=0 to ColCount-1 do
      begin
       Points[Col,Row].SortIndex:=SI;
       Points[Col,Row].Empty:=False;
       Points[Col,Row].X:=Col*ColWidth;
       Points[Col,Row].Y:=Row*RowHeight;
       Inc(SI);
      end;
    end;
   for Row:=0 to RowCount-1 do
    begin
     for Col:=0 to ColCount-1 do
      begin
       repeat
        C:=Random(ColCount);
        R:=Random(RowCount);
        PuzzleCell[Col,Row].Empty:=True;
        PuzzleCell[Col,Row]:=Points[C,R];
        Points[C,R].Empty:=True;
       Until PuzzleCell[Col,Row].Empty=False;
      end;
    end;
   DrawGrid1.ColCount:=ColCount;
   DrawGrid1.RowCount:=RowCount;
   GameStatue:=GamePlaying;
   MNPPause.Enabled:=(GameStatue=GamePlaying);
   DrawGrid1.Refresh;
   StatusBar1.SimpleText:='Dupla kattint�ssal indul a j�t�k!';
  end;
 Second:=0;
end;

function PuzzleWinned:Boolean;
var C,R,SI:Integer;
begin
 SI:=0;
 Result:=False;
 for R:=0 to Main.RowCount-1 do
  begin
   for C:=0 to Main.ColCount-1 do
    begin
     if PuzzleCell[C,R].SortIndex <> SI then Exit;
     Inc(SI);
    end;
  end;
 Result:=True;
 GameStatue:=GameWinned; 
 Form1.MNPPause.Enabled:=(GameStatue=GamePlaying);
end;

procedure TForm1.MNPExitClick(Sender: TObject);
begin
 Form1.Close
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
 With Main do
  begin
   Bitmap:=TBitmap.Create;
   Bitmap.LoadFromResourceName(HInstance,'IMAGE');
   ColCount:=4;
   RowCount:=4;
   ShufflePuzzle;
   Image1.Picture.Bitmap:=Bitmap;
  end;
 ScrollBox1.Width:=Form1.Width Div 2;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 Main.Bitmap.Free;
end;

procedure TForm1.FormCanResize(Sender: TObject; var NewWidth,
  NewHeight: Integer; var Resize: Boolean);
begin
 ScrollBox1.Width:=Round((ScrollBox1.Width / Form1.Width) * NewWidth);
end;

procedure TForm1.DrawGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
  vRect: TRect; State: TGridDrawState);
var SRect:Trect;
begin
 with DrawGrid1 do
  begin
   ColWidths[ACol]:=Main.ColWidth;
   RowHeights[ARow]:=Main.RowHeight;
   if PuzzleCell[ACol,ARow].Empty then
    begin
     Canvas.Pen.Color:=clWhite;
     Canvas.Brush.Color:=clWhite;
     Canvas.FillRect(vRect);
    end
   else
    begin
     SRect:=Rect(PuzzleCell[ACol,ARow].X,
                 PuzzleCell[ACol,ARow].Y,
                 PuzzleCell[ACol,ARow].X+Main.ColWidth,
                 PuzzleCell[ACol,ARow].Y+Main.RowHeight);
     Canvas.CopyRect(vRect,Main.Bitmap.Canvas,SRect);
     if GameStatue=GameFinished then
      begin
       if PuzzleCell[ACol,ARow].SortIndex = ACol+(ARow*ColCount) then
            Canvas.Font.Color:=clLime
       else
            Canvas.Font.Color:=clRed;
       Canvas.Font.Name:='Arial Black';
       Canvas.Brush.Color:=clBlack;
       Canvas.TextOut(vRect.Left,vRect.Top,IntToStr(PuzzleCell[ACol,ARow].SortIndex));
      end;
    end;
   if gdSelected in State then
    begin
     Canvas.Brush.Color:=clBlue;
     Canvas.FrameRect(vRect);
    end;
  end;
end;

procedure TForm1.DrawGrid1DblClick(Sender: TObject);
var vCell:TPointRecord;
begin
 If GameStatue <> GamePlaying then Exit;
 With DrawGrid1 do
  begin
   if Clipped then
    begin
     vCell:=PuzzleCell[Col,Row];
     PuzzleCell[Col,Row]:=PuzzleCell[ClippedCell.X,ClippedCell.Y];
     PuzzleCell[Col,Row].Empty:=False;
     PuzzleCell[ClippedCell.X,ClippedCell.Y]:=vCell;
     PuzzleCell[ClippedCell.X,ClippedCell.Y].Empty:=False;
     Clipped:=False;
     DrawGrid1.Cursor:=crDefault;
     Form1.Cursor:=crDefault;
     ScrollBox2.Cursor:=crDefault;
     Image1.Cursor:=crDefault;
     PlayWave('Drop');
     if PuzzleWinned then
      begin
       Refresh;
       PlayWave('Win');
       ShowMessage('Gratul�lok! �gyes vagy!'+#13
                  +StatusBar1.SimpleText);
       StatusBar1.SimpleText:='';
       GameStatue:=GameWinned;
       MNPPause.Enabled:=(GameStatue=GamePlaying);
       Form1.StatusBar1.SimpleText:='V�ge a j�t�knak!. Nyomd '+ShortCutToText(Form1.MNPNew.ShortCut)+' meg az �j j�t�k gombot.';
       MNPNewClick(MNPNew);
      end;
    end
   else
    begin
     PuzzleCell[Col,Row].Empty:=True;
     ClippedCell.X:=Col;
     ClippedCell.Y:=Row;
     Clipped:=True;
     DrawGrid1.Cursor:=crDrag;
     Form1.Cursor:=crNoDrop;
     ScrollBox2.Cursor:=crNoDrop;
     Image1.Cursor:=crNoDrop;
     PlayWave('Clip');
    end;
   Refresh;
  end;
end;

procedure TForm1.MNPLoadImageClick(Sender: TObject);
var W,H:Integer;
    vBitmap:TBitmap;
begin
 if GameStatue=GamePlaying then GameStatue:=GamePaused;
 if OpenPictureDialog1.Execute then
  begin
   try
    vBitmap:=TBitmap.Create;
    vBitmap.LoadFromFile(OpenPictureDialog1.FileName);
    W:=MaxWidth;
    H:=Round(vBitmap.Height / vBitmap.Width * W);
    Main.Bitmap:=ResizeBitmap(vBitmap,W,H);
   except
    raise EFilerError.CreateFmt('Nem tudom megnyitni a f�jlt!',[]);
   end;
   MNPNewClick(MNPNew);
   Image1.Picture.Bitmap:=Main.Bitmap;
  end;
 if GameStatue=GamePaused then GameStatue:=GamePlaying;
end;

procedure TForm1.MNPNewClick(Sender: TObject);
begin
 if GameStatue=GamePlaying then GameStatue:=GamePaused;
 with newpuzzleform do
  begin
   SpinEdit1.MaxValue:=Main.Bitmap.Width Div 20;
   SpinEdit2.MaxValue:=Main.Bitmap.Height Div 20;
   SpinEdit1.Value:=4;
   SpinEdit2.Value:=4;
   ShowModal;
  end;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
 if GameStatue <> GamePlaying then Exit;
 StatusBar1.SimpleText:='Elapsed Time: '
                       +IntToStr(Second Div 3600)+':'
                       +IntToStr((Second Mod 3600) Div 60)+':'
                       +IntToStr(Second Mod 60);
 Inc(Second);
end;

procedure TForm1.MNPPauseClick(Sender: TObject);
begin
 GameStatue:=GamePaused;
 ShowMessage('J�t�k meg�ll�tva! Folytat�s: OK.');
 GameStatue:=GamePlaying;
end;

procedure TForm1.MNPFinishPuzzleClick(Sender: TObject);
begin
 if (GameStatue<>GamePlaying)or(MessageBox(Handle,'Biztosan befejezed ezt a puzzle-t?',
                      'Puzzle befejezve!',
                      MB_YESNO) <> ID_YES) then Exit;
 PlayWave('Finish');
 StatusBar1.SimpleText:='V�ge a j�t�knak!. Nyomd '+ShortCutToText(Form1.MNPNew.ShortCut)+' meg az �j j�t�k gombot.';
 GameStatue:=GameFinished;
 MNPPause.Enabled:=(GameStatue=GamePlaying);
 DrawGrid1.Refresh;
end;

end.
