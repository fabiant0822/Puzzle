unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Spin, Menus;

type
  TNewPuzzleForm = class(TForm)
    SpinEdit1: TSpinEdit;
    SpinEdit2: TSpinEdit;
    Label1: TLabel;
    Label2: TLabel;
    Button1: TButton;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  NewPuzzleForm: TNewPuzzleForm;

implementation

uses Unit1;

{$R *.dfm}

procedure TNewPuzzleForm.Button1Click(Sender: TObject);
begin
 if (SpinEdit1.Value=1) and (SpinEdit2.Value=1) then
  begin
   ShowMessage('Ez komoly?! 1 x 1 puzzle?'+#13
             +'(Minek? :D)');
   Exit
  end;
 Main.ColCount:=SpinEdit1.Value;
 Main.RowCount:=SpinEdit2.Value;
 ShufflePuzzle;
 NewPuzzleForm.Close;
end;

procedure TNewPuzzleForm.Button2Click(Sender: TObject);
begin
 NewPuzzleForm.Close;
end;

procedure TNewPuzzleForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 if GameStatue=GamePaused then GameStatue:=GamePlaying;
end;

end.
