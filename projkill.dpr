program projkill;

uses
  Vcl.Forms,
  frmPrincipal in 'frmPrincipal.pas' {TaskKiller};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TTaskKiller, TaskKiller);
  Application.Run;
end.
