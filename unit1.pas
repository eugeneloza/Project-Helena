unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, ComCtrls, types;

const maxmaxx={113}226;  //max 'reasonable' 50x50
      minmaxx=20;
      maxmaxy=maxmaxx;
      minmaxy=minmaxx;
      maxbots=500;
      maxzoom=50;

      maxbuildings=1000;
      maxbldgx=20;
      maxbldgy=20;
      randomaccuracy=100;

      maxplayers=16;          // max 16 fit in bunker

      backpacksize=12;
      changeweapontime=100;
      //fixweapontime=255;
      dropitemtime=20;
      pickupitemtime=40;

      blastpush=10;
      wallhardness=1;

      maxitems=maxbots*backpacksize+100;
      maxonfloor=50; // max displayed onfloor items
      maxunitslist=maxbots;

      minimumtuusable=29;

      distance_accuracy=5; //5: max 51 horizontal steps (6 turns)
      distance_step=7;
      //accuracy 7/5 provides 1% error (-3TU/turn), 3/2 provides 6% error (+15Tu/turn)
      distance_error=1.4142135-distance_step/distance_accuracy;  // 1% error = 3TU per turn   { = distance_accuracy * sqrt(2)}

      playerbotmovedelay=100;     {ms}
      enemybotmovedelay=300;      {ms}
      shotdelay=200;              {ms}
      blastdelay=500;             {ms}

      defensedifficulty=5;
      standard_damage=10;
      average_los_value=42.92;   ////////////////////////////// corrected LOS

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
      maxstatus=31;
      maxstatusdivision=9; //number of cracks
      map_wall=128;
      map_wall_smoke=map_smoke div 2;
      die_smoke=map_smoke div 3;

      map_generation_wall=247;//255-4-4;
      map_generation_free=251;//255-4;
      map_generation1=246;
      map_generation2=245;
      map_generation3=244;
      map_generation4=243;

//      statuspattern=32-1; //00011111
//      tilepattern=96;     //01100000 shr 5

//      map_tile1=0;        // .00.....
//      map_tile2=32;       // .01.....
//      map_tile3=64;       // .10.....
//      map_tile4=96;       // .11.....

const gamemode_game=255;
      gamemode_victory=254;
      gamemode_defeat=253;

        gamemode_map=127; //separator between mode "click to continue" and "move"

      gamemode_none=0;
      gamemode_help=1;
      gamemode_message=2;
      gamemode_iteminfo=3;

const border_size=7;
      text_width=45;

const datafolder='DAT'+pathdelim;
      scriptfolder=datafolder+'default'+pathdelim;

const strategy_hide=true;
      strategy_caution=1;
      strategy_finishhim=true;
      strategy_cheater=255;

      strategy_real_los=255;
      strategy_possibleloc=50;
      strategy_possible_los=100;
      strategy_visible=1;

//const tutorial_

type float=double;

type item_type=record
  w_id:byte;                 //for weapons, 0 if pure ammo
  state,maxstate:byte;
  rechargestate:word;

  ammo_id:byte;
  n:byte;
end;

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
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBox6: TCheckBox;
    ComboBox1: TComboBox;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
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
    Label14: TLabel;
    Label15: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Memo1: TMemo;
    Memo2: TMemo;
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
    procedure CheckBox5Change(Sender: TObject);
    procedure Edit4Change(Sender: TObject);
    procedure Edit6Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer
      );
    procedure Image2MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
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
    procedure bot_look_around(thisbot:integer);
    procedure clear_visible;
    procedure bot_clear_visible;
    procedure bot_recalc_visible;
    procedure read_buildings;
    function generate_enemy_list(messageflag:boolean):boolean;
    procedure generatemovement_generic(from_x,from_y,to_x,to_y,maxdistance:byte;clearit,playergo:boolean);
    procedure generatemovement(thisbot,target_x,target_y:integer);
    procedure move_bot(thisbot,to_x,to_y,use_waypoints:integer);
    procedure end_turn;
    procedure bot_action(thisbot:integer);
    procedure start_turn;
    procedure set_progressbar(flg:boolean);
    procedure find_onfloor(x,y:integer);
    procedure grow_smoke;
    procedure alert_other_bots(target,who:integer);
    procedure bot_shots(attacker,defender:integer);
    function spend_tu(thisbot:integer;tus:integer):boolean;
    procedure calculate_area(ax,ay,a,asmoke,ablast:integer);
    function load_weapon(thisbot,thisitem:integer):boolean;
    procedure pick_up(thisbot,thisitem:integer);
    procedure drop_item(thisbot,thisitem:integer);
    procedure setcontrols_menu(flg:boolean);
    procedure setcontrols_game(flg:boolean);
    procedure center_map(tox,toy:integer);

    procedure create_message_box(x1,y1,x2,y2:integer);
    procedure display_item_info(thisitem:item_type);

//    procedure display_message(mess:string);
  end;

const maxusableammo=9;
type weapon_type=record
  name:string[30];
  ACC,DAM:byte;
  Recharge,Aim,Reload:byte;
  Maxstate:byte;
  AMMO:array[1..maxusableammo]of byte;
  kind,rnd:integer;
  description:string;
end;
type ammo_type=record
  name:string[30];
  quantity:byte;
  ACC,DAM:integer;
  EXPLOSION,AREA,SMOKE:integer;
  kind,rnd:integer;
  description:string;
end;

type laying_item_type = record
  item:item_type;
  x,y:integer;
end;

type bottype=record
  name:string[30];
  action:byte;
  caution:byte;
  bottype:byte;
  target:integer;
  hp,maxhp:word;
  tu:byte;
  speed:byte;
  angle:byte;
  x,y:integer;
  owner:integer;
  items:array[1..backpacksize]of item_type;

  lastseen_x,lastseen_y,lastseen_tu:byte;
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

  map,map_status,vis,movement,distance,mapchanged:^map_array;
  mapg:^map_array;
  botvis:^map_array;
  map_parameter:array[0..8]of float;
  mapbuildings:array[1..maxbuildings]of string;
  nbuildings:integer;
  LOS_base:^map_array;
  mapfreespace:integer;
  mapinhomogenity:float;
  estimated_botstogether:float;

  averageLOS:float;
  maxx,maxy:integer;
  max_max_value,min_max_value,average_max_value:integer;
  playersn:integer;
  viewx,viewy,viewsizex,viewsizey:integer;
  draw_map_all,show_los:boolean;
  mapgenerated:boolean;
  random_tiles:boolean;
  regenerate_los:boolean;
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

  w_types,a_types:integer;

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

procedure Tform1.generatemovement_generic(from_x,from_y,to_x,to_y,maxdistance:byte;clearit,playergo:boolean);
var ix,iy:integer;
    x1,x2,y1,y2:integer;
    nomoves,distanceexceeded:boolean;
    movement_new:^map_array;
    distance_new:integer;
begin
 new(movement_new);
 if clearit then begin
  for ix:=1 to maxx do
    for iy:=1 to maxy do begin
       if map^[ix,iy]<map_wall then movement^[ix,iy]:=100 else movement^[ix,iy]:=255;
       distance^[ix,iy]:=255;
    end;

   if playergo then begin
    for ix:=1 to maxx do
      for iy:=1 to maxy do if vis^[ix,iy]=0 then movement^[ix,iy]:=253;

    for ix:=1 to nbot do if bot[ix].hp>0 then begin
      if bot[ix].owner=player then movement^[bot[ix].x,bot[ix].y]:=254;
      if (bot[ix].owner=computer) and (vis^[bot[ix].x,bot[ix].y]>oldvisible) then movement^[bot[ix].x,bot[ix].y]:=254;
    end;
  end else
    for ix:=1 to nbot do if bot[ix].hp>0 then movement^[bot[ix].x,bot[ix].y]:=254;

  movement^[from_x,from_y]:=9;
  distance^[from_x,from_y]:=0;
  nx1:=from_x-1;
  ny1:=from_y-1;
  nx2:=from_x+1;
  ny2:=from_y+1;
  if nx1<=0 then nx1:=1;
  if ny1<=0 then ny1:=1;
  if nx2>maxx then nx2:=maxx;
  if ny2>maxy then ny2:=maxy;
 end;

  movement_new^:=movement^;

  distanceexceeded:=false;
  repeat
    if maxdistance<255 then distanceexceeded:=true;
    nomoves:=true;
    x1:=nx1;x2:=nx2;
    y1:=ny1;y2:=ny2;
    for ix:=x1 to x2 do
      for iy:=y1 to y2 do if movement^[ix,iy]=100 then begin
        if ix-1>0 then begin
          if iy-1>0 then
            if movement^[ix-1,iy-1]<10 then begin movement_new^[ix,iy]:=7; distance_new:=distance^[ix-1,iy-1]+distance_step; end;
          if iy+1<=maxy then
            if movement^[ix-1,iy+1]<10 then begin movement_new^[ix,iy]:=1; distance_new:=distance^[ix-1,iy+1]+distance_step; end;
            if movement^[ix-1,iy  ]<10 then begin movement_new^[ix,iy]:=8; distance_new:=distance^[ix-1,iy  ]+distance_accuracy; end;
        end;
        if ix+1<=maxx then begin
          if iy-1>0 then
            if movement^[ix+1,iy-1]<10 then begin movement_new^[ix,iy]:=5; distance_new:=distance^[ix+1,iy-1]+distance_step; end;
          if iy+1<=maxy then
            if movement^[ix+1,iy+1]<10 then begin movement_new^[ix,iy]:=3; distance_new:=distance^[ix+1,iy+1]+distance_step; end;
            if movement^[ix+1,iy  ]<10 then begin movement_new^[ix,iy]:=4; distance_new:=distance^[ix+1,iy  ]+distance_accuracy; end;
        end;
          if iy-1>0 then
            if movement^[ix  ,iy-1]<10 then begin movement_new^[ix,iy]:=6; distance_new:=distance^[ix  ,iy-1]+distance_accuracy; end;
          if iy+1<=maxy then
            if movement^[ix  ,iy+1]<10 then begin movement_new^[ix,iy]:=2; distance_new:=distance^[ix  ,iy+1]+distance_accuracy; end;

        if movement_new^[ix,iy]<>100 then begin
          nomoves:=false;
          if distance_new<255 then distance^[ix,iy]:=distance_new else distance^[ix,iy]:=255;
          if (ix=nx1) and ((nx1-1)>0) then nx1:=nx1-1;
          if (iy=ny1) and ((ny1-1)>0) then ny1:=ny1-1;
          if (ix=nx2) and ((nx2+1)<=maxx) then nx2:=nx2+1;
          if (iy=ny2) and ((ny2+1)<=maxy) then ny2:=ny2+1;
        end else distance^[ix,iy]:=255;
        if distance_new<maxdistance then distanceexceeded:=false;
      end;
     movement^:=movement_new^;
  until (nomoves) or (distanceexceeded) or (movement^[to_x,to_x]<10);
  dispose(movement_new);
end;

procedure Tform1.generatemovement(thisbot,target_x,target_y:integer); // generatenewmap,target
begin
if (target_x>0) and (target_x<=maxx) and (target_y>0) and (target_y<=maxy) then begin
  generatemovement_generic(bot[thisbot].x,bot[thisbot].y,target_x,target_y,255,movement_map_for<>thisbot,bot[thisbot].owner=player);
  movement_map_for:=thisbot;
end;
end;

{================================================================================}
{================================================================================}
{================================================================================}

function check_LOS(x1,y1,x2,y2:integer;smoker:boolean):integer;
var dx,dy:integer;
    xx1,yy1:integer;
    range,maxrange:integer;
    L,L1:integer;
begin
 L:=-1;
 L1:=-1;
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
    if smoker=true then begin
      if map^[xx1,yy1]<map_wall then dec(L,map_status^[xx1,yy1])
    end else
      if map^[xx1,yy1]<map_wall then dec(L,2);
    if (map^[xx1,yy1]>=map_wall) and ((xx1<>x2) or (yy1<>y2)) then L:=-1;
  until (range>=maxrange) or (L<1);

  //stupid bugfix for los(x1,x2)<>los(x2,x1)
  dx:=x1-x2;
  dy:=y1-y2;
  maxrange:=round(visibleaccuracy*sqrt(sqr(dx)+sqr(dy)))+1;
  L1:=visiblerange*visibleaccuracy;
  range:=0;
  repeat
    inc(range);
    xx1:=x2+round(dx*range / maxrange);
    yy1:=y2+round(dy*range / maxrange);
    if smoker=true then begin
      if map^[xx1,yy1]<map_wall then dec(L1,map_status^[xx1,yy1])
    end else
      if map^[xx1,yy1]<map_wall then dec(L1,2);
    if (map^[xx1,yy1]>=map_wall) and ((xx1<>x1) or (yy1<>y1)) then L1:=-1;
  until (range>=maxrange) or (L1<1);
 end;
 if L>L1 then check_LOS:=L else check_LOS:=L1;

 end;

{================================================================================}
{================================================================================}
{================================================================================}

function Tform1.generate_enemy_list(messageflag:boolean):boolean;
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
      alert_other_bots(bot[i].target,i);
    end;
  end;
  if enemyunits_new<>enemyunitsn then begin
    generate_enemy_list:=true;
    if (enemyunits_new>enemyunitsn) and (messageflag) and (this_turn=player) then begin
     draw_map;
     showmessage('Enemy nearby!');
    end;
  end else generate_enemy_list:=false;
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
   for ix:=bot[thisbot].x-visiblerange to bot[thisbot].x+visiblerange do if (ix>0) and (ix<=maxx) then
    for iy:=bot[thisbot].y-visiblerange to bot[thisbot].y+visiblerange do if (iy>0) and (iy<=maxy) then begin
      LOS:=check_LOS(bot[thisbot].x,bot[thisbot].y,ix,iy,true);
      if LOS>0 then begin
        LOS:=round((maxvisible-oldvisible)*LOS/(visiblerange*visibleaccuracy))+oldvisible;
        if vis^[ix,iy]<LOS then begin
           vis^[ix,iy]:=LOS;
           mapchanged^[ix,iy]:=255;
           if (ix=2) then begin
             if (vis^[1,iy]=0) then begin vis^[   1,iy]:=oldvisible; mapchanged^[   1,iy]:=255 end;
           end else if (ix=maxx-1) then begin
             if (vis^[maxx,iy]=0) then begin vis^[maxx,iy]:=oldvisible; mapchanged^[maxx,iy]:=255 end;
           end;
           if (iy=2) then begin
              if (vis^[ix,1]=0) then begin vis^[ix,1]:=oldvisible; mapchanged^[ix,   1]:=255 end else
           end else if (iy=maxy-1) then begin
              if (vis^[ix,maxy]=0) then begin vis^[ix,maxy]:=oldvisible; mapchanged^[ix,maxy]:=255 end;
           end;
        end;

      end
    end;
  end;
end;

procedure Tform1.bot_look_around(thisbot:integer);
var ix,iy:integer;
    LOS:integer;
begin
 if (bot[thisbot].hp>0) then begin
   for ix:=bot[thisbot].x-visiblerange to bot[thisbot].x+visiblerange do if (ix>0) and (ix<=maxx) then
    for iy:=bot[thisbot].y-visiblerange to bot[thisbot].y+visiblerange do if (iy>0) and (iy<=maxy) then begin
      LOS:=check_LOS(bot[thisbot].x,bot[thisbot].y,ix,iy,true);
      if (bot[thisbot].owner=computer) then begin
        if LOS>0 then if botvis^[ix,iy]<strategy_real_los then botvis^[ix,iy]:=strategy_visible;
      end else
        if LOS>0 then botvis^[ix,iy]:=strategy_real_los;
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

function TForm1.spend_tu(thisbot:integer;tus:integer):boolean;
var oldtu:byte;
begin
 if (bot[thisbot].tu>=tus) or (gamemode=gamemode_victory) then begin
   oldtu:=bot[thisbot].tu;
   if gamemode<>gamemode_victory then dec(bot[thisbot].tu,tus);
   if bot[thisbot].items[1].rechargestate>tus then dec(bot[thisbot].items[1].rechargestate,tus) else bot[thisbot].items[1].rechargestate:=0;

   if (bot[thisbot].owner=player) then
     if ((oldtu>=strategy_cheater) and (bot[thisbot].tu<=strategy_cheater)) or (botvis^[bot[thisbot].x,bot[thisbot].y]=strategy_visible) then begin
       bot[thisbot].lastseen_x :=bot[thisbot].x;
       bot[thisbot].lastseen_y :=bot[thisbot].y;
       bot[thisbot].lastseen_tu:=bot[thisbot].tu;
     end;

   spend_tu:=true;
 end else begin
   spend_tu:=false;
   if bot[thisbot].owner=player then begin
     if tus<=255 then showmessage('Not enough TUs') else showmessage('Impossible...')
   end;
 end;
end;

{=================================================================}
{=================================================================}
{=================================================================}

const maxwaypoints=1000;
var waypointx,waypointy:array[1..maxwaypoints]of integer;
    waypointn:integer;
    waypoint_count:integer;
//    waypoint_distance:integer;
procedure Generatewaypoints(thisbot,to_x,to_y:integer);
var xx1,yy1:integer;
begin
  waypointn:=0;
  xx1:=to_x;
  yy1:=to_y;
//  waypoint_distance:=0;
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

//    inc(waypoint_distance,round(bot[thisbot].speed*sqrt(sqr(xx1-waypointx[waypointn])+sqr(yy1-waypointy[waypointn]))));
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
       if generate_enemy_list(true) then waypointn:=0
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
   for iy:= 1 to maxy do mapg^[ix,iy]:=generatorseed;
end;

{--------------------------------------------------------------------------------------}
procedure generate_map_cocon;
var ix,iy,cx,cy:integer;
    dx,dy:integer;
    map_seed:float;
    tile:byte;
    flg,flgx:boolean;
begin
  random_tiles:=false;
  form1.memo1.lines.add('COCON MAP * no');
  if map_parameter[1]=-1 then cx:=round((2+random)*maxx/5) else cx:=round(map_parameter[1]);
  if map_parameter[2]=-1 then cy:=round((2+random)*maxy/5) else cy:=round(map_parameter[2]);
  for ix:=1 to maxx do
    for iy:= 1 to maxy do begin
       map_seed:=1.5*sqrt((sqr(ix-cx+0.0001)+sqr(iy-cy+0.0001)+1)/(sqr((maxx +0.0001)/ 2)+sqr((maxy+0.0001) / 2)+1));
       if 1>map_seed then tile:=3 else
       if 0.5>map_seed then tile:=2 else
                            tile:=1;
       if (random>map_seed) or (random<0.3) then mapg^[ix,iy]:=map_generation_wall+tile else mapg^[ix,iy]:=map_generation_free+tile;
     end;

  mapg^[cx,cy]:=map_generation1;
  repeat
   flgx:=true;
   for ix:=2 to maxx-1 do
     for iy:=2 to maxy-1 do if (mapg^[ix,iy]<map_generation_free) and (mapg^[ix,iy]>=map_generation_wall) then begin
       flg:=false;
       for dx:=-1 to 1 do
        for dy:=-1 to 1 do
           if mapg^[ix+dx,iy+dy]=map_generation1 then flg:=true;
       for dx:=-1 to 1 do
         for dy:=-1 to 1 do
           if mapg^[ix+dx,iy+dy]>=map_generation_free then flg:=false;

       if flg then begin
         mapg^[ix,iy]:=map_generation1;
         flgx:=false;
       end;
     end;
  until flgx;

  repeat
    ix:=round(random*(maxx-3))+2;
    iy:=round(random*(maxy-3))+2;
  until (mapg^[ix,iy]>=map_generation_free);

  for dx:=0 to max_max_value do
    mapg^[cx+round((ix-cx)*dx/max_max_value),cy+round((iy-cy)*dx/max_max_value)]:=map_generation1;

  for ix:=2 to maxx-1 do
    for iy:=2 to maxy-1 do
      if mapg^[ix,iy]=map_generation1 then mapg^[ix,iy]:=map_generation_free+0;
end;

{----------------------------------------------------------------------------------}

procedure generate_map_random;
var ix,iy:integer;
    map_seed:float;
begin
  if map_parameter[1]=-1 then map_seed:=0.4+0.3*random else map_seed:=map_parameter[1];
  form1.memo1.lines.add('RANDOM MAP * '+inttostr(round(map_seed*100)));
  for ix:=1 to maxx do
    for iy:= 1 to maxy do begin
       if random>map_seed then mapg^[ix,iy]:=map_generation_wall else mapg^[ix,iy]:=map_generation_free;
     end;
end;

{----------------------------------------------------------------------------------}

const maxcircles=20;
procedure generate_map_random_circles;
var ix,iy,i:integer;
    Ncircles:integer;
    cx,cy,r:array[1..maxcircles] of integer;
begin
  generate_map_makewalls(map_generation_wall);
  if map_parameter[1]=-1 then Ncircles:=round(sqr(sqr(random))*(max_max_value/10-1))+1 else Ncircles:=round(map_parameter[1]);
  if NCircles>maxcircles then NCircles:=maxcircles;
  form1.memo1.lines.add('RANDOM CIRCLES MAP * '+inttostr(Ncircles));
  for i:=1 to NCircles do begin
    r[i]:=round(max_max_value/(Ncircles+1)*sqr(random))+5;
    cx[i]:=round((maxx/2)*random)+maxx div 4;
    cy[i]:=round((maxy/2)*random)+maxy div 4;
  end;
  for ix:=1 to maxx do
    for iy:= 1 to maxy do
      for i:=1 to NCircles do begin
       if ((sqrt(random))>sqrt(sqr(ix-cx[i])+sqr(iy-cy[i]))/r[i]) or (random>0.9) then mapg^[ix,iy]:=map_generation_free;
     end;
end;

{--------------------------------------------------------------------------------------}

procedure generate_map_circles;
var ix,iy,i,dx,dy:integer;
    map_seed:float;
begin
  generate_map_makewalls(map_generation_wall);
  if map_parameter[1]=-1 then map_seed:=0.4+random/4 else map_seed:=map_parameter[1];
  form1.memo1.lines.add('CIRCLES MAP * '+inttostr(round(map_seed*100)));
  repeat
    i:=round(sqr(sqr(random))*max_max_value/5)+4;
    ix:=round(random*(maxx-1)+1);
    iy:=round(random*(maxy-1)+1);
    for dx:=-i to i do
     for dy:=-i to i do
      if (sqr(dx)+sqr(dy)<=i) and (ix+dx>0) and (iy+dy>0) and (ix+dx<=maxx) and (iy+dy<=maxy) then mapg^[ix+dx,iy+dy]:=map_generation_free;
        i:=0;
        for ix:=1 to maxx do
          for iy:= 1 to maxy do if mapg^[ix,iy]=map_generation_free then inc(i);
  until (i/maxx/maxy>map_seed);
end;

{--------------------------------------------------------------------------------------}

procedure generate_map_anticircles;
var ix,iy,i,dx,dy:integer;
    map_seed:float;
begin
  generate_map_makewalls(map_generation_free);
  if map_parameter[1]=-1 then map_seed:=0.3+random/3 else map_seed:=map_parameter[1];
  form1.memo1.lines.add('ANTI-CIRCLES MAP * '+inttostr(round(map_seed*100)));
  repeat
    i:=round(sqr(sqr(random))*max_max_value/5)+1;
    ix:=round(random*(maxx-1)+1);
    iy:=round(random*(maxy-1)+1);
    for dx:=-i to i do
     for dy:=-i to i do
      if (sqr(dx)+sqr(dy)<=i) and (ix+dx>0) and (iy+dy>0) and (ix+dx<=maxx) and (iy+dy<=maxy) then mapg^[ix+dx,iy+dy]:=map_generation_wall;
        i:=0;
         for ix:=1 to maxx do
           for iy:= 1 to maxy do if mapg^[ix,iy]=map_generation_free then inc(i);
   until (i/maxx/maxy<map_seed) or (random<0.00001);
end;

{--------------------------------------------------------------------------------------}

procedure generate_map_rectagonal;
var ix,iy,i,dx,dy:integer;
    map_seed:float;
begin
  generate_map_makewalls(map_generation_wall);
  if map_parameter[1]=-1 then map_seed:=0.2+random*0.6 else map_seed:=map_parameter[1];
  form1.memo1.lines.add('RECTAGONAL MAP * '+inttostr(round(map_seed*100)));

  repeat
    i:=round(random*max_max_value/3);
    ix:=round(random*(maxx-1))+1;
    iy:=round(random*(maxy-1))+1;
    if random>0.5 then begin
     if random>0.5 then begin
       for dx:=ix to ix+i do if dx<=maxx then mapg^[dx,iy]:=map_generation_free
     end else begin
       for dx:=ix-i to ix do if dx>0 then mapg^[dx,iy]:=map_generation_free;
     end;
    end else begin
     if random>0.5 then begin
       for dy:=iy to iy+i do if dy<=maxy then mapg^[ix,dy]:=map_generation_free;
     end else begin
       for dy:=iy-i to iy do if dy>0 then mapg^[ix,dy]:=map_generation_free;
     end
    end;
    i:=0;
    for ix:=1 to maxx do
      for iy:= 1 to maxy do if mapg^[ix,iy]=map_generation_free then inc(i);
  until (i/maxx/maxy>map_seed);
end;

{--------------------------------------------------------------------------------------}

procedure generate_map_block;
var ix,iy,iix,iiy,dx,dy:integer;
    map_seed:float;
begin
  generate_map_makewalls(map_generation_wall);
  if map_parameter[1]=-1 then map_seed:=0.45+random/5 else map_seed:=map_parameter[1];
  if map_parameter[2]=-1 then dx:=round(random*5)+1 else dx:=round(map_parameter[2]);
  if map_parameter[3]=-1 then dy:=round(random*5)+1 else dy:=round(map_parameter[3]);
  form1.memo1.lines.add('BLOCK MAP * '+inttostr(round(map_seed*100)));
  if (dx=1) and (dy=1) then dx:=2;
  for ix:=1 to maxx div dx do
   for iy:=1 to maxy div dy do if random>map_seed then begin
     for iix:=ix*dx to (ix+1)*dx-1 do
      for iiy:=iy*dy to (iy+1)*dy-1 do if (iix>0) and (iiy>0) and (iix<=maxx) and (iiy<=maxy) then mapg^[iix,iiy]:=map_generation_free;
   end;
end;

{--------------------------------------------------------------------------------------}

procedure generate_map_diamonds;
var ix,iy,iix,iiy,dx,dy:integer;
    map_seed:float;
begin
  generate_map_makewalls(map_generation_wall);
  if map_parameter[1]=-1 then map_seed:=0.22+random/8 else map_seed:=map_parameter[1];
  if map_parameter[2]=-1 then dx:=round(random*5+3) else dx:=round(map_parameter[2]);
  dy:=dx;
  form1.memo1.lines.add('DIAMONDS MAP * '+inttostr(round(map_seed*100)));

//      if (dx=1) and (dy=1) then dx:=2;
  for ix:=0 to maxx div dx do
  for iy:=0 to maxy div dy do if (random>map_seed) then begin
    for iix:=ix*dx to (ix+1)*dx do
    for iiy:=iy*dy to (iy+1)*dy do if (abs((ix+0.5)*dx-iix)+abs((iy+0.5)*dy-iiy)<dx/1.9) and (iix>0) and (iiy>0) and (iix<=maxx) and (iiy<=maxy) then mapg^[iix,iiy]:=map_generation_free;
  end;
end;

{-------------------------------------------------------------------------------}

procedure generate_map_tmap;
var ix,iy:integer;
    map_seed:float;
begin
  generate_map_makewalls(map_generation_wall);
  if map_parameter[1]=-1 then map_seed:=0.2+random/8 else map_seed:=map_parameter[1];
  form1.memo1.lines.add('T MAP * '+inttostr(round(map_seed*100)));

  for ix:=0 to maxx div 4-1 do
   for iy:=0 to maxy div 4-1 do begin
     mapg^[ix*4+2,iy*4+2]:=map_generation_free;
     mapg^[ix*4+3,iy*4+3]:=map_generation_free;
     mapg^[ix*4+3,iy*4+2]:=map_generation_free;
     mapg^[ix*4+2,iy*4+3]:=map_generation_free;
     if random>map_seed then begin
       mapg^[ix*4+1,iy*4+2]:=map_generation_free;
       mapg^[ix*4+1,iy*4+3]:=map_generation_free;
     end;
     if random>map_seed then begin
       mapg^[ix*4+4,iy*4+2]:=map_generation_free;
       mapg^[ix*4+4,iy*4+3]:=map_generation_free;
     end;
     if random>map_seed then begin
       mapg^[ix*4+2,iy*4+1]:=map_generation_free;
       mapg^[ix*4+3,iy*4+1]:=map_generation_free;
     end;
     if random>map_seed then begin
       mapg^[ix*4+2,iy*4+4]:=map_generation_free;
       mapg^[ix*4+3,iy*4+4]:=map_generation_free;
     end;
  end;
end;

{--------------------------------------------------------------------------------------}

const maxmaxlinearsinus=maxmaxx div 2;
procedure generate_map_linearsinus;
var ix,iy,i:integer;
    frqx,frqy,phase,amp:array[1..maxmaxlinearsinus] of float;
    sum:float;
    maptype:byte;
    maxlinearsinus:integer;
begin
 maxlinearsinus:=max_max_value div 2;
 if map_parameter[1]=-1 then maptype:=round(random*1.3+0.45) else maptype:=round(map_parameter[1]);
 form1.memo1.lines.add('LINEAR SINUS MAP * type'+inttostr(maptype));
 for i:=1 to maxlinearsinus do begin
   sum:=random;
   if maptype=0 then sum:=(2*random-1);
   frqx[i]:=Pi*max_max_value/2*sum;
   sum:=random;
   if maptype=0 then sum:=(2*random-1);
   if maptype=2 then sum:=-random;
   frqy[i]:=Pi*max_max_value/2*sum;
   phase[i]:=random*2*pi;
   amp[i]:=sqrt(sqrt(random));
 end;

 for ix:=1 to maxx do
  for iy:=1 to maxy do begin
    sum:=0;
    for i:=1 to maxlinearsinus do sum:=sum+(amp[i]*sin(frqx[i]*ix/maxx+frqy[i]*iy/maxy+phase[i]));
    if sum>0 then mapg^[ix,iy]:=map_generation_wall else mapg^[ix,iy]:=map_generation_free;
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
  generate_map_makewalls(map_generation_wall);
  room_min:=3;
  room_max:=min_max_value div 5;
  if map_parameter[1]=-1 then room_n:=round(sqr(sqr(random))*(sqrt(maxx*maxy/sqr(room_max+3))))+3 else room_n:=round(map_parameter[1]);
  pass_min:=min_max_value div 5;
  pass_max:=max_max_value div 2;
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
        mapg^[ix,iy]:=map_generation_free;
       // if (ix=sx) or (ix=sx+roomx) or (iy=sy) or (iy=roomy) then if random>0.1/(roomx+roomy) then mapg^[ix,iy]:=map_generation1 else begin inc(pass); mapg^[ix,iy]:=map_generation2; end;
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
             mapg^[ix,iy]:=map_generation_free
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
    until mapg^[ix,iy]=map_generation2;

    if random>0.5 then begin dx:=round(random*2)-1; dy:=0 end else begin dy:=round(random*2)-1; dx:=0 end;
    repeat
      ix:=ix+dx;
      iy:=iy+dy;
      if (ix>0) and (ix<maxx) and (iy>0) and (iy<maxy) then begin
        if mapg^[ix,iy]>250 then pass:=0 else
         begin mapg^[ix,iy]:=map_generation_free; inc(i) end;
      end else pass:=0;
      dec(pass);
    until (pass<=0);
    if pass=-1 then generatecoords:=true;
    if (pass=0) and (random>0.9) then begin
      generatecoords:=true;
      mapg^[ix,iy]:=map_generation2;
    end;
  until (i/maxx/maxy>0.01) or (random<0.0001);

  for ix:=1 to maxx do
    for iy:= 1 to maxy do begin
       if mapg^[ix,iy]=map_generation1 then mapg^[ix,iy]:=map_generation_wall;
       if mapg^[ix,iy]=map_generation2 then mapg^[ix,iy]:=map_generation_free;
    end;  }
end;

{--------------------------------------------------------------------------------------}

procedure generate_map_Concentric;
var ix,iy,iix,iiy,dx,dy:integer;
    //map_seed:float;
    circle_rout,circle_rin,start_phase_x,start_phase_y:float;
begin
 // map_seed:=0.22+random/8;
  generate_map_makewalls(map_generation_wall);
  if map_parameter[1]=-1 then dx:=round(sqr(random)*max_max_value/2)+3 else dx:=round(map_parameter[1]);
 // if random>0.1 then dx:=round(max_max_value/2+random*max_max_value/2)+1;

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
       if (sqr((ix+0.5)*dx-iix+start_phase_x)+sqr((iy+0.5)*dx-iiy+start_phase_y)<sqr(circle_rout)) and ((sqr((ix+0.5)*dx-iix+start_phase_x)+sqr((iy+0.5)*dx-iiy+start_phase_y)>sqr(circle_rin))) and (iix>0) and (iiy>0) and (iix<=maxx) and (iiy<=maxy) then mapg^[iix,iiy]:=map_generation_free;
  end;
end;

{--------------------------------------------------------------------------------------}

procedure generate_map_slant;
var ix,iy:integer;
    map_seed:float;
begin
  generate_map_makewalls(map_generation_wall);
  if map_parameter[1]=-1 then map_seed:=0.98+random*0.02 else map_seed:=map_parameter[1];
  form1.memo1.lines.add('SLANT * '+inttostr(round(map_seed*100)));
{  for ix:=1 to 14 do
   for iy:=1 to 14 do mapg^[ix,iy]:=map_generation_free;}

  for ix:=0 to maxx div 5-1 do
   for iy:=0 to maxy div 5-1 do begin
     if random>0.5 then begin
       mapg^[ix*5+1,iy*5+1]:=map_generation_free;
       mapg^[ix*5+2,iy*5+2]:=map_generation_free;
       mapg^[ix*5+3,iy*5+3]:=map_generation_free;
       mapg^[ix*5+4,iy*5+4]:=map_generation_free;
       mapg^[ix*5+5,iy*5+5]:=map_generation_free;
       mapg^[ix*5+2,iy*5+1]:=map_generation_free;
       mapg^[ix*5+3,iy*5+2]:=map_generation_free;
       mapg^[ix*5+4,iy*5+3]:=map_generation_free;
       mapg^[ix*5+5,iy*5+4]:=map_generation_free;
       mapg^[ix*5+1,iy*5+2]:=map_generation_free;
       mapg^[ix*5+2,iy*5+3]:=map_generation_free;
       mapg^[ix*5+3,iy*5+4]:=map_generation_free;
       mapg^[ix*5+4,iy*5+5]:=map_generation_free;
       if random>map_seed then begin
         mapg^[ix*5+5,iy*5+1]:=map_generation_free;
         mapg^[ix*5+4,iy*5+2]:=map_generation_free;
         mapg^[ix*5+5,iy*5+2]:=map_generation_free;
         mapg^[ix*5+4,iy*5+1]:=map_generation_free;
       end;
       if random>map_seed then begin
         mapg^[ix*5+1,iy*5+5]:=map_generation_free;
         mapg^[ix*5+2,iy*5+4]:=map_generation_free;
         mapg^[ix*5+2,iy*5+5]:=map_generation_free;
         mapg^[ix*5+1,iy*5+4]:=map_generation_free;
       end;
     end else begin
       mapg^[ix*5+5,iy*5+1]:=map_generation_free;
       mapg^[ix*5+4,iy*5+2]:=map_generation_free;
       mapg^[ix*5+3,iy*5+3]:=map_generation_free;
       mapg^[ix*5+2,iy*5+4]:=map_generation_free;
       mapg^[ix*5+1,iy*5+5]:=map_generation_free;
       mapg^[ix*5+4,iy*5+1]:=map_generation_free;
       mapg^[ix*5+3,iy*5+2]:=map_generation_free;
       mapg^[ix*5+2,iy*5+3]:=map_generation_free;
       mapg^[ix*5+1,iy*5+4]:=map_generation_free;
       mapg^[ix*5+5,iy*5+2]:=map_generation_free;
       mapg^[ix*5+4,iy*5+3]:=map_generation_free;
       mapg^[ix*5+3,iy*5+4]:=map_generation_free;
       mapg^[ix*5+2,iy*5+5]:=map_generation_free;
       if random>map_seed then begin
         mapg^[ix*5+5,iy*5+5]:=map_generation_free;
         mapg^[ix*5+4,iy*5+4]:=map_generation_free;
         mapg^[ix*5+5,iy*5+4]:=map_generation_free;
         mapg^[ix*5+4,iy*5+5]:=map_generation_free;
       end;
       if random>map_seed then begin
         mapg^[ix*5+1,iy*5+1]:=map_generation_free;
         mapg^[ix*5+2,iy*5+2]:=map_generation_free;
         mapg^[ix*5+2,iy*5+1]:=map_generation_free;
         mapg^[ix*5+1,iy*5+2]:=map_generation_free;
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
  generate_map_makewalls(map_generation_wall);
  if map_parameter[1]=-1 then map_seed:=0.2+random/4 else map_seed:=map_parameter[1];
  form1.memo1.lines.add('BOXES MAP * '+inttostr(round(map_seed*100)));
  repeat
    ax:=round(maxx/5*random)+4;
    ay:=round(maxy/5*random)+4;
    bx:=round(((random)))+1;
    by:=round(((random)))+1;
    sx:=round(random*(maxx-ax-2))+1;
    sy:=round(random*(maxy-ay-2))+1;
    for ix:=sx to sx+ax do
     for iy:=sy to sy+ay do if mapg^[ix,iy]=map_generation_wall then begin
       if (ix<sx+bx) or (ix>sx+ax-bx) or (iy<sy+by) or (iy>sy+ay-by) then mapg^[ix,iy]:=map_generation_free else mapg^[ix,iy]:=map_generation1;
     end;

    freespace:=0;
    walls:=0;
    for ix:=1 to maxx do
     for iy:=1 to maxy do begin
       if mapg^[ix,iy]=map_generation_free then inc(freespace);
       if mapg^[ix,iy]=map_generation_wall then inc(walls);
     end;

  until (freespace/maxx/maxy>map_seed) or (walls/maxx/maxy<0.01) or (random<0.0001);
  for ix:=1 to maxx do
   for iy:=1 to maxy do if mapg^[ix,iy]=map_generation1 then mapg^[ix,iy]:=map_generation_wall;
end;

{--------------------------------------------------------------------------------------}

procedure generate_map_concentricfull;
var ix,iy,j:integer;
    cx,cy:float;
    maxr,rx_in,ry_in,rx_out,ry_out:float;
    map_seed:float;
    freespace,walls:integer;
begin
  generate_map_makewalls(map_generation_wall);
  if map_parameter[1]=-1 then map_seed:=0.2+random/4 else map_seed:=map_parameter[1];
  form1.memo1.lines.add('CONCENTRIC FULL MAP * '+inttostr(round(map_seed*100)));

  if map_parameter[2]=-1 then begin
    maxr:=random*min_max_value+10;
    if min_max_value<=max_max_value div 2 then maxr:=random*min_max_value+5;
  end else
    maxr:=map_parameter[2];

  repeat
    rx_out:=random*(maxr)+1;
    ry_out:=rx_out+random*4-2;if ry_out<1 then ry_out:=1;
    cx:=random*(maxx-rx_out)+rx_out; { if (rx_out>maxx/2) and (cx>0) or (cx<maxx) then rx_out:=rx_out/3;}
    cy:=random*(maxy-ry_out)+ry_out; { if (ry_out>maxy/2) and (cy>0) or (cy<maxy) then ry_out:=ry_out/3;}
    rx_in:=rx_out-1-sqr(random)*3; if rx_in<=1 then rx_in:=1;
    ry_in:=ry_out-1-sqr(random)*3; if ry_in<=1 then ry_in:=1;
    for ix:=1 to maxx do
     for iy:=1 to maxy do if (mapg^[ix,iy]=map_generation_wall) and (sqr((ix-cx)/rx_out)+sqr((iy-cy)/ry_out)<1) then begin
       if sqr((ix-cx)/rx_in)+sqr((iy-cy)/ry_in)>=1 then mapg^[ix,iy]:=map_generation_free else mapg^[ix,iy]:=map_generation1;
       if (rx_in>15) or (ry_in>15) then begin
         if sqr((ix-cx)/(rx_in-5-random*2))+sqr((iy-cy)/(rx_in-5-random*2))<1 then begin
           if random>map_seed then
            mapg^[ix,iy]:=map_generation_wall
           else
            mapg^[ix,iy]:=map_generation_free
         end
         else begin
           if random<1/rx_in then
             for j:=0 to 10 do if (ix+round((cx-ix)*j/10)>1) and (ix+round((cx-ix)*j/10)<maxx) and (iy+round((cy-iy)*j/10)>1) and (iy+round((cy-iy)*j/10)<maxy) then
               mapg^[ix+round((cx-ix)*j/10),iy+round((cy-iy)*j/10)]:=map_generation_free;
         end;
       end;
     end;
    freespace:=0;
    walls:=0;
    for ix:=1 to maxx do
     for iy:=1 to maxy do begin
       if mapg^[ix,iy]=map_generation_free then inc(freespace);
       if mapg^[ix,iy]=map_generation_wall then inc(walls);
     end;

  until (freespace/maxx/maxy>map_seed) or (walls/maxx/maxy<0.01) or (random<0.0001);
  for ix:=1 to maxx do
   for iy:=1 to maxy do if mapg^[ix,iy]=map_generation1 then mapg^[ix,iy]:=map_generation_wall;
end;

{--------------------------------------------------------------------------------------}

procedure generate_map_egg;
var ix,iy,j:integer;
    cx0,cy0,cx,cy:float;
    rout,rin:float;
    pass_count:integer;
    tile:byte;
begin
  random_tiles:=false;
  generate_map_makewalls(map_generation_wall);
  if map_parameter[1]=-1 then cx0:=(random-0.5)*(maxx/2)+maxx/2 else cx0:=map_parameter[1];
  if map_parameter[2]=-1 then cy0:=(random-0.5)*(maxy/2)+maxy/2 else cy0:=map_parameter[2];
  rout:=sqrt(sqr(maxx-cx0)+sqr(maxy-cy0));
  if rout<sqrt(sqr(cx0)+sqr(cy0)) then rout:=sqrt(sqr(cx0)+sqr(cy0));
  if rout<sqrt(sqr(maxx-cx0)+sqr(cy0)) then rout:=sqrt(sqr(maxx-cx0)+sqr(cy0));
  if rout<sqrt(sqr(cx0)+sqr(maxy-cy0)) then rout:=sqrt(sqr(cx0)+sqr(maxy-cy0));
  //rout:=rout-random*4;
  rin:=rout-1-5*random;
  form1.memo1.lines.add('EGG MAP * no');
  repeat
    cx:=cx0+random*2-1;
    cy:=cy0+random*2-1;
    if rout>3* max_max_value div 4 then tile:=0 else
    if rout>2* max_max_value div 4 then tile:=1 else
    if rout>   max_max_value div 4 then tile:=2 else
                            tile:=3;

    for ix:=1 to maxx do
     for iy:=1 to maxy do if sqr(ix-cx)+sqr(iy-cy)<=sqr(rout) then begin
       if sqr(ix-cx)+sqr(iy-cy)<=sqr(rin) then mapg^[ix,iy]:=map_generation_wall+tile else mapg^[ix,iy]:=map_generation_free+tile;
     end;
    pass_count:=0;
    repeat
      ix:=round(random*(maxx-2))+2;
      iy:=round(random*(maxy-2))+2;
      if (sqr(ix-cx)+sqr(iy-cy)<=sqr(rout)) and (sqr(ix-cx)+sqr(iy-cy)>=sqr(rin)) then begin
        for j:=0 to round(rout*10) do begin
          mapg^[round(ix+(cx-ix)*j/round(rout*10)    ),round(iy+(cy-iy)*j/round(rout*10)    )]:=map_generation_free+tile;
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
  generate_map_makewalls(map_generation_wall);

  if map_parameter[1]=-1 then map_seed:=random/3 else map_seed:=map_parameter[1];

  if map_parameter[2]=-1 then begin
    tmp:=max_max_value/10;
    if tmp>6 then tmp:=6;
    map_stepx:=random*10 + tmp;
    map_stepy:=random*10 + tmp;
    tmp:=map_stepx;
    map_stepx:=(2*tmp+map_stepy)/3;
    map_stepy:=(2*map_stepy+tmp)/3;
  end else begin
    map_stepx:=map_parameter[2];
    map_stepy:=map_parameter[3];
  end;
  phasex:=map_stepx*random;
  phasey:=map_stepy*random;

  if map_parameter[4]=-1 then begin
    if random<0.33 then map_irregularity:=0 else     // rgular
    if random>0.5 then
      map_irregularity:=random*(map_stepx*0.4)      // 40% regular
    else
      map_irregularity:=random*(2*map_stepx-1);      // strongly irregular
  end else
    map_irregularity:=map_parameter[4];


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
             for k:=3*10 to round((tmp-3)*10) do if mapg^[round(nodex[i]+(nodex[j]-nodex[i])*k/round(tmp*10)),round(nodey[i]+(nodey[j]-nodey[i])*k/round(tmp*10))]=map_generation_free then flg2:=false;
           if flg2 then begin
             for k:=0 to round(tmp*10) do mapg^[round(nodex[i]+(nodex[j]-nodex[i])*k/round(tmp*10)),round(nodey[i]+(nodey[j]-nodey[i])*k/round(tmp*10))]:=map_generation_free;
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
  if (x>0) and (x<maxx) and (y>0) and (y<maxy) then mapg^[x,y]:=data;
end;
procedure safemapwritefinal(x,y:integer;data:byte);
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
  generate_map_makewalls(map_generation_free);
  if map_parameter[1]=-1 then map_seed:=0.6+random*0.4 else map_seed:=map_parameter[1];
  if map_parameter[2]=-1 then map_seed2:=random/4      else map_seed2:=map_parameter[2];
  if map_parameter[3]=-1 then map_seed3:=random        else map_seed3:=map_parameter[3];
  if map_parameter[4]=-1 then map_seed4:=0.75+random/4 else map_seed4:=map_parameter[4];
  if map_parameter[5]=-1 then map_seed5:=random        else map_seed5:=map_parameter[5];
  if map_parameter[6]=-1 then map_seed6:=0.8+random/4  else map_seed6:=map_parameter[6];
  if map_parameter[7]=-1 then begin
    h:=4+round(random*maxy/4);
    w:=4+round(random*maxy/4);
    if (h>2*w) and (random>0.5) then h:=round(2*w);
    if (w>2*h) and (random>0.5) then w:=round(2*h);
    if h>21 then h:=21;
    if w>21 then w:=21;
  end else begin
    h:=round(map_parameter[7]);
    w:=round(map_parameter[8])
  end;
  h_phase:=round(random*h);
  w_phase:=round(random*w);
  form1.memo1.lines.add('PLUS MAP * '+inttostr(w)+'x'+inttostr(h));
  for ix:=0 to (maxx div w)+2 do
   for iy:=0 to (maxy div h)+2 do begin
     x1:=ix*w+w_phase;
     y1:=iy*h+h_phase;
     //central box
                              safemapwrite(x1  ,y1  ,map_generation_wall);
     if random>map_seed2 then safemapwrite(x1-1,y1  ,map_generation_wall);
                              safemapwrite(x1-2,y1  ,map_generation_wall);
     if random>map_seed2 then safemapwrite(x1-2,y1-1,map_generation_wall);
                              safemapwrite(x1-2,y1-2,map_generation_wall);
     if random>map_seed2 then safemapwrite(x1-1,y1-2,map_generation_wall);
                              safemapwrite(x1  ,y1-2,map_generation_wall);
     if random>map_seed2 then safemapwrite(x1  ,y1-1,map_generation_wall);
     //vertical lines
     for j:=y1-3 downto y1-h+2 do safemapwrite(x1-2,j,map_generation_wall);
     if random>map_seed then      safemapwrite(x1-2,y1-h+1,map_generation_wall);
     for j:=y1-4 downto y1-h+1 do safemapwrite(x1,j,map_generation_wall);
     if random>map_seed then      safemapwrite(x1,y1-3,map_generation_wall);
     //horizontal lines
     for j:=x1-3 downto x1-w+2 do safemapwrite(j,y1,map_generation_wall);
     if random>map_seed then      safemapwrite(x1-w+1,y1,map_generation_wall);
     for j:=x1-4 downto x1-w+1 do safemapwrite(j,y1-2,map_generation_wall);
     if random>map_seed then      safemapwrite(x1-3,y1-2,map_generation_wall);
     //side block
     if (random>map_seed3) and (h>6) and (w>6) then begin
       for bx:=x1-4 downto x1-w+2 do
        for by:=y1-4 downto y1-h+2 do safemapwrite(bx,by,map_generation_wall);
       if random>map_seed4 then safemapwrite(((x1-4)+(x1-w+2)) div 2,y1-3 ,map_generation_wall);
       if random>map_seed4 then safemapwrite(((x1-4)+(x1-w+2)) div 2,y1-h+1,map_generation_wall);
       if random>map_seed4 then safemapwrite(x1-3  ,((y1-4)+(y1-h+2)) div 2,map_generation_wall);
       if random>map_seed4 then safemapwrite(x1-w+1,((y1-4)+(y1-h+2)) div 2,map_generation_wall);

       //hollow block
       if (random>map_seed5) and (((h>=9) and (w>=9)) or ((h=8) and (w>9)) or ((w=8) and (h>9))) then begin
         rx:=1+round(sqr(sqr(sqr(random)))*(w-9)/2);
         ry:=1+round(sqr(sqr(sqr(random)))*(h-9)/2);
         for bx:=x1-4-rx downto x1-w+2+rx do
          for by:=y1-4-ry downto y1-h+2+ry do safemapwrite(bx,by,map_generation_free);
         if random>0.5 then bx:=1 else bx:=-1;
         if w>8 then begin
           if random>map_seed6 then for j:=0 to ry do safemapwrite(((x1-4)+(x1-w+2)) div 2+bx,y1-4  -j,map_generation_free);
           if random>map_seed6 then for j:=0 to ry do safemapwrite(((x1-4)+(x1-w+2)) div 2-bx,y1-h+2+j,map_generation_free);
         end;
         if h>8 then begin
           if random>map_seed6 then for j:=0 to rx do safemapwrite(x1-4  -j,((y1-4)+(y1-h+2)) div 2+bx,map_generation_free);
           if random>map_seed6 then for j:=0 to rx do safemapwrite(x1-w+2+j,((y1-4)+(y1-h+2)) div 2-bx,map_generation_free);
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
  generate_map_makewalls(map_generation_free);
  if map_parameter[1]=-1 then map_seed:=0.6+random*0.3 else map_seed:=map_parameter[1];   //blockers
  if map_parameter[2]=-1 then map_seed2:=random else map_seed2:=map_parameter[2];
  if map_parameter[3]=-1 then map_seed3:=random*0.40 else map_seed3:=map_parameter[3];
  xphase:=round(random*smalroomssize);
  yphase:=round(random*smalroomssize);
  form1.memo1.lines.add('SMALLROOMS MAP * '+inttostr(round(map_seed*100)));
  for ix:=0 to maxx div smalroomssize+2 do
   for iy:=0 to maxy div smalroomssize+2 do begin
     x1:=ix*smalroomssize-xphase;
     y1:=iy*smalroomssize-yphase;
     //block
     for jx:=x1+1 to x1+5 do
      for jy:=y1+1 to y1+5 do safemapwrite(jx,jy,map_generation_wall);
     //hollow entrance
     flg:=false;
     if random<map_seed3 then begin safemapwrite(x1+3,y1+1,map_generation_free); flg:=true end;
     if random<map_seed3 then begin safemapwrite(x1+3,y1+5,map_generation_free); flg:=true end;
     if random<map_seed3 then begin safemapwrite(x1+1,y1+3,map_generation_free); flg:=true end;
     if random<map_seed3 then begin safemapwrite(x1+5,y1+3,map_generation_free); flg:=true end;
     //hollow
     if flg then begin
       safemapwrite(x1+2,y1+2,map_generation_free);
       safemapwrite(x1+3,y1+2,map_generation_free);
       safemapwrite(x1+4,y1+2,map_generation_free);
       safemapwrite(x1+2,y1+4,map_generation_free);
       safemapwrite(x1+3,y1+4,map_generation_free);
       safemapwrite(x1+4,y1+4,map_generation_free);
       safemapwrite(x1+2,y1+3,map_generation_free);
       safemapwrite(x1+4,y1+3,map_generation_free);
       if random<map_seed2 then safemapwrite(x1+3,y1+3,map_generation_free);
     end;
     //blockings
     if random>map_seed then safemapwrite(x1+2,y1  ,map_generation_wall);
     if random>map_seed then safemapwrite(x1+4,y1  ,map_generation_wall);
     if random>map_seed then safemapwrite(x1  ,y1+2,map_generation_wall);
     if random>map_seed then safemapwrite(x1  ,y1+4,map_generation_wall);
   end;
end;

{--------------------------------------------------------------------------------------}
const Ixsize=6;
      Iysize=8;
procedure generate_map_Imap;
var ix,iy,x1,y1:integer;
    map_seed,map_seed2,map_seed3:float;
    xphase,yphase:integer;
//    flg:boolean;
begin
 generate_map_makewalls(map_generation_free);
 if map_parameter[1]=-1 then map_seed:=0.7+random*0.3 else map_seed:=map_parameter[1];   //blockers
 if map_parameter[2]=-1 then map_seed2:=0.9+random*0.1 else map_seed2:=map_parameter[2];
 if map_parameter[3]=-1 then map_seed3:=random else map_seed3:=map_parameter[3];
 xphase:=round(random*Ixsize);
 yphase:=round(random*Iysize);
 if map_seed3>0.5 then begin
  form1.memo1.lines.add('I-map Vertical MAP * '+inttostr(round(map_seed*100)));
  for ix:=0 to maxx div Ixsize+2 do
   for iy:=0 to maxy div Iysize+2 do begin
     x1:=ix*Ixsize-xphase;
     y1:=iy*Iysize-yphase;
     //first I caps
     safemapwrite(x1  ,y1  ,map_generation_wall);
     safemapwrite(x1+1,y1  ,map_generation_wall);
     safemapwrite(x1+2,y1  ,map_generation_wall);
     safemapwrite(x1  ,y1+6,map_generation_wall);
     safemapwrite(x1+1,y1+6,map_generation_wall);
     safemapwrite(x1+2,y1+6,map_generation_wall);
     //stem
     safemapwrite(x1+1,y1+1,map_generation_wall);
     safemapwrite(x1+1,y1+2,map_generation_wall);
     safemapwrite(x1+1,y1+3,map_generation_wall);
     safemapwrite(x1+1,y1+4,map_generation_wall);
     safemapwrite(x1+1,y1+5,map_generation_wall);
     //second I caps
     safemapwrite(x1+3,y1+2,map_generation_wall);
     safemapwrite(x1+4,y1+2,map_generation_wall);
     safemapwrite(x1+5,y1+2,map_generation_wall);
     safemapwrite(x1+3,y1+4,map_generation_wall);
     safemapwrite(x1+4,y1+4,map_generation_wall);
     safemapwrite(x1+5,y1+4,map_generation_wall);
     //stem
     safemapwrite(x1+4,y1  ,map_generation_wall);
     safemapwrite(x1+4,y1+1,map_generation_wall);
     safemapwrite(x1+4,y1+5,map_generation_wall);
     safemapwrite(x1+4,y1+6,map_generation_wall);
     safemapwrite(x1+4,y1+7,map_generation_wall);
     //vertical blockers
     if random>map_seed2 then safemapwrite(x1+1,y1+7,map_generation_wall);
     if random>map_seed2 then safemapwrite(x1+4,y1+3,map_generation_wall);
     //first I horizontal blockers
     if random>map_seed then safemapwrite(x1+3,y1  ,map_generation_wall);
     if random>map_seed then safemapwrite(x1+5,y1  ,map_generation_wall);
     if random>map_seed then safemapwrite(x1+3,y1+6,map_generation_wall);
     if random>map_seed then safemapwrite(x1+5,y1+6,map_generation_wall);
     //second I horizontal blockers
     if random>map_seed then safemapwrite(x1  ,y1+2,map_generation_wall);
     if random>map_seed then safemapwrite(x1+2,y1+2,map_generation_wall);
     if random>map_seed then safemapwrite(x1  ,y1+4,map_generation_wall);
     if random>map_seed then safemapwrite(x1+2,y1+4,map_generation_wall);
   end;
 end else begin
     form1.memo1.lines.add('I-map Horizontal MAP * '+inttostr(round(map_seed*100)));
     for ix:=0 to maxx div Iysize+2 do
      for iy:=0 to maxy div Ixsize+2 do begin
        x1:=ix*Iysize-yphase;
        y1:=iy*Ixsize-xphase;
        //first I caps
        safemapwrite(x1  ,y1  ,map_generation_wall);
        safemapwrite(x1  ,y1+1,map_generation_wall);
        safemapwrite(x1  ,y1+2,map_generation_wall);
        safemapwrite(x1+6,y1  ,map_generation_wall);
        safemapwrite(x1+6,y1+1,map_generation_wall);
        safemapwrite(x1+6,y1+2,map_generation_wall);
        //stem
        safemapwrite(x1+1,y1+1,map_generation_wall);
        safemapwrite(x1+2,y1+1,map_generation_wall);
        safemapwrite(x1+3,y1+1,map_generation_wall);
        safemapwrite(x1+4,y1+1,map_generation_wall);
        safemapwrite(x1+5,y1+1,map_generation_wall);
        //second I caps
        safemapwrite(x1+2,y1+3,map_generation_wall);
        safemapwrite(x1+2,y1+4,map_generation_wall);
        safemapwrite(x1+2,y1+5,map_generation_wall);
        safemapwrite(x1+4,y1+3,map_generation_wall);
        safemapwrite(x1+4,y1+4,map_generation_wall);
        safemapwrite(x1+4,y1+5,map_generation_wall);
        //stem
        safemapwrite(x1  ,y1+4,map_generation_wall);
        safemapwrite(x1+1,y1+4,map_generation_wall);
        safemapwrite(x1+5,y1+4,map_generation_wall);
        safemapwrite(x1+6,y1+4,map_generation_wall);
        safemapwrite(x1+7,y1+4,map_generation_wall);
        //vertical blockers
        if random>map_seed2 then safemapwrite(x1+7,y1+1,map_generation_wall);
        if random>map_seed2 then safemapwrite(x1+3,y1+4,map_generation_wall);
        //first I horizontal blockers
        if random>map_seed then safemapwrite(x1  ,y1+3,map_generation_wall);
        if random>map_seed then safemapwrite(x1  ,y1+5,map_generation_wall);
        if random>map_seed then safemapwrite(x1+6,y1+3,map_generation_wall);
        if random>map_seed then safemapwrite(x1+6,y1+5,map_generation_wall);
        //second I horizontal blockers
        if random>map_seed then safemapwrite(x1+2,y1  ,map_generation_wall);
        if random>map_seed then safemapwrite(x1+2,y1+2,map_generation_wall);
        if random>map_seed then safemapwrite(x1+4,y1  ,map_generation_wall);
        if random>map_seed then safemapwrite(x1+4,y1+2,map_generation_wall);
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
  generate_map_makewalls(map_generation_free);
  if map_parameter[1]=-1 then map_seed:=0.5+random*0.2 else map_seed:=map_parameter[1];   //blockers
  xphase:=round(random*foursize);
  yphase:=round(random*foursize);
  form1.memo1.lines.add('FOUR MAP * '+inttostr(round(map_seed*100)));
  for ix:=0 to maxx div foursize+2 do
   for iy:=0 to maxy div foursize+2 do begin
     x1:=ix*foursize-xphase;
     y1:=iy*foursize-yphase;
     //horizontal lines
     safemapwrite(x1  ,y1+1,map_generation_wall);
     safemapwrite(x1+1,y1+1,map_generation_wall);
     safemapwrite(x1+2,y1+1,map_generation_wall);
     safemapwrite(x1+3,y1+4,map_generation_wall);
     safemapwrite(x1+4,y1+4,map_generation_wall);
     safemapwrite(x1+5,y1+4,map_generation_wall);
     //vertical lines
     safemapwrite(x1+1,y1+3,map_generation_wall);
     safemapwrite(x1+1,y1+4,map_generation_wall);
     safemapwrite(x1+1,y1+5,map_generation_wall);
     safemapwrite(x1+4,y1  ,map_generation_wall);
     safemapwrite(x1+4,y1+1,map_generation_wall);
     safemapwrite(x1+4,y1+2,map_generation_wall);
     //blockings
     if random>map_seed then safemapwrite(x1+1,y1  ,map_generation_wall);
     if random>map_seed then safemapwrite(x1+3,y1+1,map_generation_wall);
     if random>map_seed then safemapwrite(x1+5,y1+1,map_generation_wall);
     if random>map_seed then safemapwrite(x1+1,y1+2,map_generation_wall);
     if random>map_seed then safemapwrite(x1+4,y1+3,map_generation_wall);
     if random>map_seed then safemapwrite(x1  ,y1+4,map_generation_wall);
     if random>map_seed then safemapwrite(x1+2,y1+4,map_generation_wall);
     if random>map_seed then safemapwrite(x1+4,y1+5,map_generation_wall);
   end;
end;

{--------------------------------------------------------------------------------------}

const fivesize=5;
procedure generate_map_five;
var ix,iy,x1,y1:integer;
    map_seed:float;
    xphase,yphase:integer;
begin
  generate_map_makewalls(map_generation_free);
  if map_parameter[1]=-1 then map_seed:=0.5+random*0.2 else map_seed:=map_parameter[1];   //blockers
  xphase:=round(random*fivesize);
  yphase:=round(random*fivesize);
  form1.memo1.lines.add('FIVE MAP * '+inttostr(round(map_seed*100)));
  for ix:=0 to maxx div fivesize+2 do
   for iy:=0 to maxy div fivesize+2 do begin
     x1:=ix*fivesize-xphase;
     y1:=iy*fivesize-yphase;
     //permament walls
     safemapwrite(x1  ,y1  ,map_generation_wall);
     safemapwrite(x1+2,y1  ,map_generation_wall);
     safemapwrite(x1+3,y1  ,map_generation_wall);
     safemapwrite(x1  ,y1+2,map_generation_wall);
     safemapwrite(x1+2,y1+2,map_generation_wall);
     safemapwrite(x1+3,y1+2,map_generation_wall);
     safemapwrite(x1  ,y1+3,map_generation_wall);
     safemapwrite(x1+2,y1+3,map_generation_wall);
     safemapwrite(x1+3,y1+3,map_generation_wall);
     //blockings
     if random>map_seed then safemapwrite(x1+1,y1  ,map_generation_wall);
     if random>map_seed then safemapwrite(x1+4,y1  ,map_generation_wall);
     if random>map_seed then safemapwrite(x1  ,y1+1,map_generation_wall);
     if random>map_seed then safemapwrite(x1+2,y1+1,map_generation_wall);
     if random>map_seed then safemapwrite(x1+4,y1+2,map_generation_wall);
     if random>map_seed then safemapwrite(x1+1,y1+3,map_generation_wall);
     if random>map_seed then safemapwrite(x1  ,y1+4,map_generation_wall);
     if random>map_seed then safemapwrite(x1+3,y1+4,map_generation_wall);
   end;
end;

{--------------------------------------------------------------------------------------}
const dashsize=6;
procedure generate_map_dash;
var ix,iy,x1,y1,line:integer;
    map_seed,map_kind,map_type:float;
    xphase,yphase:integer;
    kind:boolean;
begin
  generate_map_makewalls(map_generation_free);
  if map_parameter[1]=-1 then map_seed:=0.5+random*0.2 else map_seed:=map_parameter[1];   //blockers
  xphase:=round(random*dashsize);
  yphase:=round(random*dashsize);

  if map_parameter[2]=-1 then map_kind:=random else map_kind:=map_parameter[2];
  if map_kind>0.5 then kind:=true else kind:=false;

  if map_parameter[3]=-1 then map_type:=random else map_type:=map_parameter[3];
  if map_type>0.5 then begin
    form1.memo1.lines.add('DASH horizontal MAP * '+inttostr(round(map_seed*100)));
    if kind then form1.memo1.lines.add('top-left variant') else form1.memo1.lines.add('top-right variant');
    for ix:=0 to maxx div dashsize+2 do
     for iy:=0 to maxy div dashsize+2 do begin
       x1:=ix*dashsize-xphase;
       y1:=iy*dashsize-yphase;
       //permament walls
       safemapwrite(x1  ,y1  ,map_generation_wall); //first line
       safemapwrite(x1+1,y1  ,map_generation_wall);
       safemapwrite(x1+3,y1  ,map_generation_wall);
       safemapwrite(x1+4,y1  ,map_generation_wall);
       if kind then line:=y1+2 else line:=y1+4;
       safemapwrite(x1+1,line,map_generation_wall); //third line
       safemapwrite(x1+2,line,map_generation_wall);
       safemapwrite(x1+4,line,map_generation_wall);
       safemapwrite(x1+5,line,map_generation_wall);
       if kind then line:=y1+4 else line:=y1+2;
       safemapwrite(x1  ,line,map_generation_wall);  //fifth line
       safemapwrite(x1+2,line,map_generation_wall);
       safemapwrite(x1+3,line,map_generation_wall);
       safemapwrite(x1+5,line,map_generation_wall);
       //blockings
       if random>map_seed then safemapwrite(x1+2,y1  ,map_generation_wall); //first line
       if random>map_seed then safemapwrite(x1+5,y1  ,map_generation_wall);
       if kind then line:=y1+1 else line:=y1+5;
       if random>map_seed then safemapwrite(x1+1,line,map_generation_wall); //second line
       if random>map_seed then safemapwrite(x1+4,line,map_generation_wall);
       if kind then line:=y1+2 else line:=y1+4;
       if random>map_seed then safemapwrite(x1  ,line,map_generation_wall); //third line
       if random>map_seed then safemapwrite(x1+3,line,map_generation_wall);
       if random>map_seed then safemapwrite(x1+2,y1+3,map_generation_wall); //fourth line
       if random>map_seed then safemapwrite(x1+5,y1+3,map_generation_wall);
       if kind then line:=y1+4 else line:=y1+2;
       if random>map_seed then safemapwrite(x1+1,line,map_generation_wall); //fifth line
       if random>map_seed then safemapwrite(x1+4,line,map_generation_wall);
       if kind then line:=y1+5 else line:=y1+1;
       if random>map_seed then safemapwrite(x1  ,line,map_generation_wall); //sixth line
       if random>map_seed then safemapwrite(x1+3,line,map_generation_wall);
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
       safemapwrite(x1  ,y1  ,map_generation_wall); //first line
       safemapwrite(x1  ,y1+1,map_generation_wall);
       safemapwrite(x1  ,y1+3,map_generation_wall);
       safemapwrite(x1  ,y1+4,map_generation_wall);
       if kind then line:=x1+2 else line:=x1+4;
       safemapwrite(line,y1+1,map_generation_wall); //third line
       safemapwrite(line,y1+2,map_generation_wall);
       safemapwrite(line,y1+4,map_generation_wall);
       safemapwrite(line,y1+5,map_generation_wall);
       if kind then line:=x1+4 else line:=x1+2;
       safemapwrite(line,y1  ,map_generation_wall);  //fifth line
       safemapwrite(line,y1+2,map_generation_wall);
       safemapwrite(line,y1+3,map_generation_wall);
       safemapwrite(line,y1+5,map_generation_wall);
       //blockings
       if random>map_seed then safemapwrite(x1  ,y1+2,map_generation_wall); //first line
       if random>map_seed then safemapwrite(x1  ,y1+5,map_generation_wall);
       if kind then line:=x1+1 else line:=x1+5;
       if random>map_seed then safemapwrite(line,y1+1,map_generation_wall); //second line
       if random>map_seed then safemapwrite(line,y1+4,map_generation_wall);
       if kind then line:=x1+2 else line:=x1+4;
       if random>map_seed then safemapwrite(line,y1  ,map_generation_wall); //third line
       if random>map_seed then safemapwrite(line,y1+3,map_generation_wall);
       if random>map_seed then safemapwrite(x1+3,y1+2,map_generation_wall); //fourth line
       if random>map_seed then safemapwrite(x1+3,y1+5,map_generation_wall);
       if kind then line:=x1+4 else line:=x1+2;
       if random>map_seed then safemapwrite(line,y1+1,map_generation_wall); //fifth line
       if random>map_seed then safemapwrite(line,y1+4,map_generation_wall);
       if kind then line:=x1+5 else line:=x1+1;
       if random>map_seed then safemapwrite(line,y1  ,map_generation_wall); //sixth line
       if random>map_seed then safemapwrite(line,y1+3,map_generation_wall);
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
  generate_map_makewalls(map_generation_wall);
  if map_parameter[1]=-1 then map_seed:=0.6+random*0.1+sqr(sqr(random))*0.3 else map_seed:=map_parameter[1];
  if map_parameter[2]=-1 then max_length:=max_max_value/10+3+max_max_value/2*random else max_length:=map_parameter[2];
  maxrotorlength:=1.5+10*sqr(sqr(random));
  if map_parameter[3]=-1 then max_angles:=2+round(random*3+sqr(sqr(sqr(random)))*32) else max_angles:=round(map_parameter[3]);
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
       safemapwrite(x2,y2,map_generation_free);
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
  generate_map_makewalls(map_generation_wall);
  if map_parameter[1]=-1 then map_seed:=0.8+0.2*random else map_seed:=map_parameter[1];
  form1.memo1.lines.add('EGGRE MAP * '+inttostr(round(100*map_seed)));
  x1:=2;
  y1:=2;
  x2:=maxx-1;
  y2:=maxy-1;
  maxwallwidth:=4+round(sqr(random)*min_max_value/4);
  maxpasswidth:=1+round(sqr(sqr(random))*6);
  repeat
    for dx:=x1 to x2 do
     for dy:=y1 to y2 do mapg^[dx,dy]:=map_generation_free;
    xx1:=x1+1+round(random*maxpasswidth);
    xx2:=x2-1-round(random*maxpasswidth);
    yy1:=y1+1+round(random*maxpasswidth);
    yy2:=y2-1-round(random*maxpasswidth);
    // block some passages here
    for i:=1 to (2*(xx2-xx1)+2*(yy2-yy1)) div 15+4 do begin
      if random>0.5 then begin
        dy:=yy1+round((yy2-yy1-2)*random)+1;
        if random>0.5 then
          for dx:=x1 to xx1 do mapg^[dx,dy]:=map_generation_wall
        else
          for dx:=xx2 to x2 do mapg^[dx,dy]:=map_generation_wall
      end else begin
         dx:=xx1+round((xx2-xx1-2)*random)+1;
         if random>0.5 then
           for dy:=y1 to yy1 do mapg^[dx,dy]:=map_generation_wall
         else
           for dy:=yy2 to y2 do mapg^[dx,dy]:=map_generation_wall
      end;
    end;
    x1:=xx1;
    x2:=xx2;
    y1:=yy1;
    y2:=yy2;
    if (x1<x2) and (y1<y2) then begin
      for dx:=x1 to x2 do
       for dy:=y1 to y2 do mapg^[dx,dy]:=map_generation_wall;

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
                for dx:=x1+1 to xx1-2 do mapg^[dx,dy]:=map_generation_free;
                inc(dy);
              end;
              if dy-dy0>=3 then begin
                if random>0.5 then mapg^[   x1,dy0+1+round((dy-dy0-3)*random)]:=map_generation_free
                              else mapg^[xx1-1,dy0+1+round((dy-dy0-3)*random)]:=map_generation_free

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
                for dx:=xx2+2 to x2-1 do mapg^[dx,dy]:=map_generation_free;
                inc(dy);
              end;
              if dy-dy0>=3 then begin
                if random>0.5 then mapg^[   x2,dy0+1+round((dy-dy0-3)*random)]:=map_generation_free
                              else mapg^[xx2+1,dy0+1+round((dy-dy0-3)*random)]:=map_generation_free

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
                for dy:=y1+1 to yy1-2 do mapg^[dx,dy]:=map_generation_free;
                inc(dx);
              end;
              if dx-dx0>=3 then begin
                if random>0.5 then mapg^[dx0+1+round((dx-dx0-3)*random),y1]:=map_generation_free
                              else mapg^[dx0+1+round((dx-dx0-3)*random),yy1-1]:=map_generation_free

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
                for dy:=yy2+2 to y2-1 do mapg^[dx,dy]:=map_generation_free;
                inc(dx);
              end;
              if dx-dx0>=3 then begin
                if random>0.5 then mapg^[dx0+1+round((dx-dx0-3)*random),y2]:=map_generation_free
                              else mapg^[dx0+1+round((dx-dx0-3)*random),yy2+1]:=map_generation_free

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
              for dx:=x1 to xx1 do mapg^[dx,dy]:=map_generation_free
            else
              for dx:=xx2 to x2 do mapg^[dx,dy]:=map_generation_free
          end else begin
             dx:=xx1+round((xx2-xx1-2)*random)+1;
             if random>0.5 then
               for dy:=y1 to yy1 do mapg^[dx,dy]:=map_generation_free
             else
               for dy:=yy2 to y2 do mapg^[dx,dy]:=map_generation_free
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
  generate_map_makewalls(map_generation_wall);

  if map_parameter[1]=-1 then snowflakesize:=6+sqrt(random)*min_max_value/7 else snowflakesize:=map_parameter[1];
  maxsnowflakes:=8;
  if snowflakesize<8 then maxsnowflakes:=1 else
  if snowflakesize<13 then maxsnowflakes:=3 else
  if snowflakesize<19 then maxsnowflakes:=5;
  if random>0.5+0.4*(max_max_value/maxmaxx) then snowflakes:=round(random*maxsnowflakes)+3 else snowflakes:=0;
  phase_x:=-(random) * snowflakesize;
  phase_y:=-(random) * snowflakesize;
  if map_parameter[2]>=0 then snowflakes:=round(map_parameter[2]);

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
        safemapwrite(round(cx+r*sin(angle+i/s*2*Pi)),round(cy+r*cos(angle+i/s*2*Pi)),map_generation_free);
        safemapwrite(round(cx+r*sin(angle+i/s*2*Pi)),round(cy-1+r*cos(angle+i/s*2*Pi)),map_generation_free);
        safemapwrite(round(cx-1+r*sin(angle+i/s*2*Pi)),round(cy+r*cos(angle+i/s*2*Pi)),map_generation_free);
        safemapwrite(round(cx-1+r*sin(angle+i/s*2*Pi)),round(cy-1+r*cos(angle+i/s*2*Pi)),map_generation_free);
{        if snowflakesize>12 then safemapwrite(round(cx-1+r*sin(angle+i/s*2*Pi)),round(cy-1+r*cos(angle+i/s*2*Pi)),map_generation_free);
        if snowflakesize>20 then safemapwrite(round(cx+1+r*sin(angle+i/s*2*Pi)),round(cy-1+r*cos(angle+i/s*2*Pi)),map_generation_free);}
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
  generate_map_makewalls(map_generation_wall);
  if map_parameter[1]=-1 then areasize:=round(sqr(random)*maxx*maxy/13)+50 else areasize:=round(map_parameter[1]);
  entrance_x:=2; entrance_y:=2;//************************
  form1.memo1.lines.add('AREAS MAP * '+inttostr(areasize));
  for ix:=2 to maxx-1 do
   for iy:=2 to maxy-1 do mapg^[ix,iy]:=map_generation1; //diggable
  x1:=entrance_x;  y1:=entrance_y; //entrance
  thissize:=areasize div 2 + round(random*areasize/2) +7;
  repeat
    mapg^[x1,y1]:=map_generation2; //grow
    map_tmp^:=mapg^;
    repeat
      count:=0;
      for ix:=2 to maxx-1 do
        for iy:=2 to maxy-1 do if (mapg^[ix,iy]=map_generation1) and (random>0.5) then
          if (mapg^[ix-1,iy]=map_generation2) or (mapg^[ix+1,iy]=map_generation2) or (mapg^[ix,iy-1]=map_generation2) or (mapg^[ix,iy+1]=map_generation2) then begin
            map_tmp^[ix,iy]:=map_generation2;
            dec(thissize);
            inc(count)
          end;
      mapg^:=map_tmp^;
    until (thissize<=0) or (count=0);
    //change to idle
    for ix:=2 to maxx-1 do
      for iy:=2 to maxy-1 do if mapg^[ix,iy]=map_generation2 then mapg^[ix,iy]:=map_generation3;
    //surround by walls
     for ix:=2 to maxx-1 do
      for iy:=2 to maxy-1 do if mapg^[ix,iy]=map_generation1 then begin
          if (mapg^[ix-1,iy]=map_generation3) or (mapg^[ix+1,iy]=map_generation3) or
             (mapg^[ix,iy-1]=map_generation3) or (mapg^[ix,iy+1]=map_generation3) or
             (mapg^[ix-1,iy-1]=map_generation3) or (mapg^[ix+1,iy+1]=map_generation3) or
             (mapg^[ix+1,iy-1]=map_generation3) or (mapg^[ix-1,iy+1]=map_generation3) then
                           mapg^[ix,iy]:=map_generation4;
      end;

     count:=0;
     for ix:=2 to maxx-1 do
      for iy:=2 to maxy-1 do if mapg^[ix,iy]=map_generation1 then inc(count);
    //reset start point
    if count>0 then
    repeat
      x1:=round(random*(maxx-1))+1;
      y1:=round(random*(maxy-1))+1;
      thissize:=round(sqrt(random)*areasize)+10;
    until mapg^[x1,y1]=map_generation1;
  until count=0;
  //make doors
  mapg^[entrance_x,entrance_y]:=map_generation_free;
  repeat
    //grow the room
    firstcount:=-1;
    repeat
      count:=0;
      for ix:=2 to maxx-1 do
        for iy:=2 to maxy-1 do begin
          if (mapg^[ix,iy]=map_generation3) or (mapg^[ix,iy]=map_generation4) then begin
            if (mapg^[ix-1,iy]=map_generation_free) or (mapg^[ix+1,iy]=map_generation_free) or
               (mapg^[ix,iy-1]=map_generation_free) or (mapg^[ix,iy+1]=map_generation_free) or
               (mapg^[ix-1,iy-1]=map_generation_free) or (mapg^[ix+1,iy+1]=map_generation_free) or
               (mapg^[ix+1,iy-1]=map_generation_free) or (mapg^[ix-1,iy+1]=map_generation_free) then begin
                  inc(count);
                  if (mapg^[ix,iy]=map_generation3) then mapg^[ix,iy]:=map_generation_free
                                       else mapg^[ix,iy]:=map_generation_wall;
            end;
          end
        end;
      if firstcount=-1 then firstcount:=count
    until count=0;
    if (firstcount=0) and (random>0.001) then mapg^[x1,y1]:=map_generation_wall;
    // make door
    count:=0;
    repeat
      x1:=round(random*(maxx-3))+2;
      y1:=round(random*(maxy-3))+2;
      if mapg^[x1,y1]=map_generation_wall then begin
        mapg^[x1,y1]:=map_generation_free;
        inc(count);
      end;
    until count>=1;
    //calculate remaining rooms
    count:=0;
    for ix:=2 to maxx-1 do
      for iy:=2 to maxy-1 do if mapg^[ix,iy]=map_generation3 then inc(count);
  until count=0;
  //debug
  for ix:=2 to maxx-1 do
    for iy:=2 to maxy-1 do if mapg^[ix,iy]=map_generation4 then mapg^[ix,iy]:=map_generation_wall;
  for ix:=2 to maxx-1 do
    for iy:=2 to maxy-1 do if mapg^[ix,iy]=map_generation3 then mapg^[ix,iy]:=map_generation_free;
  dispose(map_tmp);
end;

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
    count_free,count_diggable,count_all:integer;
    stophole,flg,stopworms:boolean;
begin
  generate_map_makewalls(map_generation_wall);
  form1.memo1.lines.add('WORMHOLE MAP * no');
  entrance_x:=6; entrance_y:=6;//**************
  xx:=entrance_x; yy:=entrance_y;
  angle:=round(random*2*Pi);
  anglespeed:=0;
  thissize:=maxwormsize * random+minwormsize;
  sizespeed:=0;

  for ix:=2 to maxx-1 do
   for iy:=2 to maxy-1 do mapg^[ix,iy]:=map_generation1; //diggable

  stopworms:=false;
  repeat
    stophole:=false;
    x1:=round(xx);
    y1:=round(yy);
    for dx:=-round(thissize+wallthickness) to round(thissize+wallthickness) do
     for dy:=-round(thissize+wallthickness) to round(thissize+wallthickness) do if not stophole then
       if (x1+dx>=1) and (y1+dy>=1) and (x1+dx<=maxx) and (y1+dy<=maxy) then begin
        if (sqr(dx)+sqr(dy)<thissize) and (mapg^[x1+dx,y1+dy]<=map_generation2) then begin
          mapg^[x1+dx,y1+dy]:=map_generation_free;
        end else
        if sqr(dx)+sqr(dy)<=thissize+wallthickness then begin
          if mapg^[x1+dx,y1+dy]=map_generation1 then begin
            mapg^[x1+dx,y1+dy]:=map_generation2; //diggable wall
          end else
          if mapg^[x1+dx,y1+dy]=map_generation_wall then begin
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
         for iy:=2 to maxy-1 do if mapg^[ix,iy]=map_generation2 then mapg^[ix,iy]:=map_generation_wall;
        flg:=false;
        x1:=round(random*(maxx-2))+1;
        y1:=round(random*(maxy-2))+1;
        {if mapg^[x1,y1]=map_generation_wall then} begin
          count_free:=0;
          count_all:=0;
          count_diggable:=0;
          for dx:=-round(thissize+wallthickness) to round(thissize+wallthickness) do
           for dy:=-round(thissize+wallthickness) to round(thissize+wallthickness) do
             if (x1+dx>=1) and (y1+dy>=1) and (x1+dx<=maxx) and (y1+dy<=maxy) and ((sqr(dx)+sqr(dy)<thissize+3)) then begin
               if mapg^[x1+dx,y1+dy]=map_generation1 then inc(count_diggable) else
               if mapg^[x1+dx,y1+dy]=map_generation_free then inc(count_free);
               inc(count_all);
             end;
          if (count_diggable/count_all>0.8) and (count_free>0) and ((count_all-count_free-count_diggable)/count_all<0.1) then flg:=true;
        end;
      until (flg) or (count>maxx*maxy*5);
      if count>=maxx*maxy then stopworms:=true else begin
        for dx:=-round(thissize) to round(thissize) do
         for dy:=-round(thissize) to round(thissize) do
           if (x1+dx>=1) and (y1+dy>=1) and (x1+dx<=maxx) and (y1+dy<=maxy) and ((sqr(dx)+sqr(dy)<thissize+1)) then begin
             if mapg^[x1+dx,y1+dy]=map_generation_wall then mapg^[x1+dx,y1+dy]:=map_generation2 else
             if mapg^[x1+dx,y1+dy]=map_generation1 then mapg^[x1+dx,y1+dy]:=map_generation_free;
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
     for iy:=2 to maxy-1 do if mapg^[ix,iy]=map_generation1 then inc(count);
  until (count<0.3*maxx*maxy) or (stopworms);

  for ix:=2 to maxx-1 do
   for iy:=2 to maxy-1 do if mapg^[ix,iy]=map_generation1 then mapg^[ix,iy]:=map_generation_wall;
end;

{----------------------------------------------------------------------------------}

const maxmaxrooms=maxmaxx div 3;
procedure generate_map_untangle;
var map_seed,roomsize,thisroomsize:float;
    map_roomsn:integer;
    roomx,roomy:array[0..maxmaxrooms]of byte;
    i,j,dx,dy,length,radius:integer;
    shape:byte;
begin
  generate_map_makewalls(map_generation_wall);
  if map_parameter[1]=-1 then map_roomsn:=1+average_max_value div 7+round(average_max_value/7 * random) else map_roomsn:=round(map_parameter[1]);
  if map_parameter[2]=-1 then map_seed:=sqr(1/map_roomsn)+0.2*random else map_seed:=map_parameter[2];
  if map_roomsn>maxmaxrooms then map_roomsn:=maxmaxrooms;
  form1.memo1.lines.add('UNTANGLE MAP * '+inttostr(round(map_seed*100))+'/rooms='+inttostr(map_roomsn));
  if map_parameter[4]=-1 then begin
    if random>0.5 then roomsize:=0 else roomsize:=1+(random*min_max_value/10);
  end else
    roomsize:=map_parameter[4];
  if map_parameter[3]=-1 then shape:=trunc(random*3) else shape:=trunc(map_parameter[3]);
  if map_parameter[5]=-1 then radius:=min_max_value div 2-round(random*min_max_value/9) else radius:=round(map_parameter[5]);
  case shape of
    0:form1.memo1.lines.add('random shape');
    1:form1.memo1.lines.add('circle shape '+inttostr(radius));
    2:form1.memo1.lines.add('random circle shape '+inttostr(radius));
  end;
  roomx[0]:=2;
  roomy[0]:=2;
  for i:=1 to map_roomsn do begin
    case shape of
      0:begin roomx[i]:=round((maxx-2)*random)+2;roomy[i]:=round((maxy-2)*random)+2;  end;
      1:begin roomx[i]:=maxx div 2+round(radius*sin(2*Pi*i/map_roomsn));roomy[i]:=maxy div 2+round(radius*cos(2*Pi*i/map_roomsn));  end;
      2:begin roomx[i]:=maxx div 2+round((radius/3+2*radius/3*random)*sin(2*Pi*i/map_roomsn));roomy[i]:=maxy div 2+round((radius/3+2*radius/3*random)*cos(2*Pi*i/map_roomsn));  end;
    end;
  end;

  //create rooms
  if roomsize>0 then
  for i:=0 to map_roomsn do begin
    thisroomsize:=sqr(random)*roomsize;
    if round(thisroomsize)>0 then
    for dx:=roomx[i]-round(thisroomsize)-1 to roomx[i]+round(thisroomsize)+1 do if (dx>1) and (dx<maxx) then
     for dy:=roomy[i]-round(thisroomsize)-1 to roomy[i]+round(thisroomsize)+1 do if (dy>1) and (dy<maxy) then
      if sqr(roomx[i]-dx)+sqr(roomy[i]-dy)<=sqr(thisroomsize) then
        mapg^[dx,dy]:=map_generation_free;
  end;

  //create passages
  for i:=0 to map_roomsn-1 do
   for j:=i+1 to map_roomsn do if ((random<map_seed) or (i=0)) and ((i>0) or (j=1)) then begin
     length:=round(5*sqrt(sqr(roomx[i]-roomx[j])+sqr(roomy[i]-roomy[j])));
     if length>0 then
     for dx:=0 to length do begin
       safemapwrite(roomx[i]+round(     (roomx[j]-roomx[i])*dx/length),roomy[i]+round(    (roomy[j]-roomy[i])*dx/length),map_generation_free);
{       safemapwrite(roomx[i]+round( 0.5+(roomx[j]-roomx[i])*dx/length),roomy[i]+round(0.5+(roomy[j]-roomy[i])*dx/length),map_generation_free);
       safemapwrite(roomx[i]+round(-0.5+(roomx[j]-roomx[i])*dx/length),roomy[i]+round(0.5+(roomy[j]-roomy[i])*dx/length),map_generation_free);}
     end;
   end;

end;

{------------------------------------------------}

procedure generate_map_checkers;
var ix,iy:integer;
    map_seed1,map_seed2:float;
    checkersize:float;
    tmp:boolean;
    shiftx,shifty:float;
begin
  if map_parameter[1]=-1 then map_seed1:=(0.1+random/10) else map_seed1:=map_parameter[1];
  if map_parameter[2]=-1 then map_seed2:=1-(0.1+random/10) else map_seed2:=map_parameter[2];
  if map_parameter[3]=-1 then checkersize:=3+(sqr(sqr(random))*min_max_value/3) else checkersize:=map_parameter[3];
  form1.memo1.lines.add('CHECKERS MAP * '+inttostr(round(checkersize)));
  shiftx:=(checkersize*random);
  shifty:=(checkersize*random);
  for ix:=1 to maxx do
   for iy:=1 to maxy do begin
     if ((    odd(round((ix+shiftx) / checkersize))) and (    odd(round((iy+shifty) / checkersize)))) or
        ((not odd(round((ix+shiftx) / checkersize))) and (not odd(round((iy+shifty) / checkersize)))) then tmp:=true else tmp:=false;
     if (tmp) then begin
       if random<map_seed1 then mapg^[ix,iy]:=map_generation_free else mapg^[ix,iy]:=map_generation_wall;
     end else begin
       if random<map_seed2 then mapg^[ix,iy]:=map_generation_free else mapg^[ix,iy]:=map_generation_wall;
     end;

   end;
end;

{-------------------------------------------------------------------------------------------}

procedure create_bunker(bx,by,bsizex,bsizey:integer);
var ix,iy:integer;
begin
  for ix:=bx-3 to bx+bsizex+2 do if (ix>1) and (ix<maxx) then
    for iy:=by-3 to by+bsizey+2 do if (iy>1) and (iy<maxy) then begin
      if (((ix=bx-1) or (ix=bx+bsizex)) and (iy>=by-1) and (iy<=by+bsizey))
      or (((iy=by-1) or (iy=by+bsizey)) and (ix>=bx-1) and (ix<=bx+bsizex)) then
        map^[ix,iy]:=map_generation_wall
      else
        map^[ix,iy]:=map_generation_free
    end;

  safemapwritefinal(bx+bsizex div 2-1,by-1,map_generation_free);
  safemapwritefinal(bx+bsizex div 2,by+bsizey,map_generation_free);
  safemapwritefinal(bx-1,by+bsizey div 2-1,map_generation_free);
  safemapwritefinal(bx+bsizex,by+bsizey div 2,map_generation_free);

  safemapwritefinal(bx+bsizex div 2-1,by-3,map_generation_wall);
  safemapwritefinal(bx+bsizex div 2-2,by-3,map_generation_wall);
  safemapwritefinal(bx+bsizex div 2  ,by-3,map_generation_wall);

  safemapwritefinal(bx+bsizex div 2+1,by+bsizey+2,map_generation_wall);
  safemapwritefinal(bx+bsizex div 2-1,by+bsizey+2,map_generation_wall);
  safemapwritefinal(bx+bsizex div 2  ,by+bsizey+2,map_generation_wall);

  safemapwritefinal(bx-3,by+bsizey div 2-1,map_generation_wall);
  safemapwritefinal(bx-3,by+bsizey div 2-2,map_generation_wall);
  safemapwritefinal(bx-3,by+bsizey div 2  ,map_generation_wall);

  safemapwritefinal(bx+bsizex+2,by+bsizey div 2+1,map_generation_wall);
  safemapwritefinal(bx+bsizex+2,by+bsizey div 2-1,map_generation_wall);
  safemapwritefinal(bx+bsizex+2,by+bsizey div 2  ,map_generation_wall);

  form1.memo1.lines.add('Bunker building created.');
end;

{-----------------------------------------------------}

var     bldg_area:integer;

procedure create_box(limitsize:integer);
var x1,y1,x2,y2:integer;
    ix,iy:integer;
begin
  x1:=round(random*(maxx - 8))+1;
  x2:=x1 + round(sqr(sqr(random))*((maxx-x1)))+4;
  if x2>=maxx then x2:=maxx-1;
  if x2-x1>limitsize then x2:=x1+limitsize;
  y1:=round(random*(maxy - 8))+1;
  y2:=y1 + round(sqr(sqr(random))*((maxy-y1)))+4;
  if y2>=maxy then y2:=maxy-1;
  if y2-y1>limitsize then y2:=y1+limitsize;
  for ix:=x1 to x2 do
   for iy:=y1 to y2 do safemapwritefinal(ix,iy,map_generation_free);
  for ix:=x1+1 to x2-1 do
   for iy:=y1+1 to y2-1 do safemapwritefinal(ix,iy,map_generation_wall);
  for ix:=x1+2 to x2-2 do
   for iy:=y1+2 to y2-2 do safemapwritefinal(ix,iy,map_generation_free);
  if random>0.5 then begin
    if random>0.5 then x1:=x1+1 else x1:=x2-1;
    safemapwritefinal(x1,y1+round(random*(y2-y1-4))+2,map_generation_free);
  end else begin
    if random>0.5 then y1:=y1+1 else y1:=y2-1;
    safemapwritefinal(x1+round(random*(x2-x1-4))+2,y1,map_generation_free);
  end;
  inc(bldg_area,(x2-x1+1)*(y2-y1+1));

  form1.memo1.lines.add('Box building created.');
end;

{----------------------------------------------------------------}

const box_probability=0.3;
//      bunker_probabioity=0.4;
      bldg_probability=0.5;
procedure generate_map_buildings;
var f1:file of byte;
    ix,iy,jx,jy,tmp:integer;
    x1,y1:integer;
    bldgx,bldgy:byte;
    tmpmap,tmprnd:array[1..maxbldgx,1..maxbldgy] of byte;
    s1:string;
    value:byte;
    flg:boolean;
    seed1,seed2,seed3:float;

    map_seed:float;
begin
 if (form1.checkbox6.checked) then begin
   if map_parameter[0]=-1 then map_seed:=random*0.3 else map_seed:=map_parameter[0];
   bldg_area:=0;

   if (random<box_probability) then
     repeat create_box(min_max_value div 3) until random>box_probability;
{   if (random<bunker_probability) then
     repeat create_bunker(round(random*(maxx-8)),round(random*(maxy-8)),round(random*4)+1,round(random*4)+1) until random>bunker_probability;}

  for ix:=1 to maxx do
   for iy:=1 to maxy do vis^[ix,iy]:=0;

  if {(random<bldg_probability) and} (nbuildings>0) then
    repeat
      begin
      // memo1.lines.add(filename);
       s1:=mapbuildings[1+round(random*(nbuildings-1))];
       Assignfile(f1,ExtractFilePath(application.ExeName)+datafolder+'BLDG'+pathdelim+s1);
       Reset(f1);

       Read(f1,bldgx);
       Read(f1,bldgy);
//       form1.memo1.lines.add(inttostr(bldgx)+' x '+inttostr(bldgy) + ' / ' + inttostr(min_max_value));
       if (min_max_value>bldgx+2) and (min_max_value>bldgy+2) then begin
         seed1:=random;
         seed2:=random;
         seed3:=random;

         for ix:=1 to bldgx do
          for iy:=1 to bldgy do Read(f1,tmpmap[ix,iy]);
         for ix:=1 to bldgx do
          for iy:=1 to bldgy do Read(f1,tmprnd[ix,iy]);

         value:=0;
         repeat
           inc(value);
           x1:=round(random*(maxx-bldgx-4)+2);
           y1:=round(random*(maxy-bldgy-4)+2);
           flg:=true;
           for ix:=x1 to x1+bldgx do
            for iy:=y1 to y1+bldgy do if vis^[ix,iy]>0 then flg:=false;
         until (flg) or (value>50);

         if flg then begin
           form1.memo1.lines.add('Adding building '+s1);
           for ix:=1 to bldgx do
            for iy:=1 to bldgy do if tmpmap[ix,iy]>0 then begin
              if seed1<0.5 then jx:=ix else jx:=bldgx-ix+1;
              if seed2<0.5 then jy:=iy else jy:=bldgy-iy+1;
              if seed3<0.5 then begin
                tmp:=jy;
                jy:=jx;
                jx:=tmp;
             end;
             jx:=jx+x1-1;
             jy:=jy+y1-1;
             if random<tmprnd[ix,iy]/randomaccuracy then map^[jx,jy]:=map_generation_wall else map^[jx,jy]:=map_generation_free;
             vis^[jx,jy]:=1;
         end;
       end;
      // Read(f1,0);  //entrance_x
      // Read(f1,0);  //entrance_y
       end;
       closefile(f1);
      end;
    until (bldg_area<(maxx-2)*(maxy-2)*map_seed) or (random<0.01);
 end;
end;

{----------------------------------------------------------------}

const enter_x=2;
      enter_y=2;

const homogenity_x=3;
      homogenity_y=3;
function test_map(free_from,free_to:byte):boolean;
var ix,iy,dx,dy:integer;
    nerrors,nfree:integer;
    all_count,free_count:integer;
    deviation:float;
    thismapfloor,thismapwall:byte;
begin
 map^:=mapg^;

 generate_map_buildings;
 create_bunker(enter_x,enter_y,4,4);

 //entrance
 for ix:=enter_x to enter_x+3 do
   for iy:=enter_y to enter_y+3 do map^[ix,iy]:=map_free;

if random_tiles then
repeat
 case trunc(random*4) of
   0:thismapfloor:=0;
   1:thismapfloor:=1;
   2:thismapfloor:=2;
   3:thismapfloor:=3;
 end;
 case trunc(random*4) of
   0:thismapwall:=0;
   1:thismapwall:=1;
   2:thismapwall:=2;
   3:thismapwall:=3;
 end;
until thismapfloor<>thismapwall;

 repeat
  nfree:=0;
  for ix:=2 to maxx-1 do
   for iy:= 2 to maxy-1 do begin
     map_status^[ix,iy]:=0;
     if map^[ix,iy]>=map_generation_free then
     for dx:=-1 to 1 do
       for dy:=-1 to 1 do
         if map^[ix+dx,iy+dy]<map_wall then begin
           if random_tiles then map^[ix,iy]:=map_free+thismapfloor else begin
             if map^[ix,iy]>=map_generation_free then map^[ix,iy]:=map_free+(map^[ix,iy]-map_generation_free);
           end;
           nfree:=1;
         end;

   end;
 until nfree=0;

  nerrors:=0;
  for ix:=1 to maxx do
   for iy:= 1 to maxy do if map^[ix,iy]>=map_generation_free then begin map^[ix,iy]:=map_generation_wall; inc(nerrors); end;

  nfree:=0;
  for ix:=1 to maxx do
   for iy:= 1 to maxy do begin
     if map^[ix,iy]<map_wall then inc(nfree);
     if map^[ix,iy]>=map_generation_wall then begin
       if random_tiles then map^[ix,iy]:=map_wall+thismapwall else map^[ix,iy]:=map_wall+(map^[ix,iy]-map_generation_wall);
       map_status^[ix,iy]:=maxstatus-round(random*4);
     end;
   end;



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
       if map^[dx,dy]<map_wall then inc(free_count);
       inc(all_count);
     end;
     deviation:=deviation+sqr((free_count/all_count)/(nfree/maxx/maxy)-1);
  end;
 mapinhomogenity:=sqrt(deviation)/(homogenity_x*homogenity_y);
 form1.memo1.lines.add('Map inhomogenity: '+inttostr(round(mapinhomogenity*100))+'%');
 form1.memo1.lines.add('...');

if (nfree/maxx/maxy>free_from/100) and (nfree/maxx/maxy<free_to/100) and (mapinhomogenity<0.15) then test_map:=true else test_map:=false; {(nerrors/maxx/maxy<0.2) and (nerrors<nfree/3) and}
end;

{--------------------------------------------------------------------------------------}

function createbot(owner:integer;name:string;maxhp,x,y:integer):boolean;
var i,j,weaponhp:integer;
    flg:boolean;
    weapon_kind,weapon_type{,ammo_kind},ammo_type:integer;
    ammo_usable:boolean;
begin
  inc(nbot);
  bot[nbot].name:=name;
  bot[nbot].MAXHP:=maxhp;
  bot[nbot].HP:=bot[nbot].MAXHP;
  bot[nbot].x:=x;
  bot[nbot].y:=y;

  bot[nbot].lastseen_x:=x;
  bot[nbot].lastseen_y:=y;
  bot[nbot].lastseen_tu:=255;

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
    weapon_kind:=1;
    if bot[nbot].owner<>player then begin
      if random<0.3 then weapon_kind:=2;
      if random<0.05 then weapon_kind:=3;
      bot[nbot].caution:=round(sqr(random)*50);
      bot[nbot].bottype:=2;
      if random<0.1 then begin
        bot[nbot].bottype:=3;
        bot[nbot].maxhp:=bot[nbot].maxhp*2;
        bot[nbot].hp:=bot[nbot].maxhp;
        bot[nbot].caution:=0;
        bot[nbot].name:=name+'(H)';
      end else
      if random<0.1 then begin
        bot[nbot].bottype:=4;
        bot[nbot].maxhp:=bot[nbot].maxhp div 2;
        bot[nbot].hp:=bot[nbot].maxhp;
        bot[nbot].speed:=20;
        bot[nbot].caution:=50+round(sqrt(random)*50);
        bot[nbot].name:=name+'(Q)';
      end;

    end else begin
      bot[nbot].bottype:=1;
    end;
    if form1.checkbox3.checked then weapon_kind:=3;
    repeat
      weapon_type:=trunc(w_types*random)+1;
    until (random*100<WEAPON_SPECIFICATIONS[weapon_type].rnd) and (WEAPON_SPECIFICATIONS[weapon_type].kind=weapon_kind);
    bot[nbot].items[i].w_id:=weapon_type;

    bot[nbot].items[i].maxstate:=weapon_specifications[bot[nbot].items[i].w_id].maxstate-round(0.1*weapon_specifications[bot[nbot].items[i].w_id].maxstate*random);
    bot[nbot].items[i].state:=round((bot[nbot].items[i].maxstate-0.2*bot[nbot].items[i].maxstate*random)*(11/(i+10)));
    bot[nbot].items[i].rechargestate:=0;
    inc(weaponhp,bot[nbot].items[i].state);

    repeat
      ammo_type:=trunc(a_types*random)+1;
      ammo_usable:=false;
      for j:=1 to maxusableammo do if WEAPON_SPECIFICATIONS[weapon_type].AMMO[j]=ammo_type then ammo_usable:=true;
      if (AMMO_SPECIFICATIONS[ammo_type].kind<>1) and (bot[nbot].owner=player) and (not form1.checkbox3.checked) then ammo_usable:=false;
    until (random*100<AMMO_SPECIFICATIONS[ammo_type].rnd) and (ammo_usable) {and (WEAPON_SPECIFICATIONS[weapon_type].kind=weapon_kind)};
    bot[nbot].items[i].ammo_id:=ammo_type;
    bot[nbot].items[i].n:=ammo_specifications[bot[nbot].items[i].ammo_id].quantity;
  until (bot[nbot].HP*itemdamagerate<weaponhp) or (i=backpacksize) or (bot[nbot].owner=player);

  if map^[bot[nbot].x,bot[nbot].y]<map_wall then flg:=true else flg:=false;
  if (flg) and (nbot>1) then
    for i:=1 to nbot-1 do if (bot[i].hp>0) and (bot[nbot].x=bot[i].x) and (bot[nbot].y=bot[i].y) then flg:=false;
  if not flg then dec(nbot);
  createbot:=flg;
end;

{-----------------------------------------------------------------------------------------------}

procedure generate_LOS_base_map{(all:boolean;los_x,los_y:integer)};
var ix,iy,dx,dy,count:integer;
    tmp_bar:integer;
begin
  regenerate_los:=false;
  form1.memo1.lines.add('Generating LOS base map...');
  form1.set_progressbar(true);
  tmp_bar:= form1.progressbar1.max;
  form1.progressbar1.max:=maxx;


  for ix:=1 to maxx do begin
    for iy:=1 to maxy do if (LOS_base^[ix,iy]=255) and (map^[ix,iy]<map_wall) then begin
      count:=0;
      for dx:=ix-visiblerange to ix+visiblerange do
        for dy:=iy-visiblerange to iy+visiblerange do
          if (dx>0) and (dy>0) and (dx<=maxx) and (dy<=maxy) then
           if map^[dx,dy]<map_wall then
            if (check_LOS(ix,iy,dx,dy,false)>0) then inc(count);
      if count>1 then dec(count);
      if count<254 then LOS_base^[ix,iy]:=count else LOS_base^[ix,iy]:=254;

    end else LOS_base^[ix,iy]:=254;
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

  form1.progressbar1.max:=tmp_bar;
  if this_turn=player then form1.set_progressbar(false);
  //dispose(tmp_map);
end;

{--------------------------------------------------------------------------------------}

function calculate_difficulty(players,playershp,enemies,enemieshp,maaxx,maaxy,mapfreex:integer):integer;
var estimated_firepower:float;
    difficultybonus:integer;
    LOS_adjusted:float;
begin
  LOS_adjusted:=group_attack_range*Pi*mapfreex/((maaxx-2)*(maaxy-2));
  if averageLOS>LOS_adjusted then LOS_adjusted:=averageLOS;

  if form1.checkbox1.checked then difficultybonus:=defensedifficulty else difficultybonus:=1;
  estimated_botstogether:=enemies*LOS_adjusted/mapfreex;
  if estimated_botstogether<1 then estimated_botstogether:=1;
  estimated_firepower:=estimated_botstogether/players;
  estimated_firepower:=estimated_firepower*(1+enemies*0.25*5*standard_damage/playershp); {random damage}
  estimated_firepower:=estimated_firepower*(1+5*standard_damage*(estimated_botstogether*enemieshp/enemies/(players*standard_damage*5))/playershp); {persistent damage}
  calculate_difficulty:=round(100 * enemieshp/playershp * difficultybonus * estimated_firepower);
end;

function saydifficulty(difficulty:integer):string;
var winchance:integer;
begin
  case difficulty of
      0.. 75:saydifficulty:='EASY'+' ('+inttostr(difficulty)+'%)';
     76..150:saydifficulty:='NORMAL'+' ('+inttostr(difficulty)+'%)';
    151..225:saydifficulty:='HARD'+' ('+inttostr(difficulty)+'%)';
    226..320:saydifficulty:='VERY HARD'+' ('+inttostr(difficulty)+'%)';
    ELSE   saydifficulty:='INSANE?'+' ('+inttostr(difficulty)+'%)'
  end;
  winchance:=round(100*exp(-0.0135446*(difficulty-100)));
  if winchance>100 then winchance:=100;
  saydifficulty:=saydifficulty + ' chance to win is '+inttostr(winchance)+'%';
end;

{-------------------------------------------------------------------}

Procedure Tform1.read_buildings;
var Path:string;
    Rec : TSearchRec;
begin
    nbuildings:=0;
    Path:=ExtractFilePath(application.ExeName)+datafolder+'BLDG'+pathdelim;
    if FindFirst (Path + '*.HMP', faAnyFile - faDirectory, Rec) = 0 then begin
      try
      repeat
        inc(nbuildings);
        mapbuildings[nbuildings]:=Rec.Name;
//        memo2.lines.add(mapbuildings[nbuildings]);
      until FindNext(Rec) <> 0;
      finally
        FindClose(Rec) ;
      end;
    end;
end;

{--------------------------------------------------------------------------------------}

procedure TForm1.generate_map;
var ix,iy,i_bot,j:integer;
    x1,y1,count:integer;
    map_type:byte;
    generatedbots:integer;
    bot_hp_const,player_hp_const:integer;
    total_bot_hp,total_player_hp{,total_bot_firepower,total_player_firepower}:integer;
//    estimated_firepower:float;
    i_flag,flg:boolean;
    estimated_difficulty,needed_difficulty:integer;
    weapon_kind,ammo_type,weapon_type:integer;
    ammo_usable:boolean;
begin
  map_parameter[0]:=-1;
  map_parameter[1]:=-1;
  map_parameter[2]:=-1;
  map_parameter[3]:=-1;
  map_parameter[4]:=-1;
  map_parameter[5]:=-1;
  map_parameter[6]:=-1;
  map_parameter[7]:=-1;
  map_parameter[8]:=-1;
  new(mapg);

  randomize;

  val(edit2.text,maxx,ix);
  if maxx<minmaxx then maxx:=minmaxx;
  if maxx>maxmaxx then maxx:=maxmaxx;
  if (maxx>maxmaxx div 2) and (maxx<maxmaxx) then begin
    if maxx<3*maxmaxx div 4 then maxx:=maxmaxx div 2 else maxx:=maxmaxx;
  end;
  edit2.text:=inttostr(maxx);
  val(edit7.text,maxy,ix);
  if maxy<minmaxy then maxy:=minmaxy;
  if maxy>maxmaxy then maxy:=maxmaxy;
  if (maxy>maxmaxy div 2) and (maxy<maxmaxy) then begin
    if maxy<3*maxmaxy div 4 then maxy:=maxmaxy div 2 else maxy:=maxmaxy;
  end;
  edit7.text:=inttostr(maxy);

  if maxx>maxy then begin max_max_value:=maxx; min_max_value:=maxy; end else
                    begin max_max_value:=maxy; min_max_value:=maxx; end;
  average_max_value:=(maxx+maxy) div 2;

  if min_max_value>trackbar1.max then trackbar1.max:=maxzoom;
  if min_max_value<trackbar1.max then trackbar1.max:=min_max_value;
  if (viewsizex>min_max_value) or (viewsizey>min_max_value) then begin
    viewsizex:=min_max_value;
    viewsizey:=min_max_value;
    trackbar1.position:=min_max_value;
  end;

  memo1.lines.add('Generating map...');
  memo1.lines.add('Map size: '+inttostr(maxx)+'x'+inttostr(maxy));

  random_tiles:=true;
  if combobox1.itemIndex<1 then map_type:=trunc(random*20)+1 else map_type:=combobox1.ItemIndex;
// repeat
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
        4: if random>0.6 then
             repeat generate_map_diamonds       until test_map(20,70)
           else
             repeat generate_map_checkers           until test_map(20,70);
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
       15: if random<1/5 then
             repeat generate_map_smallrooms     until test_map(20,70)
           else if random<1/4 then
             repeat generate_map_Imap           until test_map(20,70)
           else if random<1/3 then
             repeat generate_map_four           until test_map(20,70)
           else if random<1/2 then
             repeat generate_map_five           until test_map(20,70)
           else
             repeat generate_map_dash          until test_map(20,70);
       16: if random>0.5 then
             repeat generate_map_untangle       until test_map(30,60)
           else
             repeat generate_map_rotor          until test_map(20,70);
       17:   repeat generate_map_eggre          until test_map(20,70);
       18:   repeat generate_map_snowflake      until test_map(20,70);
       19:   repeat generate_map_areas          until test_map(20,90);
       20:   repeat generate_map_wormhole       until test_map(20,90);
  end;
// until mapinhomogenity<0.15;

 dispose(mapg);

 for ix:=1 to maxx do
   for iy:= 1 to maxy do begin
      vis^[ix,iy]:=0;
      mapchanged^[ix,iy]:=255;
   end;

  if (form1.radiobutton3.checked) or ((form1.radiobutton2.checked) and (random>0.8)) then begin
    memo1.lines.add('Generating smoke...');
    for ix:=maxx div 5+2 to maxx do
     for iy:=maxy div 5+2 to maxy do if map^[ix,iy]<map_wall then map_status^[ix,iy]:=round(map_smoke*sqrt(random)); //tile
    for ix:=1 to 10 do grow_smoke;
  end;


  memo1.lines.add('Calculating map strategy...');

  for ix:=1 to maxx do
   for iy:=1 to maxy do LOS_base^[ix,iy]:=255;
  generate_LOS_base_map{(true,1,1)};
  memo1.lines.add('Average LOS = '+inttostr(round(averageLOS)));
  if averageLOS<group_attack_range*Pi*mapfreespace/(maxx*maxy) then
    form1.memo1.lines.add('LOS adjusted = '+inttostr(round(group_attack_range*Pi*mapfreespace/(maxx*maxy))));

  memo1.lines.add('Map ready. Setting bots.');

  itemsn:=0;
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
  val(edit6.text,needed_difficulty,ix);

  total_bot_hp:=0;
  total_player_hp:=0;
//  total_bot_firepower:=0;
//  total_player_firepower:=0;

  x1:=5;           //**bunker size!!!
  y1:=5;
  iy:=round(sqrt(playersn))-1;
  for ix:=1 to playersn do begin
    createbot(player,'player'+inttostr(ix),player_hp_const,x1+enter_x-2,y1+enter_y-2);
    dec(x1);
    if x1<5-iy then begin
      dec(y1);
      x1:=5;
    end;
    if bot[nbot].hp>15 then inc(total_player_hp,bot[nbot].hp) else inc(total_player_hp,15);
    bot[nbot].bottype:=1;
//      inc(total_player_firepower,standard_damage);
  end;
  //  bot[1].items[1].w_id:=4;
  //  bot[1].items[1].ammo_id:=6;

  val(edit1.text,generatedbots,ix);
  inc(generatedbots,playersn);
  if generatedbots<playersn+1 then generatedbots:=playersn+1;
  if generatedbots>maxbots then generatedbots:=maxbots;
  edit1.text:=inttostr(generatedbots-playersn);

  memo1.lines.add('...');

  i_bot:=playersn;
  repeat
    inc(i_bot);
    count:=0;
    repeat
      inc(count);
      x1:=round(random*(maxx-3)+2);
      y1:=round(random*(maxy-3)+2);
      flg:=true;
      for ix:=1 to playersn do begin
        if (check_LOS(x1,y1,bot[ix].x,bot[ix].y,true)>0) and (random<0.99) then flg:=false;
        if (sqr(x1-bot[ix].x)+sqr(y1-bot[ix].y)<sqr(visiblerange/3)) and
           (sqr(x1-bot[ix].x)+sqr(y1-bot[ix].y)<sqr(maxx/4)) and (random<0.95) then flg:=false
      end;
    until (((flg) or (random>0.999)) and createbot(computer,'d'+inttostr(round(random*999)),{round(random*30)+}bot_hp_const,x1,y1)) or (count>10000);
    if checkbox1.checked then bot[nbot].action:=action_attack else bot[nbot].action:=action_random;
    bot[nbot].target:=round(random*(playersn-1))+1;

    if bot[nbot].hp>15 then inc(total_bot_hp,bot[nbot].hp) else inc(total_bot_hp,15);
    //inc(total_bot_firepower,standard_damage);

    estimated_difficulty:=calculate_difficulty(playersn,total_player_hp,nbot-playersn,total_bot_hp,maxx,maxy,mapfreespace);
    if checkbox5.checked then
      i_flag:=estimated_difficulty>=needed_difficulty
    else
      i_flag:=nbot>=generatedbots;

  until (i_flag) or (nbot>maxbots) or (nbot>=mapfreespace);

  memo1.lines.add('Player units = '+inttostr(playersn));
  memo1.lines.add('Total Player HP = '+inttostr(total_player_hp));
  memo1.lines.add('Enemy bots = '+inttostr(nbot-playersn));
  memo1.lines.add('Total bot HP = '+inttostr(total_bot_hp{ div (nbot-playersn)}));
  memo1.lines.add('Bots together = '+floattostr(round(estimated_botstogether*10)/10));

  memo1.lines.add('True difficulty = '+saydifficulty(estimated_difficulty));

  //generate ground items
  memo1.lines.add('Creating items...');
  iy:=0;
  for ix:=1 to nbot do {if bot[ix].owner=computer then} begin
    inc(iy,bot[ix].hp);
  end;
  count:=0;
  While ((iy>(itemsn*10+nbot*20)*10) or (random<0.9) or (count<sqrt(maxx*maxy)/4)) and (itemsn<maxitems) do begin
      inc(count);
      inc(itemsn);
      repeat
        x1:=round(random*(maxx-2)+1);
        y1:=round(random*(maxy-2)+1);
      until (map^[x1,y1]<map_wall);
      item[itemsn].x:=x1;
      item[itemsn].y:=y1;
      item[itemsn].item.w_id:=0;
      weapon_type:=0;
      if (random<iy*itemdamagerate*2/((itemsn*10+nbot*20)*10)) or (random<0.1) then begin
        weapon_kind:=1;
        if random<0.10 then weapon_kind:=2;
        if random<0.08 then weapon_kind:=3;
        if checkbox3.checked then weapon_kind:=3;
        repeat
          weapon_type:=trunc(w_types*random)+1;
        until (random*100<WEAPON_SPECIFICATIONS[weapon_type].rnd) and (WEAPON_SPECIFICATIONS[weapon_type].kind=weapon_kind);
        item[itemsn].item.w_id:=weapon_type;

        item[itemsn].item.maxstate:=round((weapon_specifications[item[itemsn].item.w_id].maxstate*3/4)*random+weapon_specifications[item[itemsn].item.w_id].maxstate/4);
        item[itemsn].item.state:=round(item[itemsn].item.maxstate*random);
        item[itemsn].item.rechargestate:=0;
      end;

      repeat
        ammo_type:=trunc(a_types*random)+1;
        if weapon_type=0 then ammo_usable:=true else begin
          ammo_usable:=false;
          for j:=1 to maxusableammo do if WEAPON_SPECIFICATIONS[weapon_type].AMMO[j]=ammo_type then ammo_usable:=true;
        end;
      until (random*100<AMMO_SPECIFICATIONS[ammo_type].rnd) and (ammo_usable) {and (WEAPON_SPECIFICATIONS[weapon_type].kind=weapon_kind)};
      item[itemsn].item.ammo_id:=ammo_type;
      item[itemsn].item.n:=round((ammo_specifications[item[itemsn].item.ammo_id].quantity-1)*random)+1;
  end;

  memo2.lines:=memo1.lines;

  memo1.lines.add('...');

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

  if checkbox4.checked then begin
    memo1.lines.add('Tutorial mode on');

  end;


  current_turn:=0;
  start_turn;

//  map_changed:=true;
end;

{--------------------------------------------------------------------------------------}

function valueof(s:string):integer;
var v1,v2:integer;
begin
  val(s,v1,v2);
  if v2<>0 then showmessage('Script error: unable to process number.');
  valueof:=v1;
end;

procedure TForm1.generate_items_types;
var i:integer;
    s:string;
    f1:Textfile;
begin
 assignfile(f1,ExtractFilePath(application.ExeName)+scriptfolder+'weapon.inf');
 reset(f1);
 w_types:=0;
 repeat
   readln(f1,s);
   if trim(s)='<WEAPON>' then begin
     inc(w_types);
     if w_types>255 then begin
       w_types:=255;
       showmessage('weapon.ini error: No more than 255 weapon/item types allowed!');
     end;
     with weapon_specifications[w_types] do begin
       for i:=1 to maxusableammo do AMMO[i]:=0;
       NAME        := 'no name';
       ACC         :=   0;
       DAM         :=   0;
       RECHARGE    :=   0;
       AIM         :=   0;
       RELOAD      :=   0;
       MAXSTATE    :=   0;
       Description := '';
       KIND        :=   0;
       RND         :=   0;

       i:=0;
       repeat
         readln(f1,s);
         s:=trim(s);
         if copy(s,1,5)='NAME=' then NAME:=trim(copy(s,6,99)) else
         if copy(s,1,4)='ACC=' then ACC:=valueof(copy(s,5,99)) else
         if copy(s,1,4)='DAM=' then DAM:=valueof(copy(s,5,99)) else
         if copy(s,1,9)='RECHARGE=' then RECHARGE:=valueof(copy(s,10,99)) else
         if copy(s,1,4)='AIM=' then AIM:=valueof(copy(s,5,99)) else
         if copy(s,1,7)='RELOAD=' then RELOAD:=valueof(copy(s,8,99)) else
         if copy(s,1,9)='MAXSTATE=' then MAXSTATE:=valueof(copy(s,10,99)) else
         if copy(s,1, 5)='KIND=' then KIND:=valueof(copy(s,6,99)) else
         if copy(s,1, 4)='RND=' then RND:=valueof(copy(s,5,99)) else
         if copy(s,1,12)='DESCRIPTION=' then description:=trim(copy(s,13,999)) else
         if copy(s,1,5)='AMMO=' then begin
           inc(i);
           if i>maxusableammo then begin
             showmessage('weapon.ini error: max usable ammo types = '+inttostr(maxusableammo));
             i:=maxusableammo;
           end;
           AMMO[i]:=valueof(copy(s,6,99))
         end;
       until (s='</WEAPON>') or (eof(f1));
     end;
   end;
 until eof(f1);
 closefile(f1);

 assignfile(f1,ExtractFilePath(application.ExeName)+scriptfolder+'ammo.inf');
 reset(f1);
 a_types:=0;
 repeat
   readln(f1,s);
   if trim(s)='<AMMO>' then begin
     inc(a_types);
     if a_types>255 then begin
       a_types:=255;
       showmessage('ammo.ini error: No more than 255 ammo types allowed!');
     end;
     with ammo_specifications[a_types] do begin
       NAME        := 'no name';
       ACC         :=  0;
       DAM         :=  0;
       QUANTITY    :=  0;
       EXPLOSION   :=  0;
       AREA        :=  0;
       SMOKE       :=  0;
       Description := '';
       KIND        :=  0;
       RND         :=  0;

       repeat
         readln(f1,s);
         s:=trim(s);
         if copy(s,1, 5)='NAME=' then NAME:=trim(copy(s,6,99)) else
         if copy(s,1, 4)='ACC=' then ACC:=valueof(copy(s,5,99)) else
         if copy(s,1, 4)='DAM=' then DAM:=valueof(copy(s,5,99)) else
         if copy(s,1, 9)='QUANTITY=' then QUANTITY:=valueof(copy(s,10,99)) else
         if copy(s,1,10)='EXPLOSION=' then EXPLOSION:=valueof(copy(s,11,99)) else
         if copy(s,1, 5)='AREA=' then AREA:=valueof(copy(s,6,99)) else
         if copy(s,1, 5)='AREA=' then AREA:=valueof(copy(s,6,99)) else
         if copy(s,1, 5)='KIND=' then KIND:=valueof(copy(s,6,99)) else
         if copy(s,1, 4)='RND=' then RND:=valueof(copy(s,5,99)) else
         if copy(s,1,12)='DESCRIPTION=' then description:=trim(copy(s,13,999)) else
         if copy(s,1, 6)='SMOKE=' then SMOKE:=valueof(copy(s,7,99));
       until (s='</AMMO>') or (eof(f1));
     end;
   end;
 until eof(f1);
 closefile(f1);
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
  label11.caption:='(1..'+inttostr(maxbots-maxplayers)+')';
  edit1.text:=inttostr(37);
  label12.caption:='(1..'+inttostr(maxplayers)+')';
  edit5.text:=inttostr(4);

  new(map);
  new(map_status);
  new(vis);
  new(mapchanged);
  new(movement);
  new(distance);
  new(LOS_base);
  new(botvis);
  gamemode:=gamemode_none;
  form1.DoubleBuffered:=true;
  generate_items_types;

  read_buildings;

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
    smk:integer;
begin
  if bot[thisbot].items[1].state>round(dam*itemdamagerate) then dec(bot[thisbot].items[1].state,round(dam*itemdamagerate)) else bot[thisbot].items[1].state:=0;
  bot[thisbot].action:=action_attack;
  if bot[thisbot].hp>dam then dec(bot[thisbot].hp,dam) else begin
   bot[thisbot].hp:=0;

   smk:=map_status^[bot[thisbot].x,bot[thisbot].y] + die_smoke;
   if smk>map_smoke then smk:=map_smoke;
   map_status^[bot[thisbot].x,bot[thisbot].y]:=smk;

   form1.memo1.lines.add(bot[thisbot].name + ' is destroyed');
   if thisbot=selected then begin
     form1.scrollbar1.position:=0; form1.scrollbar2.position:=0;
     selected:=-1;
   end;
   if thisbot=selectedenemy then begin
     selectedenemy:=-1;
     form1.generate_enemy_list(true);
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

const maxblast=50;
      maxgeneration=50;           //no greater than 60!!!
type blastarea=array[-maxblast..maxblast,-maxblast..maxblast] of shortint;
procedure Tform1.calculate_area(ax,ay,a,asmoke,ablast:integer);
var ix,iy,dx,dy,ddx,ddy,count,generation,i,j:integer;
    flg,flg_x:boolean;
    direction_x,direction_y:^blastarea;
    mytimer:tdate;
    x2,y2:integer;
var area:^blastarea;
    generationsum:float;
//    regeneratelos:boolean;
    smk:integer;
    //tmp_area:^blastarea;
begin
  new(area);
  new(direction_x);
  new(direction_y);

  for dx:=-maxblast to maxblast do
   for dy:=-maxblast to maxblast do begin
     if (ax+dx>1) and (ax+dx<maxx) and (ay+dy>1) and (ay+dy<maxy) then begin
       if map^[ax+dx,ay+dy]<map_wall then area^[dx,dy]:=127 else area^[dx,dy]:=126;
     end else
       area^[dx,dy]:=125;
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
    for iy:=-generation to generation do if abs(iy)<maxblast then begin
     if area^[ix,iy]=127 then begin
        for dx:=-1 to 1 do
         for dy:=-1 to 1 do if {tmp_}area^[ix+dx,iy+dy]<generation then begin
           area^[ix,iy]:=generation;
           inc(direction_x^[ix,iy],dx);
           inc(direction_y^[ix,iy],dy);
         end;
        if area^[ix,iy]=generation then inc(count);
      end else if area^[ix,iy]=126 then begin
        for dx:=-1 to 1 do
         for dy:=-1 to 1 do if area^[ix+dx,iy+dy]<generation then
           area^[ix,iy]:=generation+60;
      end;
    end;
   //walls

  until (count>=a) or (generation>=maxgeneration);
  //dispose(tmp_area);

  generationsum:=0;
  if generation>maxblast then generation:=maxblast;

  for ix:=-generation to generation do
   for iy:=-generation to generation do if area^[ix,iy]<=maxgeneration then
     generationsum:=generationsum+1/sqrt(area^[ix,iy]);

  //draw explosion
  for dx:=-generation to generation do
   for dy:=-generation to generation do if (ax+dx>1) and (ax+dx<maxx) and (ay+dy>1) and (ay+dy<maxy) and (area^[dx,dy]<=maxgeneration) then
    if vis^[ax+dx,ay+dy]>=oldvisible then
     with image1.canvas do begin
       //mapchanged^[ax+dx,ay+dy]:=0;
       //brush.style:=bsclear;
       x2:=round((dx+ax-viewx-0.5)*image1.width / viewsizex);
       y2:=round((dy+ay-viewy-0.5)*image1.height / viewsizey);
       pen.color:=RGB(255,255,180,0);
       ix:=round(sqr((ablast/10/generationsum)/sqrt(area^[dx,dy])))+5;
       if ix>(image1.width / viewsizex-2) then  pen.width:=round((image1.width / viewsizex-1))
         else pen.width:=ix;
       moveto(x2,y2);
       lineto(x2,y2);
     end;
//  image1.update;
  mytimer:=now;
  repeat  image1.update; until (now-mytimer)*24*60*60*1000>blastdelay;
{  draw_map;                                     }

   //damage tagets //make smoke // destroy walls
//   regenerate_los:=false;
   for dx:=-generation to generation do
     for dy:=-generation to generation do
       if (ax+dx>1) and (ax+dx<maxx) and (ay+dy>1) and (ay+dy<maxy) and (area^[dx,dy]<125) then begin
         if map^[ax+dx,ay+dy]<map_wall then begin
           ix:=round((asmoke/generationsum)/sqrt(area^[dx,dy]));
           if ix<1 then ix:=1;

           smk:=map_status^[ax+dx,ay+dy] + ix;
           if smk>map_smoke then smk:=map_smoke;
           map_status^[ax+dx,ay+dy]:=smk;

           mapchanged^[ax+dx,ay+dy]:=255;

           for i:=1 to nbot do if (bot[i].x=ax+dx) and (bot[i].y=ay+dy) and (bot[i].hp>0) then begin
             ix:=round((ablast/generationsum)/sqrt(area^[dx,dy]));
             if ix<1 then ix:=1;
             memo1.lines.add(bot[i].name+' is hit for '+inttostr(ix)+' by explosion');
             hit_bot(i,ix);
             if vis^[bot[i].x,bot[i].y]>oldvisible then
             with image1.canvas do begin
               brush.style:=bsclear;
               iy:=255;
               mytimer:=now;
               repeat
                 x2:=round((bot[i].x-viewx-0.5)*image1.width / viewsizex);
                 y2:=round((bot[i].y-viewy-0.5)*image1.height / viewsizey);
                 font.color:=RGB(iy,255,10,10);
                 font.size:=17;
                 textout(x2-10,y2-15,inttostr(ix));
                 image1.update;
                 iy:=255-round(100*(now-mytimer)*24*60*60*1000/blastdelay);
               until iy<=155;
             end;
             for ix:=-1 to 1 do
               for iy:=-1 to 1 do mapchanged^[bot[i].x+ix,bot[i].y+iy]:=255;
             draw_map;
           end;
         end else begin
           ix:=map_status^[ax+dx,ay+dy] - round((ablast/generationsum)/sqrt(area^[dx,dy]-60)/wallhardness);
           mapchanged^[ax+dx,ay+dy]:=255;
           if (ix<0) then begin
            map^[ax+dx,ay+dy]:=map^[ax+dx,ay+dy]-map_wall;
            map_status^[ax+dx,ay+dy]:=map_wall_smoke; //tile

             for ddx:=-visiblerange to visiblerange do if (ax+dx+ddx>0) and (ax+dx+ddx<=maxx) then
              for ddy:=-visiblerange to visiblerange do if (ay+dy+ddy>0) and (ay+dy+ddy<=maxy) then
                if check_LOS(ax+dx,ay+dy,ax+dx+ddx,ay+dy+ddy,false)>0 then LOS_base^[ax+dx+ddx,ay+dy+ddy]:=255;
             regenerate_los:=true;

           end else begin
             map_status^[ax+dx,ay+dy]:=ix;
           end;
         end;
       end;
   if (regenerate_los) and (this_turn<>player) then generate_LOS_base_map{(false,ax+dx,ay+dy)};

   //push surviving tagets
   for i:=1 to nbot do if (bot[i].hp>0) then begin
   flg_x:=true;
   for dx:=-generation to generation do if flg_x then
     for dy:=-generation to generation do if flg_x then
       if (bot[i].x=ax+dx) and (bot[i].y=ay+dy) and (area^[dx,dy]<=maxgeneration) then begin
           flg_x:=false;
           ix:=round((ablast/generationsum)/sqrt(area^[dx,dy]));
           if ix>blastpush then begin
           mapchanged^[bot[i].x,bot[i].y]:=255;
           if map^[bot[i].x-sgn(direction_x^[dx,dy]),bot[i].y-sgn(direction_y^[dx,dy])]<map_wall then begin
             flg:=true;
             for j:=1 to nbot do
               if (bot[j].x=bot[i].x-sgn(direction_x^[dx,dy])) and (bot[j].y=bot[i].y-sgn(direction_y^[dx,dy])) and (bot[j].hp>0) then flg:=false;
             if flg then begin
//               memo1.lines.add('[dbg] push '+bot[i].name);
               dec(bot[i].x,sgn(direction_x^[dx,dy]));
               dec(bot[i].y,sgn(direction_y^[dx,dy]));
               mapchanged^[bot[i].x,bot[i].y]:=255;
             end;
           end else
           if map^[bot[i].x,bot[i].y-sgn(direction_y^[dx,dy])]<map_wall then begin
             flg:=true;
             for j:=1 to nbot do
               if (bot[j].x=bot[i].x) and (bot[j].y=bot[i].y-sgn(direction_y^[dx,dy])) and (bot[j].hp>0) then flg:=false;
             if flg then begin
//               memo1.lines.add('[dbg] push '+bot[i].name);
               //dec(bot[i].x,sgn(direction_x^[dx,dy]));
               dec(bot[i].y,sgn(direction_y^[dx,dy]));
               mapchanged^[bot[i].x,bot[i].y]:=255;
             end;
           end else
           if map^[bot[i].x-sgn(direction_x^[dx,dy]),bot[i].y]<map_wall then begin
             flg:=true;
             for j:=1 to nbot do
               if (bot[j].x=bot[i].x-sgn(direction_x^[dx,dy])) and (bot[j].y=bot[i].y) and (bot[j].hp>0) then flg:=false;
             if flg then begin
//               memo1.lines.add('[dbg] push '+bot[i].name);
               dec(bot[i].x,sgn(direction_x^[dx,dy]));
               //dec(bot[i].y,sgn(direction_y^[dx,dy]));
               mapchanged^[bot[i].x,bot[i].y]:=255;
             end;
           end
          end;
         end;
    end;


    if this_turn=computer then clear_visible else begin
      for i:=1 to nbot do if bot[i].owner=player then begin
        look_around(i);
        generate_enemy_list(true);
      end;
      draw_map;
    end;

  dispose(area);
  dispose(direction_x);
  dispose(direction_y);
end;


{-------------------------------------------------------------------}

procedure tform1.alert_other_bots(target,who:integer);
var j:integer;
begin
  for j:=1 to nbot do if (bot[j].owner=computer) and (bot[j].hp>0) then
    if sqr(bot[j].x-bot[who].x)+sqr(bot[j].y-bot[who].y)<group_attack_range then begin
      bot[j].target:=target;
      bot[j].action:=action_attack;
  end;

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
   LOS:=check_LOS(bot[attacker].x,bot[attacker].y,bot[defender].x,bot[defender].y,true);
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
         alert_other_bots(attacker,defender);
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

       if ammo_specifications[bot[attacker].items[1].ammo_id].area>0 then begin
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
    i,j:integer;
    dx,dy:shortint;
    smoke_new:^map_array;
begin
 new(smoke_new);

for j:=1 to 3 do begin
  smoke_new^:=map_status^;

 for ix:=1 to maxx do
   for iy:=1 to maxy do if (smoke_new^[ix,iy]=1) and (random>0.7) then smoke_new^[ix,iy]:=0;

 for ix:=1 to maxx do
   for iy:=1 to maxy do if (map_status^[ix,iy]>1) and (map^[ix,iy]<map_wall) then begin
     i:=0;
     repeat
       inc(i);
       dx:=round(random*2)-1;
       dy:=round(random*2)-1;
       if (ix+dx>0) and (ix+dx<=maxx) and (iy+dy>0) and (iy+dy<=maxy) and ((dx<>0) or (dy<>0)) then begin
         if (smoke_new^[ix+dx,iy+dy]<map_status^[ix,iy]) and (smoke_new^[ix+dx,iy+dy]<map_smoke) then begin
           dec(map_status^[ix,iy]); //tile
           dec(smoke_new^[ix,iy]); //tile
           {if random>0.5 then }inc(smoke_new^[ix+dx,iy+dy]); //tile
         end;
       end;
     until (i>=30) or (map_status^[ix,iy]=1);
   end;
  map_status^:=smoke_new^;
end;
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

procedure Tform1.bot_clear_visible;
var x1,y1,i:integer;
begin
  for x1:=1 to maxx do
    for y1:=1 to maxy do botvis^[x1,y1]:=0;
end;

procedure Tform1.bot_recalc_visible;
var i:integer;
    x1,y1,x2,y2:integer;
    expecteddistance:byte;
    calculatelos:boolean;
begin
  for i:=1 to nbot do if bot[i].owner=computer then bot_look_around(i);
  calculatelos:=false;
  for i:=1 to nbot do if (bot[i].owner=player) and (bot[i].hp>0) then begin
    if (botvis^[bot[i].x,bot[i].y]=strategy_visible) {or (strategy_cheater<=bot[i].lastseen_tu) or (bot[i].lastseen_tu<bot[i].speed)} then begin
      bot_look_around(i);  // REAL LOS
    end else begin
      calculatelos:=true;
      expecteddistance:=distance_accuracy*bot[i].lastseen_tu div bot[i].speed;
      generatemovement_generic(bot[i].lastseen_x,bot[i].lastseen_y,1,1,expecteddistance,true,false);
      for x1:=1 to maxx do
        for y1:=1 to maxy do if (distance^[x1,y1]<=expecteddistance) and (botvis^[x1,y1]<>strategy_visible) and (botvis^[x1,y1]<strategy_real_los) then botvis^[x1,y1]:=strategy_possibleloc;
    end
  end;
  if calculatelos then begin
    for x1:=1 to maxx do
     for y1:=1 to maxy do if botvis^[x1,y1]=strategy_possibleloc then begin
       for x2:=1 to maxx do
        for y2:=1 to maxy do if (map^[x2,y2]<map_wall) and (botvis^[x2,y2]<>strategy_possibleloc) and (botvis^[x2,y2]<>strategy_possible_los) and (botvis^[x2,y2]<strategy_real_los) then
         if check_LOS(x1,y1,x2,y2,true)>0 then botvis^[x2,y2]:=strategy_possible_los;
     end;
  end;
end;

{--------------------------------------------------------------------------------------}

const max_los_targets=maxplayers;
procedure Tform1.bot_action(thisbot:integer);
var LOS_targets:array[1..max_los_targets] of integer;
    j,k,l:integer;
    stopactions,flg,weaponneeded:boolean;
    ammo_available,weapon_available:byte;
    range,lastrange,aim,aim_at_weak:integer;
    aim_at_weak_value:single;
    x1,y1,dx,dy:integer;
    timetoshot:integer;
    cautiontime:integer;
    passcount:byte;
    I_am_visible:boolean;
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
      lastrange:=256;
      aim:=0;
      for j:=1 to itemsn do if (item[j].item.w_id>0) and (item[j].item.state>0) and (item[j].item.n>0) then begin
        generatemovement(thisbot,item[j].x,item[j].y);
        if (distance^[item[j].x,item[j].y]<lastrange) and (movement^[item[j].x,item[j].y]<10) then begin
          flg:=true;
          for k:=1 to nbot do if (bot[k].hp>0) and (k<>thisbot) and (bot[k].x=item[j].x) and (bot[k].y=item[j].y) then flg:=false;
          if (aim>0) and (item[j].item.state<item[j].item.maxstate div 3) and (item[j].item.n<4) then flg:=false;
          if (flg)  then begin
            aim:=j;
            lastrange:=distance^[item[j].x,item[j].y]
          end;
        end;
      end;
      if (aim>0) and ((bot[thisbot].items[backpacksize].ammo_id>0) or (bot[thisbot].items[backpacksize].w_id>0)) then
        for j:=2 to backpacksize do drop_item(thisbot,j);
      if (aim=0) then
        stopactions:=true {!}
      else
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
    for j:=1 to playersn do if (check_LOS(bot[thisbot].x,bot[thisbot].y,bot[j].x,bot[j].y,true)>0) and (bot[j].hp>0) then begin
      inc(k);
      LOS_targets[k]:=j;
    end;
    //if LOS not empty - attack&move
    if k>0 then begin
      lastrange:=sqr(maxx)+sqr(maxy);
      aim:=0;
      aim_at_weak:=0;
      aim_at_weak_value:=0;
      for j:=1 to k do begin
        range:=sqr(bot[thisbot].x-bot[LOS_targets[j]].x)+ sqr(bot[thisbot].y-bot[LOS_targets[j]].y);
        if range<1 then range:=1;
        if range<lastrange then begin
          aim:=LOS_targets[j];
          lastrange:=range
        end;
        if 1/sqrt(sqrt(range))/bot[LOS_targets[j]].hp>aim_at_weak_value then begin
          aim_at_weak:=LOS_targets[j];
          aim_at_weak_value:=1/sqrt(sqrt(range))/bot[LOS_targets[j]].hp;
       end;
      end;
      bot[thisbot].action:=action_attack;
      bot[thisbot].target:=aim;
      if strategy_finishhim then bot[thisbot].target:=aim_at_weak;
      alert_other_bots(bot[thisbot].target,thisbot);
      bot_shots(thisbot,bot[thisbot].target);
    end;

    //Escape visible range or at least minimize LOS
    timetoshot:=bot[thisbot].items[1].rechargestate+weapon_specifications[bot[thisbot].items[1].w_id].aim;
    cautiontime:=timetoshot+round(bot[thisbot].caution*strategy_caution);
    if 255-cautiontime<timetoshot then cautiontime:=timetoshot;
    if strategy_hide then
    if (bot[thisbot].tu<cautiontime) and (bot[thisbot].tu>=bot[thisbot].speed) and (vis^[bot[thisbot].x,bot[thisbot].y]>oldvisible) then begin
      x1:=bot[thisbot].x;
      y1:=bot[thisbot].y;
      generatemovement(thisbot,bot[bot[thisbot].target].x,bot[bot[thisbot].target].y); //buggy
      for dx:=bot[thisbot].x- trunc(bot[thisbot].tu/bot[thisbot].speed) to bot[thisbot].x+trunc(bot[thisbot].tu/bot[thisbot].speed) do if (dx>1) and (dx<maxx) then
        for dy:=bot[thisbot].y- trunc(bot[thisbot].tu/bot[thisbot].speed) to bot[thisbot].y+trunc(bot[thisbot].tu/bot[thisbot].speed) do if (dy>1) and (dy<maxy) then
          if (map^[dx,dy]<map_wall) and (distance^[dx,dy]>0) and (distance^[dx,dy]/distance_accuracy*bot[thisbot].speed<=bot[thisbot].tu) and ((LOS_base^[x1,y1]>LOS_base^[dx,dy]) or ((vis^[x1,y1]>oldvisible) and (vis^[dx,dy]<=oldvisible))) then
            if (vis^[dx,dy]<=oldvisible) or (vis^[x1,y1]>oldvisible) then begin
              flg:=true;
              for j:=1 to nbot do if (bot[j].x=dx) and (bot[j].y=dy) then flg:=false;
              if flg then begin
                x1:=dx;
                y1:=dy;
              end;
            end;
      if (x1<>bot[thisbot].x) or (y1<>bot[thisbot].y) then begin
//        memo1.lines.add('[dbg] '+bot[thisbot].name+' hides from vis'+inttostr(vis^[bot[thisbot].x,bot[thisbot].y])+'/los'+inttostr(LOS_base^[bot[thisbot].x,bot[thisbot].y])+'/tu'+inttostr(bot[thisbot].tu));
        move_bot(thisbot,x1,y1,100);
//        memo1.lines.add('[dbg] '+bot[thisbot].name+' hides to vis'+inttostr(vis^[bot[thisbot].x,bot[thisbot].y])+'/los'+inttostr(LOS_base^[bot[thisbot].x,bot[thisbot].y])+'/tu'+inttostr(bot[thisbot].tu));

      end;
      stopactions:=true;
    end else //buggy

    //action/attack - go to the nearest LOS
    if (bot[thisbot].action=action_attack) and (bot[bot[thisbot].target].hp>0) then begin
      if (k=0) or (bot[thisbot].items[1].rechargestate>=bot[thisbot].speed) then begin
        if vis^[bot[thisbot].x,bot[thisbot].y]<=oldvisible then begin
          lastrange:=256;
          I_am_visible:=false;
        end
        else begin
          lastrange:=sqr(bot[thisbot].x-bot[bot[thisbot].target].x)+sqr(bot[thisbot].y-bot[bot[thisbot].target].y);
          I_am_visible:=true;
        end;
        j:=1;
        flg:=false;
        generatemovement(thisbot,bot[bot[thisbot].target].x,bot[bot[thisbot].target].y);  //buggy
        repeat
          for dx:=bot[thisbot].x-j to bot[thisbot].x+j do
           for dy:=bot[thisbot].y-j to bot[thisbot].y+j do if (dx>0) and (dy>0) and (dx<=maxx) and (dy<=maxy) then
            if (map^[dx,dy]<map_wall) and ((botvis^[dx,dy]=strategy_possible_los) or (botvis^[dx,dy]=strategy_real_los)) {(vis^[dx,dy]>oldvisible)} and (((lastrange>distance^[dx,dy]) and (distance^[dx,dy]>0) and (not I_am_visible)) or ((lastrange>sqr(dx-bot[bot[thisbot].target].x)+sqr(dy-bot[bot[thisbot].target].y)) and (distance^[dx,dy]/distance_accuracy*bot[thisbot].speed<=bot[thisbot].items[1].rechargestate) and (I_am_visible))) then begin
              aim:=1;
              for l:=1 to nbot do if (bot[l].x=dx) and (bot[l].y=dy) and (bot[l].hp>0) then aim:=0;
              if (aim=1) and (movement^[dx,dy]<10) then begin
                x1:=dx;
                y1:=dy;
                if I_am_visible then
                  lastrange:=sqr(x1-bot[bot[thisbot].target].x)+sqr(y1-bot[bot[thisbot].target].y)
                else
                  lastrange:=distance^[dx,dy];
                flg:=true;
              end;
            end;
          inc(j);
        until (flg) or (j>maxx);
        if flg then begin
          if ((k<>0) and (j<=1+timetoshot/(bot[thisbot].speed*sqrt(2))) and (bot[thisbot].items[1].rechargestate>=bot[thisbot].speed*sqrt(sqr(bot[thisbot].x-x1)+sqr(bot[thisbot].y-y1)))) or (k=0) then move_bot(thisbot,x1,y1,1)
        end else
          if (k=0) then stopactions:=true;
        bot_recalc_visible;
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

    if bot[thisbot].hp<=0 then stopactions:=true;
  until (bot[thisbot].tu<30*sqrt(2)*1.01) or (stopactions);
end;


procedure TForm1.end_turn;
var i:integer;
begin
  this_turn:=computer;

  grow_smoke;
  selectedenemy:=-1;
  memo1.clear;
  clear_visible;
  draw_map;
  //LOS - is "current" map_visible;

  if (regenerate_los){ and (this_turn<>player)} then generate_LOS_base_map{(false,ax+dx,ay+dy)};

  for i:=1 to nbot do if bot[i].owner<>player then begin
    spend_tu(i,bot[i].tu);
    bot[i].tu:=255;
  end;

  bot_clear_visible;
  bot_recalc_visible;

  set_progressbar(true);
  progressbar1.max:=nbot;
  for i:=1 to nbot do if (bot[i].owner<>player) and (bot[i].hp>0) then begin
    bot_action(i);
    progressbar1.position:=i;
    progressbar1.update;
  end;

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

  bot_clear_visible;
  bot_recalc_visible;

  n1:=0; n2:=0;
  for i:=1 to nbot do if bot[i].hp>0 then begin if bot[i].owner=player then begin spend_tu(i,bot[i].tu); bot[i].tu:=255; inc(n2) end else inc(n1); end;
  if (n1<n2) or (n1<3) then begin
    for i:=1 to nbot do if (bot[i].hp>0) and (bot[i].owner=computer) and (bot[i].action<>action_attack) then begin
      bot[i].action:=action_attack;
      bot[i].target:=round(random*(playersn-1))+1;
    end;
  end;
  memo1.lines.add('bots remaining: '+inttostr(n1));
  if n1=0 then begin
    gamemode:=gamemode_victory;
    memo1.lines.add('---- VICTORY!!! ----');
  end;
  if n2=0 then begin
    gamemode:=gamemode_defeat;
    memo1.lines.add('---- DEFEAT... ----');
  end;
  if (n1=0) or (n2=0) then begin
   memo1.lines.add('Players = '+inttostr(n2));
   memo1.lines.add('Bots = '+inttostr(n1));
   for n1:=1 to maxx do
    for n2:=1 to maxy do begin
      vis^[n1,n2]:=maxvisible;
      mapchanged^[n1,n2]:=255;
    end;
    ix:=0;iy:=0;
    for i:=1 to nbot do if bot[i].owner=player then inc(ix,bot[i].hp) else inc(iy,bot[i].hp);
    memo1.lines.add('Player HP sum = '+inttostr(ix));
    memo1.lines.add('Bot HP sum = '+inttostr(iy));
  end;
  n1:=0; n2:=0;
  for ix:=1 to maxx do
    for iy:=1 to maxy do if map^[ix,iy]<map_wall then begin
      inc(n1);
      if vis^[ix,iy]>0 then inc(n2);
    end;
  memo1.lines.add('MapExplored: '+inttostr(round(n2*100/n1))+'%');
  memo1.lines.add('------------------------------');
  generate_enemy_list(false);

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
 if (mapgenerated) and ((gamemode=gamemode_game) or (gamemode=gamemode_iteminfo)) then buttonpressed:=(MessageDlg('Are you sure? Current map will be lost.',mtCustom, [mbYes,mbCancel], 0)=MrYes) else buttonpressed:=true;
 if buttonpressed then begin
  memo1.clear;
  generate_map;
  togglebox1.checked:=false;
  togglebox1.state:=cbUnchecked;
  gamemode:=gamemode_game;
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
  generate_enemy_list(false);
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
  MyImage.LoadFromFile(ExtractFilePath(application.ExeName)+datafolder+'help.jpg');
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
  MyImage.LoadFromFile(ExtractFilePath(application.ExeName)+datafolder+'help_menu.jpg');
  image1.visible:=true;
  destrect:=Rect(0,0,image1.width,image1.height);
  image1.Canvas.CopyRect(destrect,MyImage.canvas,destrect);
  MyImage.free;
end;

procedure TForm1.CheckBox5Change(Sender: TObject);
begin
  edit6.enabled:=checkbox5.checked;
  edit1.enabled:=not checkbox5.checked;
  Edit4Change(nil);
end;


procedure TForm1.Edit4Change(Sender: TObject);
var botsquantity,hpquantity,playerhp,playerquantity,i:integer;
    difficulty,mapsizex,mapsizey:integer;
begin
  val(edit5.text,playersn,i);
  if playersn<1 then playersn:=1;
  playerquantity:=playersn;
  val(edit4.text,playerhp,i);
  val(edit1.text,botsquantity,i);
  val(edit2.text,mapsizex,i);
  val(edit7.text,mapsizey,i);
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
  if botsquantity+playerquantity>mapsizex*mapsizey*0.2 then begin
    label8.caption:='Not enough space on the map to place bots';
    label8.color:=$0000FF;
  end;

  if (mapsizex>2) and (mapsizey>2) and (playerhp>0) and (playerquantity>0) and (hpquantity>0) and (botsquantity>0) then begin
    if checkbox5.checked then val(edit6.text,difficulty,i) else begin
      if hpquantity<15 then hpquantity:=15;
      difficulty:=calculate_difficulty(playerquantity,playerhp*playerquantity,botsquantity,hpquantity*botsquantity,mapsizex,mapsizey,mapsizex*mapsizey div 2);

      if checkbox1.checked then difficulty:=difficulty*defensedifficulty;
    end;
    label10.Caption:='Difficulty: '+saydifficulty(difficulty);
  end else label10.caption:='ERROR CALCULATING DIFFICULTY';
end;

procedure TForm1.Edit6Change(Sender: TObject);
begin

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
  dispose(map_status);
  dispose(vis);
  dispose(movement);
  dispose(distance);
  dispose(mapchanged);
  dispose(LOS_base);
  dispose(botvis);
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
  if (map^[mousex,mousey]<map_wall) and (vis^[mousex,mousey]>0) then begin
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
      if (Button=mbright) and (bot[found].owner=computer) and (selected>0) then begin
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
          if check_LOS(bot[selected].x,bot[selected].y,bot[selectedenemy].x,bot[selectedenemy].y,true)>0 then
            bot_shots(selected,selectedenemy)
          else
            show_LOS:=true;
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
 else if (gamemode=gamemode_help) or (gamemode=gamemode_iteminfo) then begin
   if gamemode=gamemode_help then begin
     togglebox1.checked:=true;
     togglebox1.state:=cbChecked;
   end;
   gamemode:=previous_gamemode;
   draw_map_all:=true;
   if (previous_gamemode>100) and (mapgenerated) then draw_map;
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
    if map^[mousex,mousey]>=map_wall then image1.cursor:=CrNo else begin
      if map^[mousex,mousey]<map_wall then begin
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

procedure TForm1.Image2MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
 if button=mbleft then begin
   if (selected>0) and (selecteditem>1) then
    if (bot[selected].items[selecteditem].n>0) and (bot[selected].items[selecteditem].ammo_id>0) and (bot[selected].items[selecteditem].w_id=0) and (bot[selected].items[1].w_id>0) and (bot[selected].items[1].ammo_id=0) then
     if load_weapon(selected,selecteditem) then begin
       selectedonfloor:=-1;
       selecteditem:=-1;
       if gamemode=gamemode_iteminfo then begin draw_map_all:=true; gamemode:=previous_gamemode; draw_map end else draw_stats;
     end;
 end else {button=mbright} begin
   if selected>0 then display_item_info(bot[selected].items[1]);
 end;
end;


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
var tmpitem:item_type;
    selectednew,freespace,i:integer;
    //i:integer;
    //flg:boolean;
begin
  if (y>=0) and (y<=(backpacksize*2-1)*fontsize) and (selected>0) then begin
    selectednew:=round((y-fontsize-3+scrollbar1.position)/(2*fontsize))+2;
    if selectednew<2 then selectednew:=2;
    if selectednew>backpacksize then selectednew:=backpacksize;
    if button=mbleft then begin
      if (ssShift in shift) or ((ssCtrl in shift) and (bot[selected].items[selectednew].w_id=0) and (bot[selected].items[selectednew].ammo_id=0)) then begin
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
         if freespace>=2 then begin
           if spend_tu(selected,weapon_specifications[bot[selected].items[selectednew].w_id].reload) then begin
            bot[selected].items[freespace].ammo_id:=bot[selected].items[selectednew].ammo_id;
            bot[selected].items[freespace].n:=bot[selected].items[selectednew].n;
            bot[selected].items[selectednew].ammo_id:=0;
           end
         end else showmessage('Backpack is full!');

        end
       end else if selecteditem=selectednew then begin
         if load_weapon(selected,selecteditem) then begin
           selectedonfloor:=-1;
           selecteditem:=-1;
         end;
       end else begin
         selectedonfloor:=-1;
         if (bot[selected].items[selectednew].ammo_id>0) or (bot[selected].items[selectednew].w_id>0) then
           selecteditem:=selectednew
         else if selecteditem>0 then begin
           tmpitem:=bot[selected].items[selectednew];
           bot[selected].items[selectednew]:=bot[selected].items[selecteditem];
           bot[selected].items[selecteditem]:=tmpitem;
           selecteditem:=-1;
        end;
      end;
         if gamemode=gamemode_iteminfo then begin draw_map_all:=true; gamemode:=previous_gamemode; draw_map end else draw_stats;
      //draw_map;
   end else {button=mbright} begin
     display_item_info(bot[selected].items[selectednew]);
   end;
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
  if (not flg) and (bot[thisbot].owner=player) then showmessage('Backpack is full!');
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
   if button=mbleft then begin
    if (ssCtrl in Shift) and (item[onfloor[selectednew]].item.w_id>0) and (item[onfloor[selectednew]].item.ammo_id>0) then begin
      if spend_tu(selected,weapon_specifications[item[onfloor[selectednew]].item.w_id].reload+(pickupitemtime+dropitemtime)div 2) then begin
        inc(itemsn);
        item[itemsn]:=item[onfloor[selectednew]];
        item[onfloor[selectednew]].item.n:=0;
        item[onfloor[selectednew]].item.ammo_id:=0;
        item[itemsn].item.w_id:=0;
        selectedonfloor:=selectednew;
        selecteditem:=-1;
      end;
    end else
    if selectednew=selectedonfloor then begin
      pick_up(selected,selectedonfloor);
      selectedonfloor:=-1;
    end else begin
      selectedonfloor:=selectednew;
      selecteditem:=-1;
    end;
     if gamemode=gamemode_iteminfo then begin draw_map_all:=true; gamemode:=previous_gamemode; draw_map end else draw_stats;
    //draw_map;
   end else {button=mbright} begin
     display_item_info(item[onfloor[selectednew]].item);
   end;
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
    if gamemode=gamemode_iteminfo then begin draw_map_all:=true;  gamemode:=previous_gamemode; end;
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
    if gamemode=gamemode_iteminfo then begin draw_map_all:=true;  gamemode:=previous_gamemode; end;
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
 edit7.visible:=flg;
 label15.visible:=flg;
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
 checkbox3.visible:=flg;
 label13.visible:=flg;
 button7.visible:=flg;
 memo2.visible:=flg;
 checkbox4.visible:=flg;
 label14.visible:=flg;
 edit6.Visible:=flg;
 checkbox5.Visible:=flg;
 checkbox6.visible:=flg;
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

{--------------------------------------------------------------------------------------}
const item_box_x=50;
      item_box_y=50;
      font_size10=15;
procedure Tform1.display_item_info(thisitem:item_type);
var starty,startx:integer;
    descr:string;
    line_width:integer;
    tmp:integer;
begin
 if (thisitem.w_id>0) or (thisitem.ammo_id>0) then begin
  if gamemode<>gamemode_iteminfo then previous_gamemode:=gamemode;
  gamemode:=gamemode_iteminfo;
  create_message_box(item_box_x,item_box_y,item_box_x+300,item_box_y+500);
  with image1.canvas do begin
    brush.Style:=bsclear;
    starty:=item_box_y+2*border_size;
    startx:=item_box_x+2*border_size;
    if thisitem.w_id>0 then begin
      {weapon stats}
     font.color:=clwhite;
     font.size:=16;
     textout(startx,starty,WEAPON_SPECIFICATIONS[thisitem.w_id].name);
     font.size:=10;
     textout(startx,starty+25,'STATE: '+inttostr(thisitem.state)+'/'+inttostr(thisitem.maxstate)+'('+inttostr(WEAPON_SPECIFICATIONS[thisitem.w_id].maxstate)+')      = '+inttostr(round(100*thisitem.state/thisitem.maxstate))+'%');
     textout(startx,starty+25+font_size10,'DAM: +'+inttostr(WEAPON_SPECIFICATIONS[thisitem.w_id].dam)+'         ACC: +'+inttostr(WEAPON_SPECIFICATIONS[thisitem.w_id].acc));
     textout(startx,starty+25+2*font_size10,'Time to AIM: '+inttostr(WEAPON_SPECIFICATIONS[thisitem.w_id].aim));
     textout(startx,starty+25+3*font_size10,'Time to RECHARGE: '+inttostr(WEAPON_SPECIFICATIONS[thisitem.w_id].recharge));
     textout(startx,starty+25+4*font_size10,'Time to CHANGE CLIP: '+inttostr(WEAPON_SPECIFICATIONS[thisitem.w_id].reload));

     font.color:=clyellow;
     starty:=starty+25+5*font_size10;
     descr:= WEAPON_SPECIFICATIONS[thisitem.w_id].description;
     repeat
       line_width:=text_width+1;
       if line_width>length(descr) then line_width:=length(descr) else
         repeat
          dec(line_width);
         until (copy(descr,line_width,1)=' ') or (line_width<=text_width div 2);
       textout(startx,starty,copy(descr,1,line_width));
       descr:=trim(copy(descr,line_width,999));
       starty:=starty+font_size10;
     until length(descr)<=1;
     starty:=starty+font_size10;
    end;
    if thisitem.ammo_id>0 then begin
      {ammo stats}
      font.color:=clwhite;
      font.size:=16;
      textout(startx,starty,AMMO_SPECIFICATIONS[thisitem.ammo_id].name);
      font.size:=10;
      textout(startx,starty+25,'QUANTITY: '+inttostr(thisitem.n)+'/'+inttostr(AMMO_SPECIFICATIONS[thisitem.ammo_id].quantity));
      textout(startx,starty+25+1*font_size10,'DAM: +'+inttostr(AMMO_SPECIFICATIONS[thisitem.ammo_id].dam)+'         ACC: +'+inttostr(AMMO_SPECIFICATIONS[thisitem.ammo_id].acc));
      textout(startx,starty+25+2*font_size10,'EXPLOSION: '+inttostr(AMMO_SPECIFICATIONS[thisitem.ammo_id].explosion)+' / AREA: '+inttostr(AMMO_SPECIFICATIONS[thisitem.ammo_id].Area)+' / SMOKE: '+inttostr(AMMO_SPECIFICATIONS[thisitem.ammo_id].Smoke));

      font.color:=clyellow;
      starty:=starty+25+3*font_size10;
      descr:= AMMO_SPECIFICATIONS[thisitem.ammo_id].description;
      repeat
        line_width:=text_width+1;
        if line_width>length(descr) then line_width:=length(descr) else
          repeat
           dec(line_width);
          until (copy(descr,line_width,1)=' ') or (line_width<=text_width div 2);
        textout(startx,starty,copy(descr,1,line_width));
        descr:=trim(copy(descr,line_width,999));
        starty:=starty+font_size10;
      until length(descr)<=1;
      starty:=starty+font_size10+10;

      if thisitem.w_id>0 then begin
        {summary stats}
        font.color:=clwhite-255;
        font.size:=16;
        textout(startx,starty,'SUMMARY ESTIMATE:');
        font.size:=10;
        if thisitem.state>thisitem.maxstate div 3 then tmp:=thisitem.maxstate div 3 else begin tmp:=thisitem.state; font.color:=clred; end;
        textout(startx,starty+25,'DAM: '+ inttostr(round((AMMO_SPECIFICATIONS[thisitem.ammo_id].dam+WEAPON_SPECIFICATIONS[thisitem.w_id].dam)*tmp/(thisitem.maxstate div 3))));
        font.color:=clwhite-255;
        textout(startx,starty+font_size10+25,'ACC: '+ inttostr(AMMO_SPECIFICATIONS[thisitem.ammo_id].acc+WEAPON_SPECIFICATIONS[thisitem.w_id].acc));
        textout(startx,starty+2*font_size10+25,'Shots per turn: '+ inttostr(trunc(255/(WEAPON_SPECIFICATIONS[thisitem.w_id].aim+WEAPON_SPECIFICATIONS[thisitem.w_id].recharge))));
        if thisitem.state>thisitem.maxstate div 3 then tmp:=thisitem.maxstate div 3 else begin tmp:=thisitem.state; font.color:=clred; end;
        textout(startx,starty+3*font_size10+25,'Damage per turn: '+ inttostr(round((AMMO_SPECIFICATIONS[thisitem.ammo_id].dam+WEAPON_SPECIFICATIONS[thisitem.w_id].dam)*tmp/(thisitem.maxstate div 3))*trunc(255/(WEAPON_SPECIFICATIONS[thisitem.w_id].aim+WEAPON_SPECIFICATIONS[thisitem.w_id].recharge))));
        font.color:=clwhite-255;

        if AMMO_SPECIFICATIONS[thisitem.ammo_id].Area>0 then begin
          case AMMO_SPECIFICATIONS[thisitem.ammo_id].Area of
               1 ..   9: tmp:=9;
              10 ..  25: tmp:=25;
              26 ..  49: tmp:=49;
              50 ..  81: tmp:=81;
              82 .. 121: tmp:=121;
             else tmp:=AMMO_SPECIFICATIONS[thisitem.ammo_id].Area;
          end;
          textout(startx,starty+4*font_size10+25,'Average explosion damage: '+ inttostr(AMMO_SPECIFICATIONS[thisitem.ammo_id].explosion div tmp));
        end;
      end;
    end;

  end;
 end;
end;

{------------------------------------------}

procedure Tform1.create_message_box(x1,y1,x2,y2:integer);
begin
 with image1.canvas do begin
   brush.color:=RGB(255,130,130,200);
   brush.style:=bssolid;
   fillrect(x1,y1,x2,y2);
   brush.color:=RGB(255,50,50,70);
   brush.style:=bssolid;
   fillrect(x1+border_size,y1+border_size,x2-border_size,y2-border_size);
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
       font.size:=9;
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
    minimapx0,minimapy0:integer;
    x1,y1,x2,y2:integer;
    xx1,yy1:integer;
    thistime:TDatetime;
    tmp_color:byte;
    btc1,btc2,btc3:byte;
    //dx,dy,range,maxrange:integer;
begin
  thistime:=now;
  image1.canvas.lock;
  sx:=image1.width;
  sy:=image1.height;
  scalex:=sx / viewsizex;
  scaley:=sy / viewsizey;
  scaleminimapx:=image7.Width / max_max_value;
  scaleminimapy:=image7.height / max_max_value;
  if maxx>=maxy then minimapx0:=0 else minimapx0:=round(scaleminimapx * (maxy-maxx) / 2);
  if maxy>=maxx then minimapy0:=0 else minimapy0:=round(scaleminimapy * (maxx-maxy) / 2);

  image7.canvas.brush.style:=bssolid;

  if (show_los) and (selectedenemy>0) then begin
   for mx:=2 to maxx-1 do
     for my:=2 to maxy-1 do if (check_los(mx,my,bot[selectedenemy].x,bot[selectedenemy].y,true)>0) and (vis^[mx,my]>0) and (map^[mx,my]<map_wall) then mapchanged^[mx,my]:=2;
  end;

  if {(draw_map_all) and }(maxx<>maxy) then with image7.canvas do begin
    brush.color:=clgray;
    if minimapx0>0 then begin
      fillrect(0,0,minimapx0,image7.height);
      fillrect(minimapx0+round(maxx*scaleminimapx),0,image7.width,image7.height);
    end else begin
      fillrect(0,0,image7.width,minimapy0);
      fillrect(0,minimapy0+round(maxy*scaleminimapy),image7.width,image7.height);
    end;
  end;

  with image1.canvas do begin
    pen.width:=1;
    {draw_map}
    for mx:=1 to maxx do
      for my:=1 to maxy do if (mapchanged^[mx,my]>0) or (draw_map_all) then begin
        //mapchanged^[mx,my]:=1;
        if vis^[mx,my]=0 then begin
          brush.color:=$330000
        end else begin
          if vis^[mx,my]=oldvisible then begin
             if map^[mx,my]>=map_wall then begin
               tmp_color:=99;
               brush.color:=RGB(tmp_color,255,220,220);
               pen.color:=RGB(tmp_color-15,255,220,220);
             end else begin
               tmp_color:=50;
               brush.color:=RGB(tmp_color,80,99,80);
               pen.color:=RGB(tmp_color-15,80,99,80);
             end;
           end else begin
             if map^[mx,my]>=map_wall then begin
               tmp_color:=round(155*sqr((vis^[mx,my]-oldvisible)/(maxvisible-oldvisible)))+100;
               brush.color:=RGB(tmp_color,255,220,220);
               pen.color:=RGB(tmp_color-15,255,220,220);
             end else begin
               tmp_color:=round(200*sqr((vis^[mx,my]-oldvisible)/(maxvisible-oldvisible)))+55;
               brush.color:=RGB(tmp_color,80,99,80);
               pen.color:=RGB(tmp_color-15,80,99,80);
             end;
           end;
        end;


        if mapchanged^[mx,my]=255 then begin
          image7.canvas.brush.color:=brush.color;
          image7.canvas.fillrect(round((mx-1)*scaleminimapx)+minimapx0, round((my-1)*scaleminimapy)+minimapy0, round(mx*scaleminimapx)+minimapx0, round(my*scaleminimapy)+minimapy0);
        end;

        if (mx>viewx) and (my>viewy) and (mx<=viewx+viewsizex) and (my<=viewy+viewsizey) then begin
          brush.style:=bssolid;
          fillrect(round((mx-1-viewx)*scalex), round((my-1-viewy)*scaley), round((mx-viewx)*scalex), round((my-viewy)*scaley));

          if (vis^[mx,my]>=oldvisible) then begin
            if (map^[mx,my]=3) or (map^[mx,my]=3+map_wall) then begin
              brush.style:= bsCross;
              brush.color:= pen.color;
              fillrect(round((mx-1-viewx)*scalex), round((my-1-viewy)*scaley), round((mx-viewx)*scalex), round((my-viewy)*scaley));
            end else
            if (map^[mx,my]=2) or (map^[mx,my]=2+map_wall) then begin
              rectangle(round((mx-1-viewx)*scalex), round((my-1-viewy)*scaley), round((mx-viewx)*scalex), round((my-viewy)*scaley));
            end else
            if (map^[mx,my]=1) or (map^[mx,my]=1+map_wall) then begin
              brush.color:= pen.color;
              rectangle(round((mx-1-viewx)*scalex+scalex/4), round((my-1-viewy)*scaley+scaley/4), round((mx-viewx)*scalex-scalex/4), round((my-viewy)*scaley-scaley/4));
            end else
          end;
          if map^[mx,my]<map_wall then begin

            if mapchanged^[mx,my]=2 then begin
              brush.style:= bsDiagCross;
              brush.color:=$000088;
              fillrect(round((mx-1-viewx)*scalex), round((my-1-viewy)*scaley), round((mx-viewx)*scalex), round((my-viewy)*scaley));
            end;

            if (map_status^[mx,my]>0) and (vis^[mx,my]>oldvisible) then begin
              for i:=1 to 1+round((0.01+0.3*(map_status^[mx,my]-1)/(map_smoke-1))*scalex*scaley) do begin
                brush.style:=bssolid;
                brush.color:=RGB(round(150*(random*vis^[mx,my]-oldvisible)/(maxvisible-oldvisible))+100,255,255,255);
                x1:=round((mx-1-viewx+random*(scalex-1)/scalex)*(scalex));
                y1:=round((my-1-viewy+random*(scaley-1)/scaley)*(scaley));
                fillrect(x1,y1,x1+1,y1+1);
              end;
            end;
          end else begin
            if (map_status^[mx,my]<(2*maxstatusdivision-1)*maxstatus div maxstatusdivision div 2) and (vis^[mx,my]>0) then begin
              for i:=1 to 1+maxstatusdivision*(maxstatus-map_status^[mx,my]) div maxstatus do begin
                x1:=round((mx-1-viewx+sqr(sin(mx*1.4+my*1.1+i*1.3))*(scalex-1)/scalex)*(scalex));
                y1:=round((my-1-viewy+sqr(cos(mx*1.2+my*1.3+i*1.1))*(scaley-1)/scaley)*(scaley));
                x2:=round((mx-1-viewx+sqr(sin(mx*1.1+my*1.5+i*1.2))*(scalex-1)/scalex)*(scalex));
                y2:=round((my-1-viewy+sqr(cos(mx*1.3+my*1.2+i*1.4))*(scaley-1)/scaley)*(scaley));
{                tmp_color:=40;
                pen.color:=tmp_color+256*tmp_color+65536*tmp_color;}
                pen.color:=RGB(tmp_color-20-round((tmp_color/2)*sqr(sin(mx*0.3+my+i*3.4)){/(sqrt(sqrt(sqr(x1-x2)+sqr(y1-y2))))}),255,220,220);
                moveto(x1,y1);
                lineto(x2,y2);
              end;
            end;
          end;
          //++++++++++++++++++++++++++++++++++++++++++++++++++++++
          if (botvis^[mx,my]=strategy_possibleloc) then begin
              brush.style:= bsCross;
              brush.color:= clred;
              fillrect(round((mx-1-viewx)*scalex), round((my-1-viewy)*scaley), round((mx-viewx)*scalex), round((my-viewy)*scaley));
          end;
          if (botvis^[mx,my]=strategy_possible_los) then begin
              brush.style:= bsCross;
              brush.color:= clyellow;
              fillrect(round((mx-1-viewx)*scalex), round((my-1-viewy)*scaley), round((mx-viewx)*scalex), round((my-viewy)*scaley));
          end;
          //++++++++++++++++++++++++++++++++++++++++++++++
          if vis^[mx,my]=0 then begin
            brush.style:= bsDiagCross;
            brush.color:=$990000;
            fillrect(round((mx-1-viewx)*scalex), round((my-1-viewy)*scaley), round((mx-viewx)*scalex), round((my-viewy)*scaley));
          end;
          //*******
//          font.color:=$FFFFFF;font.size:=5;textout(round((mx-1-viewx)*scalex), round((my-1-viewy)*scaley), inttostr(LOS_base^[mx,my]));
//          font.color:=$FFFFFF;font.size:=5;textout(round((mx-1-viewx)*scalex), round((my-1-viewy)*scaley), inttostr(distance^[mx,my]));
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
        image7.canvas.fillrect(round((item[i].x-1)*scaleminimapx)+minimapx0, round((item[i].y-1)*scaleminimapy)+minimapy0, round(item[i].x*scaleminimapx)+minimapx0, round(item[i].y*scaleminimapy)+minimapy0);
       end;
     {draw_bots}
     for mx:=1 to nbot do if bot[mx].hp>0 then begin
       if (vis^[bot[mx].x,bot[mx].y]>oldvisible) and ((mapchanged^[bot[mx].x,bot[mx].y]>0) or (draw_map_all)) then begin
         if (bot[mx].x-viewx>0) and (bot[mx].y-viewy>0) and (bot[mx].x-viewx<=viewsizex) and (bot[mx].y-viewy<=viewsizey) then begin
           fx1:=(bot[mx].x-viewx-1)*scalex;
           fy1:=(bot[mx].y-viewy-1)*scaley;
           fx2:=(bot[mx].x-viewx  )*scalex-1;
           fy2:=(bot[mx].y-viewy  )*scaley-1;
           case bot[mx].bottype of
              2:begin btc1:=120; btc2:=150; btc3:=150 end;
              3:begin btc1:=140; btc2:=140; btc3:=220 end;
              4:begin btc1:=200; btc2:=140; btc3:=140 end;
              else begin btc1:=140; btc2:=140; btc3:=170 end;
           end;
           pen.color:=RGB(round(150*((vis^[bot[mx].x,bot[mx].y]-oldvisible)/(maxvisible-oldvisible)))+55,btc1,btc2,btc3);
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
         image7.canvas.fillrect(round((bot[mx].x-1)*scaleminimapx)+minimapx0, round((bot[mx].y-1)*scaleminimapy)+minimapy0, round(bot[mx].x*scaleminimapx)+minimapx0, round(bot[mx].y*scaleminimapy)+minimapy0);

         if (bot[mx].x-viewx>0) and (bot[mx].y-viewy>0) and (bot[mx].x-viewx<=viewsizex) and (bot[mx].y-viewy<=viewsizey) then begin
           ellipse(round(fx1+scalex / 6), round(fy1+scaley / 6), round(fx2-scalex / 6), round(fy2-scaley / 6));
           pen.color:=RGB(round(150*((vis^[bot[mx].x,bot[mx].y]-oldvisible)/(maxvisible-oldvisible)))+55,btc1+10,btc2+10,btc3);
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
               if check_LOS(bot[selected].x,bot[selected].y,bot[selectedenemy].x,bot[selectedenemy].y,true)>0 then pen.color:=$0000FF else pen.color:=$00EEFF;
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

     if (show_los) and (selectedenemy>0) then begin
      for mx:=2 to maxx-1 do
        for my:=2 to maxy-1 do if (check_los(mx,my,bot[selectedenemy].x,bot[selectedenemy].y,true)>0) and (vis^[mx,my]>0) and (map^[mx,my]<map_wall) then mapchanged^[mx,my]:=255;
     end;

     draw_map_all:=false;

     image7.canvas.brush.style:=bsclear;
     image7.canvas.pen.color:=$FFFFFF;
     image7.canvas.rectangle(round((viewx+0.3)*scaleminimapx)+minimapx0, round((viewy+0.3)*scaleminimapy)+minimapy0, round((viewx+viewsizex-0.3)*scaleminimapx)+minimapx0, round((viewy+viewsizey-0.3)*scaleminimapy)+minimapy0);

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

  show_los:=false;

end;

{procedure TDrawMap.execute;
begin
    if map_changed then begin
      map_changed:=false;
      form1.draw_map;
    end;
end;}

end.

