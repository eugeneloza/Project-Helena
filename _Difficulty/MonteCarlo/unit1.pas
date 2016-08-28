unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, MonteCarloUnit;

const VictoryChanceAmount=1000;

type

  { TForm1 }

  TForm1 = class(TForm)
    Image1: TImage;
    Image2: TImage;
    Memo1: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { private declarations }
  public
    procedure Draw_data;
    procedure Calculate_difficulty;
  end;

type staterecord=record
  pn,php,en,ehp:integer;
end;

type battlerecord=record
  maxx,maxy:integer;
  maptype:String;
  Free,LOS,LOSadjusted:single;
  start,finish:staterecord;
  turns:integer;
  filename:string;

  //calculated
  difficulty,conclusion:single;
  averageenemyhp,averageplayerhp:single;
  maparea:integer;
  victory:Boolean;
  MonteCarlo:MonteCarloRecord;
end;

var
  Form1: TForm1;
  battles: array of battlerecord;
  VictoryChance,VictoryChanceCarlo:array [0..VictoryChanceAmount] of single;
  maxXaxis,minXaxis,maxYaxis,minYaxis,scaleXaxis,scaleYaxis,maxZaxis,minZaxis,scaleZaxis:single;
  txt: text;

implementation

{$R+}{$Q+}

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
var Rec : TSearchRec;
    s,g:string;
    isStart:boolean;
    i,j:integer;
    duplicate:boolean;
    ancienterror:boolean;
begin
 //basic result 1=1
 setlength(battles,length(battles)+1);
 with battles[length(battles)-1] do begin
   filename:='n/a';
   maptype:='n/a';
   maxx:=35;
   maxy:=35;
   free:=0.5;
   los:=20;
   start.pn:=1;
   start.php:=1;
   start.en:=1;
   start.ehp:=0;
   finish.pn:=1;
   finish.php:=1;
   finish.en:=0;
   finish.ehp:=0;
   turns:=0;
 end;

  if FindFirst ('data'+pathdelim+'battle*.txt', faAnyFile - faDirectory, Rec) = 0 then begin
    try
    repeat
      AssignFile(txt,'data'+pathdelim+Rec.Name);
      reset(txt);
      setlength(battles,length(battles)+1);
      isStart:=true;
      battles[length(battles)-1].filename:=Rec.Name;
      with battles[length(battles)-1] do
      repeat
        readln(txt,s);

        g:='Map size: ';
        for j:=0 to 1 do begin
          if copy(s,1,length(g))=g then begin
            i:=length(g)+1;
            g:='';
            repeat
              g:=g+copy(s,i,1);
              inc(i);
            until copy(s,i,1)='x';
            maxx:=strtoint(g);
            maxy:=strtoint(copy(s,i+1,length(s)-i));
            readln(txt,maptype);
            //bugfix for older reports
            g:='Adding building ';
            ancienterror:=copy(maptype,1,length(g))=g;
            g:='Box building created.';
            ancienterror:=ancienterror or (copy(maptype,1,length(g))=g);
            if ancienterror then begin
              g:='Map inhomogenity: ';
              repeat
                readln(txt,maptype);
              until copy(maptype,1,length(g))=g;
              readln(txt,maptype);
            end;
          end;
          g:='Размер карты: ';
        end;

        g:='Map free area: ';
        for j:=0 to 1 do begin
          if copy(s,1,length(g))=g then free:=strtoint(copy(s,length(g)+1,length(s)-length(g)-1))/100;
          g:='Свободное место: ';
        end;
        g:='Average LOS = ';
        for j:=0 to 1 do begin
          if copy(s,1,length(g))=g then LOS:=strtoint(copy(s,length(g)+1,length(s)-length(g)));
          g:='Средний LOS = ';
        end;
        g:='LOS adjusted = ';
        for j:=0 to 1 do begin
          if copy(s,1,length(g))=g then LOSAdjusted:=strtoint(copy(s,length(g)+1,length(s)-length(g)));
          g:='Уточнённый LOS = ';
        end;
        if isStart then begin
          g:='Player units = ';
          for j:=0 to 1 do begin
            if copy(s,1,length(g))=g then start.pn:=strtoint(copy(s,length(g)+1,length(s)-length(g)));
            g:='Ботов игрока = ';
          end;
          g:='Total Player HP = ';
          for j:=0 to 1 do begin
            if copy(s,1,length(g))=g then start.php:=strtoint(copy(s,length(g)+1,length(s)-length(g)));
            g:='Сумма HP ботов игрока = ';
          end;
          g:='Enemy bots = ';
          for j:=0 to 1 do begin
            if copy(s,1,length(g))=g then start.en:=strtoint(copy(s,length(g)+1,length(s)-length(g)));
            g:='Ботов врага = ';
          end;
          g:='Total bot HP = ';
          for j:=0 to 1 do begin
            if copy(s,1,length(g))=g then start.ehp:=strtoint(copy(s,length(g)+1,length(s)-length(g)));
            g:='Сумма HP ботов врага = ';
          end;
          g:='Difficulty = ';
          for j:=0 to 1 do begin
            if copy(s,1,length(g))=g then isStart:=false;
            g:='Сложность = ';
          end;
        end else begin
          g:='Player units = ';
          for j:=0 to 1 do begin
            if copy(s,1,length(g))=g then finish.pn:=strtoint(copy(s,length(g)+1,length(s)-length(g)));
            g:='Ботов игрока = ';
          end;
          g:='Total Player HP = ';
          for j:=0 to 1 do begin
            if copy(s,1,length(g))=g then finish.php:=strtoint(copy(s,length(g)+1,length(s)-length(g)));
            g:='Сумма HP ботов игрока = ';
          end;
          g:='Enemy bots = ';
          for j:=0 to 1 do begin
            if copy(s,1,length(g))=g then finish.en:=strtoint(copy(s,length(g)+1,length(s)-length(g)));
            g:='Ботов врага = ';
          end;
          g:='Total bot HP = ';
          for j:=0 to 1 do begin
            if copy(s,1,length(g))=g then finish.ehp:=strtoint(copy(s,length(g)+1,length(s)-length(g)));
            g:='Сумма HP ботов врага = ';
          end;
        end;
        g:='TURN: ';
        for j:=0 to 1 do begin
          if copy(s,1,length(g))=g then turns:=strtoint(copy(s,length(g)+1,length(s)-length(g)));
          g:='ХОД: ';
        end;
      until eof(txt);
      closefile(txt);
    until FindNext(Rec) <> 0;
    finally
      FindClose(Rec) ;
    end;
  end;

  AssignFile(txt,'data'+pathdelim+'old.txt');
  reset(txt);
  j:=0;
  repeat
    inc(j);
    setlength(battles,length(battles)+1);
    with battles[length(battles)-1] do
      readln(txt,maxx,maxy,free,los,start.pn,start.php,start.en,start.ehp,finish.pn,finish.php,finish.en,finish.ehp,turns,maptype);
    duplicate:=false;
    with battles[length(battles)-1] do
    for i:=low(battles) to high(battles)-1 do
      if (battles[i].start.ehp=start.ehp) and
         (battles[i].start.php=start.php) and
         (battles[i].start.pn=start.pn) and
         (battles[i].start.en=start.en) and
         (battles[i].finish.ehp=finish.ehp) and
         (battles[i].finish.php=finish.php) and
         (battles[i].finish.pn=finish.pn) and
         (battles[i].finish.en=finish.en) then duplicate:=true;
    battles[length(battles)-1].filename:='old.txt:'+inttostr(j);
    battles[length(battles)-1].maptype:=copy(battles[length(battles)-1].maptype,2,length(battles[length(battles)-1].maptype));
    if duplicate then setlength(battles,length(battles)-1);
  until eof(txt);
  closefile(txt);


  memo1.clear;
  memo1.lines.add(inttostr(length(battles))+' records read');

  calculate_difficulty;
  draw_data;
end;

{======================================================================}


procedure TForm1.Image1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var diff,concl,d,d1:single;
    i,k:integer;
begin
  diff:=x/scaleXaxis+minXaxis;
  concl:=(image1.height-y)/scaleYaxis+minYaxis;
  k:=0;
  d:=sqr(diff-battles[k].difficulty)+sqr(concl-battles[k].conclusion);
  for i:=low(battles) to high(battles) do begin
    d1:=sqr(diff-battles[i].difficulty)+sqr(concl-battles[i].conclusion);
    if d1<d then begin
      d:=d1;
      k:=i;
    end;
  end;

  memo1.clear;
  with battles[k] do begin
    memo1.lines.add('file : '+filename);
    memo1.lines.add('');
    memo1.lines.add('maptype = '+maptype);
    memo1.lines.add('map = '+inttostr(maxx)+'x'+inttostr(maxy));
    memo1.lines.add('map area = '+inttostr(maparea));
    memo1.lines.add('map free = '+inttostr(round(Free*100))+'%');
    memo1.lines.add('LOS = '+inttostr(round(LOS)));
    memo1.lines.add('LOS adj. = '+inttostr(round(LOSadjusted)));
    memo1.lines.add('start:');
    memo1.lines.add('p bots = '+inttostr(start.pn));
    memo1.lines.add('p hp = '+inttostr(start.php));
    memo1.lines.add('average = '+inttostr(round(averageplayerhp)));
    memo1.lines.add('e bots = '+inttostr(start.en));
    memo1.lines.add('e hp = '+inttostr(start.ehp));
    memo1.lines.add('average = '+inttostr(round(averageenemyhp)));
    memo1.lines.add('finish:');
    memo1.lines.add('p bots = '+inttostr(finish.pn));
    memo1.lines.add('p hp = '+inttostr(finish.php));
    memo1.lines.add('e bots = '+inttostr(finish.en));
    memo1.lines.add('e hp = '+inttostr(finish.ehp));
    memo1.lines.add('turns = '+inttostr(turns));
    memo1.lines.add('');
    memo1.lines.add('calculated:');
    memo1.lines.add('difficulty = '+inttostr(round(difficulty*100))+'%');
    memo1.lines.add('Conclusion = '+inttostr(round(conclusion*100))+'%');

    memo1.lines.add('');
    with MonteCarlo do begin
      Memo1.lines.add('--- MonteCarlo results ---');
      memo1.lines.add('Victory chance: '+floattostr(round(victorychance*10000)/100)+'%');
      memo1.lines.add('Average score: '+floattostr(round(averagescore*10000)/100)+'%');
      memo1.lines.add('Best score: '+floattostr(round(bestscore*10000)/100)+'%');
      memo1.lines.add('Average good score: '+floattostr(round(averagegoodscore*10000)/100)+'%');
      memo1.lines.add('Average bad score: '+floattostr(round(averagebadscore*10000)/100)+'%');
      memo1.lines.add('Worst score: '+floattostr(round(worstscore*10000)/100)+'%');
      memo1.lines.add('Deviation: '+floattostr(round(scoredeviation*10000)/100)+'%');
      memo1.lines.add('Chance of ammo shortage: '+floattostr(round(outofammochance*10000)/100)+'%');
      memo1.lines.add('Turns: '+floattostr(round(battleturns*10)/10));
      memo1.lines.add('Bots together (true): '+floattostr(round(botstogether*100)/100));
    end;

  end;
end;

{======================================================================}

procedure TForm1.Draw_Data;
var i,x1,y1:integer;
begin
 with image1.Canvas do begin
   brush.color:=clWhite;
   fillrect(0,0,image1.width,image1.height);
   pen.color:=clblack;
   pen.width:=1;
   y1:=image1.height-round((0-minYaxis)*scaleYaxis);
   moveto(0,y1);lineto(image1.width,y1);

   moveto(0,0);lineto(round((maxXaxis-minXaxis)*scaleXaxis),round((maxXaxis-minXaxis)*scaleYaxis));

   for i:=low(battles) to high(battles) do with battles[i] do begin
     if (MonteCarlo.averagebadscore-MonteCarlo.scoredeviation<conclusion) and (MonteCarlo.averagegoodscore+MonteCarlo.scoredeviation>conclusion) then pen.color:=clBlue else pen.color:=clFuChSia;
     if (MonteCarlo.averagebadscore<conclusion) and (MonteCarlo.averagegoodscore>conclusion) then pen.color:=clgreen;
     if (MonteCarlo.worstscore>conclusion) or (MonteCarlo.bestscore<conclusion) then pen.color:=clred;
     pen.width:=3+round((maparea-minZaxis)*scaleZaxis);
     x1:=round((difficulty-minXaxis)*scaleXaxis);
     y1:=image1.height-round((conclusion-minYaxis)*scaleYaxis);
     moveto(x1,y1);lineto(x1,y1);
   end;
 end;

 with image2.canvas do begin
   fillrect(0,0,image2.width,image2.height);
   pen.color:=clblack;
   pen.width:=1;
   moveto(0,image2.height div 2);lineto(image2.width,image2.height div 2);
   moveto(0,0);
   pen.color:=clblue;
   for i:=0 to VictoryChanceAmount do
     lineto(round(image2.width*i/VictoryChanceAmount),round((1-VictoryChance[i])*image2.height));
   moveto(0,0);
   pen.color:=clgreen;
   for i:=0 to VictoryChanceAmount do
     lineto(round(image2.width*i/VictoryChanceAmount),round((1-VictoryChanceCarlo[i])*image2.height));
 end;
end;

{======================================================================}


procedure TForm1.calculate_difficulty;
var i,j,k:integer;
    v,d,t,r:single;
    outofmodel:integer;
begin
 for i:=low(battles) to high(battles) do with battles[i] do begin
   averageenemyhp:=start.ehp/start.en;
   averageplayerhp:=start.php/start.pn;
   if finish.php>0 then
     conclusion:=finish.php/start.php
   else
     conclusion:=-finish.ehp/start.php;
   if finish.php>0 then victory:=true else victory:=false;

   if LOSadjusted=0 then begin
     LOSadjusted:=25*3.1415*Free;
     if LOS>LOSadjusted then LOSadjusted:=LOS;
   end;

   MonteCarlo:=CalculateMonteCarlo(start.pn,start.en,round(averageplayerhp),round(averageenemyhp),round(LOSadjusted*1.12),maxx,maxy,round(free*100));

   maparea:=(maxx-2)*(maxy-2);
   difficulty:=-MonteCarlo.averagescore{start.ehp/start.php};
 end;

 maxXaxis:=battles[0].difficulty;
 minXaxis:=maxXaxis;
 maxYaxis:=battles[0].conclusion;
 minYaxis:=maxYaxis;
// maxZaxis:=battles[0].maparea;
 maxZaxis:=battles[0].Averageenemyhp;
 minZaxis:=maxZaxis;
 for i:=low(battles) to high(battles) do with battles[i] do begin
   if battles[i].difficulty>maxXaxis then maxXaxis:=battles[i].difficulty;
   if battles[i].difficulty<minXaxis then minXaxis:=battles[i].difficulty;
   if battles[i].conclusion>maxYaxis then maxYaxis:=battles[i].conclusion;
   if battles[i].conclusion<minYaxis then minYaxis:=battles[i].conclusion;
   if battles[i].maparea>maxZaxis then maxZaxis:=battles[i].maparea;
   if battles[i].maparea<minZaxis then minZaxis:=battles[i].maparea;
 end;
 scaleXaxis:=image1.width/(maxXaxis-minXaxis);
 scaleYaxis:=image1.height/(maxYaxis-minYaxis);
 scaleZaxis:=10/(maxZaxis-minZaxis);

 for j:=0 to VictoryChanceAmount do begin
   d:=0;v:=0;
   t:=(maxXaxis-minXaxis)*j/VictoryChanceAmount+minXaxis;
   for i:=low(battles) to high(battles) do if abs(t-battles[i].difficulty)<(maxXaxis-minXaxis)/20 then begin
     //r:=1/((sqr(t-battles[i].difficulty))+2/VictoryChanceAmount);
     if battles[i].finish.php>0 then v+=1 else d+=1;
   end;
   if v+d>0 then VictoryChance[j]:=v/(v+d) else
     if j>0 then VictoryChance[j]:=VictoryChance[j-1] else VictoryChance[j]:=1;
 end;

 for j:=0 to VictoryChanceAmount do begin
   t:=(maxXaxis-minXaxis)*j/VictoryChanceAmount+minXaxis;
   v:=0;k:=0;
   for i:=low(battles) to high(battles) do if abs(t-battles[i].difficulty)<(maxXaxis-minXaxis)/20 then begin
     inc(k);
     v+=(battles[i].MonteCarlo.victorychance);
   end;
   if k>0 then VictoryChanceCarlo[j]:=v/k else
     if j>0 then VictoryChanceCarlo[j]:=VictoryChanceCarlo[j-1] else VictoryChanceCarlo[j]:=1;
 end;

 r:=0;
 for i:=low(battles) to high(battles) do r+=sqr(battles[i].MonteCarlo.averagescore-battles[i].conclusion);
 memo1.lines.add('average line error = '+floattostr(round(sqrt(r)/length(battles)*100000)/100000));
 outofmodel:=0;
 for i:=low(battles) to high(battles) do if (battles[i].MonteCarlo.averagebadscore<battles[i].conclusion) and (battles[i].MonteCarlo.averagegoodscore>battles[i].conclusion) then inc(outofmodel);
 memo1.lines.add('outofmodel rigorous = '+floattostr(round((length(battles)-outofmodel)/length(battles)*100000)/1000)+'%');
 outofmodel:=0;
 for i:=low(battles) to high(battles) do if (battles[i].MonteCarlo.averagebadscore-battles[i].MonteCarlo.scoredeviation<battles[i].conclusion) and (battles[i].MonteCarlo.averagegoodscore+battles[i].MonteCarlo.scoredeviation>battles[i].conclusion) then inc(outofmodel);
 memo1.lines.add('outofmodel deviation = '+floattostr(round((length(battles)-outofmodel)/length(battles)*100000)/1000)+'%');
 outofmodel:=0;
 for i:=low(battles) to high(battles) do if (battles[i].MonteCarlo.worstscore>battles[i].conclusion) or (battles[i].MonteCarlo.bestscore<battles[i].conclusion) then inc(outofmodel);
 memo1.lines.add('outofmodel absolute = '+floattostr(round((outofmodel)/length(battles)*100000)/1000)+'%');
end;

end.

