unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, ComCtrls;

const maxmaxx=75;
      maxmaxy=75;
      rndaccuracy=100;

type float=double;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    ComboBox1: TComboBox;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    RadioButton1: TRadioButton;
    RadioButton10: TRadioButton;
    RadioButton11: TRadioButton;
    RadioButton12: TRadioButton;
    RadioButton13: TRadioButton;
    RadioButton14: TRadioButton;
    RadioButton15: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    RadioButton4: TRadioButton;
    RadioButton5: TRadioButton;
    RadioButton6: TRadioButton;
    RadioButton7: TRadioButton;
    RadioButton8: TRadioButton;
    RadioButton9: TRadioButton;
    RadioGroup1: TRadioGroup;
    RadioGroup2: TRadioGroup;
    RadioGroup3: TRadioGroup;
    TrackBar1: TTrackBar;
    TrackBar2: TTrackBar;
    TrackBar3: TTrackBar;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Image1DragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);

    procedure draw_map;
    procedure clear_map(value,rndvalue:integer);
    procedure Image1MouseLeave(Sender: TObject);
    procedure Image1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer
      );
    procedure Image1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure refreshfileslist;
    procedure updatemap(button:byte;x,y:integer);
  private
    { private declarations }
  public
    { public declarations }
  end;

type maptype=array[1..maxmaxx,1..maxmaxy] of byte;
type maptypeboolean=array[1..maxmaxx,1..maxmaxy] of boolean;

var
  Form1: TForm1;
  maxx,maxy:integer;
  map,rnd:maptype;   //rnd -> wall probability is rnd/rndaccuracy;
  map_changed:maptypeboolean;
  draw_map_all:boolean;
  oldbutton:byte;
  filechanged:boolean;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.refreshfileslist;
var Path:string;
    Rec : TSearchRec;
begin
  combobox1.clear;
  Path:=ExtractFilePath(application.ExeName){+pathdelim}+'MAP'+pathdelim;
  if FindFirst (Path + '*.HMP', faAnyFile - faDirectory, Rec) = 0 then begin
    button3.enabled:=true;
    try
    repeat
      Combobox1.Items.Add(Rec.Name) ;
    until FindNext(Rec) <> 0;
    finally
      FindClose(Rec) ;
    end;
    combobox1.itemindex:=0;
  end else button3.enabled:=false;
end;

procedure TForm1.clear_map(value,rndvalue:integer);
var ix,iy:integer;
begin
 for ix:=1 to maxmaxx do
  for iy:=1 to maxmaxy do begin
    map[ix,iy]:=value;
    rnd[ix,iy]:=rndvalue;
  end;
 draw_map_all:=true;
 draw_map;
end;

procedure TForm1.Image1MouseLeave(Sender: TObject);
begin
  oldbutton:=0;
end;

procedure TForm1.Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if oldbutton>0 then updatemap(oldbutton,x,y);
end;

procedure TForm1.Image1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  oldbutton:=0;
end;

procedure Tform1.updatemap(button:byte;x,y:integer);
var mapx,mapy:integer;
    placevalue_map,placevalue_rnd:byte;
begin
  filechanged:=true;
  mapx:=round(x/image1.width*maxx+0.5);
  mapy:=round(y/image1.height*maxy+0.5);
  if mapx<1 then mapx:=1;
  if mapx>maxx then mapx:=maxx;
  if mapy<1 then mapy:=1;
  if mapy>maxy then mapy:=maxy;

  if button=1 then begin
    if radiobutton1.checked then placevalue_map:=1;
    if radiobutton2.checked then placevalue_map:=2;
    if radiobutton3.checked then placevalue_map:=3;
    if radiobutton4.checked then placevalue_map:=4;
    if radiobutton5.checked then placevalue_map:=0;
    placevalue_rnd:=round(100*trackbar1.position/trackbar1.max);
  end else if button=2 then begin
    if radiobutton6.checked then placevalue_map:=1;
    if radiobutton7.checked then placevalue_map:=2;
    if radiobutton8.checked then placevalue_map:=3;
    if radiobutton9.checked then placevalue_map:=4;
    if radiobutton10.checked then placevalue_map:=0;
    placevalue_rnd:=round(100*trackbar2.position/trackbar2.max);
  end else if button=3 then begin
    if radiobutton11.checked then placevalue_map:=1;
    if radiobutton12.checked then placevalue_map:=2;
    if radiobutton13.checked then placevalue_map:=3;
    if radiobutton14.checked then placevalue_map:=4;
    if radiobutton15.checked then placevalue_map:=0;
    placevalue_rnd:=round(100*trackbar3.position/trackbar3.max);
  end;

  map[mapx,mapy]:=placevalue_map;
  rnd[mapx,mapy]:=placevalue_rnd;
  map_changed[mapx,mapy]:=true;

  draw_map;
end;

procedure TForm1.Image1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
 case button of
   mbleft: oldbutton:=1;
   mbright: oldbutton:=2;
   mbmiddle: oldbutton:=3;
 end;
 updatemap(oldbutton,x,y);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  maxx:=16;
  maxy:=16;
  Form1.DoubleBuffered:=true;
  oldbutton:=0;
  refreshfileslist;
  filechanged:=false;
  clear_map(0,0);
end;

procedure TForm1.Image1DragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin

end;

procedure TForm1.Button1Click(Sender: TObject);
var tmp1,tmp2:integer;
begin
  val(edit1.text,tmp1,tmp2);
  if (tmp1<3) or (tmp1>maxmaxx) or (tmp2<>0) then edit1.text:=inttostr(maxx) else maxx:=tmp1;
  val(edit2.text,tmp1,tmp2);
  if (tmp1<3) or (tmp1>maxmaxy) or (tmp2<>0) then edit2.text:=inttostr(maxy) else maxy:=tmp1;

  draw_map_all:=true;
  draw_map;
end;

procedure TForm1.Button2Click(Sender: TObject);
var filename:string;
    f1:file of byte;   // maxx,maxy,map...,rnd...
    ix,iy:integer;
begin
  filename:=ExtractFilePath(application.ExeName)+'MAP'+pathdelim+edit3.text+'.HMP';
//  memo1.lines.add(filename);
  Assignfile(f1,filename);
  Rewrite(f1);

  write(f1,maxx);
  write(f1,maxy);
  for ix:=1 to maxx do
   for iy:=1 to maxy do write(f1,map[ix,iy]);
  for ix:=1 to maxx do
   for iy:=1 to maxy do write(f1,rnd[ix,iy]);
  write(f1,0);  //entrance_x
  write(f1,0);  //entrance_y

  closefile(f1);

  filechanged:=false;

  refreshfileslist;
end;

procedure TForm1.Button3Click(Sender: TObject);
var filename:string;
    f1:file of byte;   // maxx,maxy,map...,rnd...
    ix,iy:integer;
    tmp:byte;
begin
 filename:=ExtractFilePath(application.ExeName)+'MAP'+pathdelim+combobox1.Items[combobox1.itemindex];
// memo1.lines.add(filename);
 Assignfile(f1,filename);
 Reset(f1);

 Read(f1,tmp); maxx:=tmp;
 Read(f1,tmp); maxy:=tmp;
 for ix:=1 to maxx do
  for iy:=1 to maxy do Read(f1,map[ix,iy]);
 for ix:=1 to maxx do
  for iy:=1 to maxy do Read(f1,rnd[ix,iy]);
// Read(f1,0);  //entrance_x
// Read(f1,0);  //entrance_y

 closefile(f1);

 edit1.text:=inttostr(maxx);
 edit2.text:=inttostr(maxy);
 filechanged:=false;
 draw_map_all:=true;
 draw_map;
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  clear_map(0,0);
end;

procedure TForm1.Button5Click(Sender: TObject);
var tmpmap1,tmpmap2:maptype;
    ix,iy:integer;
begin
  tmpmap1:=map;
  tmpmap2:=rnd;

  ix:=maxx;
  maxx:=maxy;
  maxy:=ix;

  for ix:=1 to maxx do
   for iy:=1 to maxy do begin
     map[ix,iy]:=tmpmap1[iy,ix];
     rnd[ix,iy]:=tmpmap2[iy,ix];
   end;

  edit1.text:=inttostr(maxx);
  edit2.text:=inttostr(maxy);
  draw_map_all:=true;
  draw_map;
end;

procedure TForm1.draw_map;
var ix,iy:integer;
    scalex,scaley:float;
    brushcol,pencol:integer;
    c1,c2:byte;
begin
  with image1.canvas do begin
    scalex:=image1.width/maxx;
    scaley:=image1.height/maxy;
    pen.width:=0;
    for ix:=1 to maxx do
      for iy:=1 to maxy do if (map_changed[ix,iy]) or (draw_map_all) then begin
        c1:=255*rnd[ix,iy] div rndaccuracy;
        c2:=(128+4*c1) div 5;
        case map[ix,iy] of
          0: begin pencol:=c1+c1*256+c1*65536; brushcol:=c2+c2*256+c2*65536; end;
          1: begin pencol:=c1 div 2 +c1 div 2*256+c1*65536; brushcol:=c2 div 2+c2 div 2*256+c2*65536; end;
          2: begin pencol:=c1+c1 div 2 *256+c1 div 2*65536; brushcol:=c2+c2 div 2*256+c2 div 2*65536; end;
          3: begin pencol:=c1 div 2 +c1*256+c1 div 2*65536; brushcol:=c2 div 2+c2*256+c2 div 2*65536; end;
          4: begin pencol:=c1 +c1 div 2*256+c1*65536; brushcol:=c2+c2 div 2*256+c2*65536; end;
        end;
        brush.color:=brushcol;
        pen.color:=pencol;
        Rectangle(round((ix-1)*scalex),round((iy-1)*scaley),round((ix)*scalex)+1,round((iy)*scaley)+1);
        map_changed[ix,iy]:=false;
      end;
 end;
 draw_map_all:=false;
end;

end.

