unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, ComCtrls, types;

const maxmaxx={113}226;  //max 'reasonable' 50x50
      minmaxx=20;
      maxmaxy=maxmaxx;
      maxbots=500;
      maxzoom=50;

      maxplayers=16;          // max 16 fit in bunker

      backpacksize=12;
      changeweapontime=100;
      //fixweapontime=255;
      dropitemtime=20;
      pickupitemtime=40;

      blastpush=10;

      maxitems=maxbots*backpacksize+100;
      maxonfloor=50; // max displayed onfloor items
      maxunitslist=maxbots;

      minimumtuusable=29;

      playerbotmovedelay=100;     {ms}
      enemybotmovedelay=300;      {ms}
      shotdelay=200;              {ms}
      blastdelay=500;              {ms}

      defensedifficulty=5;

const itemdamagerate=0.4;           //40% damage taken by armed weapon

const maxbot_hp_const=3000;
      maxplayer_hp_const=3000;

const action_attack=1;
      action_random=2;
      action_guard=3;

      group_attack_range=25; //sqr

const visiblerange=32;
      visibleaccuracy=10;
      accuracy_accuracy=10;
      oldvisible=1;
      maxvisible=100;

      maxangle=200;

const playermovementdelay=0;

const player=1;
      computer=2;

const map_free=0;
      map_smoke=15;
      map_wall=16;

const gamemode_game=255;
      gamemode_help=1;
      gamemode_none=0;
      gamemode_victory=254;
      gamemode_defeat=101;

type float=double;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    ComboBox1: TComboBox;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    Image5: TImage;
    Image6: TImage;
    Image7: TImage;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Memo1: TMemo;
    ProgressBar1: TProgressBar;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    ScrollBar1: TScrollBar;
    ScrollBar2: TScrollBar;
    ScrollBar3: TScrollBar;
    ScrollBar4: TScrollBar;
    Togglebox1: TToggleBox;
    TrackBar1: TTrackBar;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Edit4Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer
      );
    procedure Image3MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image3MouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure Image4MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image4MouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure Image5MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image5MouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure Image6MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image6MouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure Image7MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Togglebox1Change(Sender: TObject);
    procedure ScrollBar1Change(Sender: TObject);
    procedure ScrollBar2Change(Sender: TObject);
    procedure ScrollBar3Change(Sender: TObject);
    procedure ScrollBar4Change(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);

  private
    { private declarations }
  public
    procedure generate_map;
    procedure generate_items_types;
    procedure draw_map;
    procedure draw_stats;
    procedure look_around(thisbot:integer);
    procedure clear_visible;
    function generate_enemy_list:boolean;
    procedure generatemovement(thisbot,target_x,target_y:integer);
    procedure move_bot(thisbot,to_x,to_y,use_waypoints:integer);
    procedure end_turn;
    procedure bot_action(thisbot:integer);
    procedure start_turn;
    procedure set_progressbar(flg:boolean);
    procedure find_onfloor(x,y:integer);
    procedure grow_smoke;
    procedure bot_shots(attacker,defender:integer);
    function spend_tu(thisbot:integer;tus:byte):boolean;
    function load_weapon(thisbot,thisitem:integer):boolean;
    procedure pick_up(thisbot,thisitem:integer);
    procedure drop_item(thisbot,thisitem:integer);
    procedure setcontrols_menu(flg:boolean);
    procedure setcontrols_game(flg:boolean);
    procedure center_map(tox,toy:integer);
  end;

const maxmodifiers=2;
type item_type=record
  w_id:byte;                 //for weapons, 0 if pure ammo
  state,maxstate:byte;
  rechargestate:word;
//  w_modifier_type:array[1..maxmodifiers] of byte;
//  w_modifier_level:array[1..maxmodifiers] of shortint;

  ammo_id:byte;
  n:byte;
//  a_modifier_type:array[1..maxmodifiers] of byte;
//  a_modifier_level:array[1..maxmodifiers] of shortint;
end;

const maxusableammo=9;
type weapon_type=record
  name:string[30];
  ACC,DAM:byte;
  Recharge,Aim,Reload:byte;
  Maxstate:byte;
  AMMO:array[1..maxusableammo]of byte;
end;
type ammo_type=record
  name:string[30];
  quantity:byte;
  ACC,DAM:integer;
  EXPLOSION,AREA,SMOKE,TRACE_SMOKE:integer;
end;

type laying_item_type = record
  item:item_type;
  x,y:integer;
end;

type bottype=record
  name:string[30];
  action:byte;
  target:integer;
  hp,maxhp:word;
  tu:byte;
  speed:byte;
  angle:byte;
  x,y:integer;
  owner:integer;
  items:array[1..backpacksize]of item_type;
end;


{type TDrawMap = class(TThread)
  private

  protected
    procedure Execute; override;
  public
end;}

type map_array = array[1..maxmaxx,1..maxmaxy] of byte;

var
  Form1: TForm1;
{  MapDrawing: TDrawMap;     }

  map,vis,movement,mapchanged:^map_array;
  LOS_base:^map_array;
  mapfreespace:integer;
  averageLOS:float;
  maxx,maxy:integer;
  playersn:integer;
  viewx,viewy,viewsizex,viewsizey:integer;
  draw_map_all:boolean;
  mapgenerated:boolean;
  gamemode,previous_gamemode:byte;

  bot: array[1..maxbots] of bottype;
  playerunits,enemyunits:array[1..maxunitslist]of integer;
  playerunitsn,enemyunitsn:integer;

  item: array[1..maxitems] of laying_item_type;
  itemsn:integer;
  onfloor: array[1..maxonfloor] of integer;
  onfloorn:byte;
  weapon_specifications: array[1..255] of weapon_type;
  ammo_specifications: array[1..255] of ammo_type;
  //other items 200...255;

  nbot: integer;
  selected,selectedenemy,selectedx,selectedy,selecteditem,selectedonfloor: integer;
  current_turn,this_turn:integer;

  movement_map_for: integer;
  nx1,nx2,ny1,ny2:integer;

//  sintable,costable: array[0..maxangle] of float;

implementation

{$R+}{$Q+}

{$R *.lfm}

{ TForm1 }

{-----------------------------}

function sgn(value:integer):shortint;
begin
  if value>0 then sgn:= 1 else
  if value<0 then sgn:=-1 else
                  sgn:=0;
end;

{-----------------------------}

function RGB(intensity,r,g,b:byte):integer;
begin
 RGB:=round(r*intensity/255)+256*round(g*intensity/255)+65536*round(b*intensity/255)
end;

{================================================================================}
{================================================================================}
{================================================================================}

procedure Tform1.generatemovement(thisbot,target_x,target_y:integer); // generatenewmap,target
var ix,iy:integer;
    x1,x2,y1,y2:integer;
    nomoves:boolean;
    movement_new:^map_array;
begin
if (target_x>0) and (target_x<=maxx) and (target_y>0) and (target_y<=maxy) then begin
  new(movement_new);
 if movement_map_for<>thisbot then begin
  for ix:=1 to maxx do
    for iy:=1 to maxy do if map^[ix,iy]<=map_smoke then movement^[ix,iy]:=100 else movement^[ix,iy]:=255;

   if bot[thisbot].owner=player then begin
    for ix:=1 to maxx do
      for iy:=1 to maxy do if vis^[ix,iy]=0 then movement^[ix,iy]:=253;

    for ix:=1 to nbot do if bot[ix].hp>0 then begin
      if bot[ix].owner=player then movement^[bot[ix].x,bot[ix].y]:=254;
      if (bot[ix].owner=computer) and (vis^[bot[ix].x,bot[ix].y]>oldvisible) then movement^[bot[ix].x,bot[ix].y]:=254;
    end;
  end else
    for ix:=1 to nbot do if bot[ix].hp>0 then movement^[bot[ix].x,bot[ix].y]:=254;

  movement^[bot[thisbot].x,bot[thisbot].y]:=9;
  nx1:=bot[thisbot].x-1;
  ny1:=bot[thisbot].y-1;
  nx2:=bot[thisbot].x+1;
  ny2:=bot[thisbot].y+1;
  if nx1<=0 then nx1:=1;
  if ny1<=0 then ny1:=1;
  if nx2>maxx then nx2:=maxx;
  if ny2>maxy then ny2:=maxy;
 end;

  movement_new^:=movement^;


  repeat
    nomoves:=true;
    x1:=nx1;x2:=nx2;
    y1:=ny1;y2:=ny2;
    for ix:=x1 to x2 do
      for iy:=y1 to y2 do if movement^[ix,iy]=100 then begin
        if ix-1>0 then begin
          if iy-1>0 then
            if movement^[ix-1,iy-1]<10 then movement_new^[ix,iy]:=7;
          if iy+1<=maxy then
            if movement^[ix-1,iy+1]<10 then movement_new^[ix,iy]:=1;
          if movement^[ix-1,iy]<10 then movement_new^[ix,iy]:=8;
        end;
        if ix+1<=maxx then begin
          if iy-1>0 then
            if movement^[ix+1,iy-1]<10 then movement_new^[ix,iy]:=5;
          if iy+1<=maxy then
            if movement^[ix+1,iy+1]<10 then movement_new^[ix,iy]:=3;
          if movement^[ix+1,iy]<10 then movement_new^[ix,iy]:=4;
        end;
        if iy-1>0 then
          if movement^[ix,iy-1]<10 then movement_new^[ix,iy]:=6;
        if iy+1<=maxy then
          if movement^[ix,iy+1]<10 then movement_new^[ix,iy]:=2;
        if movement_new^[ix,iy]<>100 then begin
          nomoves:=false;
          if (ix=nx1) and ((nx1-1)>0) then nx1:=nx1-1;
          if (iy=ny1) and ((ny1-1)>0) then ny1:=ny1-1;
          if (ix=nx2) and ((nx2+1)<=maxx) then nx2:=nx2+1;
          if (iy=ny2) and ((ny2+1)<=maxy) then ny2:=ny2+1;
        end;
      end;
     movement^:=movement_new^;
  until (nomoves) or (movement^[target_x,target_y]<10);
  dispose(movement_new);
  movement_map_for:=thisbot;
end;
end;

{================================================================================}
{================================================================================}
{================================================================================}

function check_LOS(x1,y1,x2,y2:integer):integer;
var dx,dy:integer;
    xx1,yy1:integer;
    range,maxrange:integer;
    L:integer;
begin
 L:=-1;
 if (x1>0) and (y1>0) and (x2>0) and (y2>0) and (x1<=maxx) and (y1<=maxy) and (x2<=maxx) and (y2<=maxy) then begin
  dx:=x2-x1;
  dy:=y2-y1;
  maxrange:=round(visibleaccuracy*sqrt(sqr(dx)+sqr(dy)))+1;
  L:=visiblerange*visibleaccuracy;
  range:=0;
  repeat
    inc(range);
    xx1:=x1+round(dx*range / maxrange);
    yy1:=y1+round(dy*range / maxrange);
    if map^[xx1,yy1]<=map_smoke then dec(L,map^[xx1,yy1]+2);
    if (map^[xx1,yy1]>map_smoke) and ((xx1<>x2) or (yy1<>y2)) then L:=-1;
  until (range>=maxrange) or (L<1);
 end;
 check_LOS:=L;

 end;

{================================================================================}
{================================================================================}
{================================================================================}

function Tform1.generate_enemy_list:boolean;
var i,j:integer;
    enemyunits_new:integer;
begin
  enemyunits_new:=0;
  for i:=1 to nbot do if (bot[i].owner=computer) and (bot[i].hp>0) and (enemyunits_new<maxunitslist) then
  if vis^[bot[i].x,bot[i].y]>oldvisible then begin
    inc(enemyunits_new);
    enemyunits[enemyunits_new]:=i;
    if bot[i].action=action_random then begin
      bot[i].action:=action_attack;
      for j:=1 to nbot do if (bot[j].owner=player) and (bot[j].hp>0) then bot[i].target:=j;
    end;
  end;
  if enemyunits_new<>enemyunitsn then generate_enemy_list:=true else generate_enemy_list:=false;
  enemyunitsn:=enemyunits_new;
end;

{================================================================================}
{================================================================================}
{================================================================================}


procedure Tform1.look_around(thisbot:integer);
var //visrange:integer;
    ix,iy:integer;
    LOS:integer;
begin
 if (bot[thisbot].owner=player) and (bot[thisbot].hp>0) then begin
   for ix:=bot[thisbot].x-visiblerange to bot[thisbot].x+visiblerange do
    for iy:=bot[thisbot].y-visiblerange to bot[thisbot].y+visiblerange do begin
      LOS:=check_LOS(bot[thisbot].x,bot[thisbot].y,ix,iy);
      if LOS>0 then begin
        LOS:=round((maxvisible-oldvisible)*LOS/(visiblerange*visibleaccuracy))+oldvisible;
        if vis^[ix,iy]<LOS then begin vis^[ix,iy]:=LOS; mapchanged^[ix,iy]:=255 end;
      end
    end;
  end;
end;

{================================================================================}
{================================================================================}
{================================================================================}

procedure Tform1.find_onfloor(x,y:integer);
var i:integer;
begin
  onfloorn:=0;
  if itemsn>0 then
  for i:=1 to itemsn do if (x=item[i].x) and (y=item[i].y) then if onfloorn<maxonfloor then begin
    inc(onfloorn);
    onfloor[onfloorn]:=i;
  end;
end;

{================================================================================}
{================================================================================}
{================================================================================}

function TForm1.spend_tu(thisbot:integer;tus:byte):boolean;
begin
 if (bot[thisbot].tu>=tus) or (gamemode=gamemode_victory) then begin
   if gamemode<>gamemode_victory then dec(bot[thisbot].tu,tus);
   if bot[thisbot].items[1].rechargestate>tus then dec(bot[thisbot].items[1].rechargestate,tus) else bot[thisbot].items[1].rechargestate:=0;
   spend_tu:=true;
 end else begin
   spend_tu:=false;
   if bot[thisbot].owner=player then showmessage('Not enough TUs');
 end;
end;

{=================================================================}
{=================================================================}
{=================================================================}

const maxwaypoints=1000;
var waypointx,waypointy:array[1..maxwaypoints]of integer;
    waypointn:integer;
    waypoint_count:integer;
    waypoint_distance:integer;
procedure Generatewaypoints(thisbot,to_x,to_y:integer);
var xx1,yy1:integer;
begin
  waypointn:=0;
  xx1:=to_x;
  yy1:=to_y;
  waypoint_distance:=0;
  repeat
    inc(waypointn);
    waypointx[waypointn]:=xx1;
    waypointy[waypointn]:=yy1;

    case movement^[xx1,yy1] of
      5: begin inc(xx1); dec(yy1) end;
      6: begin           dec(yy1) end;
      7: begin dec(xx1); dec(yy1) end;
      8: begin dec(xx1)           end;
      1: begin dec(xx1); inc(yy1) end;
      2: begin           inc(yy1) end;
      3: begin inc(xx1); inc(yy1) end;
      4: begin inc(xx1);          end;
    end;

    inc(waypoint_distance,round(bot[thisbot].speed*sqrt(sqr(xx1-waypointx[waypointn])+sqr(yy1-waypointy[waypointn]))));
  until (xx1=bot[thisbot].x) and (yy1=bot[thisbot].y);
end;

procedure Tform1.move_bot(thisbot,to_x,to_y,use_waypoints:integer);
var i:integer;
    oldx,oldy:integer;
    step_tu:byte;
    dx:integer;
    flg:boolean;

    mytimer:TDate;
begin
 generatemovement(thisbot,to_x,to_y);
 oldx:=bot[thisbot].x;
 oldy:=bot[thisbot].y;
 if (to_x>0) and (to_y>0) and (to_x<=maxx) and (to_y<=maxy) then
  if movement^[to_x,to_y]<10 then begin
   generatewaypoints(thisbot,to_x,to_y);

   waypoint_count:=0;
   repeat
    step_tu:=round(bot[thisbot].speed*sqrt(sqr(bot[thisbot].x-waypointx[waypointn])+sqr(bot[thisbot].y-waypointy[waypointn])));
    flg:=true;
    for i:=1 to nbot do if (bot[i].hp>0) and (i<>thisbot) then
      if (bot[i].x=waypointx[waypointn]) and (bot[i].y=waypointy[waypointn]) then //begin
        flg:=false;
//        waypointn:=0;
//      end;
    if vis^[bot[thisbot].x,bot[thisbot].y]>oldvisible then mapchanged^[bot[thisbot].x,bot[thisbot].y]:=255;
    if (bot[thisbot].tu>=step_tu) and (flg) then begin
     spend_tu(thisbot,step_tu);

       if bot[thisbot].y-waypointy[waypointn]<>0 then begin
         dx:=round(maxangle*arctan((bot[thisbot].x-waypointx[waypointn])/(bot[thisbot].y-waypointy[waypointn]))/2/Pi);
         if bot[thisbot].y-waypointy[waypointn]>0 then dx:=150-dx else dx:=50-dx;
         bot[thisbot].angle:=dx;
      end
       else begin
         if bot[thisbot].x-waypointx[waypointn]>0 then bot[thisbot].angle:=100 else bot[thisbot].angle:=0
       end;

     bot[thisbot].x:=waypointx[waypointn];
     bot[thisbot].y:=waypointy[waypointn];
      if vis^[bot[thisbot].x,bot[thisbot].y]>oldvisible then mapchanged^[bot[thisbot].x,bot[thisbot].y]:=255;
      i:=3;   //buggy
      if (viewx<=1) or (viewy<=1) or (viewx+viewsizex>=maxx-2) or (viewy+viewsizey>=maxy-2) then i:=1;
      if (bot[thisbot].x<=viewx+i) or (bot[thisbot].y<=viewy+i) or (bot[thisbot].x>=viewx+viewsizex+1-i) or (bot[thisbot].y>=viewy+viewsizey+1-i) then
       if vis^[bot[thisbot].x,bot[thisbot].y]>oldvisible then
         center_map(bot[thisbot].x,bot[thisbot].y);

     if bot[thisbot].owner=player then begin
       look_around(thisbot);
       if generate_enemy_list then begin
         draw_map;
         showmessage('Enemy nearby!');
         waypointn:=0;
       end;
     end;
     if (vis^[bot[thisbot].x,bot[thisbot].y]>oldvisible) or (bot[thisbot].owner=player) then begin
       mytimer:=now;
       draw_map;
       dx:=round((now-mytimer)*24*60*60*1000);
       if bot[thisbot].owner=player then begin
         if playerbotmovedelay>dx then sleep(playerbotmovedelay-dx)
       end else begin
         if enemybotmovedelay>dx then sleep(enemybotmovedelay-dx)
       end;
     end;
     inc(waypoint_count);
     dec(waypointn);
    end else waypointn:=0;
   until (waypointn<=0) or (waypoint_count>=use_waypoints); /// or interrupted by time lack or enemy
   if (bot[thisbot].x<>oldx) or (bot[thisbot].y<>oldy) then movement_map_for:=-1;
   if (thisbot=selected) and (checkbox2.checked) and ((bot[thisbot].x<>to_x) or (bot[thisbot].y<>to_y)) then generatemovement(thisbot,to_x,to_y);
 end;
{ if vis^[bot[thisbot].x,bot[thisbot].y]>oldvisible then begin
   draw_map;
 end;   }
end;

{================================================================================}
{================================================================================}
{================================================================================}

procedure generate_map_makewalls(generatorseed:byte);
var ix,iy:integer;
begin
 for ix:=1 to maxx do
   for iy:= 1 to maxy do map^[ix,iy]:=generatorseed;
end;

{--------------------------------------------------------------------------------------}
procedure generate_map_cocon; //???
var ix,iy,cx,cy:integer;
    map_seed:float;
begin
  form1.memo1.lines.add('COCON MAP * no');
  cx:=round((2+random)*maxx/5);
  cy:=round((2+random)*maxy/5);
  for ix:=1 to maxx do
    for iy:= 1 to maxy do begin
       map_seed:=1.5*sqrt((sqr(ix-cx+0.0001)+sqr(iy-cy+0.0001)+1)/(sqr((maxx +0.0001)/ 2)+sqr((maxy+0.0001) / 2)+1));
       if (random>map_seed) or (random<0.3) then map^[ix,iy]:=map_wall else map^[ix,iy]:=255;
     end;
end;

{----------------------------------------------------------------------------------}

procedure generate_map_random;
var ix,iy:integer;
    map_seed:float;
begin
  map_seed:=0.4+0.3*random;
  form1.memo1.lines.add('RANDOM MAP * '+inttostr(round(map_seed*100)));
  for ix:=1 to maxx do
    for iy:= 1 to maxy do begin
       if random>map_seed then map^[ix,iy]:=map_wall else map^[ix,iy]:=255;
     end;
end;

{----------------------------------------------------------------------------------}

const maxcircles=20;
procedure generate_map_random_circles;
var ix,iy,i:integer;
    Ncircles:integer;
    cx,cy,r:array[1..maxcircles] of integer;
begin
  generate_map_makewalls(map_wall);
  Ncircles:=round(sqr(sqr(random))*(maxx/10-1))+1;
  if NCircles>maxcircles then NCircles:=maxcircles;
  form1.memo1.lines.add('RANDOM CIRCLES MAP * '+inttostr(Ncircles));
  for i:=1 to NCircles do begin
    r[i]:=round(maxx/(Ncircles+1)*sqr(random))+5;
    cx[i]:=round((maxx/2)*random)+maxx div 4;
    cy[i]:=round((maxy/2)*random)+maxy div 4;
  end;
  for ix:=1 to maxx do
    for iy:= 1 to maxy do
      for i:=1 to NCircles do begin
       if ((sqrt(random))>sqrt(sqr(ix-cx[i])+sqr(iy-cy[i]))/r[i]) or (random>0.9) then map^[ix,iy]:=255;
     end;
end;

{--------------------------------------------------------------------------------------}

procedure generate_map_circles;
var ix,iy,i,dx,dy:integer;
    map_seed:float;
begin
  generate_map_makewalls(map_wall);
  map_seed:=0.4+random/4;
  form1.memo1.lines.add('CIRCLES MAP * '+inttostr(round(map_seed*100)));
  repeat
    i:=round(sqr(sqr(random))*maxx/5)+4;
    ix:=round(random*(maxx-1)+1);
    iy:=round(random*(maxy-1)+1);
    for dx:=-i to i do
     for dy:=-i to i do
      if (sqr(dx)+sqr(dy)<=i) and (ix+dx>0) and (iy+dy>0) and (ix+dx<=maxx) and (iy+dy<=maxy) then map^[ix+dx,iy+dy]:=255;
        i:=0;
        for ix:=1 to maxx do
          for iy:= 1 to maxy do if map^[ix,iy]=255 then inc(i);
  until (i/maxx/maxy>map_seed);
end;

{--------------------------------------------------------------------------------------}

procedure generate_map_anticircles;
var ix,iy,i,dx,dy:integer;
    map_seed:float;
begin
  map_seed:=0.3+random/3;
  generate_map_makewalls(255);
  form1.memo1.lines.add('ANTI-CIRCLES MAP * '+inttostr(round(map_seed*100)));
  repeat
    i:=round(sqr(sqr(random))*maxx/5)+1;
    ix:=round(random*(maxx-1)+1);
    iy:=round(random*(maxy-1)+1);
    for dx:=-i to i do
     for dy:=-i to i do
      if (sqr(dx)+sqr(dy)<=i) and (ix+dx>0) and (iy+dy>0) and (ix+dx<=maxx) and (iy+dy<=maxy) then map^[ix+dx,iy+dy]:=map_wall;
        i:=0;
         for ix:=1 to maxx do
           for iy:= 1 to maxy do if map^[ix,iy]=255 then inc(i);
   until (i/maxx/maxy<map_seed) or (random<0.00001);
end;

{--------------------------------------------------------------------------------------}

procedure generate_map_rectagonal;
var ix,iy,i,dx,dy:integer;
    map_seed:float;
begin
  map_seed:=0.2+random*0.6;
  form1.memo1.lines.add('RECTAGONAL MAP * '+inttostr(round(map_seed*100)));
  generate_map_makewalls(map_wall);

  repeat
    i:=round(random*maxx/3);
    ix:=round(random*(maxx-1))+1;
    iy:=round(random*(maxy-1))+1;
    if random>0.5 then begin
     if random>0.5 then begin
       for dx:=ix to ix+i do if dx<=maxx then map^[dx,iy]:=255
     end else begin
       for dx:=ix-i to ix do if dx>0 then map^[dx,iy]:=255;
     end;
    end else begin
     if random>0.5 then begin
       for dy:=iy to iy+i do if dy<=maxy then map^[ix,dy]:=255;
     end else begin
       for dy:=iy-i to iy do if dy>0 then map^[ix,dy]:=255;
     end
    end;
    i:=0;
    for ix:=1 to maxx do
      for iy:= 1 to maxy do if map^[ix,iy]=255 then inc(i);
  until (i/maxx/maxy>map_seed);
end;

{--------------------------------------------------------------------------------------}

procedure generate_map_block;
var ix,iy,iix,iiy,dx,dy:integer;
    map_seed:float;
begin
  map_seed:=0.45+random/5;
  generate_map_makewalls(map_wall);
  form1.memo1.lines.add('BLOCK MAP * '+inttostr(round(map_seed*100)));


  dx:=round(random*5)+1;
  dy:=round(random*5)+1;
  if (dx=1) and (dy=1) then dx:=2;
  for ix:=1 to maxx div dx do
   for iy:=1 to maxy div dy do if random>map_seed then begin
     for iix:=ix*dx to (ix+1)*dx-1 do
      for iiy:=iy*dy to (iy+1)*dy-1 do if (iix>0) and (iiy>0) and (iix<=maxx) and (iiy<=maxy) then map^[iix,iiy]:=255;
   end;
end;

{--------------------------------------------------------------------------------------}

procedure generate_map_diamonds;
var ix,iy,iix,iiy,dx,dy:integer;
    map_seed:float;
begin
  map_seed:=0.22+random/8;
  generate_map_makewalls(map_wall);
  form1.memo1.lines.add('DIAMONDS MAP * '+inttostr(round(map_seed*100)));

  dx:=round(random*5)+3;
  dy:=dx;
//      if (dx=1) and (dy=1) then dx:=2;
  for ix:=0 to maxx div dx do
  for iy:=0 to maxy div dy do if (random>map_seed) then begin
    for iix:=ix*dx to (ix+1)*dx do
    for iiy:=iy*dy to (iy+1)*dy do if (abs((ix+0.5)*dx-iix)+abs((iy+0.5)*dy-iiy)<dx/1.9) and (iix>0) and (iiy>0) and (iix<=maxx) and (iiy<=maxy) then map^[iix,iiy]:=255;
  end;
end;

procedure generate_map_tmap;
var ix,iy:integer;
    map_seed:float;
begin
  map_seed:=0.2+random/8;
  generate_map_makewalls(map_wall);
  form1.memo1.lines.add('T MAP * '+inttostr(round(map_seed*100)));

  for ix:=0 to maxx div 4-1 do
   for iy:=0 to maxy div 4-1 do begin
     map^[ix*4+2,iy*4+2]:=255;
     map^[ix*4+3,iy*4+3]:=255;
     map^[ix*4+3,iy*4+2]:=255;
     map^[ix*4+2,iy*4+3]:=255;
     if random>map_seed then begin
       map^[ix*4+1,iy*4+2]:=255;
       map^[ix*4+1,iy*4+3]:=255;
     end;
     if random>map_seed then begin
       map^[ix*4+4,iy*4+2]:=255;
       map^[ix*4+4,iy*4+3]:=255;
     end;
     if random>map_seed then begin
       map^[ix*4+2,iy*4+1]:=255;
       map^[ix*4+3,iy*4+1]:=255;
     end;
     if random>map_seed then begin
       map^[ix*4+2,iy*4+4]:=255;
       map^[ix*4+3,iy*4+4]:=255;
     end;
  end;
end;

{--------------------------------------------------------------------------------------}

{const maxsqrsinus=maxx div 4;
      checkblocks=2;
procedure generate_map_sqrsinus;
var ix,iy,i:integer;
    mapfree:array[1..checkblocks,1..checkblocks]of integer;
    map_seed,sinus_threshold,max_frq:float;
    frqx,frqy,phase,amp:array[1..maxsqrsinus] of float;
    sum,allamp:float;
    flag1:boolean;
begin
 map_seed:=0.4+random/8;
 form1.memo1.lines.add('ABSOLUTE SINUS MAP * '+inttostr(round(map_seed*100)));
 repeat
  form1.memo1.lines.add('regenerating...');
  allamp:=0;
  max_frq:=random*(maxx-4)+3;
  for i:=1 to maxsqrsinus do begin
    frqx[i]:=Pi*max_frq*(sqr(random));
    frqy[i]:=Pi*max_frq*(sqr(random));
    phase[i]:=random*2*pi;
    amp[i]:=random/sqrt(sqrt(frqx[i]+frqy[i]));
    allamp:=allamp+sqr(amp[i]);
  end;
  allamp:=sqrt(allamp);

  for ix:=1 to checkblocks do
    for iy:=1 to checkblocks do mapfree[ix,iy]:=0;
  sinus_threshold:=0.7;
  for ix:=1 to maxx do
   for iy:=1 to maxy do begin
     sum:=0;
     for i:=1 to maxsqrsinus do sum:=sum+abs(amp[i]*sin(frqx[i]*ix/maxx+frqy[i]*iy/maxy+phase[i]));
     if sum/allamp>sinus_threshold then map^[ix,iy]:=map_wall else
       begin
         map^[ix,iy]:=255;
         if (ix<maxx div 2) then begin
           if (iy<maxy div 2) then inc(mapfree[1,1]) else inc(mapfree[1,2]);
         end else begin
           if (iy<maxy div 2) then inc(mapfree[2,1]) else inc(mapfree[2,2]);
         end;

       end;
   end;
  flag1:=true;
  for ix:=1 to checkblocks do
    for iy:=1 to checkblocks do if (4*mapfree[ix,iy]/maxx/maxy<map_seed-0.3) or (4*mapfree[ix,iy]/maxx/maxy>map_seed+0.3) then flag1:=false;
 until flag1;
end; }

{--------------------------------------------------------------------------------------}

const maxmaxlinearsinus=maxmaxx div 2;
procedure generate_map_linearsinus;
var ix,iy,i:integer;
    frqx,frqy,phase,amp:array[1..maxmaxlinearsinus] of float;
    sum:float;
    maptype:byte;
    maxlinearsinus:integer;
begin
 maxlinearsinus:=maxx div 2;
 maptype:=round(random*1.3+0.45);
 form1.memo1.lines.add('LINEAR SINUS MAP * type'+inttostr(maptype));
 for i:=1 to maxlinearsinus do begin
   sum:=random;
   if maptype=0 then sum:=(2*random-1);
   frqx[i]:=Pi*maxx/2*sum;
   sum:=random;
   if maptype=0 then sum:=(2*random-1);
   if maptype=2 then sum:=-random;
   frqy[i]:=Pi*maxx/2*sum;
   phase[i]:=random*2*pi;
   amp[i]:=sqrt(sqrt(random));
 end;

 for ix:=1 to maxx do
  for iy:=1 to maxy do begin
    sum:=0;
    for i:=1 to maxlinearsinus do sum:=sum+(amp[i]*sin(frqx[i]*ix/maxx+frqy[i]*iy/maxy+phase[i]));
    if sum>0 then map^[ix,iy]:=map_wall else map^[ix,iy]:=255;
 end;
end;

{--------------------------------------------------------------------------------------}

procedure generate_map_rooms;
var room_max,room_min,room_n,roomx,roomy,sx,sy:integer;
    i,ix,iy:integer;
    pass_max,pass_min,pass:integer;
    dx,dy:integer;
    //generatecoords:boolean;
begin
  generate_map_makewalls(map_wall);
  room_min:=3;
  room_max:=maxx div 5;
  room_n:=round(sqr(sqr(random))*(sqrt(maxx*maxy/sqr(room_max+3))))+3;
  pass_min:=maxx div 5;
  pass_max:=maxx div 2;
  form1.memo1.lines.add('ROOMS MAP * '+inttostr(room_n));
  //make rooms
  for i:=1 to room_n do begin
    roomx:=round((room_max-room_min)*random)+room_min;
    roomy:=round((room_max-room_min)*random)+room_min;
    sx:=round(random*(maxx-roomx-2))+1;
    sy:=round(random*(maxy-roomy-2))+1;
    pass:=0;
    for ix:=sx to sx+roomx do
     for iy:=sy to sy+roomy do begin
        map^[ix,iy]:=255;
       // if (ix=sx) or (ix=sx+roomx) or (iy=sy) or (iy=roomy) then if random>0.1/(roomx+roomy) then map^[ix,iy]:=254 else begin inc(pass); map^[ix,iy]:=253; end;
     end;

     //make 1 tunnel
     repeat
      ix:=sx+round(random*(roomx div 2))+ roomx div 4;
      iy:=sy+round(random*(roomy div 2))+ roomy div 4;
      repeat
        if random>0.5 then begin dx:=round(random*2)-1; dy:=0 end else begin dy:=round(random*2)-1; dx:=0 end;
        pass:=round(random*(pass_max-pass_min))+pass_min;
        repeat
          ix:=ix+dx;
          iy:=iy+dy;
          if (ix>0) and (ix<maxx) and (iy>0) and (iy<maxy) then
             map^[ix,iy]:=255
          else pass:=0;
          dec(pass);
        until (pass<=0);
       until random>0.7+0.29/(sqrt(room_n));
     until random>0.7;
   end;
  //make tunnels
 { i:=0;
  pass_min:=round(random*maxx/4)+1;
  pass_max:=round(random*maxx/2)+pass_min+5;
  generatecoords:=true;
  repeat
    pass:=round(random*(pass_max-pass_min))+pass_min;
    if generatecoords then
    repeat
      ix:=round(random*(maxx-4))+2;
      iy:=round(random*(maxy-4))+2;
      generatecoords:=false;
    until map^[ix,iy]=253;

    if random>0.5 then begin dx:=round(random*2)-1; dy:=0 end else begin dy:=round(random*2)-1; dx:=0 end;
    repeat
      ix:=ix+dx;
      iy:=iy+dy;
      if (ix>0) and (ix<maxx) and (iy>0) and (iy<maxy) then begin
        if map^[ix,iy]>250 then pass:=0 else
         begin map^[ix,iy]:=255; inc(i) end;
      end else pass:=0;
      dec(pass);
    until (pass<=0);
    if pass=-1 then generatecoords:=true;
    if (pass=0) and (random>0.9) then begin
      generatecoords:=true;
      map^[ix,iy]:=253;
    end;
  until (i/maxx/maxy>0.01) or (random<0.0001);

  for ix:=1 to maxx do
    for iy:= 1 to maxy do begin
       if map^[ix,iy]=254 then map^[ix,iy]:=map_wall;
       if map^[ix,iy]=253 then map^[ix,iy]:=255;
    end;  }
end;

{--------------------------------------------------------------------------------------}

procedure generate_map_Concentric;
var ix,iy,iix,iiy,dx,dy:integer;
    //map_seed:float;
    circle_rout,circle_rin,start_phase_x,start_phase_y:float;
begin
 // map_seed:=0.22+random/8;
  generate_map_makewalls(map_wall);
  dx:=round(sqr(random)*maxx/2)+3;
 // if random>0.1 then dx:=round(maxx/2+random*maxx/2)+1;

  form1.memo1.lines.add('CONCENTRIC MAP * '+inttostr(dx));

  dy:=dx;
  start_phase_x:=random*dx;
  start_phase_y:=random*dy;
  for ix:=-1 to maxx div dx+1 do
   for iy:=-1 to maxy div dy+1 do{ if (random>map_seed) then} begin
    circle_rout:=sqr(random)*(dx-2)+2;
    circle_rin:=random*(circle_rout-2)+1;
    for iix:=(ix-2)*dx to (ix+3)*dx do
     for iiy:=(iy-2)*dy to (iy+3)*dy do
       if (sqr((ix+0.5)*dx-iix+start_phase_x)+sqr((iy+0.5)*dx-iiy+start_phase_y)<sqr(circle_rout)) and ((sqr((ix+0.5)*dx-iix+start_phase_x)+sqr((iy+0.5)*dx-iiy+start_phase_y)>sqr(circle_rin))) and (iix>0) and (iiy>0) and (iix<=maxx) and (iiy<=maxy) then map^[iix,iiy]:=255;
  end;
end;

{--------------------------------------------------------------------------------------}

procedure generate_map_slant;
var ix,iy:integer;
    map_seed:float;
begin
  map_seed:=0.98+random*0.02;
  generate_map_makewalls(map_wall);
  form1.memo1.lines.add('SLANT * '+inttostr(round(map_seed*100)));
{  for ix:=1 to 14 do
   for iy:=1 to 14 do map^[ix,iy]:=255;}

  for ix:=0 to maxx div 5-1 do
   for iy:=0 to maxy div 5-1 do begin
     if random>0.5 then begin
       map^[ix*5+1,iy*5+1]:=255;
       map^[ix*5+2,iy*5+2]:=255;
       map^[ix*5+3,iy*5+3]:=255;
       map^[ix*5+4,iy*5+4]:=255;
       map^[ix*5+5,iy*5+5]:=255;
       map^[ix*5+2,iy*5+1]:=255;
       map^[ix*5+3,iy*5+2]:=255;
       map^[ix*5+4,iy*5+3]:=255;
       map^[ix*5+5,iy*5+4]:=255;
       map^[ix*5+1,iy*5+2]:=255;
       map^[ix*5+2,iy*5+3]:=255;
       map^[ix*5+3,iy*5+4]:=255;
       map^[ix*5+4,iy*5+5]:=255;
       if random>map_seed then begin
         map^[ix*5+5,iy*5+1]:=255;
         map^[ix*5+4,iy*5+2]:=255;
         map^[ix*5+5,iy*5+2]:=255;
         map^[ix*5+4,iy*5+1]:=255;
       end;
       if random>map_seed then begin
         map^[ix*5+1,iy*5+5]:=255;
         map^[ix*5+2,iy*5+4]:=255;
         map^[ix*5+2,iy*5+5]:=255;
         map^[ix*5+1,iy*5+4]:=255;
       end;
     end else begin
       map^[ix*5+5,iy*5+1]:=255;
       map^[ix*5+4,iy*5+2]:=255;
       map^[ix*5+3,iy*5+3]:=255;
       map^[ix*5+2,iy*5+4]:=255;
       map^[ix*5+1,iy*5+5]:=255;
       map^[ix*5+4,iy*5+1]:=255;
       map^[ix*5+3,iy*5+2]:=255;
       map^[ix*5+2,iy*5+3]:=255;
       map^[ix*5+1,iy*5+4]:=255;
       map^[ix*5+5,iy*5+2]:=255;
       map^[ix*5+4,iy*5+3]:=255;
       map^[ix*5+3,iy*5+4]:=255;
       map^[ix*5+2,iy*5+5]:=255;
       if random>map_seed then begin
         map^[ix*5+5,iy*5+5]:=255;
         map^[ix*5+4,iy*5+4]:=255;
         map^[ix*5+5,iy*5+4]:=255;
         map^[ix*5+4,iy*5+5]:=255;
       end;
       if random>map_seed then begin
         map^[ix*5+1,iy*5+1]:=255;
         map^[ix*5+2,iy*5+2]:=255;
         map^[ix*5+2,iy*5+1]:=255;
         map^[ix*5+1,iy*5+2]:=255;
       end;
     end;
  end;
end;

{--------------------------------------------------------------------------------------}

procedure generate_map_boxes;
var ix,iy:integer;
    sx,sy:integer;
    ax,ay,bx,by:integer;
    map_seed:float;
    freespace,walls:integer;
begin
  generate_map_makewalls(map_wall);
  map_seed:=0.2+random/4;
  form1.memo1.lines.add('BOXES MAP * '+inttostr(round(map_seed*100)));
  repeat
    ax:=round(maxx/5*random)+4;
    ay:=round(maxy/5*random)+4;
    bx:=round(((random)))+1;
    by:=round(((random)))+1;
    sx:=round(random*(maxx-ax-2))+1;
    sy:=round(random*(maxy-ay-2))+1;
    for ix:=sx to sx+ax do
     for iy:=sy to sy+ay do if map^[ix,iy]=map_wall then begin
       if (ix<sx+bx) or (ix>sx+ax-bx) or (iy<sy+by) or (iy>sy+ay-by) then map^[ix,iy]:=255 else map^[ix,iy]:=254;
     end;

    freespace:=0;
    walls:=0;
    for ix:=1 to maxx do
     for iy:=1 to maxy do begin
       if map^[ix,iy]=255 then inc(freespace);
       if map^[ix,iy]=map_wall then inc(walls);
     end;

  until (freespace/maxx/maxy>map_seed) or (walls/maxx/maxy<0.01) or (random<0.0001);
  for ix:=1 to maxx do
   for iy:=1 to maxy do if map^[ix,iy]=254 then map^[ix,iy]:=map_wall;
end;

{--------------------------------------------------------------------------------------}

procedure generate_map_concentricfull;
var ix,iy,j:integer;
    cx,cy:float;
    maxr,rx_in,ry_in,rx_out,ry_out:float;
    map_seed:float;
    freespace,walls:integer;
begin
  generate_map_makewalls(map_wall);
  map_seed:=0.2+random/4;
  form1.memo1.lines.add('CONCENTRIC FULL MAP * '+inttostr(round(map_seed*100)));
  maxr:=random*maxx+10;
  repeat
    rx_out:=random*(maxr)+1;
    ry_out:=rx_out+random*4-2;if ry_out<1 then ry_out:=1;
    cx:=random*(maxx-rx_out)+rx_out; { if (rx_out>maxx/2) and (cx>0) or (cx<maxx) then rx_out:=rx_out/3;}
    cy:=random*(maxy-ry_out)+ry_out; { if (ry_out>maxy/2) and (cy>0) or (cy<maxy) then ry_out:=ry_out/3;}
    rx_in:=rx_out-1-sqr(random)*3; if rx_in<=1 then rx_in:=1;
    ry_in:=ry_out-1-sqr(random)*3; if ry_in<=1 then ry_in:=1;
    for ix:=1 to maxx do
     for iy:=1 to maxy do if (map^[ix,iy]=map_wall) and (sqr((ix-cx)/rx_out)+sqr((iy-cy)/ry_out)<1) then begin
       if sqr((ix-cx)/rx_in)+sqr((iy-cy)/ry_in)>=1 then map^[ix,iy]:=255 else map^[ix,iy]:=254;
       if (rx_in>15) or (ry_in>15) then begin
         if sqr((ix-cx)/(rx_in-5-random*2))+sqr((iy-cy)/(rx_in-5-random*2))<1 then begin
           if random>map_seed then
            map^[ix,iy]:=map_wall
           else
            map^[ix,iy]:=255
         end
         else begin
           if random<1/rx_in then
             for j:=0 to 10 do if (ix+round((cx-ix)*j/10)>1) and (ix+round((cx-ix)*j/10)<maxx) and (iy+round((cy-iy)*j/10)>1) and (iy+round((cy-iy)*j/10)<maxy) then
               map^[ix+round((cx-ix)*j/10),iy+round((cy-iy)*j/10)]:=255;
         end;
       end;
     end;
    freespace:=0;
    walls:=0;
    for ix:=1 to maxx do
     for iy:=1 to maxy do begin
       if map^[ix,iy]=255 then inc(freespace);
       if map^[ix,iy]=map_wall then inc(walls);
     end;

  until (freespace/maxx/maxy>map_seed) or (walls/maxx/maxy<0.01) or (random<0.0001);
  for ix:=1 to maxx do
   for iy:=1 to maxy do if map^[ix,iy]=254 then map^[ix,iy]:=map_wall;
end;

{--------------------------------------------------------------------------------------}

procedure generate_map_egg;
var ix,iy,j:integer;
    cx0,cy0,cx,cy:float;
    rout,rin:float;
    pass_count:integer;
begin
  generate_map_makewalls(map_wall);
  cx0:=random*(maxx/2)+maxx/4;
  cy0:=random*(maxy/2)+maxy/4;
  rout:=sqrt(sqr(maxx-cx0)+sqr(maxy-cy0));
  if rout<sqrt(sqr(cx0)+sqr(cy0)) then rout:=sqrt(sqr(cx0)+sqr(cy0));
  if rout<sqrt(sqr(maxx-cx0)+sqr(cy0)) then rout:=sqrt(sqr(maxx-cx0)+sqr(cy0));
  if rout<sqrt(sqr(cx0)+sqr(maxy-cy0)) then rout:=sqrt(sqr(cx0)+sqr(maxy-cy0));
  //rout:=rout-random*4;
  rin:=rout-1-5*random;
  form1.memo1.lines.add('EGG MAP * no');
  repeat
    cx:=cx0+random*2-1;
    cy:=cx0+random*2-1;
    for ix:=1 to maxx do
     for iy:=1 to maxy do if sqr(ix-cx)+sqr(iy-cy)<=sqr(rout) then begin
       if sqr(ix-cx)+sqr(iy-cy)<=sqr(rin) then map^[ix,iy]:=map_wall else map^[ix,iy]:=255;
     end;
    pass_count:=0;
    repeat
      ix:=round(random*(maxx-2))+2;
      iy:=round(random*(maxy-2))+2;
      if (sqr(ix-cx)+sqr(iy-cy)<=sqr(rout)) and (sqr(ix-cx)+sqr(iy-cy)>=sqr(rin)) then begin
        for j:=0 to round(rout*10) do begin
          map^[round(ix+(cx-ix)*j/round(rout*10)    ),round(iy+(cy-iy)*j/round(rout*10)    )]:=255;
{          map^[round(ix-(cx-ix)*j/round(rout*10)+0.5),round(iy-(cy-iy)*j/round(rout*10)-0.5)]:=255;
          map^[round(ix-(cx-ix)*j/round(rout*10)-0.5),round(iy-(cy-iy)*j/round(rout*10)+0.5)]:=255;}
        end;
        inc(pass_count);
      end;
    until (pass_count>sqrt(rout)+1) or (random<1/maxx/maxy);
    rout:=rin-2-5*random;
    rin :=rout-1-2*random;
  until rin<0;
end;

{--------------------------------------------------------------------------------------}

const maxnodes=(maxmaxx div 4+2)*(maxmaxy div 4+2);
procedure generate_map_net;
var map_seed,map_stepx,map_stepy,phasex,phasey,map_irregularity,map_maxrange:float;
    ix,iy,i,j,k:integer;
    nodex,nodey:array[1..maxnodes] of float;
    nodestate:array[1..maxnodes]of byte;
    n:integer;
    tmp:float;
    flg,flg2:boolean;
begin
  generate_map_makewalls(map_wall);

  map_seed:=random/3;
  tmp:=maxx/10;
  if tmp>6 then tmp:=6;
  map_stepx:=random*10 + tmp;
  map_stepy:=random*10 + tmp;
  tmp:=map_stepx;
  map_stepx:=(2*tmp+map_stepy)/3;
  map_stepy:=(2*map_stepy+tmp)/3;
  phasex:=map_stepx*random;
  phasey:=map_stepy*random;
  if random<0.33 then map_irregularity:=0 else     // rgular
  if random>0.5 then
    map_irregularity:=random*(map_stepx*0.4)      // 40% regular
  else
    map_irregularity:=random*(2*map_stepx-1);      // strongly irregular

  map_maxrange:=map_stepx+map_stepy{+random*map_irregularity};
  if map_irregularity<=2 then map_seed:=map_seed/2;

  form1.memo1.lines.add('NET MAP * '+inttostr(round(map_irregularity))+'/'+inttostr(round(map_stepx)));

  n:=0;
  for ix:=0 to round(maxx / map_stepx)+2 do
    for iy:=0 to round(maxy / map_stepy)+2 do begin
      inc(n);
      nodex[n]:=ix*map_stepx-phasex+random*map_irregularity;
      nodey[n]:=iy*map_stepy-phasey+random*map_irregularity;
      nodestate[n]:=0;
      if (nodex[n]<1) or (nodex[n]>maxx) or (nodey[n]<1) or (nodey[n]>maxy) then dec(n);
    end;

  inc(n);
  nodex[n]:=1;
  nodey[n]:=1;
  nodestate[n]:=1;
  repeat
    i:=round(random*(n-1))+1;
    if nodestate[i]=1 then begin
      flg:=true;
      for j:=1 to n do begin
        tmp:=sqrt(sqr(nodex[i]-nodex[j])+sqr(nodey[i]-nodey[j]));
        if (i<>j) and (tmp<=map_maxrange) and (nodestate[j]<2) then begin
         flg:=false;
         if random<map_seed then begin
           flg2:=true;
           if tmp>6 then
             for k:=3*10 to round((tmp-3)*10) do if map^[round(nodex[i]+(nodex[j]-nodex[i])*k/round(tmp*10)),round(nodey[i]+(nodey[j]-nodey[i])*k/round(tmp*10))]=255 then flg2:=false;
           if flg2 then begin
             for k:=0 to round(tmp*10) do map^[round(nodex[i]+(nodex[j]-nodex[i])*k/round(tmp*10)),round(nodey[i]+(nodey[j]-nodey[i])*k/round(tmp*10))]:=255;
             nodestate[j]:=1;
             if random<0.7 then nodestate[i]:=2;
           end;
         end;
        end;
      end;
      if flg then nodestate[i]:=2;
    end;

    flg:=true;
    for i:=1 to n do if nodestate[i]=0 then flg:=false;
  until (flg) or (random<0.0001);
end;


{--------------------------------------------------------------------------------------}

procedure safemapwrite(x,y:integer;data:byte);
begin
  if (x>0) and (x<maxx) and (y>0) and (y<maxy) then map^[x,y]:=data;
end;

{--------------------------------------------------------------------------------------}

procedure generate_map_plus;
var h,w,h_phase,w_phase:integer;
    map_seed,map_seed2,map_seed3,map_seed4,map_seed5,map_seed6:float;
    ix,iy,j,bx,by,rx,ry:integer;
    x1,y1:integer;
begin
  generate_map_makewalls(255);
  map_seed:=0.6+random*0.4;
  map_seed2:=random/4;
  map_seed3:=random;
  map_seed4:=0.75+random/4;
  map_seed5:=random;
  map_seed6:=0.8+random/4;
  h:=4+round(random*maxy/4);
  w:=4+round(random*maxy/4);
  if (h>2*w) and (random>0.5) then h:=round(2*w);
  if (w>2*h) and (random>0.5) then w:=round(2*h);
  if h>21 then h:=21;
  if w>21 then w:=21;
  h_phase:=round(random*h);
  w_phase:=round(random*w);
  form1.memo1.lines.add('PLUS MAP * '+inttostr(w)+'x'+inttostr(h));
  for ix:=0 to (maxx div w)+2 do
   for iy:=0 to (maxy div h)+2 do begin
     x1:=ix*w+w_phase;
     y1:=iy*h+h_phase;
     //central box
                              safemapwrite(x1  ,y1  ,map_wall);
     if random>map_seed2 then safemapwrite(x1-1,y1  ,map_wall);
                              safemapwrite(x1-2,y1  ,map_wall);
     if random>map_seed2 then safemapwrite(x1-2,y1-1,map_wall);
                              safemapwrite(x1-2,y1-2,map_wall);
     if random>map_seed2 then safemapwrite(x1-1,y1-2,map_wall);
                              safemapwrite(x1  ,y1-2,map_wall);
     if random>map_seed2 then safemapwrite(x1  ,y1-1,map_wall);
     //vertical lines
     for j:=y1-3 downto y1-h+2 do safemapwrite(x1-2,j,map_wall);
     if random>map_seed then      safemapwrite(x1-2,y1-h+1,map_wall);
     for j:=y1-4 downto y1-h+1 do safemapwrite(x1,j,map_wall);
     if random>map_seed then      safemapwrite(x1,y1-3,map_wall);
     //horizontal lines
     for j:=x1-3 downto x1-w+2 do safemapwrite(j,y1,map_wall);
     if random>map_seed then      safemapwrite(x1-w+1,y1,map_wall);
     for j:=x1-4 downto x1-w+1 do safemapwrite(j,y1-2,map_wall);
     if random>map_seed then      safemapwrite(x1-3,y1-2,map_wall);
     //side block
     if (random>map_seed3) and (h>6) and (w>6) then begin
       for bx:=x1-4 downto x1-w+2 do
        for by:=y1-4 downto y1-h+2 do safemapwrite(bx,by,map_wall);
       if random>map_seed4 then safemapwrite(((x1-4)+(x1-w+2)) div 2,y1-3 ,map_wall);
       if random>map_seed4 then safemapwrite(((x1-4)+(x1-w+2)) div 2,y1-h+1,map_wall);
       if random>map_seed4 then safemapwrite(x1-3  ,((y1-4)+(y1-h+2)) div 2,map_wall);
       if random>map_seed4 then safemapwrite(x1-w+1,((y1-4)+(y1-h+2)) div 2,map_wall);

       //hollow block
       if (random>map_seed5) and (((h>=9) and (w>=9)) or ((h=8) and (w>9)) or ((w=8) and (h>9))) then begin
         rx:=1+round(sqr(sqr(sqr(random)))*(w-9)/2);
         ry:=1+round(sqr(sqr(sqr(random)))*(h-9)/2);
         for bx:=x1-4-rx downto x1-w+2+rx do
          for by:=y1-4-ry downto y1-h+2+ry do safemapwrite(bx,by,255);
         if random>0.5 then bx:=1 else bx:=-1;
         if w>8 then begin
           if random>map_seed6 then for j:=0 to ry do safemapwrite(((x1-4)+(x1-w+2)) div 2+bx,y1-4  -j,255);
           if random>map_seed6 then for j:=0 to ry do safemapwrite(((x1-4)+(x1-w+2)) div 2-bx,y1-h+2+j,255);
         end;
         if h>8 then begin
           if random>map_seed6 then for j:=0 to rx do safemapwrite(x1-4  -j,((y1-4)+(y1-h+2)) div 2+bx,255);
           if random>map_seed6 then for j:=0 to rx do safemapwrite(x1-w+2+j,((y1-4)+(y1-h+2)) div 2-bx,255);
         end;
       end;
     end;
   end;
end;

{--------------------------------------------------------------------------------------}

const smalroomssize=6;
procedure generate_map_smallrooms;
var ix,iy,jx,jy,x1,y1:integer;
    map_seed,map_seed2,map_seed3:float;
    xphase,yphase:integer;
    flg:boolean;
begin
  generate_map_makewalls(255);
  map_seed:=0.6+random*0.3;   //blockers
  map_seed2:=random;
  map_seed3:=random*0.40;
  xphase:=round(random*smalroomssize);
  yphase:=round(random*smalroomssize);
  form1.memo1.lines.add('SMALLROOMS MAP * '+inttostr(round(map_seed*100)));
  for ix:=0 to maxx div smalroomssize+2 do
   for iy:=0 to maxy div smalroomssize+2 do begin
     x1:=ix*smalroomssize-xphase;
     y1:=iy*smalroomssize-yphase;
     //block
     for jx:=x1+1 to x1+5 do
      for jy:=y1+1 to y1+5 do safemapwrite(jx,jy,map_wall);
     //hollow entrance
     flg:=false;
     if random<map_seed3 then begin safemapwrite(x1+3,y1+1,255); flg:=true end;
     if random<map_seed3 then begin safemapwrite(x1+3,y1+5,255); flg:=true end;
     if random<map_seed3 then begin safemapwrite(x1+1,y1+3,255); flg:=true end;
     if random<map_seed3 then begin safemapwrite(x1+5,y1+3,255); flg:=true end;
     //hollow
     if flg then begin
       safemapwrite(x1+2,y1+2,255);
       safemapwrite(x1+3,y1+2,255);
       safemapwrite(x1+4,y1+2,255);
       safemapwrite(x1+2,y1+4,255);
       safemapwrite(x1+3,y1+4,255);
       safemapwrite(x1+4,y1+4,255);
       safemapwrite(x1+2,y1+3,255);
       safemapwrite(x1+4,y1+3,255);
       if random<map_seed2 then safemapwrite(x1+3,y1+3,255);
     end;
     //blockings
     if random>map_seed then safemapwrite(x1+2,y1  ,map_wall);
     if random>map_seed then safemapwrite(x1+4,y1  ,map_wall);
     if random>map_seed then safemapwrite(x1  ,y1+2,map_wall);
     if random>map_seed then safemapwrite(x1  ,y1+4,map_wall);
   end;
end;

{--------------------------------------------------------------------------------------}
const Ixsize=6;
      Iysize=8;
procedure generate_map_Imap;
var ix,iy,x1,y1:integer;
    map_seed,map_seed2:float;
    xphase,yphase:integer;
//    flg:boolean;
begin
 generate_map_makewalls(255);
 map_seed:=0.7+random*0.3;   //blockers
 map_seed2:=0.9+random*0.1;
 xphase:=round(random*Ixsize);
 yphase:=round(random*Iysize);
 if random>0.5 then begin
  form1.memo1.lines.add('I-map Vertical MAP * '+inttostr(round(map_seed*100)));
  for ix:=0 to maxx div Ixsize+2 do
   for iy:=0 to maxy div Iysize+2 do begin
     x1:=ix*Ixsize-xphase;
     y1:=iy*Iysize-yphase;
     //first I caps
     safemapwrite(x1  ,y1  ,map_wall);
     safemapwrite(x1+1,y1  ,map_wall);
     safemapwrite(x1+2,y1  ,map_wall);
     safemapwrite(x1  ,y1+6,map_wall);
     safemapwrite(x1+1,y1+6,map_wall);
     safemapwrite(x1+2,y1+6,map_wall);
     //stem
     safemapwrite(x1+1,y1+1,map_wall);
     safemapwrite(x1+1,y1+2,map_wall);
     safemapwrite(x1+1,y1+3,map_wall);
     safemapwrite(x1+1,y1+4,map_wall);
     safemapwrite(x1+1,y1+5,map_wall);
     //second I caps
     safemapwrite(x1+3,y1+2,map_wall);
     safemapwrite(x1+4,y1+2,map_wall);
     safemapwrite(x1+5,y1+2,map_wall);
     safemapwrite(x1+3,y1+4,map_wall);
     safemapwrite(x1+4,y1+4,map_wall);
     safemapwrite(x1+5,y1+4,map_wall);
     //stem
     safemapwrite(x1+4,y1  ,map_wall);
     safemapwrite(x1+4,y1+1,map_wall);
     safemapwrite(x1+4,y1+5,map_wall);
     safemapwrite(x1+4,y1+6,map_wall);
     safemapwrite(x1+4,y1+7,map_wall);
     //vertical blockers
     if random>map_seed2 then safemapwrite(x1+1,y1+7,map_wall);
     if random>map_seed2 then safemapwrite(x1+4,y1+3,map_wall);
     //first I horizontal blockers
     if random>map_seed then safemapwrite(x1+3,y1  ,map_wall);
     if random>map_seed then safemapwrite(x1+5,y1  ,map_wall);
     if random>map_seed then safemapwrite(x1+3,y1+6,map_wall);
     if random>map_seed then safemapwrite(x1+5,y1+6,map_wall);
     //second I horizontal blockers
     if random>map_seed then safemapwrite(x1  ,y1+2,map_wall);
     if random>map_seed then safemapwrite(x1+2,y1+2,map_wall);
     if random>map_seed then safemapwrite(x1  ,y1+4,map_wall);
     if random>map_seed then safemapwrite(x1+2,y1+4,map_wall);
   end;
 end else begin
     form1.memo1.lines.add('I-map Horizontal MAP * '+inttostr(round(map_seed*100)));
     for ix:=0 to maxx div Iysize+2 do
      for iy:=0 to maxy div Ixsize+2 do begin
        x1:=ix*Iysize-yphase;
        y1:=iy*Ixsize-xphase;
        //first I caps
        safemapwrite(x1  ,y1  ,map_wall);
        safemapwrite(x1  ,y1+1,map_wall);
        safemapwrite(x1  ,y1+2,map_wall);
        safemapwrite(x1+6,y1  ,map_wall);
        safemapwrite(x1+6,y1+1,map_wall);
        safemapwrite(x1+6,y1+2,map_wall);
        //stem
        safemapwrite(x1+1,y1+1,map_wall);
        safemapwrite(x1+2,y1+1,map_wall);
        safemapwrite(x1+3,y1+1,map_wall);
        safemapwrite(x1+4,y1+1,map_wall);
        safemapwrite(x1+5,y1+1,map_wall);
        //second I caps
        safemapwrite(x1+2,y1+3,map_wall);
        safemapwrite(x1+2,y1+4,map_wall);
        safemapwrite(x1+2,y1+5,map_wall);
        safemapwrite(x1+4,y1+3,map_wall);
        safemapwrite(x1+4,y1+4,map_wall);
        safemapwrite(x1+4,y1+5,map_wall);
        //stem
        safemapwrite(x1  ,y1+4,map_wall);
        safemapwrite(x1+1,y1+4,map_wall);
        safemapwrite(x1+5,y1+4,map_wall);
        safemapwrite(x1+6,y1+4,map_wall);
        safemapwrite(x1+7,y1+4,map_wall);
        //vertical blockers
        if random>map_seed2 then safemapwrite(x1+7,y1+1,map_wall);
        if random>map_seed2 then safemapwrite(x1+3,y1+4,map_wall);
        //first I horizontal blockers
        if random>map_seed then safemapwrite(x1  ,y1+3,map_wall);
        if random>map_seed then safemapwrite(x1  ,y1+5,map_wall);
        if random>map_seed then safemapwrite(x1+6,y1+3,map_wall);
        if random>map_seed then safemapwrite(x1+6,y1+5,map_wall);
        //second I horizontal blockers
        if random>map_seed then safemapwrite(x1+2,y1  ,map_wall);
        if random>map_seed then safemapwrite(x1+2,y1+2,map_wall);
        if random>map_seed then safemapwrite(x1+4,y1  ,map_wall);
        if random>map_seed then safemapwrite(x1+4,y1+2,map_wall);
      end;
 end;
end;

{--------------------------------------------------------------------------------------}

const foursize=6;
procedure generate_map_four;
var ix,iy,x1,y1:integer;
    map_seed:float;
    xphase,yphase:integer;
begin
  generate_map_makewalls(255);
  map_seed:=0.5+random*0.2;   //blockers
  xphase:=round(random*foursize);
  yphase:=round(random*foursize);
  form1.memo1.lines.add('FOUR MAP * '+inttostr(round(map_seed*100)));
  for ix:=0 to maxx div foursize+2 do
   for iy:=0 to maxy div foursize+2 do begin
     x1:=ix*foursize-xphase;
     y1:=iy*foursize-yphase;
     //horizontal lines
     safemapwrite(x1  ,y1+1,map_wall);
     safemapwrite(x1+1,y1+1,map_wall);
     safemapwrite(x1+2,y1+1,map_wall);
     safemapwrite(x1+3,y1+4,map_wall);
     safemapwrite(x1+4,y1+4,map_wall);
     safemapwrite(x1+5,y1+4,map_wall);
     //vertical lines
     safemapwrite(x1+1,y1+3,map_wall);
     safemapwrite(x1+1,y1+4,map_wall);
     safemapwrite(x1+1,y1+5,map_wall);
     safemapwrite(x1+4,y1  ,map_wall);
     safemapwrite(x1+4,y1+1,map_wall);
     safemapwrite(x1+4,y1+2,map_wall);
     //blockings
     if random>map_seed then safemapwrite(x1+1,y1  ,map_wall);
     if random>map_seed then safemapwrite(x1+3,y1+1,map_wall);
     if random>map_seed then safemapwrite(x1+5,y1+1,map_wall);
     if random>map_seed then safemapwrite(x1+1,y1+2,map_wall);
     if random>map_seed then safemapwrite(x1+4,y1+3,map_wall);
     if random>map_seed then safemapwrite(x1  ,y1+4,map_wall);
     if random>map_seed then safemapwrite(x1+2,y1+4,map_wall);
     if random>map_seed then safemapwrite(x1+4,y1+5,map_wall);
   end;
end;

{--------------------------------------------------------------------------------------}

const fivesize=5;
procedure generate_map_five;
var ix,iy,x1,y1:integer;
    map_seed:float;
    xphase,yphase:integer;
begin
  generate_map_makewalls(255);
  map_seed:=0.5+random*0.2;   //blockers
  xphase:=round(random*fivesize);
  yphase:=round(random*fivesize);
  form1.memo1.lines.add('FIVE MAP * '+inttostr(round(map_seed*100)));
  for ix:=0 to maxx div fivesize+2 do
   for iy:=0 to maxy div fivesize+2 do begin
     x1:=ix*fivesize-xphase;
     y1:=iy*fivesize-yphase;
     //permament walls
     safemapwrite(x1  ,y1  ,map_wall);
     safemapwrite(x1+2,y1  ,map_wall);
     safemapwrite(x1+3,y1  ,map_wall);
     safemapwrite(x1  ,y1+2,map_wall);
     safemapwrite(x1+2,y1+2,map_wall);
     safemapwrite(x1+3,y1+2,map_wall);
     safemapwrite(x1  ,y1+3,map_wall);
     safemapwrite(x1+2,y1+3,map_wall);
     safemapwrite(x1+3,y1+3,map_wall);
     //blockings
     if random>map_seed then safemapwrite(x1+1,y1  ,map_wall);
     if random>map_seed then safemapwrite(x1+4,y1  ,map_wall);
     if random>map_seed then safemapwrite(x1  ,y1+1,map_wall);
     if random>map_seed then safemapwrite(x1+2,y1+1,map_wall);
     if random>map_seed then safemapwrite(x1+4,y1+2,map_wall);
     if random>map_seed then safemapwrite(x1+1,y1+3,map_wall);
     if random>map_seed then safemapwrite(x1  ,y1+4,map_wall);
     if random>map_seed then safemapwrite(x1+3,y1+4,map_wall);
   end;
end;

{--------------------------------------------------------------------------------------}
const dashsize=6;
procedure generate_map_dash;
var ix,iy,x1,y1,line:integer;
    map_seed:float;
    xphase,yphase:integer;
    kind:boolean;
begin
  generate_map_makewalls(255);
  map_seed:=0.5+random*0.2;   //blockers
  xphase:=round(random*dashsize);
  yphase:=round(random*dashsize);
  if random>0.5 then kind:=true else kind:=false;

  if random>0.5 then begin
    form1.memo1.lines.add('DASH horizontal MAP * '+inttostr(round(map_seed*100)));
    if kind then form1.memo1.lines.add('top-left variant') else form1.memo1.lines.add('top-right variant');
    for ix:=0 to maxx div dashsize+2 do
     for iy:=0 to maxy div dashsize+2 do begin
       x1:=ix*dashsize-xphase;
       y1:=iy*dashsize-yphase;
       //permament walls
       safemapwrite(x1  ,y1  ,map_wall); //first line
       safemapwrite(x1+1,y1  ,map_wall);
       safemapwrite(x1+3,y1  ,map_wall);
       safemapwrite(x1+4,y1  ,map_wall);
       if kind then line:=y1+2 else line:=y1+4;
       safemapwrite(x1+1,line,map_wall); //third line
       safemapwrite(x1+2,line,map_wall);
       safemapwrite(x1+4,line,map_wall);
       safemapwrite(x1+5,line,map_wall);
       if kind then line:=y1+4 else line:=y1+2;
       safemapwrite(x1  ,line,map_wall);  //fifth line
       safemapwrite(x1+2,line,map_wall);
       safemapwrite(x1+3,line,map_wall);
       safemapwrite(x1+5,line,map_wall);
       //blockings
       if random>map_seed then safemapwrite(x1+2,y1  ,map_wall); //first line
       if random>map_seed then safemapwrite(x1+5,y1  ,map_wall);
       if kind then line:=y1+1 else line:=y1+5;
       if random>map_seed then safemapwrite(x1+1,line,map_wall); //second line
       if random>map_seed then safemapwrite(x1+4,line,map_wall);
       if kind then line:=y1+2 else line:=y1+4;
       if random>map_seed then safemapwrite(x1  ,line,map_wall); //third line
       if random>map_seed then safemapwrite(x1+3,line,map_wall);
       if random>map_seed then safemapwrite(x1+2,y1+3,map_wall); //fourth line
       if random>map_seed then safemapwrite(x1+5,y1+3,map_wall);
       if kind then line:=y1+4 else line:=y1+2;
       if random>map_seed then safemapwrite(x1+1,line,map_wall); //fifth line
       if random>map_seed then safemapwrite(x1+4,line,map_wall);
       if kind then line:=y1+5 else line:=y1+1;
       if random>map_seed then safemapwrite(x1  ,line,map_wall); //sixth line
       if random>map_seed then safemapwrite(x1+3,line,map_wall);
     end;
  end
  else begin
    form1.memo1.lines.add('DASH vertical MAP * '+inttostr(round(map_seed*100)));
    if kind then form1.memo1.lines.add('top-left variant') else form1.memo1.lines.add('top-right variant');
    for ix:=0 to maxx div dashsize+2 do
     for iy:=0 to maxy div dashsize+2 do begin
       x1:=ix*dashsize-xphase;
       y1:=iy*dashsize-yphase;
       //permament walls
       safemapwrite(x1  ,y1  ,map_wall); //first line
       safemapwrite(x1  ,y1+1,map_wall);
       safemapwrite(x1  ,y1+3,map_wall);
       safemapwrite(x1  ,y1+4,map_wall);
       if kind then line:=x1+2 else line:=x1+4;
       safemapwrite(line,y1+1,map_wall); //third line
       safemapwrite(line,y1+2,map_wall);
       safemapwrite(line,y1+4,map_wall);
       safemapwrite(line,y1+5,map_wall);
       if kind then line:=x1+4 else line:=x1+2;
       safemapwrite(line,y1  ,map_wall);  //fifth line
       safemapwrite(line,y1+2,map_wall);
       safemapwrite(line,y1+3,map_wall);
       safemapwrite(line,y1+5,map_wall);
       //blockings
       if random>map_seed then safemapwrite(x1  ,y1+2,map_wall); //first line
       if random>map_seed then safemapwrite(x1  ,y1+5,map_wall);
       if kind then line:=x1+1 else line:=x1+5;
       if random>map_seed then safemapwrite(line,y1+1,map_wall); //second line
       if random>map_seed then safemapwrite(line,y1+4,map_wall);
       if kind then line:=x1+2 else line:=x1+4;
       if random>map_seed then safemapwrite(line,y1  ,map_wall); //third line
       if random>map_seed then safemapwrite(line,y1+3,map_wall);
       if random>map_seed then safemapwrite(x1+3,y1+2,map_wall); //fourth line
       if random>map_seed then safemapwrite(x1+3,y1+5,map_wall);
       if kind then line:=x1+4 else line:=x1+2;
       if random>map_seed then safemapwrite(line,y1+1,map_wall); //fifth line
       if random>map_seed then safemapwrite(line,y1+4,map_wall);
       if kind then line:=x1+5 else line:=x1+1;
       if random>map_seed then safemapwrite(line,y1  ,map_wall); //sixth line
       if random>map_seed then safemapwrite(line,y1+3,map_wall);
     end;
  end;
end;

{--------------------------------------------------------------------------------------}

procedure generate_map_rotor;        //buggy, but I liked it :)
var dx,dy,sx,sy,x1,y1,x2,y2:integer;
    map_seed,max_length,phase,maxrotorlength:float;
    ddx,ddy,r:float;
    angle,max_angles:integer;
    freearea:integer;
begin
  generate_map_makewalls(map_wall);
  map_seed:=0.6+random*0.1+sqr(sqr(random))*0.3;
  max_length:=maxx/10+3+maxx/2*random;
  maxrotorlength:=1.5+10*sqr(sqr(random));
  max_angles:=2+round(random*3+sqr(sqr(sqr(random)))*32);
  phase:=random*2*Pi;
  form1.memo1.lines.add('ROTOR MAP * '+inttostr(round(map_seed*100))+'/'+inttostr(max_angles)+'/'+inttostr(round(max_length)));
  freearea:=0;
  repeat
    x1:=round(random*max_length)+1;
    y1:=round((1.5+maxrotorlength*random)*x1);
    angle:=round(random*max_angles);
    ddx:=sin((angle/max_angles)*2*Pi+phase);
    ddy:=cos((angle/max_angles)*2*Pi+phase);
    sx:=round(random*maxx);
    sy:=round(random*maxy);
    for dx:=0 to x1 do
     for dy:=0 to y1 do begin
       r:=sqrt(sqr(dx-x1/2)+sqr(dy-y1/2));
       x2:=sx+round(r*ddx);
       y2:=sy+round(r*ddy);
       safemapwrite(x2,y2,255);
     end;
    inc(freearea,x1*y1);
  until freearea>25*maxx*maxy*map_seed;
end;

{--------------------------------------------------------------------------------------}

procedure generate_map_eggRE;
var x1,y1,x2,y2,xx1,xx2,yy1,yy2:integer;
    dx,dy,dy0,dx0,i:integer;
    maxwallwidth,maxpasswidth:integer;
    map_seed:float;
    //roomsize,rx,ry:integer;
begin
  generate_map_makewalls(map_wall);
  map_seed:=0.8+0.2*random;
  form1.memo1.lines.add('EGGRE MAP * '+inttostr(round(100*map_seed)));
  x1:=2;
  y1:=2;
  x2:=maxx-1;
  y2:=maxy-1;
  maxwallwidth:=4+round(sqr(random)*maxx/4);
  maxpasswidth:=1+round(sqr(sqr(random))*6);
  repeat
    for dx:=x1 to x2 do
     for dy:=y1 to y2 do map^[dx,dy]:=255;
    xx1:=x1+1+round(random*maxpasswidth);
    xx2:=x2-1-round(random*maxpasswidth);
    yy1:=y1+1+round(random*maxpasswidth);
    yy2:=y2-1-round(random*maxpasswidth);
    // block some passages here
    for i:=1 to (2*(xx2-xx1)+2*(yy2-yy1)) div 15+4 do begin
      if random>0.5 then begin
        dy:=yy1+round((yy2-yy1-2)*random)+1;
        if random>0.5 then
          for dx:=x1 to xx1 do map^[dx,dy]:=map_wall
        else
          for dx:=xx2 to x2 do map^[dx,dy]:=map_wall
      end else begin
         dx:=xx1+round((xx2-xx1-2)*random)+1;
         if random>0.5 then
           for dy:=y1 to yy1 do map^[dx,dy]:=map_wall
         else
           for dy:=yy2 to y2 do map^[dx,dy]:=map_wall
      end;
    end;
    x1:=xx1;
    x2:=xx2;
    y1:=yy1;
    y2:=yy2;
    if (x1<x2) and (y1<y2) then begin
      for dx:=x1 to x2 do
       for dy:=y1 to y2 do map^[dx,dy]:=map_wall;

      xx1:=x1+1+round(random*maxwallwidth);
      xx2:=x2-1-round(random*maxwallwidth);
      yy1:=y1+1+round(random*maxwallwidth);
      yy2:=y2-1-round(random*maxwallwidth);
      if (xx1<xx2) and (yy1<yy2) then begin
        // create rooms inside walls
        // left rooms
        if xx1-x1>=3 then begin
          dy:=yy1+1;
          repeat
            if random>map_seed then begin
              dy0:=dy;
              while (random>0.2) and (dy<=yy2-1) do begin
                for dx:=x1+1 to xx1-2 do map^[dx,dy]:=255;
                inc(dy);
              end;
              if dy-dy0>=3 then begin
                if random>0.5 then map^[   x1,dy0+1+round((dy-dy0-3)*random)]:=255
                              else map^[xx1-1,dy0+1+round((dy-dy0-3)*random)]:=255

              end;
            end;
            inc(dy);
          until dy>=yy2-1;
        end;
        //right rooms
        if x2-xx2>=3 then begin
          dy:=yy1+1;
          repeat
            if random>map_seed then begin
              dy0:=dy;
              while (random>0.2) and (dy<=yy2-1) do begin
                for dx:=xx2+2 to x2-1 do map^[dx,dy]:=255;
                inc(dy);
              end;
              if dy-dy0>=3 then begin
                if random>0.5 then map^[   x2,dy0+1+round((dy-dy0-3)*random)]:=255
                              else map^[xx2+1,dy0+1+round((dy-dy0-3)*random)]:=255

              end;
            end;
            inc(dy);
          until dy>=yy2-1;
        end;
        // top rooms
        if yy1-y1>=3 then begin
          dx:=xx1+1;
          repeat
            if random>map_seed then begin
              dx0:=dx;
              while (random>0.2) and (dx<=xx2-1) do begin
                for dy:=y1+1 to yy1-2 do map^[dx,dy]:=255;
                inc(dx);
              end;
              if dx-dx0>=3 then begin
                if random>0.5 then map^[dx0+1+round((dx-dx0-3)*random),y1]:=255
                              else map^[dx0+1+round((dx-dx0-3)*random),yy1-1]:=255

              end;
            end;
            inc(dx);
          until dx>=xx2-1;
        end;
        // bottom rooms
        if y2-yy2>=3 then begin
          dx:=xx1+1;
          repeat
            if random>map_seed then begin
              dx0:=dx;
              while (random>0.2) and (dx<=xx2-1) do begin
                for dy:=yy2+2 to y2-1 do map^[dx,dy]:=255;
                inc(dx);
              end;
              if dx-dx0>=3 then begin
                if random>0.5 then map^[dx0+1+round((dx-dx0-3)*random),y2]:=255
                              else map^[dx0+1+round((dx-dx0-3)*random),yy2+1]:=255

              end;
            end;
            inc(dx);
          until dx>=xx2-1;
        end;

        // create passages
        for i:=1 to (2*(xx2-xx1)+2*(yy2-yy1)) div 15+1 do begin
          if random>0.5 then begin
            dy:=yy1+round((yy2-yy1-2)*random)+1;
            if random>0.5 then
              for dx:=x1 to xx1 do map^[dx,dy]:=255
            else
              for dx:=xx2 to x2 do map^[dx,dy]:=255
          end else begin
             dx:=xx1+round((xx2-xx1-2)*random)+1;
             if random>0.5 then
               for dy:=y1 to yy1 do map^[dx,dy]:=255
             else
               for dy:=yy2 to y2 do map^[dx,dy]:=255
          end;
        end;
      end;
      x1:=xx1;
      x2:=xx2;
      y1:=yy1;
      y2:=yy2;
    end;
  until (x1>=x2) or (y1>=y2);
end;

{-------------------------------------------------------------------------------------------}

procedure generate_map_snowflake;
var snowflakes,maxsnowflakes:integer;
    ix,iy,s,i,r:integer;
    angle:float;
    phase_x,phase_y,snowflakesize,cx,cy:float;
begin
  generate_map_makewalls(map_wall);
  snowflakesize:=6+sqrt(random)*maxx/7;
  maxsnowflakes:=8;
  if snowflakesize<8 then maxsnowflakes:=1 else
  if snowflakesize<13 then maxsnowflakes:=3 else
  if snowflakesize<19 then maxsnowflakes:=5;
  if random>0.5+0.4*(maxx/maxmaxx) then snowflakes:=round(random*maxsnowflakes)+3 else snowflakes:=0;
  phase_x:=-(random) * snowflakesize;
  phase_y:=-(random) * snowflakesize;

  if snowflakes=0 then
    form1.memo1.lines.add('SNOWFLAKE MAP * different /'+inttostr(round(snowflakesize)))
  else
    form1.memo1.lines.add('SNOWFLAKE MAP * equal='+inttostr(snowflakes)+'/'+inttostr(round(snowflakesize)));

  for ix:=0 to round(maxx / snowflakesize) + 2 do
   for iy:=0 to round(maxy / snowflakesize) + 2 do begin
     cx:=ix*snowflakesize+phase_x;
     cy:=iy*snowflakesize+phase_y;
     if snowflakes=0 then s:=round(random*(maxsnowflakes+1))+2 else s:=snowflakes;
     angle:=round(random*2*Pi);
     for i:=0 to s do
      for r:=1 to round(snowflakesize/2) do begin
        safemapwrite(round(cx+r*sin(angle+i/s*2*Pi)),round(cy+r*cos(angle+i/s*2*Pi)),255);
        safemapwrite(round(cx+r*sin(angle+i/s*2*Pi)),round(cy-1+r*cos(angle+i/s*2*Pi)),255);
        safemapwrite(round(cx-1+r*sin(angle+i/s*2*Pi)),round(cy+r*cos(angle+i/s*2*Pi)),255);
        safemapwrite(round(cx-1+r*sin(angle+i/s*2*Pi)),round(cy-1+r*cos(angle+i/s*2*Pi)),255);
{        if snowflakesize>12 then safemapwrite(round(cx-1+r*sin(angle+i/s*2*Pi)),round(cy-1+r*cos(angle+i/s*2*Pi)),255);
        if snowflakesize>20 then safemapwrite(round(cx+1+r*sin(angle+i/s*2*Pi)),round(cy-1+r*cos(angle+i/s*2*Pi)),255);}
      end;
    end;
end;

{-------------------------------------------------------------------------------------------}

procedure generate_map_areas;
var areasize,thissize:integer;
    ix,iy,count,firstcount:integer;
    x1,y1:integer;
    entrance_x,entrance_y:integer;
    map_tmp:^map_array;
begin
  new(map_tmp);
  generate_map_makewalls(map_wall);
  areasize:=round(sqr(random)*maxx*maxy/13)+50;
  entrance_x:=2; entrance_y:=2;
  form1.memo1.lines.add('AREAS MAP * '+inttostr(areasize));
  for ix:=2 to maxx-1 do
   for iy:=2 to maxy-1 do map^[ix,iy]:=254; //diggable
  x1:=entrance_x;  y1:=entrance_y; //entrance
  thissize:=areasize div 2 + round(random*areasize/2) +7;
  repeat
    map^[x1,y1]:=253; //grow
    map_tmp^:=map^;
    repeat
      count:=0;
      for ix:=2 to maxx-1 do
        for iy:=2 to maxy-1 do if (map^[ix,iy]=254) and (random>0.5) then
          if (map^[ix-1,iy]=253) or (map^[ix+1,iy]=253) or (map^[ix,iy-1]=253) or (map^[ix,iy+1]=253) then begin
            map_tmp^[ix,iy]:=253;
            dec(thissize);
            inc(count)
          end;
      map^:=map_tmp^;
    until (thissize<=0) or (count=0);
    //change to idle
    for ix:=2 to maxx-1 do
      for iy:=2 to maxy-1 do if map^[ix,iy]=253 then map^[ix,iy]:=252;
    //surround by walls
     for ix:=2 to maxx-1 do
      for iy:=2 to maxy-1 do if map^[ix,iy]=254 then begin
          if (map^[ix-1,iy]=252) or (map^[ix+1,iy]=252) or
             (map^[ix,iy-1]=252) or (map^[ix,iy+1]=252) or
             (map^[ix-1,iy-1]=252) or (map^[ix+1,iy+1]=252) or
             (map^[ix+1,iy-1]=252) or (map^[ix-1,iy+1]=252) then
                           map^[ix,iy]:=250;
      end;

     count:=0;
     for ix:=2 to maxx-1 do
      for iy:=2 to maxy-1 do if map^[ix,iy]=254 then inc(count);
    //reset start point
    if count>0 then
    repeat
      x1:=round(random*(maxx-1))+1;
      y1:=round(random*(maxy-1))+1;
      thissize:=round(sqrt(random)*areasize)+10;
    until map^[x1,y1]=254;
  until count=0;
  //make doors
  map^[entrance_x,entrance_y]:=255;
  repeat
    //grow the room
    firstcount:=-1;
    repeat
      count:=0;
      for ix:=2 to maxx-1 do
        for iy:=2 to maxy-1 do begin
          if (map^[ix,iy]=252) or (map^[ix,iy]=250) then begin
            if (map^[ix-1,iy]=255) or (map^[ix+1,iy]=255) or
               (map^[ix,iy-1]=255) or (map^[ix,iy+1]=255) or
               (map^[ix-1,iy-1]=255) or (map^[ix+1,iy+1]=255) or
               (map^[ix+1,iy-1]=255) or (map^[ix-1,iy+1]=255) then begin
                  inc(count);
                  if (map^[ix,iy]=252) then map^[ix,iy]:=255
                                       else map^[ix,iy]:=map_wall;
            end;
          end
        end;
      if firstcount=-1 then firstcount:=count
    until count=0;
    if (firstcount=0) and (random>0.001) then map^[x1,y1]:=map_wall;
    // make door
    count:=0;
    repeat
      x1:=round(random*(maxx-3))+2;
      y1:=round(random*(maxy-3))+2;
      if map^[x1,y1]=map_wall then begin
        map^[x1,y1]:=255;
        inc(count);
      end;
    until count>=1;
    //calculate remaining rooms
    count:=0;
    for ix:=2 to maxx-1 do
      for iy:=2 to maxy-1 do if map^[ix,iy]=252 then inc(count);
  until count=0;
  //debug
  for ix:=2 to maxx-1 do
    for iy:=2 to maxy-1 do if map^[ix,iy]=250 then map^[ix,iy]:=map_wall;
  for ix:=2 to maxx-1 do
    for iy:=2 to maxy-1 do if map^[ix,iy]=252 then map^[ix,iy]:=255;
  dispose(map_tmp);
end;

{---------------------------------------------------------------------------------------------}
{-------------------------------------------------------------------------------------------}

const maxwormsize=3.0;
      minwormsize=1.5;
      wallthickness=1.5; {<minwormsize}
      stopevent=0.01;
procedure generate_map_wormhole;
var ix,iy,dx,dy,x1,y1:integer;
    xx,yy,angle,anglespeed,thissize,sizespeed:float;
    entrance_x,entrance_y:integer;
    count:integer;
    count_free,count_254,count_all:integer;
    stophole,flg,stopworms:boolean;
begin
  generate_map_makewalls(map_wall);
  form1.memo1.lines.add('WORMHOLE MAP * no');
  entrance_x:=6; entrance_y:=6;
  xx:=entrance_x; yy:=entrance_y;
  angle:=round(random*2*Pi);
  anglespeed:=0;
  thissize:=maxwormsize * random+minwormsize;
  sizespeed:=0;

  for ix:=2 to maxx-1 do
   for iy:=2 to maxy-1 do map^[ix,iy]:=254; //diggable

  stopworms:=false;
  repeat
    stophole:=false;
    x1:=round(xx);
    y1:=round(yy);
    for dx:=-round(thissize+wallthickness) to round(thissize+wallthickness) do
     for dy:=-round(thissize+wallthickness) to round(thissize+wallthickness) do if not stophole then
       if (x1+dx>=1) and (y1+dy>=1) and (x1+dx<=maxx) and (y1+dy<=maxy) then begin
        if (sqr(dx)+sqr(dy)<thissize) and (map^[x1+dx,y1+dy]<=253) then begin
          map^[x1+dx,y1+dy]:=255;
        end else
        if sqr(dx)+sqr(dy)<=thissize+wallthickness then begin
          if map^[x1+dx,y1+dy]=254 then begin
            map^[x1+dx,y1+dy]:=253; //diggable wall
          end else
          if map^[x1+dx,y1+dy]=map_wall then begin
            stophole:=true;
          end;
        end;
       end;
    if (stophole) or (random<stopevent) then begin
      angle:=round(random*2*Pi);
      anglespeed:=0;
      thissize:=maxwormsize * sqr(random) + minwormsize;
      sizespeed:=0;
      //reset x1,y1,angle,anglespeed;
      count:=0;
      repeat
        inc(count);
        for ix:=2 to maxx-1 do
         for iy:=2 to maxy-1 do if map^[ix,iy]=253 then map^[ix,iy]:=map_wall;
        flg:=false;
        x1:=round(random*(maxx-2))+1;
        y1:=round(random*(maxy-2))+1;
        {if map^[x1,y1]=map_wall then} begin
          count_free:=0;
          count_all:=0;
          count_254:=0;
          for dx:=-round(thissize+wallthickness) to round(thissize+wallthickness) do
           for dy:=-round(thissize+wallthickness) to round(thissize+wallthickness) do
             if (x1+dx>=1) and (y1+dy>=1) and (x1+dx<=maxx) and (y1+dy<=maxy) and ((sqr(dx)+sqr(dy)<thissize+3)) then begin
               if map^[x1+dx,y1+dy]=254 then inc(count_254) else
               if map^[x1+dx,y1+dy]=255 then inc(count_free);
               inc(count_all);
             end;
          if (count_254/count_all>0.8) and (count_free>0) and ((count_all-count_free-count_254)/count_all<0.1) then flg:=true;
        end;
      until (flg) or (count>maxx*maxy*5);
      if count>=maxx*maxy then stopworms:=true else begin
        for dx:=-round(thissize) to round(thissize) do
         for dy:=-round(thissize) to round(thissize) do
           if (x1+dx>=1) and (y1+dy>=1) and (x1+dx<=maxx) and (y1+dy<=maxy) and ((sqr(dx)+sqr(dy)<thissize+1)) then begin
             if map^[x1+dx,y1+dy]=map_wall then map^[x1+dx,y1+dy]:=253 else
             if map^[x1+dx,y1+dy]=254 then map^[x1+dx,y1+dy]:=255;
           end;
      end;
      xx:=x1;
      yy:=y1;
    end else begin
      xx:=xx+0.5*sin(angle);
      yy:=yy+0.5*cos(angle);
      angle:=angle+anglespeed;
      anglespeed:=anglespeed+(random-0.5)/16;
      thissize:=thissize+sizespeed;
      if (thissize>maxwormsize) or (thissize<minwormsize) then sizespeed:=-sizespeed;
      sizespeed:=sizespeed+(random-0.5)/3;
      if abs(sizespeed)>1.0 then sizespeed:=-sizespeed/2;
    end;

    count:=0;
    for ix:=2 to maxx-1 do
     for iy:=2 to maxy-1 do if map^[ix,iy]=254 then inc(count);
  until (count<0.3*maxx*maxy) or (stopworms);

  for ix:=2 to maxx-1 do
   for iy:=2 to maxy-1 do if map^[ix,iy]=254 then map^[ix,iy]:=map_wall;
end;

{-------------------------------------------------------------------------------------------}

const homogenity_x=3;
      homogenity_y=3;
function test_map(free_from,free_to:byte):boolean;
var ix,iy,dx,dy:integer;
    nerrors,nfree:integer;
    all_count,free_count:integer;
    deviation:float;
begin
 for ix:=2 to 7 do
   for iy:=2 to 7 do begin
     map^[ix,iy]:=map_free;
   end;

 map^[6,6]:=map_wall;
 map^[6,5]:=map_wall;
 map^[6,4]:=map_wall;
// map^[6,3]:=map_wall;
 map^[5,6]:=map_wall;
 map^[4,6]:=map_wall;
// map^[3,6]:=map_wall;

 repeat
  nfree:=0;
  for ix:=2 to maxx-1 do
   for iy:= 2 to maxy-1 do if map^[ix,iy]=255 then
     for dx:=-1 to 1 do
       for dy:=-1 to 1 do
         if map^[ix+dx,iy+dy]=map_free then begin map^[ix,iy]:=map_free; nfree:=1; end;
 until nfree=0;

  nerrors:=0;
  for ix:=1 to maxx do
   for iy:= 1 to maxy do if map^[ix,iy]=255 then begin map^[ix,iy]:=map_wall; inc(nerrors); end;
  nfree:=0;
  for ix:=1 to maxx do
   for iy:= 1 to maxy do if map^[ix,iy]=map_free then inc(nfree);


 if {(nerrors/maxx/maxy<0.2) and (nerrors<nfree/3) and} (nfree/maxx/maxy>free_from/100) and (nfree/maxx/maxy<free_to/100) then test_map:=true else test_map:=false;
 form1.memo1.lines.add('Map error rate: '+inttostr(round(nerrors/maxx/maxy*100))+'%');
 form1.memo1.lines.add('Map free area: '+inttostr(round(nfree/maxx/maxy*100))+'%');

 //homogenity check
 deviation:=0;
 for ix:=1 to homogenity_x do
  for iy:=1 to homogenity_y do begin
    free_count:=0;
    all_count:=0;
    for dx:=round((ix-1)*(maxx/homogenity_x))+1 to round(ix*(maxx/homogenity_x)) do
     for dy:=round((iy-1)*(maxy/homogenity_y))+1 to round(iy*(maxy/homogenity_y)) do begin
       if map^[dx,dy]=map_free then inc(free_count);
       inc(all_count);
     end;
     deviation:=deviation+sqr((free_count/all_count)/(nfree/maxx/maxy)-1);
  end;
 form1.memo1.lines.add('Map inhomogenity: '+inttostr(round(sqrt(deviation)/(homogenity_x*homogenity_y)*100))+'%');

 form1.memo1.lines.add('...');

end;

{--------------------------------------------------------------------------------------}

function createbot(owner:integer;name:string;maxhp,x,y:integer):boolean;
var i,weaponhp:integer;
    flg:boolean;
begin
  inc(nbot);
  bot[nbot].name:=name;
  bot[nbot].MAXHP:=maxhp;
  bot[nbot].HP:=bot[nbot].MAXHP;
  bot[nbot].x:=x;
  bot[nbot].y:=y;
  bot[nbot].owner:=owner;
  bot[nbot].speed:=30;
  bot[nbot].angle:=round(random*maxangle);
  for i:=2 to backpacksize do begin
    bot[nbot].items[i].w_id:=0;
    bot[nbot].items[i].ammo_id:=0;
  end;
  i:=0;
  weaponhp:=0;
  repeat
    inc(i);
    bot[nbot].items[i].w_id:=1; //**** =1
    if bot[nbot].owner<>player then begin
      if (random<0.05) and (i=1) then bot[nbot].items[i].w_id:=4;
      if random<0.05 then bot[nbot].items[i].w_id:=2;
      if random<0.05 then bot[nbot].items[i].w_id:=3;
    end;
    bot[nbot].items[i].maxstate:=weapon_specifications[bot[nbot].items[i].w_id].maxstate-round(0.1*weapon_specifications[bot[nbot].items[i].w_id].maxstate*random);
    bot[nbot].items[i].state:=round((bot[nbot].items[i].maxstate-0.2*bot[nbot].items[i].maxstate*random)*(11/(i+10)));
    //if i>1 then  bot[nbot].items[i].state:=0; //*
    bot[nbot].items[i].rechargestate:=0;
    inc(weaponhp,bot[nbot].items[i].state);

    if bot[nbot].items[i].w_id<4 then begin
      bot[nbot].items[i].ammo_id:=1;
      if random<0.05 then bot[nbot].items[i].ammo_id:=2;
      if random<0.05 then bot[nbot].items[i].ammo_id:=3;
    end else begin
      if random<0.6 then bot[nbot].items[i].ammo_id:=5 else bot[nbot].items[i].ammo_id:=6;
    end;
    bot[nbot].items[i].n:=ammo_specifications[bot[nbot].items[i].ammo_id].quantity;
  until (bot[nbot].HP*itemdamagerate<weaponhp) or (i=backpacksize) or (bot[nbot].owner=player);

  if map^[bot[nbot].x,bot[nbot].y]<=map_smoke then flg:=true else flg:=false;
  if (flg) and (nbot>1) then
    for i:=1 to nbot-1 do if (bot[i].hp>0) and (bot[nbot].x=bot[i].x) and (bot[nbot].y=bot[i].y) then flg:=false;
  if not flg then dec(nbot);
  createbot:=flg;
end;

{-----------------------------------------------------------------------------------------------}

procedure generate_LOS_base_map;
var ix,iy,dx,dy,count:integer;
begin
  form1.set_progressbar(true);
  form1.progressbar1.max:=maxx;
  for ix:=1 to maxx do begin
    for iy:=1 to maxy do if map^[ix,iy]<map_wall then begin
      count:=0;
      for dx:=ix-visiblerange to ix+visiblerange do
        for dy:=iy-visiblerange to iy+visiblerange do
          if (dx>0) and (dy>0) and (dx<=maxx) and (dy<=maxy) then
           if map^[dx,dy]<map_wall then
            if (check_LOS(ix,iy,dx,dy)>0) then inc(count);
      if count>1 then dec(count);
      if count<255 then LOS_base^[ix,iy]:=count else LOS_base^[ix,iy]:=255;
    end else LOS_base^[ix,iy]:=0;
    form1.progressbar1.position:=ix;
    form1.progressbar1.update;
  end;

  dx:=0;
  mapfreespace:=0;
  for ix:=1 to maxx do
    for iy:=1 to maxy do if map^[ix,iy]<map_wall then begin
       inc(dx,LOS_base^[ix,iy]);
       inc(mapfreespace);
    end;
  averageLOS:=dx/mapfreespace;
end;

{--------------------------------------------------------------------------------------}
function saydifficulty(difficulty:integer):string;
begin
  case difficulty of
      0.. 80:saydifficulty:='EASY'+' ('+inttostr(difficulty)+'%)';
     81..160:saydifficulty:='NORMAL'+' ('+inttostr(difficulty)+'%)';
    161..240:saydifficulty:='HARD'+' ('+inttostr(difficulty)+'%)';
    241..400:saydifficulty:='ULTRA HARD'+' ('+inttostr(difficulty)+'%)';
    ELSE   saydifficulty:='INSANE?'+' ('+inttostr(difficulty)+'%)'
  end
end;

{--------------------------------------------------------------------------------------}

procedure TForm1.generate_map;
var ix,iy:integer;
    x1,y1,count:integer;
    map_type:byte;
    generatedbots:integer;
    bot_hp_const,player_hp_const:integer;
    total_bot_hp,total_player_hp,total_bot_firepower,total_player_firepower:integer;
begin
  randomize;

  val(edit2.text,maxx,ix);
  if maxx<minmaxx then maxx:=minmaxx;
  if maxx>maxmaxx then maxx:=maxmaxx;
  if (maxx>maxmaxx div 2) and (maxx<maxmaxx) then begin
    if maxx<3*maxmaxx div 4 then maxx:=maxmaxx div 2 else maxx:=maxmaxx;
  end;
  maxy:=maxx;
  edit2.text:=inttostr(maxx);

  if maxx>trackbar1.max then trackbar1.max:=maxzoom;
  if trackbar1.max>maxx then trackbar1.max:=maxx;
  if (viewsizex>maxx) or (viewsizey>maxy) then begin
    viewsizex:=maxx;
    viewsizey:=maxy;
    trackbar1.position:=maxx;
  end;

  memo1.lines.add('Generating map...');
  memo1.lines.add('Map size: '+inttostr(maxx)+'x'+inttostr(maxy));
  for ix:=1 to maxx do
    for iy:= 1 to maxy do begin
       vis^[ix,iy]:=0;
       mapchanged^[ix,iy]:=255;
    end;

  if combobox1.itemIndex<1 then map_type:=trunc(random*20)+1 else map_type:=combobox1.ItemIndex;
  case map_type of
        1: if random>0.6 then
             repeat generate_map_random         until test_map(20,70)
           else if random>0.6 then
             repeat generate_map_block          until test_map(20,70)
           else if random>0.6 then
             repeat generate_map_random_circles until test_map(20,70)
           else
             repeat generate_map_cocon          until test_map(20,80);
        2:   repeat generate_map_circles        until test_map(20,70);       //problems at 140x140
        3:   repeat generate_map_anticircles    until test_map(20,70);
        4:   repeat generate_map_diamonds       until test_map(20,70);
        5:   repeat generate_map_Tmap           until test_map(20,70);
        6:   repeat generate_map_linearsinus    until test_map(20,70);       //slow generation
        7: if random>0.6 then
             repeat generate_map_rectagonal     until test_map(20,70)
           else
             repeat generate_map_rooms          until test_map(20,70);       //problems at 700x700
        8:   repeat generate_map_concentric     until test_map(20,70);
        9:   repeat generate_map_slant          until test_map(20,70);
       10:   repeat generate_map_boxes          until test_map(20,70);       //problems at 700x700
       11:   repeat generate_map_concentricfull until test_map(20,70);       //problems at 700x700
       12:   repeat generate_map_egg            until test_map(20,70);
       13:   repeat generate_map_net            until test_map(20,70);       //problems at 700x700
       14:   repeat generate_map_plus           until test_map(20,70);
       15:      if random<1/5 then
             repeat generate_map_smallrooms     until test_map(20,70)
           else if random<1/4 then
             repeat generate_map_Imap           until test_map(20,70)
           else if random<1/3 then
             repeat generate_map_four           until test_map(20,70)
           else if random<1/2 then
             repeat generate_map_five           until test_map(20,70)
           else
             repeat generate_map_dash          until test_map(20,70);
       16:   repeat generate_map_rotor          until test_map(20,70);
       17:   repeat generate_map_eggre          until test_map(20,70);
       18:   repeat generate_map_snowflake      until test_map(20,70);
       19:   repeat generate_map_areas          until test_map(20,90);
       20:   repeat generate_map_wormhole       until test_map(20,90);
  end;
  itemsn:=0;
  memo1.lines.add('Map ready. Setting bots.');

  nbot:=0;

  val(edit5.text,playersn,ix);
  if playersn<1 then playersn:=1;
  if playersn>maxplayers then playersn:=maxplayers;
  val(edit4.text,player_hp_const,ix);
  if player_hp_const<1 then player_hp_const:=1;
  if player_hp_const>maxplayer_hp_const then player_hp_const:=maxplayer_hp_const;
  edit4.text:=inttostr(player_hp_const);
  val(edit3.text,bot_hp_const,ix);
  if bot_hp_const<1 then bot_hp_const:=1;
  if bot_hp_const>maxbot_hp_const then bot_hp_const:=maxbot_hp_const;
  edit3.text:=inttostr(bot_hp_const);

  x1:=5;           //**bunker size!!!
  y1:=5;
  iy:=round(sqrt(playersn))-1;
  for ix:=1 to playersn do begin
    createbot(player,'player'+inttostr(ix),player_hp_const,x1,y1);
    dec(x1);
    if x1<5-iy then begin
      dec(y1);
      x1:=5;
    end;
  end;
//  bot[1].items[1].w_id:=4;
//  bot[1].items[1].ammo_id:=6;

  val(edit1.text,generatedbots,ix);
  inc(generatedbots,playersn);
  if generatedbots<playersn+1 then generatedbots:=playersn+1;
  if generatedbots>maxbots then generatedbots:=maxbots;
  edit1.text:=inttostr(generatedbots-playersn);
  for ix:=playersn+1 to generatedbots do begin
    count:=0;
    repeat
      inc(count);
      x1:=round(random*(maxx-4)+2);
      y1:=round(random*(maxy-4)+2);
    until ((((x1>12) or (y1>12)) or (random>0.999)) and createbot(computer,'d'+inttostr(round(random*99))+inttostr(ix),{round(random*30)+}bot_hp_const,x1,y1)) or (count>10000);
    if checkbox1.checked then bot[nbot].action:=action_attack else bot[nbot].action:=action_random;
    bot[nbot].target:=round(random*(playersn-1))+1;
  end;

  iy:=0;
  for ix:=1 to nbot do {if bot[ix].owner=computer then} begin
    inc(iy,bot[ix].hp);
  end;

  //generate ground items
  count:=0;
  While ((iy>(itemsn*10+nbot*20)*10) or (random<0.9) or (count<maxx/4)) and (itemsn<maxitems) do begin
      inc(count);
      inc(itemsn);
      repeat
        x1:=round(random*(maxx-2)+1);
        y1:=round(random*(maxy-2)+1);
      until (map^[x1,y1]<map_smoke);
      item[itemsn].x:=x1;
      item[itemsn].y:=y1;
      item[itemsn].item.w_id:=0;
      if (random<iy*itemdamagerate*2/((itemsn*10+nbot*20)*10)) or (random<0.1) then begin
        if random<0.93 then item[itemsn].item.w_id:=1 else item[itemsn].item.w_id:=4;
        if random<0.09 then item[itemsn].item.w_id:=2;
        if random<0.09 then item[itemsn].item.w_id:=3;
        item[itemsn].item.maxstate:=round((weapon_specifications[item[itemsn].item.w_id].maxstate*3/4)*random+weapon_specifications[item[itemsn].item.w_id].maxstate/4);
        item[itemsn].item.state:=round(item[itemsn].item.maxstate*random);
        item[itemsn].item.rechargestate:=0;
      end;
      if item[itemsn].item.w_id<4 then begin
        if random<0.7 then item[itemsn].item.ammo_id:=1 else item[itemsn].item.ammo_id:=2;
        if random>0.8 then item[itemsn].item.ammo_id:=3;
        if random>0.7 then item[itemsn].item.ammo_id:=4;
      end else begin
        item[itemsn].item.ammo_id:=5;
        if random<0.3 then item[itemsn].item.ammo_id:=6;
      end;
      item[itemsn].item.n:=round((ammo_specifications[item[itemsn].item.ammo_id].quantity-1)*random)+1;
  end;

  memo1.lines.add('...');
  memo1.lines.add('Calculating map strategy...');
  generate_LOS_base_map;
  total_bot_hp:=0;
  total_player_hp:=0;
  total_bot_firepower:=0;
  total_player_firepower:=0;
  for ix:=1 to nbot do begin
    if bot[ix].owner=player then begin
      if bot[ix].hp>15 then inc(total_player_hp,bot[ix].hp) else inc(total_player_hp,15);
      inc(total_player_firepower,10);
    end else begin
      if bot[ix].hp>15 then inc(total_bot_hp,bot[ix].hp) else inc(total_bot_hp,15);
      inc(total_bot_firepower,10);
    end;
  end;
  memo1.lines.add('Average LOS = '+inttostr(round(averageLOS)));
  if checkbox1.checked then ix:=defensedifficulty else ix:=1;
  memo1.lines.add('HP ratio = '+inttostr(round(100*total_bot_hp/total_player_hp))+'%');
  memo1.lines.add('Firepower ratio = '+inttostr(round(ix*100*total_bot_firepower/total_player_firepower*averageLOS/mapfreespace))+'%');
  iy:=round(100*total_bot_hp/total_player_hp * ix*total_bot_firepower/total_player_firepower * averageLOS/mapfreespace);
  memo1.lines.add('True difficulty = '+saydifficulty(iy));
  memo1.lines.add('...');

  if (form1.radiobutton3.checked) or ((form1.radiobutton2.checked) and (random>0.8)) then begin
    for ix:=maxx div 5+2 to maxx do
     for iy:=maxy div 5+2 to maxy do if map^[ix,iy]=map_free then map^[ix,iy]:=round(map_smoke*sqrt(random));
    for ix:=1 to 10 do grow_smoke;
  end;


  mapgenerated:=true;

  memo1.lines.add('Starting!');
  scrollbar1.position:=0; scrollbar2.position:=0;
  selected:=-1;
  selectedenemy:=-1;
  selectedonfloor:=-1;
  selecteditem:=-1;
  selectedx:=-1;
  selectedy:=-1;
  movement_map_for:=-1;
  viewx:=0;
  viewy:=0;
  memo1.lines.add('=========================');

  current_turn:=0;
  start_turn;

//  map_changed:=true;
end;

{--------------------------------------------------------------------------------------}

procedure TForm1.generate_items_types;
var i:integer;
begin
 with weapon_specifications[1] do begin
   NAME     := 'Lt. Wasp';
   ACC      :=  20;
   DAM      :=   0;
   RECHARGE :=  40;
   AIM      :=  10;
   RELOAD   :=  50;
   MAXSTATE := 150;
   for i:=1 to maxusableammo do AMMO[i]:=0;
   AMMO[1]  := 1;
   AMMO[2]  := 2;
   AMMO[3]  := 3;
   AMMO[4]  := 4;
 end;
 with weapon_specifications[2] do begin
   NAME     := 'Hv. Wasp';
   ACC      :=   0;
   DAM      :=   5;
   RECHARGE :=  50;
   AIM      :=  10;
   RELOAD   := 100;
   MAXSTATE :=  90;
   for i:=1 to maxusableammo do AMMO[i]:=0;
   AMMO[1]  := 1;
   AMMO[2]  := 2;
   AMMO[3]  := 3;
   AMMO[4]  := 4;
 end;
 with weapon_specifications[3] do begin
   NAME     := 'Sniper Wasp';
   ACC      := 100;
   DAM      :=   0;
   RECHARGE :=  40;
   AIM      :=  15;
   RELOAD   := 100;
   MAXSTATE :=  80;
   for i:=1 to maxusableammo do AMMO[i]:=0;
   AMMO[1]  := 1;
   AMMO[2]  := 2;
   AMMO[3]  := 3;
   AMMO[4]  := 4;
 end;
 with AMMO_specifications[1] do begin
   NAME        := 'Lt. Wasp clip';
   ACC         :=  0;
   DAM         := 15;
   QUANTITY    := 20;
   EXPLOSION   :=  0;
   AREA        :=  0;
   SMOKE       :=  0;
   TRACE_SMOKE :=  0;
 end;
 with AMMO_specifications[2] do begin
   NAME        := 'Ext. Wasp clip';
   ACC         :=  0;
   DAM         := 15;
   QUANTITY    := 30;
   EXPLOSION   :=  0;
   AREA        :=  0;
   SMOKE       :=  0;
   TRACE_SMOKE :=  0;
 end;
 with AMMO_specifications[3] do begin
   NAME        := 'Hv. Wasp clip';
   ACC         :=  0;
   DAM         := 20;
   QUANTITY    := 10;
   EXPLOSION   :=  0;
   AREA        :=  0;
   SMOKE       :=  0;
   TRACE_SMOKE :=  0;
 end;
with AMMO_specifications[4] do begin
   NAME        := 'Acc. Wasp clip';
   ACC         := 80;
   DAM         := 16;
   QUANTITY    := 12;
   EXPLOSION   :=  0;
   AREA        :=  0;
   SMOKE       :=  0;
   TRACE_SMOKE :=  0;
 end;
 {///}
 with weapon_specifications[4] do begin
   NAME     := 'St. Falcon';
   ACC      :=  10;
   DAM      :=   0;
   RECHARGE := 150;
   AIM      :=  60;
   RELOAD   := 200;
   MAXSTATE := 120;
   for i:=1 to maxusableammo do AMMO[i]:=0;
   AMMO[1]  := 5;
   AMMO[2]  := 6;
 end;
 with AMMO_specifications[5] do begin
   NAME        := 'St. Falcon clip';
   ACC         :=  0;
   DAM         :=130;
   QUANTITY    :=  7;
   EXPLOSION   := 30;
   AREA        :=  3;
   SMOKE       := 10;
   TRACE_SMOKE :=  0;
 end;
 with AMMO_specifications[6] do begin
   NAME        := 'Expl. Falcon clip';
   ACC         :=  0;
   DAM         := 10;
   QUANTITY    :=  7;
   EXPLOSION   :=999;
   AREA        := 26;
   SMOKE       := 50;
   TRACE_SMOKE :=  0;
 end;

{
 type ammo_type=record
   ACC,DAM:byte;
   EXPLOSION,AREA,SMOKE,TRACE SMOKE:byte;
 end; }
end;

{--------------------------------------------------------------------------------------}

procedure TForm1.FormCreate(Sender: TObject);
//var i:integer;
begin
  maxx:=maxmaxx;
  maxy:=maxmaxy;

  viewsizex:=30;
  viewsizey:=30;

  label5.caption:='Map size (min '+inttostr(minmaxx)+' ... max '+inttostr(maxmaxx)+'):';
  edit2.text:=inttostr(40);
  label11.caption:='(1..'+inttostr(maxbots-maxplayers)+'):';
  edit1.text:=inttostr(40);
  label12.caption:='(1..'+inttostr(maxplayers)+'):';
  edit5.text:=inttostr(4);

  new(map);
  new(vis);
  new(mapchanged);
  new(movement);
  new(LOS_base);
  gamemode:=gamemode_none;
  form1.DoubleBuffered:=true;
  generate_items_types;

  //generate_map;
  mapgenerated:=false;
  togglebox1.Checked:=true;
  togglebox1.state:=cbChecked;
  set_progressbar(false);

//  togglebox1.enabled:=false;

 {  MapDrawing:=TDrawMap.Create(true);
   {Threadx.onterminate:=@TFinish;}
   MapDrawing.freeonterminate:=false;
   MapDrawing.Priority:=tpLower;
   MapDrawing.resume; }
end;

{================================================================================}
{================================================================================}
{================================================================================}

procedure hit_bot(thisbot,dam:integer);
var j,ammo_d:integer;
begin
  if bot[thisbot].items[1].state>round(dam*itemdamagerate) then dec(bot[thisbot].items[1].state,round(dam*itemdamagerate)) else bot[thisbot].items[1].state:=0;
  bot[thisbot].action:=action_attack;
  if bot[thisbot].hp>dam then dec(bot[thisbot].hp,dam) else begin
   bot[thisbot].hp:=0;
   map^[bot[thisbot].x,bot[thisbot].y]:=map^[bot[thisbot].x,bot[thisbot].y]+map_smoke div 3;
   if map^[bot[thisbot].x,bot[thisbot].y]>map_smoke then map^[bot[thisbot].x,bot[thisbot].y]:=map_smoke;
   form1.memo1.lines.add(bot[thisbot].name + ' is destroyed');
   if thisbot=selected then begin
     form1.scrollbar1.position:=0; form1.scrollbar2.position:=0;
     selected:=-1;
   end;
   if thisbot=selectedenemy then begin
     selectedenemy:=-1;
     form1.generate_enemy_list;
   end;
   if (bot[thisbot].owner=player) and (this_turn<>player) then form1.clear_visible;       //and enemy turn!!!!
   //drop items//drop corpse
   for j:=1 to backpacksize do if ((bot[thisbot].items[j].w_id>0) or (bot[thisbot].items[j].ammo_id>0)) then begin
     if itemsn=maxitems then showmessage('TOO MANY ITEMS!!!') else
       inc(itemsn);
     item[itemsn].x:=bot[thisbot].x;
     item[itemsn].y:=bot[thisbot].y;
     item[itemsn].item:=bot[thisbot].items[j];
     if j=1 then begin
       item[itemsn].item.state:=round(0.9*item[itemsn].item.state-0.2*item[itemsn].item.state*random);
       ammo_d:=item[itemsn].item.n - item[itemsn].item.n div 3 - round(random);
       if ammo_d>0 then item[itemsn].item.n:=ammo_d else item[itemsn].item.ammo_id:=0;
     end;
   end;
  end;
end;

const maxblast=25;
      maxgeneration=maxblast;
type blastarea=array[-maxblast..maxblast,-maxblast..maxblast] of shortint;
var area:^blastarea;
    generationsum:float;
procedure calculate_area(ax,ay,a,asmoke,ablast:integer);
var ix,iy,dx,dy,count,generation,i,j:integer;
    flg,flg_x:boolean;
    direction_x,direction_y:^blastarea;
    mytimer:tdate;
    x2,y2:integer;
    //tmp_area:^blastarea;
begin
  new(area);
  new(direction_x);
  new(direction_y);

  for dx:=-maxblast to maxblast do
   for dy:=-maxblast to maxblast do begin
     if (ax+dx>1) and (ax+dx<maxx) and (ay+dy>1) and (ay+dy<maxy) then begin
       if map^[ax+dx,ay+dy]<map_wall then area^[dx,dy]:=125 else area^[dx,dy]:=99;
     end else
       area^[dx,dy]:=98;
     direction_x^[dx,dy]:=0;
     direction_y^[dx,dy]:=0;
   end;

 area^[0,0]:=1;

 generation:=1;
 count:=1;
 //new(tmp_area);
 repeat
   inc(generation);
   //tmp_area^:=area^;
   for ix:=-generation to generation do if abs(ix)<maxblast then
    for iy:=-generation to generation do if abs(iy)<maxblast then if area^[ix,iy]=125 then begin
      for dx:=-1 to 1 do
       for dy:=-1 to 1 do if {tmp_}area^[ix+dx,iy+dy]<generation then begin
         area^[ix,iy]:=generation;
         inc(direction_x^[ix,iy],dx);
         inc(direction_y^[ix,iy],dy);
       end;
      if area^[ix,iy]=generation then inc(count);
    end;
  until (count>=a) or (generation>=maxgeneration);
  //dispose(tmp_area);

  generationsum:=0;
  if generation>maxblast then generation:=maxblast;
  for ix:=-generation to generation do
   for iy:=-generation to generation do if area^[ix,iy]>maxgeneration then area^[ix,iy]:=0 else begin
     //if area^[ix,iy]>1 then dec(area^[ix,iy]);
     generationsum:=generationsum+1/sqrt(area^[ix,iy]);
   end;

  for dx:=-generation to generation do
   for dy:=-generation to generation do if (ax+dx>1) and (ax+dx<maxx) and (ay+dy>1) and (ay+dy<maxy) and (area^[dx,dy]>0) then
    if vis^[ax+dx,ay+dy]>=oldvisible then
     with form1.image1.canvas do begin
       //mapchanged^[ax+dx,ay+dy]:=0;
       //brush.style:=bsclear;
       x2:=round((dx+ax-viewx-0.5)*form1.image1.width / viewsizex);
       y2:=round((dy+ay-viewy-0.5)*form1.image1.height / viewsizey);
       pen.color:=RGB(255,255,180,0);
       ix:=round(sqr((ablast/10/generationsum)/sqrt(area^[dx,dy])))+5;
       if ix>(form1.image1.width / viewsizex-2) then  pen.width:=round((form1.image1.width / viewsizex-1))
         else pen.width:=ix;
       moveto(x2,y2);
       lineto(x2,y2);
     end;
//  form1.image1.update;
  mytimer:=now;
  repeat  form1.image1.update; until (now-mytimer)*24*60*60*1000>blastdelay;
{  form1.draw_map;                                     }

   //damage tagets
   for dx:=-generation to generation do
     for dy:=-generation to generation do
       if (ax+dx>1) and (ax+dx<maxx) and (ay+dy>1) and (ay+dy<maxy) and (area^[dx,dy]>0) then begin
         if map^[ax+dx,ay+dy]<map_wall then begin
           ix:=round((asmoke/generationsum)/sqrt(area^[dx,dy]));
           if ix<1 then ix:=1;
           map^[ax+dx,ay+dy]:=map^[ax+dx,ay+dy]+ix;
           if map^[ax+dx,ay+dy]>map_smoke then map^[ax+dx,ay+dy]:=map_smoke;
           mapchanged^[ax+dx,ay+dy]:=255;

           for i:=1 to nbot do if (bot[i].x=ax+dx) and (bot[i].y=ay+dy) and (bot[i].hp>0) then begin
             ix:=round((ablast/generationsum)/sqrt(area^[dx,dy]));
             if ix<1 then ix:=1;
             form1.memo1.lines.add(bot[i].name+' is hit for '+inttostr(ix)+' by explosion');
             hit_bot(i,ix);
             if vis^[bot[i].x,bot[i].y]>oldvisible then
             with form1.image1.canvas do begin
               brush.style:=bsclear;
               iy:=255;
               mytimer:=now;
               repeat
                 x2:=round((bot[i].x-viewx-0.5)*form1.image1.width / viewsizex);
                 y2:=round((bot[i].y-viewy-0.5)*form1.image1.height / viewsizey);
                 font.color:=RGB(iy,255,10,10);
                 font.size:=17;
                 textout(x2-10,y2-15,inttostr(ix));
                 form1.image1.update;
                 iy:=255-round(100*(now-mytimer)*24*60*60*1000/blastdelay);
               until iy<=155;
             end;
             for ix:=-1 to 1 do
               for iy:=-1 to 1 do mapchanged^[bot[i].x+ix,bot[i].y+iy]:=255;
             form1.draw_map;
           end;
         end;
       end;

   //push surviving tagets
   for i:=1 to nbot do if (bot[i].hp>0) then begin
   flg_x:=true;
   for dx:=-generation to generation do if flg_x then
     for dy:=-generation to generation do if flg_x then
       if (bot[i].x=ax+dx) and (bot[i].y=ay+dy) and (area^[dx,dy]>0) then begin
           flg_x:=false;
           ix:=round((ablast/generationsum)/sqrt(area^[dx,dy]));
           if ix>blastpush then begin
           mapchanged^[bot[i].x,bot[i].y]:=255;
           if map^[bot[i].x-sgn(direction_x^[dx,dy]),bot[i].y-sgn(direction_y^[dx,dy])]<map_wall then begin
             flg:=true;
             for j:=1 to nbot do
               if (bot[j].x=bot[i].x-sgn(direction_x^[dx,dy])) and (bot[j].y=bot[i].y-sgn(direction_y^[dx,dy])) and (bot[j].hp>0) then flg:=false;
             if flg then begin
               form1.memo1.lines.add('[dbg] push '+bot[i].name);
               dec(bot[i].x,sgn(direction_x^[dx,dy]));
               dec(bot[i].y,sgn(direction_y^[dx,dy]));
               mapchanged^[bot[i].x,bot[i].y]:=255;
               if (bot[i].owner=player) then form1.look_around(i);
             end;
           end;
           end;
         end;
    end;

    if this_turn=computer then form1.clear_visible;

  dispose(area);
  dispose(direction_x);
  dispose(direction_y);
end;

{--------------------------------------------------------------------------------}

procedure tform1.bot_shots(attacker,defender:integer);
var dx,dy,i:integer;
    damage:integer;
    LOS:integer;
    flg:boolean;

    timetoattack:word;
    range,statedamper:float;
    ACC,DAM:float;
    mytimer:TDate;

    x1,y1,x2,y2:integer;
begin
 flg:=true;
 if (bot[attacker].items[1].w_id>0) and (bot[attacker].items[1].ammo_id>0) then begin
    timetoattack:= weapon_specifications[bot[attacker].items[1].w_id].aim+bot[attacker].items[1].rechargestate;
    if bot[attacker].items[1].n=0 then begin
      flg:=false;
    end;
    if bot[attacker].items[1].state=0 then begin
       if bot[attacker].owner=player then showmessage('weapon jammed!');
      flg:=false;
    end;
 end else begin
    flg:=false;
    if bot[attacker].owner=player then showmessage('No ammo!');
 end;

 if (flg) and (bot[attacker].tu>=timetoattack) and (bot[defender].hp>0) then begin
   LOS:=check_LOS(bot[defender].x,bot[defender].y,bot[attacker].x,bot[attacker].y);
   if LOS>0 then begin
     ACC:=weapon_specifications[bot[attacker].items[1].w_id].ACC+ammo_specifications[bot[attacker].items[1].ammo_id].ACC+4;
     DAM:=weapon_specifications[bot[attacker].items[1].w_id].DAM+ammo_specifications[bot[attacker].items[1].ammo_id].DAM;
     //add modifiers
     range:=(accuracy_accuracy*sqrt(sqr(bot[defender].x-bot[attacker].x)+sqr(bot[defender].y-bot[attacker].y))-ACC)/accuracy_accuracy;
     if range<1 then range:=1;
     if bot[attacker].items[1].state<bot[attacker].items[1].maxstate div 3 then statedamper:=bot[attacker].items[1].state/(bot[attacker].items[1].maxstate/3) else statedamper:=1;
     damage:=round(statedamper*DAM / sqrt(sqrt(range)));
     if damage<1 then damage:=1;
     {if damage>0 then} begin
       memo1.lines.add(bot[attacker].name+' shots '+bot[defender].name + ' for ' + inttostr(damage));


       if bot[defender].owner=computer then begin
         for dx:=1 to nbot do if (bot[dx].owner=computer) and (bot[dx].hp>0) then
           if sqr(bot[dx].x-bot[defender].x)+sqr(bot[dx].y-bot[defender].y)<group_attack_range then begin
             bot[dx].target:=attacker;
             bot[dx].action:=action_attack;
         end;
       end;

       hit_bot(defender,damage);

       spend_tu(attacker,timetoattack);

       //modifiers;

         if bot[attacker].y-bot[defender].y<>0 then begin
           dx:=round(maxangle*arctan((bot[attacker].x-bot[defender].x)/(bot[attacker].y-bot[defender].y))/2/Pi);
           if bot[attacker].y-bot[defender].y>0 then dx:=150-dx else dx:=50-dx;
           bot[attacker].angle:=dx;
        end
         else begin
           if bot[attacker].x-bot[defender].x>0 then bot[attacker].angle:=100 else bot[attacker].angle:=0
         end;

//       draw_map;
//       if bot[defender].hp>0 then
       with image1.canvas do begin
         mapchanged^[bot[attacker].x,bot[attacker].y]:=255;
         brush.style:=bsclear;
         i:=255;
         if (bot[attacker].x<=viewx-1+2) or (bot[attacker].y<=viewy-1+2) or (bot[attacker].x>=viewx+viewsizex-2) or (bot[attacker].y>=viewy+viewsizey-2) or
            (bot[defender].x<=viewx-1+2) or (bot[defender].y<=viewy-1+2) or (bot[defender].x>=viewx+viewsizex-2) or (bot[defender].y>=viewy+viewsizey-2) then
               center_map((bot[attacker].x+bot[defender].x) div 2,(bot[attacker].y+bot[defender].y) div 2);

         mytimer:=now;
         repeat
           pen.color:=RGB(i,255,255,200);
           pen.width:=1;
           x1:=round((bot[attacker].x-viewx-0.5)*image1.width / viewsizex);
           y1:=round((bot[attacker].y-viewy-0.5)*image1.height / viewsizey);
           x2:=round((bot[defender].x-viewx-0.5)*image1.width / viewsizex);
           y2:=round((bot[defender].y-viewy-0.5)*image1.height / viewsizey);
           moveto(x1,y1);
           lineto(x2,y2);
           font.color:=RGB(i,255,10,10);
           font.size:=17;
//           if damage>=10 then dx:=dx-7;
           textout(x2-10,y2-15,inttostr(damage));
           image1.update;
           i:=255-round(100*(now-mytimer)*24*60*60*1000/shotdelay);
         until i<=155;
         range:=(visibleaccuracy*sqrt(sqr(bot[defender].x-bot[attacker].x)+sqr(bot[defender].y-bot[attacker].y)));
         for i:=0 to round(range) do mapchanged^[bot[attacker].x+round((bot[defender].x-bot[attacker].x)*i/range),bot[attacker].y+round((bot[defender].y-bot[attacker].y)*i/range)]:=255;
         for dx:=-1 to 1 do
           for dy:=-1 to 1 do mapchanged^[bot[defender].x+dx,bot[defender].y+dy]:=255;
      end;
       draw_map;

       if ammo_specifications[bot[attacker].items[1].ammo_id].SMOKE>0 then begin
         calculate_area(bot[defender].x,bot[defender].y,ammo_specifications[bot[attacker].items[1].ammo_id].AREA,ammo_specifications[bot[attacker].items[1].ammo_id].SMOKE,ammo_specifications[bot[attacker].items[1].ammo_id].EXPLOSION);
         draw_map;
       end;
       if bot[attacker].hp>0 then begin
         dec(bot[attacker].items[1].n);
         if bot[attacker].items[1].state>0 then dec(bot[attacker].items[1].state);
         if bot[attacker].items[1].n>0 then
           bot[attacker].items[1].rechargestate:= weapon_specifications[bot[attacker].items[1].w_id].recharge
         else
           bot[attacker].items[1].ammo_id:=0;
       end;

     end;
   end;
 end;
end;

{================================================================================}
{================================================================================}
{================================================================================}

procedure TForm1.grow_smoke;
var ix,iy:integer;
    i:integer;
    dx,dy:shortint;
    smoke_new:^map_array;
begin
 new(smoke_new);
 smoke_new^:=map^;

 for ix:=1 to maxx do
   for iy:=1 to maxy do if (smoke_new^[ix,iy]=1) and (random>0.5) then smoke_new^[ix,iy]:=0;

 for ix:=1 to maxx do
   for iy:=1 to maxy do if (map^[ix,iy]>1) and (map^[ix,iy]<=map_smoke) then begin
     i:=0;
     repeat
       inc(i);
       dx:=round(random*2)-1;
       dy:=round(random*2)-1;
       if (ix+dx>0) and (ix+dx<=maxx) and (iy+dy>0) and (iy+dy<=maxy) and ((dx<>0) or (dy<>0)) then begin
         if (smoke_new^[ix+dx,iy+dy]<map^[ix,iy]) and (smoke_new^[ix+dx,iy+dy]<map_smoke) then begin
           dec(map^[ix,iy]);
           dec(smoke_new^[ix,iy]);
           inc(smoke_new^[ix+dx,iy+dy]);
         end;
       end;
     until (i>=30) or (map^[ix,iy]=1);
   end;

 map^:=smoke_new^;
 dispose(smoke_new);
end;

{--------------------------------------------------------------------------------------}

procedure Tform1.clear_visible;
var x1,y1,i:integer;
begin
  for x1:=1 to maxx do
    for y1:=1 to maxy do if vis^[x1,y1]>0 then begin vis^[x1,y1]:=oldvisible; mapchanged^[x1,y1]:=255; end;

  for i:=1 to nbot do if bot[i].owner=player then look_around(i);
end;

{--------------------------------------------------------------------------------------}

const max_los_targets=maxplayers;
procedure Tform1.bot_action(thisbot:integer);
var LOS_targets:array[1..max_los_targets] of integer;
    j,k,l:integer;
    stopactions,flg,weaponneeded:boolean;
    ammo_available,weapon_available:byte;
    lastrange,aim:integer;
    x1,y1,dx,dy:integer;
    timetoshot:integer;
    passcount:byte;
begin
  passcount:=0;
  repeat
    stopactions:=false;
    inc(passcount);
    if passcount>250 then stopactions:=true;

    //check available backup weapon & ammo
    ammo_available:=0;
    weapon_available:=0;
    for j:=2 to backpacksize do begin
      if (bot[thisbot].items[j].w_id>0) and (bot[thisbot].items[j].n>0) and (bot[thisbot].items[j].state>0) then begin
        if (bot[thisbot].items[j].state>bot[thisbot].items[j].maxstate div 3) and (bot[thisbot].items[j].n>3) then weapon_available:=j;
        if (weapon_available=0) and (bot[thisbot].items[j].state>0) and (bot[thisbot].items[j].n>0) then weapon_available:=j;
      end else
      if (bot[thisbot].items[j].ammo_id>0) and (bot[thisbot].items[j].n>0) and (bot[thisbot].items[1].w_id>0) then begin
        flg:=false;
        for k:=1 to maxusableammo do if weapon_specifications[bot[thisbot].items[1].w_id].AMMO[k]=bot[thisbot].items[j].ammo_id then flg:=true;
        if flg then begin
          if (bot[thisbot].items[j].n>3) then ammo_available:=j;
          if (ammo_available=0) then ammo_available:=j;
        end;
      end;
    end;
    // reload weapon if needed
    weaponneeded:=false;
    if (bot[thisbot].items[1].w_id<=0) or (bot[thisbot].items[1].state=0) or ((bot[thisbot].items[1].state<bot[thisbot].items[1].maxstate div 4) and (vis^[bot[thisbot].x,bot[thisbot].y]<=oldvisible)) then begin
      if weapon_available>0 then load_weapon(thisbot,weapon_available) else
        weaponneeded:=true;
    end;
    // reload ammo if needed
    if (bot[thisbot].items[1].n=0) then begin
      if ammo_available>0 then load_weapon(thisbot,ammo_available) else
      if weapon_available>0 then load_weapon(thisbot,weapon_available) else
        weaponneeded:=true;
    end;
    // seek weapon
    if (weaponneeded) and (itemsn>0) then begin
      // go find closest weapon state>0
      lastrange:=sqr(maxx)+sqr(maxy);
      aim:=0;
      for j:=1 to itemsn do if (sqr(bot[thisbot].x-item[j].x)+sqr(bot[thisbot].y-item[j].y)<lastrange) and (item[j].item.w_id>0) and (item[j].item.state>0) and (item[j].item.n>0) then begin
        flg:=true;
        for k:=1 to nbot do if (bot[k].hp>0) and (k<>thisbot) and (bot[k].x=item[j].x) and (bot[k].y=item[j].y) then flg:=false;
        if (aim>0) and (item[j].item.state<item[j].item.maxstate div 3) and (item[j].item.n<4) then flg:=false;
        if flg then generatemovement(thisbot,item[j].x,item[j].y);
        if (flg) and (movement^[item[j].x,item[j].y]<10) then begin
          aim:=j;
          lastrange:=sqr(bot[thisbot].x-item[j].x)+sqr(bot[thisbot].y-item[j].y)
        end;
      end;
      if (aim=0) or (bot[thisbot].items[backpacksize].ammo_id>0) or (bot[thisbot].items[backpacksize].w_id>0) then begin
        if aim>0 then for j:=2 to backpacksize do drop_item(thisbot,j);
        stopactions:=true {!}
      end else
        move_bot(thisbot,item[aim].x,item[aim].y,100);
    end;
    //see items on the ground and take if vis<0 or needed
    find_onfloor(bot[thisbot].x,bot[thisbot].y);
    if (onfloorn>0) and ((weaponneeded) or (vis^[bot[thisbot].x,bot[thisbot].y]<=oldvisible)) then begin
      j:=1;
      repeat
        if item[onfloor[j]].item.state>0 then begin
          pick_up(thisbot,j);
          j:=onfloorn;
        end;
        inc(j);
      until j>onfloorn;
    end;
    //get LOS tagets
    if (bot[thisbot].action=action_attack) and (bot[bot[thisbot].target].hp=0) then begin
      for j:=1 to nbot do if (bot[j].owner=player) and (bot[j].hp>0) then bot[thisbot].target:=j;
      if bot[bot[thisbot].target].hp=0 then bot[thisbot].action:=action_random;
    end;


    k:=0;
    for j:=1 to playersn do if (check_LOS(bot[thisbot].x,bot[thisbot].y,bot[j].x,bot[j].y)>0) and (bot[j].hp>0) then begin
      inc(k);
      LOS_targets[k]:=j;
    end;
    //if LOS not empty - attack&move
    if k>0 then begin
      lastrange:=sqr(maxx)+sqr(maxy);
      aim:=0;
      for j:=1 to k do if sqr(bot[thisbot].x-bot[LOS_targets[j]].x)+ sqr(bot[thisbot].y-bot[LOS_targets[j]].y)<lastrange then begin
        aim:=LOS_targets[j];
        lastrange:=sqr(bot[thisbot].x-bot[aim].x)+ sqr(bot[thisbot].y-bot[aim].y)
      end;
      bot[thisbot].action:=action_attack;
      bot[thisbot].target:=aim;
      bot_shots(thisbot,bot[thisbot].target);
    end;

    timetoshot:=bot[thisbot].items[1].rechargestate+weapon_specifications[bot[thisbot].items[1].w_id].aim;
    if (bot[thisbot].tu<timetoshot) {or ((bot[thisbot].tu<timetoshot+bot[thisbot].speed*sqrt(2)) and (vis^[bot[thisbot].x,bot[thisbot].y]<=oldvisible))} then begin
      if bot[thisbot].tu>=bot[thisbot].speed then begin
        //escape visible range;
        dx:=-1;dy:= 0; if (map^[bot[thisbot].x+dx,bot[thisbot].y+dy]=map_free) and (vis^[bot[thisbot].x+dx,bot[thisbot].y+dy]<=oldvisible) then move_bot(thisbot,bot[thisbot].x+dx,bot[thisbot].y+dy,1);
        dx:= 0;dy:=-1; if (map^[bot[thisbot].x+dx,bot[thisbot].y+dy]=map_free) and (vis^[bot[thisbot].x+dx,bot[thisbot].y+dy]<=oldvisible) then move_bot(thisbot,bot[thisbot].x+dx,bot[thisbot].y+dy,1);
        dx:=-1;dy:=-1; if (map^[bot[thisbot].x+dx,bot[thisbot].y+dy]=map_free) and (vis^[bot[thisbot].x+dx,bot[thisbot].y+dy]<=oldvisible) then move_bot(thisbot,bot[thisbot].x+dx,bot[thisbot].y+dy,1);
        dx:=-1;dy:=-1; if (map^[bot[thisbot].x+dx,bot[thisbot].y+dy]=map_free) and (vis^[bot[thisbot].x+dx,bot[thisbot].y+dy]<=oldvisible) then move_bot(thisbot,bot[thisbot].x+dx,bot[thisbot].y+dy,1);
        dx:=-1;dy:=+1; if (map^[bot[thisbot].x+dx,bot[thisbot].y+dy]=map_free) and (vis^[bot[thisbot].x+dx,bot[thisbot].y+dy]<=oldvisible) then move_bot(thisbot,bot[thisbot].x+dx,bot[thisbot].y+dy,1);
        dx:=+1;dy:=-1; if (map^[bot[thisbot].x+dx,bot[thisbot].y+dy]=map_free) and (vis^[bot[thisbot].x+dx,bot[thisbot].y+dy]<=oldvisible) then move_bot(thisbot,bot[thisbot].x+dx,bot[thisbot].y+dy,1);
        dx:= 0;dy:=+1; if (map^[bot[thisbot].x+dx,bot[thisbot].y+dy]=map_free) and (vis^[bot[thisbot].x+dx,bot[thisbot].y+dy]<=oldvisible) then move_bot(thisbot,bot[thisbot].x+dx,bot[thisbot].y+dy,1);
        dx:=+1;dy:= 0; if (map^[bot[thisbot].x+dx,bot[thisbot].y+dy]=map_free) and (vis^[bot[thisbot].x+dx,bot[thisbot].y+dy]<=oldvisible) then move_bot(thisbot,bot[thisbot].x+dx,bot[thisbot].y+dy,1);

        //try to minimize LOS
        dx:=-1;dy:= 0; if (map^[bot[thisbot].x+dx,bot[thisbot].y+dy]=map_free) and (LOS_base^[bot[thisbot].x+dx,bot[thisbot].y+dy]<LOS_base^[bot[thisbot].x,bot[thisbot].y]) then move_bot(thisbot,bot[thisbot].x+dx,bot[thisbot].y+dy,1);
        dx:=+1;dy:= 0; if (map^[bot[thisbot].x+dx,bot[thisbot].y+dy]=map_free) and (LOS_base^[bot[thisbot].x+dx,bot[thisbot].y+dy]<LOS_base^[bot[thisbot].x,bot[thisbot].y]) then move_bot(thisbot,bot[thisbot].x+dx,bot[thisbot].y+dy,1);
        dx:= 0;dy:=-1; if (map^[bot[thisbot].x+dx,bot[thisbot].y+dy]=map_free) and (LOS_base^[bot[thisbot].x+dx,bot[thisbot].y+dy]<LOS_base^[bot[thisbot].x,bot[thisbot].y]) then move_bot(thisbot,bot[thisbot].x+dx,bot[thisbot].y+dy,1);
        dx:= 0;dy:=+1; if (map^[bot[thisbot].x+dx,bot[thisbot].y+dy]=map_free) and (LOS_base^[bot[thisbot].x+dx,bot[thisbot].y+dy]<LOS_base^[bot[thisbot].x,bot[thisbot].y]) then move_bot(thisbot,bot[thisbot].x+dx,bot[thisbot].y+dy,1);
        dx:=-1;dy:=-1; if (map^[bot[thisbot].x+dx,bot[thisbot].y+dy]=map_free) and (LOS_base^[bot[thisbot].x+dx,bot[thisbot].y+dy]<LOS_base^[bot[thisbot].x,bot[thisbot].y]) then move_bot(thisbot,bot[thisbot].x+dx,bot[thisbot].y+dy,1);
        dx:=+1;dy:=-1; if (map^[bot[thisbot].x+dx,bot[thisbot].y+dy]=map_free) and (LOS_base^[bot[thisbot].x+dx,bot[thisbot].y+dy]<LOS_base^[bot[thisbot].x,bot[thisbot].y]) then move_bot(thisbot,bot[thisbot].x+dx,bot[thisbot].y+dy,1);
        dx:=-1;dy:=-1; if (map^[bot[thisbot].x+dx,bot[thisbot].y+dy]=map_free) and (LOS_base^[bot[thisbot].x+dx,bot[thisbot].y+dy]<LOS_base^[bot[thisbot].x,bot[thisbot].y]) then move_bot(thisbot,bot[thisbot].x+dx,bot[thisbot].y+dy,1);
        dx:=-1;dy:=+1; if (map^[bot[thisbot].x+dx,bot[thisbot].y+dy]=map_free) and (LOS_base^[bot[thisbot].x+dx,bot[thisbot].y+dy]<LOS_base^[bot[thisbot].x,bot[thisbot].y]) then move_bot(thisbot,bot[thisbot].x+dx,bot[thisbot].y+dy,1);
      end;
//      stopactions:=true;
    end;
    //action/attack - go to the nearest LOS
    if (bot[thisbot].action=action_attack) and (bot[bot[thisbot].target].hp>0) then begin
      if (k=0) or (bot[thisbot].items[1].rechargestate>=bot[thisbot].speed) then begin
        lastrange:=sqr(bot[thisbot].x-bot[bot[thisbot].target].x)+sqr(bot[thisbot].y-bot[bot[thisbot].target].y);
        j:=1;
        flg:=false;
        repeat
          for dx:=bot[thisbot].x-j to bot[thisbot].x+j do
           for dy:=bot[thisbot].y-j to bot[thisbot].y+j do if (dx>0) and (dy>0) and (dx<=maxx) and (dy<=maxy) then
            if (map^[dx,dy]<map_wall) and (vis^[dx,dy]>oldvisible) and (lastrange>sqr(dx-bot[bot[thisbot].target].x)+sqr(dy-bot[bot[thisbot].target].y)) then begin
              aim:=1;
              for l:=1 to nbot do if (bot[l].x=dx) and (bot[l].y=dy) and (bot[l].hp>0) then aim:=0;
              if aim=1 then generatemovement(thisbot,dx,dy);
              if (aim=1) and (movement^[dx,dy]<10) then begin
                x1:=dx;
                y1:=dy;
                lastrange:=sqr(x1-bot[bot[thisbot].target].x)+sqr(y1-bot[bot[thisbot].target].y);
                flg:=true;
              end;
            end;
          inc(j);
        until (flg) or (j>maxx);
        if flg then begin
          if ((k<>0) and (j<=1+timetoshot/(bot[thisbot].speed*sqrt(2))) and (bot[thisbot].items[1].rechargestate>=bot[thisbot].speed*sqrt(sqr(bot[thisbot].x-x1)+sqr(bot[thisbot].y-y1)))) or (k=0) then move_bot(thisbot,x1,y1,1)
        end else
          if (k=0) then stopactions:=true;
      end;
    end;
    //action/random - walk around
    if (bot[thisbot].action=action_random) or (passcount>100) then begin
      x1:=bot[thisbot].x+round(2*(random-0.5));
      y1:=bot[thisbot].y+round(2*(random-0.5));
      if (map^[x1,y1]<map_wall) and ((x1<>bot[thisbot].x) or (y1<>bot[thisbot].y)) and ((LOS_base^[x1,y1]<LOS_base^[bot[thisbot].x,bot[thisbot].y]) or (random<0.05+(bot[thisbot].tu-50)/100)) then
        move_bot(thisbot,x1,y1,2)
      //may be blocked and inable to use all tus!!!
    end;
    //action/guard - stand still
    if bot[thisbot].action=action_guard then stopactions:=true;
    //try to end turn at minimum nearest LOS_base & no LOS
    //stopactions:=true;
  until (bot[thisbot].tu<30*sqrt(2)*1.01) or (stopactions);
end;


procedure TForm1.end_turn;
var i{,j,k,j2}:integer;
{    lastrange,aim:integer;
    flg:boolean;}
    //LOS_targets:array[1..max_los_targets] of integer;
begin
  this_turn:=computer;

  grow_smoke;
  selectedenemy:=-1;
  memo1.clear;
  clear_visible;
  //LOS - is "current" map_visible;
  for i:=1 to nbot do if bot[i].owner<>player then begin
    spend_tu(i,bot[i].tu);
    bot[i].tu:=255;
  end;

  set_progressbar(true);
  progressbar1.max:=nbot;
  for i:=1 to nbot do if (bot[i].owner<>player) and (bot[i].hp>0) then begin
    bot_action(i);
    progressbar1.position:=i;
    progressbar1.update;
  end;

{  begin
  if ((bot[i].items[1].w_id<=0) or (bot[i].items[1].n<=0) or (bot[i].items[1].state<bot[i].items[1].maxstate/4)) then begin
     {reload from the backpack if none - go to find}
     flg:=true;
     for j:=2 to backpacksize do if (flg) and (((bot[i].items[j].w_id>0) and (bot[i].items[j].state>bot[i].items[j].maxstate/3)) or ((bot[i].items[j].w_id=0) and (bot[i].items[j].ammo_id>0))) and (bot[i].items[j].n>0) then begin
        flg:=not load_weapon(i,j);
        memo1.lines.add('[dbg] reloading...');
     end;

     if (flg) and (itemsn>0) then begin
      memo1.lines.add('[dbg] searching...');
      find_onfloor(bot[i].x,bot[i].y);
      if onfloorn>0 then begin
        memo1.lines.add('[dbg] taking...');
        pick_up(i,1);
        flg:=true;
        for j:=2 to backpacksize do if (flg) and (((bot[i].items[j].w_id>0) and (bot[i].items[j].state>bot[i].items[j].maxstate/3)) or ((bot[i].items[j].w_id=0) and (bot[i].items[j].ammo_id>0))) and (bot[i].items[j].n>0) then begin
           flg:=not load_weapon(i,j);
           memo1.lines.add('reloading...');
        end;
      end else begin
        lastrange:=sqr(maxx)+sqr(maxy); k:=1;
        for j:=1 to itemsn do if lastrange>sqr(item[j].x-bot[i].x)+sqr(item[j].y-bot[i].y) then begin
          flg:=true;
          for j2:=1 to nbot do if (item[j].x=bot[j2].x) and (item[j].y=bot[j2].y) then flg:=false;
          if flg then begin
            k:=j;
            lastrange:=sqr(item[j].x-bot[i].x)+sqr(item[j].y-bot[i].y);
          end;
        end;
        move_bot(i,item[k].x,item[k].y,100)
      end;
     end;
    end;
    if (bot[i].action=action_passive_random) or (bot[i].action=action_agressive_random) or (bot[i].target<=0) then begin
      repeat
        if (bot[i].action=action_passive_random) then begin
          for j:=1 to playersn do bot_shots(i,round(random*(playersn-1)+1));
          move_bot(i,bot[i].x+round(random*2-1),bot[i].y+round(random*2-1),1)
        end else begin
          k:=0;
          for j:=1 to playersn do if (check_LOS(bot[i].x,bot[i].y,bot[j].x,bot[j].y)>0) and (bot[j].hp>0) then begin
            inc(k);
            LOS_targets[k]:=j;
          end;
          if k>0 then begin
            lastrange:=sqr(maxx)+sqr(maxy);
            for j:=1 to k do if sqr(bot[i].x-bot[LOS_targets[j]].x)+ sqr(bot[i].y-bot[LOS_targets[j]].y)<lastrange then begin
              aim:=LOS_targets[j];
              lastrange:=sqr(bot[i].x-bot[aim].x)+ sqr(bot[i].y-bot[aim].y)
            end;
            bot[i].action:=action_attack;
            bot[i].target:=aim;
            bot_shots(i,bot[i].target);
          end else
            move_bot(i,bot[i].x+round(random*2-1),bot[i].y+round(random*2-1),1)
        end;
      until (bot[i].tu<50) or (random>0.99);
    end else begin
      repeat
        if (bot[bot[i].target].hp=0) then bot[i].target:=round(random*3)+1;

          k:=0;
          for j:=1 to playersn do if (check_LOS(bot[i].x,bot[i].y,bot[j].x,bot[j].y)>0) and (bot[j].hp>0) then begin
            inc(k);
            LOS_targets[k]:=j;
          end;
          if k>0 then begin
            lastrange:=sqr(maxx)+sqr(maxy);
            for j:=1 to k do if sqr(bot[i].x-bot[LOS_targets[j]].x)+ sqr(bot[i].y-bot[LOS_targets[j]].y)<lastrange then begin
              aim:=LOS_targets[j];
              lastrange:=sqr(bot[i].x-bot[aim].x)+ sqr(bot[i].y-bot[aim].y)
            end;
            bot[i].action:=action_attack;
            bot[i].target:=aim;
            bot_shots(i,bot[i].target);
          end else
            move_bot(i,bot[bot[i].target].x+round(random*8)-4,bot[bot[i].target].y+round(random*8)-4,2)
      until (bot[i].tu<50) or (random>0.99);
    end;
  end;}

  start_turn;
end;

{--------------------------------------------------------------------------------------}

procedure TForm1.start_turn;
var i:integer;
    ix,iy:integer;
    n1,n2:integer;
begin
  this_turn:=player;
  inc(current_turn);
  set_progressbar(false);
  memo1.lines.add('TURN: '+inttostr(current_turn));
  grow_smoke;
  clear_visible;
  n1:=0; n2:=0;
  for i:=1 to nbot do if bot[i].hp>0 then begin if bot[i].owner=player then begin spend_tu(i,bot[i].tu); bot[i].tu:=255; inc(n2) end else inc(n1); end;
  if (n1<n2) or (n1<3) then begin
    for i:=1 to nbot do if (bot[i].hp>0) and (bot[i].owner=computer) and (bot[i].action<>action_attack) then begin
      bot[i].action:=action_attack;
      bot[i].target:=round(random*(playersn-1))+1;
    end;
  end;
  memo1.lines.add('bots remaining: '+inttostr(n1));
  if n1=0 then gamemode:=gamemode_victory;
  if n2=0 then gamemode:=gamemode_defeat;
  if (n1=0) or (n2=0) then
   for n1:=1 to maxx do
    for n2:=1 to maxy do begin
      vis^[n1,n2]:=maxvisible;
      mapchanged^[n1,n2]:=255;
    end;
  n1:=0; n2:=0;
  for ix:=1 to maxx do
    for iy:=1 to maxy do if map^[ix,iy]<=map_smoke then begin
      inc(n1);
      if vis^[ix,iy]>0 then inc(n2);
    end;
  memo1.lines.add('MapExplored: '+inttostr(round(n2*100/n1))+'%');
  memo1.lines.add('------------------------------');
  generate_enemy_list;
//  draw_map_all:=true;

//  bot[5].owner:=player;

  draw_map;
end;

{================================================================================}
{================================================================================}
{================================================================================}


procedure TForm1.Button1Click(Sender: TObject);
var i,n1,n2:integer;
begin
  n1:=0; n2:=0;
  for i:=1 to nbot do if (bot[i].owner=player) and (bot[i].hp>0) then begin
    inc(n1);
    if bot[i].tu=255 then inc(n2);
  end;
  if (n1=n2) and (n1>0) then begin
    if MessageDlg('Are you sure you want to end the turn? You have not moved any units.',mtCustom, [mbYes,mbCancel], 0)=MrYes then end_turn;
  end else begin
     if (n2>0) and (checkbox2.checked) then begin
       if MessageDlg('Are you sure you want to end the turn? '+inttostr(n2)+' your units are idle this turn.',mtCustom, [mbYes,mbCancel], 0)=MrYes then end_turn;
     end else end_turn;
  end;
end;

{--------------------------------------------------------------------------------------}

procedure TForm1.Button2Click(Sender: TObject);
var buttonpressed:boolean;
begin
 if (mapgenerated) and (gamemode=gamemode_game) then buttonpressed:=(MessageDlg('Are you sure? Current map will be lost.',mtCustom, [mbYes,mbCancel], 0)=MrYes) else buttonpressed:=true;
 if buttonpressed then begin
  memo1.clear;
  generate_map;
  togglebox1.checked:=false;
  togglebox1.state:=cbUnchecked;
  gamemode:=gamemode_game;
{  setcontrols_game(true);
  setcontrols_menu(false);}
  togglebox1.enabled:=true;
 end;
end;

{--------------------------------------------------------------------------------------}

procedure TForm1.Button3Click(Sender: TObject);
var ix,iy:integer;
begin
if MessageDlg('Are you sure? Your progress will be lost.',mtCustom, [mbYes,mbCancel], 0)=MrYes then begin
 selected:=-1; selectedx:=-1; selectedy:=-1; selectedenemy:=-1; selecteditem:=-1; selectedonfloor:=-1;
 for ix:=1 to playersn do bot[ix].hp:=0;
 for ix:=1 to maxx do
    for iy:=1 to maxy do begin
       vis^[ix,iy]:=maxvisible;
       mapchanged^[ix,iy]:=255;
    end;
  generate_enemy_list;
  draw_map_all:=true;
  draw_map;
  togglebox1.checked:=false;
  togglebox1.state:=cbUnchecked;
  gamemode:=gamemode_defeat;
end
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  togglebox1.checked:=false;
  togglebox1.state:=cbUnchecked;
end;

procedure TForm1.Button5Click(Sender: TObject);
var MyImage:TJPEGImage;
    destrect:TRect;
begin
{help}
  previous_gamemode:=gamemode;
  togglebox1.checked:=false;
  togglebox1.state:=cbUnchecked;
  setcontrols_game(false);
  setcontrols_menu(false);
  gamemode:=gamemode_help;
  MyImage:=TJPEGImage.create;
//  MyImage.canvas.height:=image1.height;
//  MyImage.canvas.width:=image1.width;
  MyImage.LoadFromFile(ExtractFilePath(application.ExeName)+'help.jpg');
  image1.visible:=true;
  destrect:=Rect(0,0,image1.width,image1.height);
  image1.Canvas.CopyRect(destrect,MyImage.canvas,destrect);
  MyImage.free;
end;

procedure TForm1.Button6Click(Sender: TObject);
begin
  form1.close;
end;

procedure TForm1.Button7Click(Sender: TObject);
var MyImage:TJPEGImage;
    destrect:TRect;
begin
{help}
  previous_gamemode:=gamemode;
  togglebox1.checked:=false;
  togglebox1.state:=cbUnchecked;
  setcontrols_game(false);
  setcontrols_menu(false);
  gamemode:=gamemode_help;
  MyImage:=TJPEGImage.create;
//  MyImage.canvas.height:=image1.height;
//  MyImage.canvas.width:=image1.width;
  MyImage.LoadFromFile(ExtractFilePath(application.ExeName)+'help_menu.jpg');
  image1.visible:=true;
  destrect:=Rect(0,0,image1.width,image1.height);
  image1.Canvas.CopyRect(destrect,MyImage.canvas,destrect);
  MyImage.free;
end;


procedure TForm1.Edit4Change(Sender: TObject);
var botsquantity,hpquantity,playerhp,playerquantity,i:integer;
    difficulty,mapsize:integer;
begin
  val(edit5.text,playersn,i);
  if playersn<1 then playersn:=1;
  playerquantity:=playersn;
  val(edit4.text,playerhp,i);
  val(edit1.text,botsquantity,i);
  val(edit2.text,mapsize,i);
  val(edit3.text,hpquantity,i);
  label8.caption:='Formal test ok';
  label8.color:=$AAFFAA;
  if hpquantity*botsquantity>playerquantity*20*10+botsquantity*10*10 then begin
    label8.caption:='Additional ammo will be generated';
    label8.color:=$AAAAFF;
  end;
  if playerhp*playerquantity>botsquantity*20*10 then begin
    label8.caption:='Enemies will not be able to kill you';
    label8.color:=$0000FF;
  end;
  if botsquantity+playerquantity>mapsize*mapsize*0.2 then begin
    label8.caption:='Not enough space on the map to place bots';
    label8.color:=$0000FF;
  end;

  if (mapsize>2) and (playerhp>0) and (playerquantity>0) and (hpquantity>0) and (botsquantity>0) then begin
    if hpquantity<15 then hpquantity:=15;
    difficulty:=round(100*(hpquantity*botsquantity)/(playerhp*playerquantity) * botsquantity/playerquantity * 2 * 50/sqr(mapsize));
    if checkbox1.checked then difficulty:=difficulty*defensedifficulty;
    label10.Caption:='Difficulty: '+saydifficulty(difficulty);
  end else label10.caption:='ERROR CALCULATING DIFFICULTY';
end;

{--------------------------------------------------------------------------------------}

{procedure TForm1.CheckBox1Change(Sender: TObject);
begin
  if checkbox1.checked then begin
    button2.enabled:=true;
    button3.enabled:=true;
    radiobutton1.enabled:=true;
    radiobutton2.Enabled:=true;
    radiobutton3.Enabled:=true;
    combobox1.enabled:=true;
  end else begin
    button2.enabled:=false;
    button3.enabled:=false;
    radiobutton1.enabled:=false;
    radiobutton2.Enabled:=false;
    radiobutton3.Enabled:=false;
    combobox1.enabled:=false;
  end;
end;}

{--------------------------------------------------------------------------------------}

procedure TForm1.FormDestroy(Sender: TObject);
begin
  dispose(map);
  dispose(vis);
  dispose(movement);
  dispose(mapchanged);
  dispose(LOS_base);
end;

{================================================================================}
{================================================================================}
{================================================================================}


procedure TForm1.Image1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var // scalex,scaley:float;
    mousex,mousey:integer;
    i:integer;
    found:integer;
begin
if gamemode>200 then begin
 mousex:=round(x / (image1.width / viewsizex)+0.5)+viewx;
 mousey:=round(y / (image1.height / viewsizey)+0.5)+viewy;
 if (Button=mbmiddle) then begin
   center_map(mousex,mousey)
 end else begin
  if (mousex>0) and (mousey>0) and (mousex<=maxx) and (mousey<=maxy) then
  if (map^[mousex,mousey]<=map_smoke) and (vis^[mousex,mousey]>0) then begin
    mapchanged^[mousex,mousey]:=255;
    found:=-1;
    for i:=1 to nbot do if (bot[i].x=mousex) and (bot[i].y=mousey) and (vis^[mousex,mousey]>oldvisible) and (bot[i].hp>0) then found:=i;
    if found>0 then begin
      {clicked a bot}
      if (Button=mbLeft) and (bot[found].owner=player) then begin
        //if (selectedx>0) then draw_map_all:=true; ///////// OPTIMIZE HERE
        if (selected>0) then mapchanged^[bot[selected].x,bot[selected].y]:=255;
        if (selectedenemy>0) then mapchanged^[bot[selectedenemy].x,bot[selectedenemy].y]:=255;
        scrollbar1.position:=0; scrollbar2.position:=0;
        selected:=found;
        mapchanged^[bot[selected].x,bot[selected].y]:=255;
        selectedx:=-1; selectedy:=-1; selectedenemy:=-1; selecteditem:=-1; selectedonfloor:=-1;
      end;
      if (Button=mbright) and (bot[found].owner=computer) then begin
        if (selectedenemy<>found) and (checkbox2.checked) then begin
          if vis^[mousex,mousey]>oldvisible then begin
            //if (selectedx>0) then draw_map_all:=true;   ///////// OPTIMIZE HERE
            if (selectedenemy>0) then mapchanged^[bot[selectedenemy].x,bot[selectedenemy].y]:=255;
            selectedenemy:=found;
            mapchanged^[bot[selectedenemy].x,bot[selectedenemy].y]:=255;
            selectedx:=-1; selectedy:=-1;
          end;
        end else begin
          {fire}
          if checkbox2.checked=false then begin if selectedenemy>0 then mapchanged^[bot[selectedenemy].x,bot[selectedenemy].y]:=255; selectedenemy:=found; end;
          selectedx:=-1; selectedy:=-1;
          bot_shots(selected,selectedenemy);
        end;
      end;
    end else begin
      if (Button=mbleft) and (selected>0) then begin

        if ((selectedx<>mousex) or (selectedy<>mousey)) and (checkbox2.checked) then begin
          //if (selectedx>0) then draw_map_all:=true;   ///////// OPTIMIZE HERE                                         selectedx:=mousex; selectedy:=mousey;
          if (selectedenemy>0) then mapchanged^[bot[selectedenemy].x,bot[selectedenemy].y]:=255;
          selectedenemy:=-1;
          selectedx:=mousex; selectedy:=mousey;
          generatemovement(selected,selectedx,selectedy);
        end else begin
          {move here}
          //if (selectedx>0) then draw_map_all:=true;   ///////// OPTIMIZE HERE
          if (selectedenemy>0) then mapchanged^[bot[selectedenemy].x,bot[selectedenemy].y]:=255;
          selectedenemy:=-1;
          selectedx:=mousex; selectedy:=mousey;
          move_bot(selected,selectedx,selectedy,100);
        end;
      end;
    end;
  end;
  draw_map;
 end
 end
 else if gamemode=gamemode_help then begin
   togglebox1.checked:=true;
   togglebox1.state:=cbChecked;
   gamemode:=previous_gamemode;
   draw_map_all:=true;
   if (previous_gamemode>100) and (mapgenerated) then draw_map;
//   setcontrols_menu(true);
//   setcontrols_game(false);
 end;
end;

{================================================================================}
{================================================================================}
{================================================================================}

procedure TForm1.Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var {scalex,scaley,}mousex,mousey:integer;
    i:integer;
    found:boolean;
begin
 { scalex:=;
  scaley:=;}
 if gamemode>200 then begin
  mousex:=round(x / (image1.width / viewsizex)+0.5)+viewx;
  mousey:=round(y / (image1.height / viewsizey)+0.5)+viewy;
  if (mousex>0) and (mousey>0) and (mousex<=maxx) and (mousey<=maxy) then
  if vis^[mousex,mousey]=0 then image1.Cursor:=crHelp else begin
    if map^[mousex,mousey]=map_wall then image1.cursor:=CrNo else begin
      if map^[mousex,mousey]<=map_smoke then begin
        found:=true;
        for i:=1 to nbot do if (bot[i].x=mousex) and (bot[i].y=mousey) and (bot[i].hp>0) then begin
          found:=false;
          if bot[i].owner=player then image1.cursor:=CrHandPoint else begin
            if vis^[mousex,mousey]>oldvisible then image1.cursor:=crCross else found:=true;
          end;
        end;
        if found then image1.cursor:=crdefault;
      end;
    end;
  end;
 end else image1.cursor:=crdefault;
end;


{================================================================================}
{================================================================================}
{================================================================================}


function TForm1.load_weapon(thisbot,thisitem:integer):boolean;
var tmpitem:item_type;
    i:integer;
    flg,loadw:boolean;
begin
 loadw:=false;
 if bot[thisbot].items[thisitem].w_id>0 then begin
  if spend_tu(thisbot,changeweapontime) then begin
    tmpitem:=bot[thisbot].items[1];
    bot[thisbot].items[1]:=bot[thisbot].items[thisitem];
    bot[thisbot].items[thisitem]:=tmpitem;
    bot[thisbot].items[1].rechargestate:=weapon_specifications[bot[thisbot].items[1].w_id].recharge;
    loadw:=true;
  end
 end
 else
 if (bot[thisbot].items[1].ammo_id=0) and (bot[thisbot].items[thisitem].ammo_id>0) and (bot[thisbot].items[thisitem].w_id=0) and (bot[thisbot].items[1].w_id>0) then begin
   flg:=false;
   for i:=1 to maxusableammo do if weapon_specifications[bot[thisbot].items[1].w_id].AMMO[i]=bot[thisbot].items[thisitem].ammo_id then flg:=true;
   if flg then begin
     if spend_tu(thisbot,weapon_specifications[bot[thisbot].items[1].w_id].reload) then begin
       bot[thisbot].items[1].ammo_id:= bot[thisbot].items[thisitem].ammo_id;
       bot[thisbot].items[thisitem].ammo_id:=0;
       bot[thisbot].items[1].n:= bot[thisbot].items[thisitem].n;
       bot[thisbot].items[1].rechargestate:=weapon_specifications[bot[thisbot].items[1].w_id].recharge;
       loadw:=true;
     end
   end else showmessage('Inappropriate ammo!');
  end;
 load_weapon:=loadw;
end;

{--------------------------------------------------------------------------}

const fontsize=13;
      font7size=10;
procedure TForm1.Image3MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var //tmpitem:item_type;
    selectednew,freespace,i:integer;
    //i:integer;
    //flg:boolean;
begin
  if (y>=0) and (y<=(backpacksize*2-1)*fontsize) and (selected>0) then begin
    selectednew:=round((y-fontsize-3+scrollbar1.position)/(2*fontsize))+2;
    if selectednew<2 then selectednew:=2;
    if selectednew>backpacksize then selectednew:=backpacksize;
    if ssShift in shift then begin
      if (bot[selected].items[selectednew].ammo_id>0) or (bot[selected].items[selectednew].w_id>0) then
        drop_item(selected,selectednew)
      else
      if (bot[selected].items[1].ammo_id>0) and (bot[selected].items[selectednew].w_id=0) and (bot[selected].items[selectednew].ammo_id=0) then
       if spend_tu(selected,weapon_specifications[bot[selected].items[1].w_id].reload) then begin
        bot[selected].items[selectednew].ammo_id:=bot[selected].items[1].ammo_id;
        bot[selected].items[selectednew].n:=bot[selected].items[1].n;
        bot[selected].items[1].ammo_id:=0;
       end;
    end else if ssCtrl in shift then begin
      if (bot[selected].items[selectednew].ammo_id>0) and (bot[selected].items[selectednew].w_id>0) then begin
       //check place
       freespace:=0;
       for i:=backpacksize downto 2 do if (bot[selected].items[i].ammo_id=0) and (bot[selected].items[i].w_id=0) then freespace:=i;
       if freespace>=2 then
       if spend_tu(selected,weapon_specifications[bot[selected].items[selectednew].w_id].reload) then begin
        bot[selected].items[freespace].ammo_id:=bot[selected].items[selectednew].ammo_id;
        bot[selected].items[freespace].n:=bot[selected].items[selectednew].n;
        bot[selected].items[selectednew].ammo_id:=0;
       end;
      end
     end else if selecteditem=selectednew then begin
       if load_weapon(selected,selecteditem) then begin
         selectedonfloor:=-1;
         selecteditem:=-1;
       end;
    end else begin
       selecteditem:=selectednew;
       selectedonfloor:=-1;
    end;
    draw_map;
  end;
end;

procedure TForm1.Image3MouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
var changerate:integer;
begin
 if scrollbar1.enabled then begin
  changerate:=-wheeldelta div 3;
  if scrollbar1.position+changerate<0 then scrollbar1.position:=0 else
  if scrollbar1.position+changerate>scrollbar1.max then scrollbar1.position:=scrollbar1.max else
     scrollbar1.position:=scrollbar1.position+changerate;
 end;
end;

{------------------------------------------------------------------------------------}

procedure TForm1.drop_item(thisbot,thisitem:integer);
begin
if (bot[thisbot].items[thisitem].w_id>0) or (bot[thisbot].items[thisitem].ammo_id>0) then
  if spend_tu(thisbot,dropitemtime) then begin
   if itemsn=maxitems then showmessage('TOO MANY ITEMS!!!') else
    inc(itemsn);
   item[itemsn].item:=bot[thisbot].items[thisitem];
   item[itemsn].x:=bot[thisbot].x;
   item[itemsn].y:=bot[thisbot].y;
   bot[thisbot].items[thisitem].ammo_id:=0;
   bot[thisbot].items[thisitem].w_id:=0;
   selectedonfloor:=-1;
   selecteditem:=-1;
  end;

end;

{-------------------------------------------------------------------------------------}

procedure TForm1.pick_up(thisbot,thisitem:integer);
var i:integer;
    flg:boolean;
begin
 if onfloorn>0 then begin
  i:=1;
  flg:=false;
  repeat
   inc(i);
   if (bot[thisbot].items[i].w_id=0) and (bot[thisbot].items[i].ammo_id=0) then flg:=true;
  until (i>=backpacksize) or (flg);
  if flg and spend_tu(thisbot,pickupitemtime) then begin
    bot[thisbot].items[i]:=item[onfloor[thisitem]].item;
    for i:=onfloor[thisitem] to itemsn-1 do item[i]:=item[i+1];
      dec(itemsn);
    end;
 end;

end;

procedure TForm1.Image4MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var //tmpitem:item_type;
    selectednew:integer;
    //i:integer;
    //flg:boolean;
begin
  if (onfloorn>0) and (selected>0) then begin
    selectednew:=round((y-font7size-3+scrollbar2.position)/(2*font7size))+1;
    if selectednew<1 then selectednew:=1;
    if selectednew>onfloorn then selectednew:=onfloorn;
    if selectednew=selectedonfloor then begin
      pick_up(selected,selectedonfloor);
      selectedonfloor:=-1;
    end else begin
      selectedonfloor:=selectednew;
      selecteditem:=-1;
    end;
    draw_map;
  end;
end;

procedure TForm1.Image5MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var selectednew:integer;
begin
  if (playerunitsn>0) then begin
    if selected>0 then mapchanged^[bot[selected].x,bot[selected].y]:=255;
    selectednew:=round((y-font7size-3+scrollbar3.position)/(font7size+12))+1;
    if selectednew<1 then selectednew:=1;
    if selectednew>playerunitsn then selectednew:=playerunitsn;
    if playerunits[selectednew]<>selected then begin
      scrollbar1.position:=0; scrollbar2.position:=0;
      if (selectedenemy>0) then mapchanged^[bot[selectedenemy].x,bot[selectedenemy].y]:=255;
      selectedx:=-1; selectedy:=-1; selectedenemy:=-1; selecteditem:=-1; selectedonfloor:=-1;
    end;
    selected:=playerunits[selectednew];
    if (bot[selected].x<=viewx) or (bot[selected].y<=viewy) or (bot[selected].x>viewx+viewsizey) or (bot[selected].y>viewy+viewsizey) then center_map(bot[selected].x,bot[selected].y);
    mapchanged^[bot[selected].x,bot[selected].y]:=255;
    draw_map;
  end;
end;


procedure TForm1.Image6MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var selectednew:integer;
begin
  if (enemyunitsn>0) then begin
    selectednew:=round((y-font7size-3+scrollbar4.position)/(font7size+10))+1;
    if selectednew<1 then selectednew:=1;
    if selectednew>enemyunitsn then selectednew:=enemyunitsn;
    if selectedenemy<>enemyunits[selectednew] then begin
      if (selectedenemy>0) then mapchanged^[bot[selectedenemy].x,bot[selectedenemy].y]:=255;
    end;
    selectedenemy:=enemyunits[selectednew];
    if (bot[selectedenemy].x<=viewx) or (bot[selectedenemy].y<=viewy) or (bot[selectedenemy].x>viewx+viewsizey) or (bot[selectedenemy].y>viewy+viewsizey) then begin
      if (selected>0) then begin
        if (abs(bot[selected].x-bot[selectedenemy].x)<viewsizex) and (abs(bot[selected].y-bot[selectedenemy].y)<viewsizey) then
          center_map((bot[selected].x+bot[selectedenemy].x)div 2,(bot[selected].y+bot[selectedenemy].y)div 2)
        else
          center_map(bot[selectedenemy].x,bot[selectedenemy].y);
      end
      else
          center_map(bot[selectedenemy].x,bot[selectedenemy].y);
    end;
    mapchanged^[bot[selectedenemy].x,bot[selectedenemy].y]:=255;
    draw_map;
  end;
end;

procedure TForm1.Image4MouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
var changerate:integer;
begin
 if scrollbar2.enabled then begin
  changerate:=-wheeldelta div 3;
  if scrollbar2.position+changerate<0 then scrollbar2.position:=0 else
  if scrollbar2.position+changerate>scrollbar2.max then scrollbar2.position:=scrollbar2.max else
     scrollbar2.position:=scrollbar2.position+changerate;
 end;
end;

procedure TForm1.Image5MouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
var changerate:integer;
begin
 if scrollbar3.enabled then begin
  changerate:=-wheeldelta div 3;
  if scrollbar3.position+changerate<0 then scrollbar3.position:=0 else
  if scrollbar3.position+changerate>scrollbar3.max then scrollbar3.position:=scrollbar3.max else
     scrollbar3.position:=scrollbar3.position+changerate;
 end;
end;


procedure TForm1.Image6MouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
var changerate:integer;
begin
 if scrollbar4.enabled then begin
  changerate:=-wheeldelta div 3;
  if scrollbar4.position+changerate<0 then scrollbar4.position:=0 else
  if scrollbar4.position+changerate>scrollbar4.max then scrollbar4.position:=scrollbar4.max else
     scrollbar4.position:=scrollbar4.position+changerate;
 end;
end;

procedure TForm1.center_map(tox,toy:integer);
var mx,my:integer;
    newviewx,newviewy:integer;
begin

  newviewx:=tox-viewsizex div 2;
  newviewy:=toy-viewsizey div 2;
  if newviewx<0 then newviewx:=0;
  if newviewy<0 then newviewy:=0;
  if newviewx>maxx-viewsizex then newviewx:=maxx-viewsizex;
  if newviewy>maxy-viewsizey then newviewy:=maxy-viewsizey;

  if (newviewx<>viewx) or (newviewy<>viewy) then begin
    for mx:=viewx+1 to viewx+viewsizex do begin
      mapchanged^[mx,viewy        +1]:=255;
      mapchanged^[mx,viewy+viewsizey]:=255;
    end;
    for my:=viewy+1 to viewy+viewsizey do begin
      mapchanged^[viewx        +1,my]:=255;
      mapchanged^[viewx+viewsizex,my]:=255;
    end;
    viewx:=newviewx;
    viewy:=newviewy;
    draw_map_all:=true;
    draw_map;
  end;
end;

procedure TForm1.Image7MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
//var mousex,mousey:integer;
begin
  center_map(round(x / (image7.width / maxx)+0.5),round(y / (image7.height/ maxy)+0.5));
end;

procedure Tform1.set_progressbar(flg:boolean);
begin
 progressbar1.Visible:=flg;
 progressbar1.position:=1;
 progressbar1.min:=1;
// if button1.visible then
 if flg then begin
   button1.height:=60;
   button1.enabled:=false;
 end else begin
   button1.enabled:=true;
   button1.height:=72;
 end;
end;

procedure Tform1.setcontrols_game(flg:boolean);
begin
 image1.visible:=flg;
 image2.visible:=flg;
 image3.visible:=flg;
 image4.visible:=flg;
 image5.visible:=flg;
 image6.visible:=flg;
 memo1.visible:=flg;
 button1.visible:=flg;
 scrollbar1.visible:=flg;
 scrollbar2.visible:=flg;
 scrollbar3.visible:=flg;
 scrollbar4.visible:=flg;
 label1.visible:=flg;
 checkbox2.visible:=flg;
 image7.visible:=flg;
// if gamemode>200 then button1.enabled:=true else button1.enabled:=false;
end;

procedure Tform1.setcontrols_menu(flg:boolean);
begin
 radiobutton1.visible:=flg;
 radiobutton2.visible:=flg;
 radiobutton3.visible:=flg;
 combobox1.visible:=flg;
 button2.visible:=flg;
 button3.visible:=flg;
 label2.visible:=flg;
 label3.visible:=flg;
 button4.visible:=flg;
 edit1.visible:=flg;
 label4.visible:=flg;
 button5.visible:=flg;
 button6.visible:=flg;
 label5.visible:=flg;
 edit2.visible:=flg;
 label6.visible:=flg;
 edit3.visible:=flg;
 label7.visible:=flg;
 edit4.visible:=flg;
 label8.visible:=flg;
 trackbar1.visible:=flg;
 label9.visible:=flg;
 label10.visible:=flg;
 edit5.visible:=flg;
 label11.visible:=flg;
 label12.visible:=flg;
 checkbox1.visible:=flg;
 label13.visible:=flg;
 button7.visible:=flg;
 {$IFDEF UNIX}
 label13.visible:=false;
 {$ENDIF}

 if mapgenerated then begin
   if gamemode>200 then button4.enabled:=true else button4.enabled:=false;
   if gamemode>200 then button3.enabled:=true else button3.enabled:=false;
   togglebox1.enabled:=true;
 end else begin
   button4.enabled:=false;
   button3.enabled:=false;
   togglebox1.enabled:=false;
 end;

end;

procedure TForm1.Togglebox1Change(Sender: TObject);
begin
  if gamemode=gamemode_help then begin
    gamemode:=previous_gamemode;
    draw_map_all:=true;
    if (previous_gamemode>100) and (mapgenerated) then draw_map;
  end;
  if Togglebox1.checked then begin
    setcontrols_menu(true);
    setcontrols_game(false);
  end else begin
    setcontrols_menu(false);
    setcontrols_game(true);
  end;
end;

procedure TForm1.ScrollBar1Change(Sender: TObject);
begin
  draw_stats;
end;

procedure TForm1.ScrollBar2Change(Sender: TObject);
begin
  draw_stats;
end;

procedure TForm1.ScrollBar3Change(Sender: TObject);
begin
  draw_map;
end;

procedure TForm1.ScrollBar4Change(Sender: TObject);
begin
  draw_map;
end;

procedure TForm1.TrackBar1Change(Sender: TObject);
var ix,iy:integer;
begin
  viewsizex:=trackbar1.position;
  label13.caption:=inttostr(viewsizex);
  viewsizey:=viewsizex;
  if mapgenerated then begin
    draw_map_all:=true;
    center_map(viewx+viewsizex div 2,viewy+viewsizey div 2);
    for ix:=1 to maxx do
      for iy:=1 to maxy do mapchanged^[ix,iy]:=255;
    draw_map;
  end;
end;

{-----------------------------------------------------------------------------------}

const itemsy=46;
procedure Tform1.draw_stats;
var i,n1,n2:integer;
    yshift:integer;
    s:string;
begin
  n1:=0; n2:=0;
  for i:=1 to nbot do if (bot[i].owner=player) and (bot[i].hp>0) then begin
    if bot[i].tu=255 then inc(n2);
    if bot[i].tu>bot[i].speed*1.5 then inc(n1);
  end;
  s:='NEXT TURN';
  {$IFDEF UNIX}
  if n2>0 then s:=s+sLineBreak+inttostr(n2)+' units have not moved yet.';
  if n1-n2>0 then s:=s+sLineBreak+inttostr(n1-n2)+' units can still move.';
  {$ENDIF}
  button1.caption:=s;

   with image2.Canvas do begin
     pen.width:=1;
     brush.style:=bssolid;
     brush.color:=0;
     fillrect(0,0,image2.width,image2.height);

     if selected>0 then begin
       pen.color:=$777777;
       brush.color:=$333344;
       rectangle(3,itemsy-1,image2.width-3,itemsy+4*fontsize+3);

       brush.style:=bsclear;
       font.color:=$FFFFFF;
       textout(5,0,bot[selected].name);

       font.size:=7;
       pen.color:=$3333dd;
       pen.width:=10;
       moveto(5,25);
       lineto(round((image2.width-10)*bot[selected].hp/bot[selected].maxhp)+5,25);
       textout(image2.width div 2-50,20,inttostr(bot[selected].hp)+'/'+inttostr(bot[selected].maxhp));

       pen.color:=$33dd33;
       pen.width:=10;
       moveto(5,37);
//       if bot[selected].tu>minimumtuusable then
         lineto(round((image2.width-10)*(bot[selected].tu{-minimumtuusable})/(255{-minimumtuusable}))+5,37);
       textout(image2.width div 2-50,32,inttostr(bot[selected].tu));

       font.size:=10;
       if bot[selected].items[1].w_id>0 then begin
         font.color:=$FFFFFF;
         if bot[selected].items[1].state<bot[selected].items[1].maxstate div 2 then font.color:=$99eeFF;
         if bot[selected].items[1].state<bot[selected].items[1].maxstate div 3 then font.color:=$5555FF;
         if bot[selected].items[1].state=0 then font.color:=$0000FF;
         textout(  5,itemsy,weapon_specifications[bot[selected].items[1].w_id].name+ ' '+inttostr(bot[selected].items[1].state)+'/'+inttostr(bot[selected].items[1].maxstate)+'('+inttostr(round(100*bot[selected].items[1].state/bot[selected].items[1].maxstate))+'%)');
       end;
       if (bot[selected].items[1].ammo_id>0) and (bot[selected].items[1].n>0) then begin
         if bot[selected].items[1].state=0 then begin
           font.color:=$2222FF;
           textout(  5,itemsy+fontsize,'* JAMMED *');
         end else
         if bot[selected].items[1].rechargestate>0 then begin
           font.color:=$2222FF;
           textout(  5,itemsy+fontsize,'RELOADING '+inttostr(round(100*(1-bot[selected].items[1].rechargestate/weapon_specifications[bot[selected].items[1].w_id].RECHARGE)))+'%');
         end else
         begin
           font.color:=$FFFFFF;
           textout(  5,itemsy+fontsize,'DAM: '+inttostr(weapon_specifications[bot[selected].items[1].w_id].DAM+ammo_specifications[bot[selected].items[1].ammo_id].DAM));
           textout( 70,itemsy+fontsize,'ACC: '+inttostr(weapon_specifications[bot[selected].items[1].w_id].ACC+ammo_specifications[bot[selected].items[1].ammo_id].ACC));
         end;
         font.color:=$FFFFFF;
         textout(  5,itemsy+3*fontsize,'TU: ' +inttostr(weapon_specifications[bot[selected].items[1].w_id].AIM)+'+'+inttostr(weapon_specifications[bot[selected].items[1].w_id].RECHARGE));
         textout(  5,itemsy+2*fontsize,ammo_specifications[bot[selected].items[1].ammo_id].name+' '+inttostr(bot[selected].items[1].n)+'/'+inttostr(ammo_specifications[bot[selected].items[1].ammo_id].quantity));
       end else begin
         font.color:=$0000FF;
         textout(  5,itemsy+fontsize,'* NO AMMO *');
       end;
{        EXPLOSION   :=  0;
         TRACE_SMOKE :=  0;  }
     end;
   end;
    {draw backpack items}
   with image3.canvas do begin
       if (backpacksize*2-2)*fontsize+8<image3.height then begin
         scrollbar1.enabled:=false;
         scrollbar1.position:=0;
         //scrollbar1.visible:=false;
         //image3.width:=194;
       end else begin
         scrollbar1.enabled:=true;
         scrollbar1.min:=0;
         scrollbar1.max:=(backpacksize*2-2)*fontsize-image3.height+8;
         //scrollbar1.visible:=true;
         //set maxranges;
         //image3.width:=176
       end;
       brush.style:=bssolid;
       brush.color:=0;
       fillrect(0,0,image3.width,image3.height);
       pen.width:=1;
     if selected>0 then begin
       yshift:=scrollbar1.position;
       for i:=2 to backpacksize do begin
         brush.style:=bssolid;
         if (i=selecteditem) {and ((bot[selected].items[i].w_id>0) or (bot[selected].items[i].ammo_id>0 )) }then begin
           pen.color:=$888888;
           brush.color:=$444444;
         end else begin
             pen.color:=$333333;
             brush.color:=$222222;
         end;
         rectangle(3,(2*i-4)*fontsize+3-yshift,image3.width-3,(2*i-2)*fontsize+3-yshift);
         brush.style:=bsclear;
         if bot[selected].items[i].w_id>0 then begin
           font.color:=$FFFFFF;
           if bot[selected].items[i].state<bot[selected].items[i].maxstate div 2 then font.color:=$99eeFF;
           if bot[selected].items[i].state<bot[selected].items[i].maxstate div 3 then font.color:=$5555FF;
           if bot[selected].items[i].state=0 then font.color:=$0000FF;
           textout( 13,(2*i-4)*fontsize-yshift,weapon_specifications[bot[selected].items[i].w_id].name+' ('+inttostr(round(bot[selected].items[i].state/bot[selected].items[i].maxstate*100))+'%)');
         end;
         if bot[selected].items[i].ammo_id>0 then begin
           font.color:=$FFFFFF;
           textout( 13,(2*i-3)*fontsize-yshift,AMMO_specifications[bot[selected].items[i].ammo_id].name+' '+inttostr(bot[selected].items[i].n));
         end;
       end;
     end
    end;
   // draw on-floor items
   with image4.canvas do begin
     brush.style:=bssolid;
     brush.color:=0;
     fillrect(0,0,image4.width,image4.height);
     pen.width:=1;
     font.size:=7;
     if selected>0 then begin
       find_onfloor(bot[selected].x,bot[selected].y);
       if onfloorn>0 then begin
         if (onfloorn*2)*font7size+8<image4.height then begin
           scrollbar2.enabled:=false;
           scrollbar2.position:=0;
           //scrollbar2.visible:=false;
           //image4.width:=194;
         end else begin
           scrollbar2.enabled:=true;
           scrollbar2.min:=0;
           scrollbar2.max:=(onfloorn*2)*font7size-image4.height+8;
           //scrollbar2.visible:=true;
           //image4.width:=176
         end;
         yshift:=scrollbar2.position;
         for i:=1 to onfloorn do begin
           brush.style:=bssolid;
           if (i=selectedonfloor) {and ((bot[selected].items[i].w_id>0) or (bot[selected].items[i].ammo_id>0 )) }then begin
             pen.color:=$666666;
             brush.color:=$333333;
           end else begin
             pen.color:=$222222;
             brush.color:=$111111;
           end;
           rectangle(3,(2*i-2)*font7size+4-yshift,image4.width-3,(2*i)*font7size+3-yshift);
           brush.style:=bsclear;
           if item[onfloor[i]].item.w_id>0 then begin
             font.color:=$FFFFFF;
             if item[onfloor[i]].item.state<item[onfloor[i]].item.maxstate div 2 then font.color:=$99eeFF;
             if item[onfloor[i]].item.state<item[onfloor[i]].item.maxstate div 3 then font.color:=$5555FF;
             if item[onfloor[i]].item.state=0 then font.color:=$0000FF;
             textout( 13,(2*i-2)*font7size-yshift+4,weapon_specifications[item[onfloor[i]].item.w_id].name+' ('+inttostr(round(item[onfloor[i]].item.state/item[onfloor[i]].item.maxstate*100))+'%)');
           end;
           if item[onfloor[i]].item.ammo_id>0 then begin
             font.color:=$FFFFFF;
             textout( 13,(2*i-1)*font7size-yshift+3,AMMO_specifications[item[onfloor[i]].item.ammo_id].name+' '+inttostr(item[onfloor[i]].item.n));
           end;
         end;
       end;
     end
    end;

{draw player units list}
  with image5.canvas do begin
    brush.style:=bssolid;
    brush.color:=0;
    fillrect(0,0,image5.width,image5.height);
    playerunitsn:=0;
    for i:=1 to nbot do if (bot[i].owner=player) and (bot[i].hp>0) and (playerunitsn<maxunitslist) then begin
      font.color:=$FFFFFF;
      font.size:=7;
      inc(playerunitsn);
      playerunits[playerunitsn]:=i;
    end;
    if (playerunitsn-1)*(font7size+12)+28<image5.height then begin
      scrollbar3.enabled:=false;
      scrollbar3.position:=0;
    end else begin
      scrollbar3.enabled:=true;
      scrollbar3.min:=0;
      scrollbar3.max:=(playerunitsn-1)*(font7size+12)-image5.height+28;
    end;
    yshift:=scrollbar3.position;
    for i:=1 to playerunitsn do begin
      if playerunits[i]=selected then begin
        brush.style:=bssolid;
        brush.color:=$444444;
        pen.width:=1;
        pen.color:=$666666;
        rectangle(1,(i-1)*(font7size+12)-yshift,image5.width-1,(i-1)*(font7size+12)+font7size+12-yshift);
      end;
      brush.style:=bsclear;
      textout(3,(i-1)*(font7size+12)-yshift,bot[playerunits[i]].name);
      pen.width:=3;
      pen.color:=$3333dd;
      moveto(3,(i-1)*(font7size+12)+font7size+3-yshift);
      lineto(3+round((image5.width-7)*bot[playerunits[i]].hp/bot[playerunits[i]].maxhp),(i-1)*(font7size+12)+font7size+3-yshift);
      pen.color:=$33dd33;
      if bot[playerunits[i]].tu-minimumtuusable>(255-minimumtuusable) div image5.width+1 then begin
        moveto(3,(i-1)*(font7size+12)+font7size+7-yshift);
        lineto(3+round((image5.width-7)*(bot[playerunits[i]].tu-minimumtuusable)/(255-minimumtuusable)),(i-1)*(font7size+12)+font7size+7-yshift);
      end;
    end;
  end;

{draw enemy units list}
  with image6.canvas do begin
    brush.style:=bssolid;
    brush.color:=0;
    fillrect(0,0,image6.width,image6.height);
    if (enemyunitsn-1)*(font7size+10)+28<image6.height then begin
      scrollbar4.enabled:=false;
      scrollbar4.position:=0;
    end else begin
      scrollbar4.enabled:=true;
      scrollbar4.min:=0;
      scrollbar4.max:=(enemyunitsn-1)*(font7size+10)-image6.height+28;
    end;
    yshift:=Scrollbar4.position;

    if enemyunitsn>0 then
    for i:=1 to enemyunitsn do begin
      if enemyunits[i]=selectedenemy then begin
        brush.style:=bssolid;
        brush.color:=$444444;
        pen.width:=1;
        pen.color:=$666666;
        rectangle(1,(i-1)*(font7size+10)-yshift,image5.width-1,(i-1)*(font7size+10)+font7size+9-yshift);
      end;
      font.color:=$FFFFFF;
      font.size:=7;
      brush.style:=bsclear;
      textout(3,(i-1)*(font7size+10)-yshift,bot[enemyunits[i]].name);
      pen.width:=3;
      pen.color:=$3333dd;
      moveto(3,(i-1)*(font7size+10)+font7size+3-yshift);
      lineto(3+round((image5.width-7)*bot[enemyunits[i]].hp/bot[enemyunits[i]].maxhp),(i-1)*(font7size+10)+font7size+3-yshift);
    end;
  end;
end;

{--------------------------------------------------------------------------------------}

procedure TForm1.Draw_map;
var mx,my,i:integer;
    sx,sy:integer;
    scalex,scaley,fx1,fy1,fx2,fy2:float;
    scaleminimapx,scaleminimapy:float;
    x1,y1,x2,y2:integer;
    xx1,yy1:integer;
    thistime:TDatetime;
    //dx,dy,range,maxrange:integer;
begin
  thistime:=now;
  image1.canvas.lock;
  sx:=image1.width;
  sy:=image1.height;
  scalex:=sx / viewsizex;
  scaley:=sy / viewsizey;
  scaleminimapx:=image7.Width / maxx;
  scaleminimapy:=image7.height / maxy;
  image7.canvas.brush.style:=bssolid;
  with image1.canvas do begin
    pen.width:=1;
    {draw_map}
    for mx:=1 to maxx do
      for my:=1 to maxy do if (mapchanged^[mx,my]>0) or (draw_map_all) {or ((map^[mx,my]>0) and (map^[mx,my]<=map_smoke) and (vis^[mx,my]>oldvisible){ and (random>0.5)})} then begin
        //mapchanged^[mx,my]:=1;
        if vis^[mx,my]=0 then begin
//          brush.style:= bsDiagCross;
          brush.color:=$330000
        end else begin
          if vis^[mx,my]=oldvisible then begin
             if map^[mx,my]=map_wall then brush.color:=RGB(99,255,220,220) else
                                          brush.color:=RGB(50,80,99,80);
           end else begin
             if map^[mx,my]=map_wall then brush.color:=RGB(round(155*sqr((vis^[mx,my]-oldvisible)/(maxvisible-oldvisible)))+100,255,220,220) else
                                          brush.color:=RGB(round(200*sqr((vis^[mx,my]-oldvisible)/(maxvisible-oldvisible)))+55,80,99,80);
           end;
//           brush.style:=bssolid;
        end;


        if mapchanged^[mx,my]=255 then begin
          image7.canvas.brush.color:=brush.color;
          image7.canvas.fillrect(round((mx-1)*scaleminimapx), round((my-1)*scaleminimapy), round(mx*scaleminimapx), round(my*scaleminimapy));
        end;
        if (mx>viewx) and (my>viewy) and (mx<=viewx+viewsizex) and (my<=viewy+viewsizey) then begin
          brush.style:=bssolid;
          fillrect(round((mx-1-viewx)*scalex), round((my-1-viewy)*scaley), round((mx-viewx)*scalex), round((my-viewy)*scaley));
          if (map^[mx,my]>0) and (map^[mx,my]<=map_smoke) and (vis^[mx,my]>oldvisible) then begin
            for i:=1 to round(sqr(scalex*scaley)/(sqr(sqr(map_smoke-map^[mx,my]+3))))+1 do begin
              brush.color:=RGB(round(150*(random*vis^[mx,my]-oldvisible)/(maxvisible-oldvisible))+100,255,255,255);
              x1:=round((mx-1-viewx+random*(scalex-1)/scalex)*(scalex));
              y1:=round((my-1-viewy+random*(scaley-1)/scaley)*(scaley));
              fillrect(x1,y1,x1+1,y1+1);
            end;
          end;
          if vis^[mx,my]=0 then begin
            brush.style:= bsDiagCross;
            brush.color:=$990000;
            fillrect(round((mx-1-viewx)*scalex), round((my-1-viewy)*scaley), round((mx-viewx)*scalex), round((my-viewy)*scaley));
          end;
          //*******
          //font.size:=5;textout(round((mx-1-viewx)*scalex), round((my-1-viewy)*scaley), inttostr(LOS_base^[mx,my]));
        end;

     //     if (selectedx>0) and (movement^[mx,my]<10) then textout((mx-1)*scalex,(my-1)*scaley, inttostr(movement^[mx,my]));
      end;

    brush.style:=bssolid;
    {draw_items}
     pen.width:=1;
     if itemsn>0 then
      for i:=1 to itemsn do if (vis^[item[i].x,item[i].y]>0) and ((mapchanged^[item[i].x,item[i].y]>0) or (draw_map_all)) then begin
        if vis^[item[i].x,item[i].y]>oldvisible then begin
          pen.color:=RGB(round(150*((vis^[item[i].x,item[i].y]-oldvisible)/(maxvisible-oldvisible)))+105,128,128,255);
          brush.color:=RGB(255,80,99,80);
        end
        else begin
          pen.color:=RGB(99,50,50,99);
          brush.color:=RGB(150,80,99,80);
        end;
        if (item[i].x-viewx>0) and (item[i].y-viewy>0) and (item[i].x-viewx<=viewsizex) and (item[i].y-viewy<=viewsizey) then begin
          fx1:=(item[i].x-viewx-1)*scalex;
          fy1:=(item[i].y-viewy-1)*scaley;
          rectangle(round(fx1+scalex / 3),round(fy1+scaley / 3), round(fx1+(2*scalex) /3), round(fy1 + (2*scaley) / 3));
        end;
        image7.canvas.brush.color:=$FF9999;
        image7.canvas.fillrect(round((item[i].x-1)*scaleminimapx), round((item[i].y-1)*scaleminimapy), round(item[i].x*scaleminimapx), round(item[i].y*scaleminimapy));
       end;
     {draw_bots}
     for mx:=1 to nbot do if bot[mx].hp>0 then begin
       if (vis^[bot[mx].x,bot[mx].y]>oldvisible) and ((mapchanged^[bot[mx].x,bot[mx].y]>0) or (draw_map_all)) then begin
         if (bot[mx].x-viewx>0) and (bot[mx].y-viewy>0) and (bot[mx].x-viewx<=viewsizex) and (bot[mx].y-viewy<=viewsizey) then begin
           fx1:=(bot[mx].x-viewx-1)*scalex;
           fy1:=(bot[mx].y-viewy-1)*scaley;
           fx2:=(bot[mx].x-viewx  )*scalex-1;
           fy2:=(bot[mx].y-viewy  )*scaley-1;
           pen.color:=RGB(round(150*((vis^[bot[mx].x,bot[mx].y]-oldvisible)/(maxvisible-oldvisible)))+55,140,140,170);
           if scalex>6 then pen.width:=round (scalex / 6) else pen.width:=1;
           moveto(round((fx1+fx2)/2+0.4*scalex*cos(2*Pi*(bot[mx].angle+75)/maxangle)),round((fy1+fy2)/2+0.4*scaley*sin(2*Pi*(bot[mx].angle+75)/maxangle)));
           lineto(round((fx1+fx2)/2+0.4*scalex*cos(2*Pi*(bot[mx].angle+25)/maxangle)),round((fy1+fy2)/2+0.4*scaley*sin(2*Pi*(bot[mx].angle+25)/maxangle)));
           moveto(round((fx1+fx2)/2+0.4*scalex*cos(2*Pi*(bot[mx].angle-75)/maxangle)),round((fy1+fy2)/2+0.4*scaley*sin(2*Pi*(bot[mx].angle-75)/maxangle)));
           lineto(round((fx1+fx2)/2+0.4*scalex*cos(2*Pi*(bot[mx].angle-25)/maxangle)),round((fy1+fy2)/2+0.4*scaley*sin(2*Pi*(bot[mx].angle-25)/maxangle)));
           pen.width:=1;
         end;

         if bot[mx].owner=player then begin
                                          brush.color:=RGB(round(150*((vis^[bot[mx].x,bot[mx].y]-oldvisible)/(maxvisible-oldvisible)))+105,120,180,120);
                                          pen.color:=RGB({round(150*((vis^[bot[mx].x,bot[mx].y]-oldvisible)/(maxvisible-oldvisible)))+}255,0,255,0)
                             end else begin
                                          brush.color:=RGB(round(150*((vis^[bot[mx].x,bot[mx].y]-oldvisible)/(maxvisible-oldvisible)))+55,180,120,120);
                                          pen.color:=RGB({round(150*((vis^[bot[mx].x,bot[mx].y]-oldvisible)/(maxvisible-oldvisible)))+}255,255,0,0)
                             end;

         image7.canvas.brush.color:=pen.color;
         image7.canvas.fillrect(round((bot[mx].x-1)*scaleminimapx), round((bot[mx].y-1)*scaleminimapy), round(bot[mx].x*scaleminimapx), round(bot[mx].y*scaleminimapy));

         if (bot[mx].x-viewx>0) and (bot[mx].y-viewy>0) and (bot[mx].x-viewx<=viewsizex) and (bot[mx].y-viewy<=viewsizey) then begin
           ellipse(round(fx1+scalex / 6), round(fy1+scaley / 6), round(fx2-scalex / 6), round(fy2-scaley / 6));
           pen.color:=RGB(round(150*((vis^[bot[mx].x,bot[mx].y]-oldvisible)/(maxvisible-oldvisible)))+55,150,150,150);
           if scalex>6 then pen.width:=round (scalex / 6) else pen.width:=1;
           moveto(round((fx1+fx2)/2), round((fy1+fy2)/2));
           lineto(round((fx1+fx2)/2+0.4*scalex*cos(2*Pi*bot[mx].angle/maxangle)),round((fy1+fy2)/2+0.4*scalex*sin(2*Pi*bot[mx].angle/maxangle)));
           pen.width:=1;
           ellipse(round(fx1+scalex / 4), round(fy1+scaley / 4), round(fx2-scalex/4), round(fy2-scaley / 4));

           if (selected=mx) or ((selectedenemy=mx) and (selected>0)) then begin
             x1:=round(fx1);
             x2:=round(fx2);
             y1:=round(fy1);
             y2:=round(fy2);
             if selected=mx then pen.color:=$FF0000 else begin
               if check_LOS(bot[selected].x,bot[selected].y,bot[selectedenemy].x,bot[selectedenemy].y)>0 then pen.color:=$0000FF else pen.color:=$00EEFF;
               moveto(x1,y1);lineto(x2,y2);
               moveto(x2,y1);lineto(x1,y2);
             end;
             arc(x1,y1,x2-1,y2-1,x1-1,y1,x1,y1);
           end;
         end;
       end;
     end;


     for mx:=1 to maxx do
      for my:=1 to maxy do mapchanged^[mx,my]:=0;
     draw_map_all:=false;

     image7.canvas.brush.style:=bsclear;
     image7.canvas.pen.color:=$FFFFFF;
     image7.canvas.rectangle(round((viewx+0.3)*scaleminimapx), round((viewy+0.3)*scaleminimapy), round((viewx+viewsizex-0.3)*scaleminimapx), round((viewy+viewsizey-0.3)*scaleminimapy));

     {draw movement path}
     if (selectedx>0) and (selected>0) and (checkbox2.checked) then begin
       if (movement^[selectedx,selectedy]<9) and (selected=movement_map_for) and ((selectedx<>bot[selected].x) or (selectedy<>bot[selected].y)) then begin
         xx1:=selectedx;
         yy1:=selectedy;
         repeat
           mapchanged^[xx1,yy1]:=255;

           fx1:=(xx1-1)*scalex;
           fy1:=(yy1-1)*scaley;
           fx2:=xx1*scalex-1;
           fy2:=yy1*scaley-1;
           pen.color:=$00dd00;
           moveto(round(fx1+scalex / 3), round(fy1+scaley / 3));
           lineto(round(fx2-scalex / 3), round(fy2-scaley / 3));
           moveto(round(fx2-scalex / 3), round(fy1+scaley / 3));
           lineto(round(fx1+scalex / 3), round(fy2-scaley / 3));

           case movement^[xx1,yy1] of
             5: begin inc(xx1); dec(yy1) end;
             6: begin           dec(yy1) end;
             7: begin dec(xx1); dec(yy1) end;
             8: begin dec(xx1)           end;
             1: begin dec(xx1); inc(yy1) end;
             2: begin           inc(yy1) end;
             3: begin inc(xx1); inc(yy1) end;
             4: begin inc(xx1);          end;
           end;
         until (xx1=bot[selected].x) and (yy1=bot[selected].y);
       end;
     end;
  end;

  image1.canvas.unlock;
  image1.update;


  draw_stats;
  label1.Caption:=inttostr(round(((now-thistime)*24*60*60*1000)))+'ms';
end;

{procedure TDrawMap.execute;
begin
    if map_changed then begin
      map_changed:=false;
      form1.draw_map;
    end;
end;}

end.

