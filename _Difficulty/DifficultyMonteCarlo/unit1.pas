unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    Edit8: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure Edit4Change(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

const stdamage=15*255 div 50 div 2; {50%}
      maxcount=100000; //Monte-Carlo method
      // 1000 suitable for game = total 1% error
      // worst accuracy is for worst score - total 5% error for 1mln
      // to be more exact: worst score at wins and best scores at loose
type deviationarray=array[1..maxcount] of integer;

const Np0=16;
const Nb0=500;

var
  Form1: TForm1;
  B,mask:array [1..Nb0] of integer;
  P:array[1..Np0] of integer;
  P_hp,B_hp:integer;
  Np,Nb:integer;

implementation

{$R+}{$Q+}

{$R *.lfm}

{ TForm1 }

function calc:boolean;
var i:integer;
begin
  P_hp:=0;
  for i:=1 to Np do inc(P_hp,P[i]);
  B_hp:=0;
  for i:=1 to Nb do inc(B_hp,B[i]);
  calc:= (P_hp=0) or (B_hp=0);
end;

procedure TForm1.Button1Click(Sender: TObject);
var i:integer;
    flg:boolean;
    dam:integer;
    turns:integer;

    PlayerHp,BotHp,LOS,Area,ax,ay,freespace,tmp:integer;
    basicrandom:double;

    Victory,PlayerHpSum:integer;
    sum,avrg:double;
    count:integer;
    best,worst:integer;

    deviation:^deviationarray;
    deviationsum:double;

    together,togethersum,togetherturns:integer;

    battle:boolean;
begin
 new(deviation);
 val(edit1.text,Np,i);
 if (i<>0) or (Np>Np0) then begin showmessage('Error'); exit; end;
 val (edit3.text,Nb,i);
 if (i<>0) or (Nb>Nb0) then begin showmessage('Error'); exit; end;
 val (edit2.text,playerHP,i);
 if (i<>0) then begin showmessage('Error'); exit; end;
 val (edit4.text,BotHp,i);
 if (i<>0) then begin showmessage('Error'); exit; end;
 val (edit5.text,LOS,i);
 if (i<>0) then begin showmessage('Error'); exit; end;
 val (edit6.text,ax,i);
 if (i<>0) then begin showmessage('Error'); exit; end;
 val (edit7.text,ay,i);
 if (i<>0) then begin showmessage('Error'); exit; end;
 Area:=(ax-2)*(ay-2);
 val (edit8.text,freespace,i);
 if (i<>0) then begin showmessage('Error'); exit; end;
 if (freespace<0) or (freespace>100) then begin showmessage('Error'); exit; end;
 basicrandom:=LOS/(Area*(freespace/100));

 sum:=0;
 Victory:=0;
 turns:=0;
 best:=-10000000; worst:=1000000;
 togethersum:=0;togetherturns:=0;
 for count:=1 to maxcount do begin
  PlayerHpSum:=0;
  for i:=1 to Np do begin P[i]:=PlayerHP; inc(PlayerHpSum,PlayerHp); end;
  for i:=1 to Nb do begin B[i]:=BotHP; mask[i]:=0; end;

  repeat
    //player turn
    for i:=1 to Nb do if mask[i]=1 then mask[i]:=2; //bot is fully functional
    //check how many bots are together?
    together:=0;
    for i:=1 to Nb do if (mask[i]>0) and (b[i]>0) then inc(together);
    if together>0 then begin
      inc(togethersum,together);
      inc(togetherturns);
    end;
    //is battle ongoing? then no search for trouble
    battle:=false;
    for i:=1 to Nb do if (mask[i]>0) and (B[i]>0) then battle:=true;
    //chance to find bots in LOS
    if not battle then
      for i:=1 to Nb do if mask[i]=0 then  //if bot unfound
        if random<basicrandom then mask[i]:=1; // chance to find it and mask it at 50%
    //fire at bots
    dam:=0;
    for i:=1 to Np do if P[i]>0 then inc(dam,stdamage);
    for i:=1 to Nb do if (mask[i]>0) and (B[i]>0) and (dam>0) then begin
      if mask[i]=2 then begin
        if dam>B[i] then begin dec(dam,B[i]); B[i]:=0; end
                    else begin dec(B[i],dam); dam:=0; end;
      end else
      if mask[i]=1 then begin
        if dam div 2>B[i] then begin dec(dam,B[i]); B[i]:=0; end
                          else begin dec(B[i],dam div 2); dam:=dam div 2; end;
      end;
    end;
    //bot turn
    flg:=calc;
    if not flg then begin
      for i:=1 to Nb do if mask[i]=1 then mask[i]:=2; //bot is fully functional
      //check how many bots are together?
      together:=0;
      for i:=1 to Nb do if (mask[i]>0) and (b[i]>0) then inc(together);
      if together>0 then begin
        inc(togethersum,together);
        inc(togetherturns);
      end;
      //is battle ongoing? then no search for trouble
      battle:=false;
      for i:=1 to Nb do if (mask[i]>0) and (B[i]>0) then battle:=true;
      //chance to find player in LOS
      for i:=1 to Nb do if mask[i]=0 then  //if bot unfound
        if not battle then begin
          if random<basicrandom then mask[i]:=1; // chance to find player and mask bot at 50%
        end else
          if random<sqr(basicrandom) then mask[i]:=1; // Player is not moving so easier to find him

      // fire at player
      dam:=0;
      for i:=1 to Nb do if (B[i]>0) then begin
        if mask[i]=2 then inc(dam,stdamage) else if mask[i]=1 then inc(dam,stdamage div 2);
      end;
      repeat
        for i:=1 to Np do if (P[i]>0) and (dam>0) and (random<0.3) then begin
          if dam>P[i] then begin dec(dam,P[i]); P[i]:=0; end
                      else begin dec(P[i],dam); dam:=0; end;
        end;
        flg:=calc;
      until (flg) or (dam=0);
      inc(turns);
    end;
  until flg;
//  memo1.lines.add(inttostr(P_hp)+':'+inttostr(B_hp)+' in '+inttostr(turns)+' turns');

  deviation^[count]:=P_hp-B_hp;
  sum+=P_hp-B_hp;
  if P_hp>0 then inc(Victory);
  if best<p_hp-B_Hp then best:=p_hp-b_hp;
  if worst>p_hp-b_hp then worst:=p_hp-b_hp;
 end;
 memo1.lines.add('Bots together: '+floattostr(round(Nb*basicrandom*100)/100));
 if togetherturns>0 then memo1.lines.add('Bots together (true): '+floattostr(round(togethersum/togetherturns*100)/100));
 memo1.lines.add('Best score: '+floattostr(round(best/PlayerHpSum*10000)/100)+'%');
 memo1.lines.add('Worst score: '+floattostr(round(worst/PlayerHpSum*10000)/100)+'%');
 avrg:=0;
 tmp:=0;
 for count:=1 to maxcount do if deviation^[count]>=sum/maxcount then begin avrg+=deviation^[count]; inc(tmp) end;
 if tmp>0 then
 memo1.lines.add('Average good score: '+floattostr(round(avrg/tmp/PlayerHpSum*10000)/100)+'%');
 avrg:=0;
 tmp:=0;
 for count:=1 to maxcount do if deviation^[count]<=sum/maxcount then begin avrg+=deviation^[count];  inc(tmp) end;
 if tmp>0 then
 memo1.lines.add('Average bad score: '+floattostr(round(avrg/tmp/PlayerHpSum*10000)/100)+'%');
 memo1.lines.add('');
 memo1.lines.add('Average score: '+floattostr(round(sum/maxcount/PlayerHpSum*10000)/100)+'%');
 deviationsum:=0;
 for count:=1 to maxcount do deviationsum+=sqr(deviation^[count]-sum/maxcount);
 deviationsum:=sqrt(deviationsum/maxcount);
 memo1.lines.add('Deviation: '+floattostr(round(deviationsum/PlayerHpSum*10000)/100)+'%');
 memo1.lines.add('Victory chance: '+floattostr(round(Victory/maxcount*10000)/100)+'%');
 memo1.lines.add('Turns: '+floattostr(round(turns/maxcount*10)/10));
 memo1.lines.add('---------------------------');
 dispose(deviation)
end;

procedure TForm1.Edit4Change(Sender: TObject);
begin

end;

end.

