unit uGame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  System.Generics.Collections,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Effects, FMX.StdCtrls, Math, FMX.Ani, FMX.Filter.Effects, FMX.Layouts,System.IOUtils,
  System.IniFiles, FMX.Platform, FMX.Advertising,
  Interfaces.Controller.GUI, uGameOver, uReady, FMX.Controls.Presentation;

type
  TGameForm = class(TForm, Interfaces.Controller.GUI.IAppGUI)
    BackGroundImage: TImage;
    BirdSprite: TImage;
    ScoreLBL: TLabel;
    GlowEffect1: TGlowEffect;
    Ground: TRectangle;
    GroundB: TImage;
    GroundA: TImage;
    FBird1: TImage;
    FBird2: TImage;
    FBird3: TImage;
    BigPipe: TLayout;
    TopPipe: TRectangle;
    TopPipeCap: TRectangle;
    MyReadyFrame: TReadyFrame;
    MyGameOverFrame: TGameOverFrame;
    Timer: TTimer;
    GroundLayout: TLayout;
    procedure FormCreate(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure GetReadyLayoutClick(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure MyGameOverFrameReplayBTNClick(Sender: TObject);
    procedure MyGameOverFrameOKBTNClick(Sender: TObject);
  private
    FController: IAppController;
    type
     TOnCreateGUI = reference to procedure(const AGUI: IAppGUI);
    class var
     FOnCreateGUI: TOnCreateGUI;
  protected
    procedure RegisterController(const AController: IAppController);
    function GetGamePanelSize: TSizeF;
    function GetPipeSize: TSizeF;
    function GetBirdSize: TSizeF;
    function GetBirdPoint: TPointF;
    procedure ResetGame;
    procedure GameOver(AScore, ABestScore: Integer);
    procedure AddPipe(APipe: TPipe);
    procedure RemovePipe(APipe: TPipe);
    procedure MovePipe(APipe: TPipe);
    procedure SetBird(ABird: TBird);
    procedure SetScore(AScore: Integer);
  public
    IniFileName: String;
    procedure Run;
    class property OnCreateGUI: TOnCreateGUI read FOnCreateGUI write FOnCreateGUI;

    procedure Propaganda(Banner : TBannerAd; ID : string);
    procedure PropagandaEsconde(Banner : TBannerAd);
  end;

var
  GameForm: TGameForm;

implementation

{$R *.fmx}

uses uMenu, uDmStyle;

// ------------------------- INTERFACE ------------------------- //

procedure TGameForm.RegisterController(const AController: IAppController);
begin
 FController:= AController;
end;

function TGameForm.GetGamePanelSize: TSizeF;
begin
 Result:= TSizeF.Create(GameForm.Width,GameForm.Height-(Ground.Height+GroundLayout.Height));
end;

function TGameForm.GetPipeSize: TSizeF;
begin
 Result:= TSizeF.Create(BigPipe.Width,BigPipe.Height);
end;

function TGameForm.GetBirdSize: TSizeF;
begin
 Result:= TSizeF.Create(BirdSprite.Width,BirdSprite.Height);
end;

function TGameForm.GetBirdPoint: TPointF;
begin
  Result:= TPointF.Create(BirdSprite.Position.X,BirdSprite.Position.Y);
end;

procedure TGameForm.ResetGame;
begin
  Application.ProcessMessages;
end;

procedure TGameForm.GameOver(AScore, ABestScore: Integer);
begin
  Propaganda(MyGameOverFrame.BannerAd1, 'ca-app-pub-4608094404416880/8453766253');

  MyGameOverFrame.GOScoreLBL.Text:= IntToStr(AScore);
  MyGameOverFrame.BestScoreLbl.Text:= IntToStr(ABestScore);
  MyGameOverFrame.BringToFront;
  MyGameOverFrame.Visible:= True;
  ScoreLBL.Visible:= False;
  MyGameOverFrame.GOFloat.Enabled := True;
end;

procedure TGameForm.AddPipe(APipe: TPipe);
var R: TLayout;
begin
  // GameForm.BeginUpdate;
  R:= TLayout(BigPipe.Clone(Self));
  R.Parent:= GameForm;
  R.Visible:= True;
  R.Position.X:= APipe.Position.X;
  R.Position.Y:= APipe.Position.Y;
  R.RotationAngle:= APipe.Angle;
  R.Tag:= APipe.Tag;
  APipe.Layout:= R;

  Ground.BringToFront;
  GroundLayout.BringToFront;
  ScoreLBL.BringToFront;
  // GameForm.EndUpdate;
end;

procedure TGameForm.RemovePipe(APipe: TPipe);
begin
 APipe.Layout.DisposeOf;
end;

procedure TGameForm.MovePipe(APipe: TPipe);
begin
// GameForm.BeginUpdate;
 if Assigned(APipe.Layout) then
  APipe.Layout.Position.X:= APipe.Position.X;
// GameForm.EndUpdate;
end;

procedure TGameForm.MyGameOverFrameOKBTNClick(Sender: TObject);
begin
  MyGameOverFrame.Position.Y := GameForm.Height;
  MyGameOverFrame.Visible := False;
  PropagandaEsconde(MyGameOverFrame.BannerAd1);

  GameForm.Close;
  MenuForm.Show;
end;

procedure TGameForm.MyGameOverFrameReplayBTNClick(Sender: TObject);
begin
  MyGameOverFrame.Position.Y := GameForm.Height;
  MyGameOverFrame.Visible:= False;
  PropagandaEsconde(MyGameOverFrame.BannerAd1);
  Propaganda(MyReadyFrame.BannerAd1, 'ca-app-pub-4608094404416880/8453766253');

  MyReadyFrame.Visible:= True;
  FController.Replay;
end;

procedure TGameForm.Propaganda(Banner: TBannerAd; ID : string);
begin
  {Propaganda}
  if Banner.AdUnitID = EmptyStr then
  begin
    {$IFDEF DEBUG}
    Banner.TestMode := True;
    {$ENDIF}
    Banner.AdUnitID := ID;

  end;
  Banner.LoadAd;
  Banner.Visible := True;
end;

procedure TGameForm.PropagandaEsconde(Banner: TBannerAd);
begin
  if Banner.Visible then
    Banner.Visible  := False;
end;

procedure TGameForm.SetBird(ABird: TBird);
begin
 BirdSprite.Position.X:= ABird.Position.X;
 BirdSprite.Position.Y:= ABird.Position.Y;
 BirdSprite.RotationAngle:= ABird.Angle;
 if ABird.Flap then
  BirdSprite.Bitmap.Assign(FBird1.Bitmap)
 else
  BirdSprite.Bitmap.Assign(FBird2.Bitmap);
end;

procedure TGameForm.SetScore(AScore: Integer);
begin
 ScoreLBL.Text:= IntToStr(AScore);
end;

procedure TGameForm.TimerTimer(Sender: TObject);
begin
  if {MyReadyFrame.Visible OR} MyGameOverFrame.Visible then
    Exit;

  if GroundLayout.Tag = 0 then
  begin
    GroundB.Opacity := 1;
    GroundLayout.Tag := 1;
  end
  else
  begin
    GroundB.Opacity := 0;
    GroundLayout.Tag := 0;
  end;
end;

// ----------------------- END INTERFACE ----------------------- //

procedure TGameForm.FormCreate(Sender: TObject);
begin
 if Assigned(FOnCreateGUI) then
  FOnCreateGUI(Self);

 MyGameOverFrame.GOFloat.StopValue := 0;
 MyGameOverFrame.GOFloat.StartValue := GameForm.Height;
 MyGameOverFrame.Position.Y := GameForm.Height;
 IniFileName := System.IOUtils.TPath.GetDocumentsPath + System.SysUtils.PathDelim + 'Scores.dat';
end;

procedure TGameForm.FormHide(Sender: TObject);
begin
  MenuForm.Show;
end;

procedure TGameForm.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
  FController.Tapped;
end;

procedure TGameForm.GetReadyLayoutClick(Sender: TObject);
begin
  MyReadyFRame.Visible:= False;
  PropagandaEsconde(MyReadyFrame.BannerAd1);
  ScoreLBL.Visible:= True;
  FController.StartGame;
end;

procedure TGameForm.Run;
begin
  FController.Replay;
  MyGameOverFrame.Visible:= False;
  PropagandaEsconde(MyGameOverFrame.BannerAd1);

  Propaganda(MyReadyFrame.BannerAd1, 'ca-app-pub-4608094404416880/8453766253');

  MyReadyFrame.Visible:= True;
end;

end.
