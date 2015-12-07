program FlappyBird;

uses
  System.StartUpCopy,
  FMX.MobilePreview,
  FMX.Forms,
  uMenu in 'uMenu.pas' {MenuForm},
  uGame in 'uGame.pas' {GameForm},
  AppController in 'AppController.pas',
  Interfaces.Controller.GUI in 'Interfaces.Controller.GUI.pas',
  AppData in 'AppData.pas',
  uGameOver in 'uGameOver.pas' {GameOverFrame: TFrame},
  uReady in 'uReady.pas' {ReadyFrame: TFrame};

{$R *.res}

var Controller: IAppController;
begin
 // ReportMemoryLeaksOnShutdown := True;

  Controller:= TAppController.Create;

  TGameForm.OnCreateGUI:= procedure(const AGUI: IAppGUI)
   begin
    Controller.RegisterGUI(AGUI);
   end;

  Application.Initialize;
  Application.FormFactor.Orientations := [TFormOrientation.Portrait];
  Application.CreateForm(TMenuForm, MenuForm);
  Application.CreateForm(TGameForm, GameForm);
  Application.Run;
end.
