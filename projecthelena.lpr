program projecthelena;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads, cmem,
  {$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, Unit1, castle_components;

{$R *.res}

begin
  Application.Title:='Project Helena';
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

