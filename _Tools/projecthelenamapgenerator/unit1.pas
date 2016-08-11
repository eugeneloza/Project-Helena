unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls;

const maxmaxx=113;
      maxmaxy=113;
      rndaccuracy=254;

type

  { TForm1 }

  TForm1 = class(TForm)
    Image1: TImage;
    procedure FormCreate(Sender: TObject);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { private declarations }
  public
    { public declarations }
  end;

type maptype=array[1..maxmaxx,1..maxmaxy] of byte;

var
  Form1: TForm1;
  maxx,maxy:integer;
  map,rnd:maptype;   //rnd -> wall probability is rnd/rndaccuracy;
  file1:file of byte;   // maxx,maxy,map...,rnd...

implementation

{$R *.lfm}

{ TForm1 }

procedure clear_map(value,rndvalue:integer);
var ix,iy:integer;
begin
 for ix:=1 to maxmaxx do
  for iy:=1 to maxmaxy do begin
    map[ix,iy]:=value;
    rnd[ix,iy]:=rndvalue;
  end;
end;

procedure TForm1.Image1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var mapx,mapy:integer;
    placevalue_map,placevalue_rnd:byte;
begin
  mapx:=round(x/image1.width*maxx);
  mapy:=round(y/image1.height*maxy);
  if button=mbright then begin
    placevalue_map:=1;
    placevalue_rnd:=1;
  end else if button=mbleft then begin
    placevalue_map:=1;
    placevalue_rnd:=1;
  end else begin
    placevalue_map:=1;
    placevalue_rnd:=1;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  clear_map(0,0);
  maxx:=maxmaxx;
  maxy:=maxmaxy;
end;

end.

