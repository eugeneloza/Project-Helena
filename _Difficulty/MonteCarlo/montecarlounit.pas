unit MonteCarloUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

const stdamage=16*255 div 50 div 2; {50%}
      maxcount=1000; //Monte-Carlo method
      // 1000 suitable for game = total 1% error
      // worst accuracy is for worst score - total 5% error for 1mln
      // to be more exact: worst score at wins and best scores at loose
const Np0=16; //max player bots
const Nb0=500; //max enemy bots

Type MonteCarloRecord=record
  botstogether:single;
  bestscore,worstscore:single;
  averagegoodscore,averagebadscore:single;
  averagescore:single;
  scoredeviation:Single;
  outofammochance:single;
  victorychance:single;
  battleturns:single;
end;

Function CalculateMonteCarlo(const Np,Nb,playerHP,BotHp,LOS,ax,ay,freespace:integer):MonteCarloRecord;

implementation

Function CalculateMonteCarlo(const Np,Nb,playerHP,BotHp,LOS,ax,ay,freespace:integer):MonteCarloRecord;
type deviationarray=array[1..maxcount] of integer;
var i:integer;
    flg:boolean;
    dam:integer;
    turns:integer;

    Area,tmp:integer;
    basicrandom:double;

    Victory,PlayerHpSum:integer;
    sum,avrg:double;
    count:integer;
    best,worst:integer;

    deviation:^deviationarray;
    deviationsum:double;

    together,togethersum,togetherturns:integer;

    battle:boolean;

    B,mask:array [1..Nb0] of integer;
    P:array[1..Np0] of integer;
    P_hp,B_hp:integer;

    pammo,ammopool,outofammo,botammo:integer;
    outofammoevent:boolean;

    function calc:boolean;
    var i:integer;
    begin
      P_hp:=0;
      for i:=1 to Np do inc(P_hp,P[i]);
      B_hp:=0;
      for i:=1 to Nb do inc(B_hp,B[i]);
      calc:= (P_hp=0) or (B_hp=0);
    end;
begin
 new(deviation);
 if (Np>Np0) then begin {showmessage('Error'); } exit; end;
 if (Nb>Nb0) then begin {showmessage('Error'); } exit; end;
 Area:=(ax-2)*(ay-2);
 if (freespace<0) or (freespace>100) then begin {showmessage('Error');} exit; end;
 basicrandom:=LOS/(Area*(freespace/100));

 outofammo:=0;

 sum:=0;
 Victory:=0;
 turns:=0;
 best:=-10000000; worst:=1000000;
 togethersum:=0;togetherturns:=0;
 for count:=1 to maxcount do begin
  PlayerHpSum:=0;

  outofammoevent:=false;
  pammo:=round(4*Np);
  botammo:=3;
  ammopool:=0;

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
    //collect ammo after battle
    if battle=false then begin
      inc(pammo,ammopool{div 2});
      ammopool:=0{ammopool div 2};
    end;
    //chance to find bots in LOS
    if not battle then
      for i:=1 to Nb do if mask[i]=0 then  //if bot unfound
        if random<basicrandom then begin mask[i]:=1; inc(ammopool,botammo) end; // chance to find it and mask it at 50%
    //fire at bots
    dam:=0;
    for i:=1 to Np do if P[i]>0 then inc(dam,stdamage);
    for i:=1 to Nb do if (mask[i]>0) and (B[i]>0) and (dam>0) then begin
      if (pammo>round(2*Np)) or (random<0.05) then begin
       dec(pammo);
        if mask[i]=2 then begin
          if dam>B[i] then begin dec(dam,B[i]); B[i]:=0; end
                      else begin dec(B[i],dam); dam:=0; end;
        end else
        if mask[i]=1 then begin
          if dam div 2>B[i] then begin dec(dam,B[i]); B[i]:=0; end
                            else begin dec(B[i],dam div 2); dam:=dam div 2; end;

        end;
      end else begin
        if outofammoevent=false then begin inc(outofammo); outofammoevent:=true; end;
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
          if random<basicrandom then begin mask[i]:=1; inc(ammopool,botammo) end; // chance to find player and mask bot at 50%
        end else
          if random<sqr(basicrandom) then begin mask[i]:=1; inc(ammopool,botammo) end; // Player is not moving so easier to find him

      // fire at player
      dam:=0;
      for i:=1 to Nb do if (B[i]>0) then begin
        if mask[i]=2 then inc(dam,stdamage) else if mask[i]=1 then inc(dam,stdamage div 2);
      end;
      repeat
        for i:=1 to Np do if (P[i]>0) and (dam>0) and (random<0.3) then begin
          //dec(ammopool);
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

 with result do begin
   if togetherturns>0 then botstogether:=togethersum/togetherturns;
   bestscore:=best/PlayerHpSum;
   worstscore:=worst/PlayerHpSum;

   avrg:=0;
   tmp:=0;
   for count:=1 to maxcount do if deviation^[count]>=sum/maxcount then begin avrg+=deviation^[count]; inc(tmp) end;
   if tmp>0 then
     averagegoodscore:=avrg/tmp/PlayerHpSum;

   avrg:=0;
   tmp:=0;
   for count:=1 to maxcount do if deviation^[count]<=sum/maxcount then begin avrg+=deviation^[count];  inc(tmp) end;
   if tmp>0 then
   averagebadscore:=avrg/tmp/PlayerHpSum;

   averagescore:=sum/maxcount/PlayerHpSum;

   deviationsum:=0;
   for count:=1 to maxcount do deviationsum+=sqr(deviation^[count]-sum/maxcount);
   deviationsum:=sqrt(deviationsum/maxcount);
   scoredeviation:= deviationsum/PlayerHpSum;

   victorychance:=Victory/maxcount;
   battleturns:=turns/maxcount;
   outofammochance:=outofammo/maxcount;
 end;

 dispose(deviation)
end;

end.

