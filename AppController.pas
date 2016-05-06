unit AppController;

interface

uses
  SysUtils, Classes, Math,
  System.Generics.Collections, SyncObjs, System.Types, FMX.Types, FMX.Media,
  AppData, Interfaces.Controller.GUI, IOUtils, uMusic;

type
  TAddPipe = procedure(AYOffset: Double; Bottom: Boolean) of object ;

  TCalculator = class(TThread)
  private
   FGameTicker: Integer;
   FPipeAPos: Integer;
   FPipeBPos: Integer;
   FAddPipe: TAddPipe;
   FActive: Boolean;
  protected
   procedure Execute; override;
  public
   constructor Create;
   property AddPipe: TAddPipe read FAddPipe write FAddPipe;
  end;

 TAppController = class(TInterfacedObject, Interfaces.Controller.GUI.IAppController)
 private
  FGUI: IAppGUI;
  FData: TAppData;
  FPipes: TPipes;
  FBird: TBird;
  FTimer: TTimer; // quick and dirty
  FUpdater: TCalculator;
  procedure RegisterGUI(const AGUI: IAppGUI);
  procedure StartGame;
  procedure StopGame;
  procedure Replay;
  procedure ResetGame;
  procedure GameOver;
  procedure Tapped;
  procedure RemovePipes;
  procedure IncScore;
  procedure SetBird(APosition: TPointF; AAngle: Double; Flap: Boolean); overload;
  procedure SetBird(AYOffset,AAngle: Double; Flap: Boolean); overload;
  procedure AddPipe(AYOffset: Double; Bottom: Boolean);
  function HitBorder: Boolean;
  function HitPipe: Boolean;
  function OvercomePipe: Boolean;
  function CheckBoundryCollision(APipe: TPipe; OffSetY : LongInt = 2; OffSetX : LongInt = 2): Boolean;

  procedure MainLoop(ASender: TObject);
  procedure InitPipe;
  procedure InitBird;
 public
  destructor Destroy; override;
 end;

const
 DEF_BIRD_ANGLE = 0;
 SPAWN_TIME = 1.5;

var
 Mutex: TCriticalSection;
 BirdYPos: Double;
 BirdAngle: Double;
 BirdUp: Boolean;
 Flap: Boolean;
 GamePanelSize: TSizeF;

implementation

{ TAppController }


procedure TAppController.RegisterGUI(const AGUI: IAppGUI);
begin
  FGUI:= AGUI;
  FGUI.RegisterController(Self);
  FData:= TAppData.Create;
  Mutex:= TCriticalSection.Create;
  FPipes:= TObjectList<TPipe>.Create;

  InitPipe;
  InitBird;

  Randomize;

  FUpdater := TCalculator.Create;
  FUpdater.Start;
  FTimer:= TTimer.Create(nil);
  FTimer.Interval:=33;
  FTimer.Enabled:= false;
  FTimer.OnTimer:= MainLoop;
end;

procedure TAppController.StartGame;
begin
 ResetGame;
 FUpdater.AddPipe := AddPipe;
 FTimer.Enabled := true;
 FUpdater.FActive := True;
end;

procedure TAppController.StopGame;
begin
 FUpdater.FActive := False;
 // this causes crashes on Android sometimes so I made it a pool and it just re-uses the thread
 //FUpdater.Terminate;
 //FUpdater.WaitFor;
 //FUpdater.DisposeOf;
 FTimer.Enabled := False;
end;

procedure TAppController.Replay;
begin
 ResetGame;
end;

procedure TAppController.ResetGame;
begin
  RemovePipes;
  BirdYPos:= TBird.DefPosition.Y;
  BirdAngle:= DEF_BIRD_ANGLE;
  BirdUp:= False;
  Flap:= False;
  GamePanelSize:= FGUI.GetGamePanelSize;
  SetBird(TBird.DefPosition,DEF_BIRD_ANGLE,False);

  FData.ResetScore;
  FGUI.SetScore(FData.GetScore);
  FGUI.ResetGame;
end;

procedure TAppController.GameOver;
begin
  if FData.GetScore >= FData.GetHighscore then
    FData.SaveScore(FData.GetHighscore);
  TMusic.Create(TSom.Hit);
  StopGame;
  FGUI.GameOver(FData.GetScore, FData.GetHighscore);
end;

procedure TAppController.Tapped;
begin
  Mutex.Enter;
  BirdUp:= True;
  TMusic.Create(TSom.Wing);
  Mutex.Leave;
end;

procedure TAppController.RemovePipes;
var n: Integer;
begin
  for n:= 0 to FPipes.Count-1 do
    FGUI.RemovePipe(TPipe(FPipes.Items[n]));
  FPipes.Clear;
end;

procedure TAppController.IncScore;
begin
  TMusic.Create(TSom.Pointer);
  FData.IncScore;
  FGUI.SetScore(FData.GetScore);
end;

procedure TAppController.SetBird(APosition: TPointF; AAngle: Double; Flap: Boolean);
begin
  FBird.Position:= APosition;
  FBird.Angle:= AAngle;
  FBird.Flap:= Flap;
  FGUI.SetBird(FBird);
end;

procedure TAppController.SetBird(AYOffset,AAngle: Double; Flap: Boolean);
begin
  FBird.Position:= PointF(FBird.DefPosition.X,FBird.Position.Y+AYOffset);
  FBird.Angle:= AAngle;
  FBird.Flap:= Flap;
  FGUI.SetBird(FBird);
end;

procedure TAppController.AddPipe(AYOffset: Double; Bottom: Boolean);
begin
  FPipes.Add(TPipe.Create);
  TPipe(FPipes.Last).Position:= PointF(GamePanelSize.Width,AYOffset);
  if Bottom then
    TPipe(FPipes.Last).Angle:= 180
  else
    TPipe(FPipes.Last).Angle:= 0;
  TPipe(FPipes.Last).Tag:= Integer(Bottom)+1;
  TPipe(FPipes.Last).TagFloat:= 0;
  TPipe(FPipes.Last).Added:= false;
  TPipe(FPipes.Last).Layout:= nil;
end;

procedure TAppController.MainLoop(ASender: TObject);
var n: Integer;
    aPipe: TPipe;
    GameOverCheck: Boolean;
begin
 GameOverCheck:= false;
 if HitBorder then
  GameOverCheck:= true;

 Mutex.Enter;
 // this should be also threaded
 for n:= FPipes.Count-1 downto 0 do
 begin
  if Assigned(FPipes.Items[n]) then
   begin
    aPipe:= TPipe(FPipes.Items[n]);
    aPipe.Position:= PointF(aPipe.Position.X-5,aPipe.Position.Y);
    if not aPipe.Added then
    begin
     FGUI.AddPipe(aPipe);
     aPipe.Added:= true;
    end;
    FGUI.MovePipe(aPipe);

    // is pipe outside the visible area? - then delete it
    if (aPipe.Position.X<((aPipe.Size.Width*-1)-10)) then
    begin
     FGUI.RemovePipe(aPipe);
     FPipes.Delete(n);
    end;
   end;
 end;
 if HitPipe then
  GameOverCheck:= true
 else
  if OvercomePipe then
   IncScore;

 SetBird(BirdYPos,BirdAngle,Flap);
 Mutex.Leave;

 if GameOverCheck then
  GameOver;
end;

procedure TAppController.InitPipe;
begin
 TPipe.Size:= FGUI.GetPipeSize;
end;

procedure TAppController.InitBird;
begin
 FBird:= TBird.Create;
 TBird.Size:= FGUI.GetBirdSize;
 TBird.DefPosition:= FGUI.GetBirdPoint;
end;

function TAppController.HitBorder: Boolean;
begin
 Result:= ((FBird.Position.Y+TBird.Size.Height)>=GamePanelSize.Height) or
          ((FBird.Position.Y)<0);
end;

function TAppController.HitPipe: Boolean;
var n: Integer;
begin
 Result:= false;

 for n:= FPipes.Count-1 downto 0 do
  if Assigned(FPipes.Items[n]) then
    if CheckBoundryCollision(TPipe(FPipes.Items[n])) then
    begin
     Result:= true;
     break;
    end;
end;

function TAppController.OvercomePipe: Boolean;
var n: Integer;
    aPipe: TPipe;
begin
 Result:= false;

 for n:= FPipes.Count-1 downto 0 do
 begin
  if Assigned(FPipes.Items[n]) then
   begin
    aPipe:= TPipe(FPipes.Items[n]);
    if (((aPipe.Position.X+(aPipe.Size.Width/2))<FBird.Position.X) AND (aPipe.Tag=1) AND (aPipe.TagFloat=0)) then
    begin
     aPipe.TagFloat:= 1;
     Result:= true;
    end;
   end;
 end;
end;

function TAppController.CheckBoundryCollision(APipe: TPipe; OffSetY : LongInt = 2; OffSetX : LongInt = 2): Boolean;
begin
 Result:=(not((FBird.GetRect.Bottom - (OffSetY * 2) < APipe.GetRect.Top + OffSetY) or
         (FBird.GetRect.Top + OffSetY > APipe.GetRect.Bottom - (OffSetY * 2)) or
         (FBird.GetRect.Right - (OffSetX * 2) < APipe.GetRect.Left + OffSetX) or
         (FBird.GetRect.Left + OffSetX > APipe.GetRect.Right - (OffSetX * 2))));
end;


destructor TAppController.Destroy;
begin
  {$IFDEF MSWINDOWS}
  FreeAndNil(FPipes);
  FreeAndNil(FTimer);
  FreeAndNil(FUpdater);
  FreeAndNil(FData);
  FreeAndNil(FBird);
  FreeAndNil(Mutex);
  {$ELSE}
  FPipes.DisposeOf;
  FTimer.DisposeOf;
  FUpdater.DisposeOf;
  FData.DisposeOf;
  FBird.DisposeOf;
  Mutex.DisposeOf;
  {$ENDIF}
  inherited;
end;

{ TUpdater }

constructor TCalculator.Create;
begin
 inherited Create(true);
 BirdAngle:= DEF_BIRD_ANGLE;
 BirdYPos:= TBird.DefPosition.Y;
 FGameTicker:= 0;
end;

procedure TCalculator.Execute;
const BIRD_UP_HEIGHT = 42;
      BIRD_UP_SPEED = 5;
      BIRD_DOWN_SPEED = 5;
      MIN_GAP_SIZE = 110;
      MAX_GAP_SIZE = 170;
var BirdUpCount: Integer;
    IsBirdUp: Boolean;
    GapSize: Single;
    YOff,YMinOff,YMaxOff: Integer;
begin
 inherited;
  BirdUpCount:= 0;
  IsBirdUp:= false;
  while not Terminated do
  begin
    if FActive then
    begin
      // if user tapped several times in succession
      if BirdUp then
      begin
        BirdUpCount:= 0;
        IsBirdUp:= true;
        BirdUp:= false;
      end;

      if FGameTicker = 0 then
      begin
        //PipeRange:= (GamePanelSize.Height - TPipe.Size.Height);
        GapSize:= RandomRange(MIN_GAP_SIZE,MAX_GAP_SIZE);
        YMinOff:= Round(GamePanelSize.Height-(GamePanelSize.Height - GapSize/2));
        YMaxOff:= Round(GamePanelSize.Height - GapSize);
        YOff:= RandomRange(YMinOff,YMaxOff);

        FPipeAPos:= Round((YOff-TPipe.Size.Height)-(GapSize/2));
        FPipeBPos:= YOff+Round(GapSize/2);

        FAddPipe(FPipeAPos,false);
        FAddPipe(FPipeBPos,true);
      end;

      if FGameTicker>(SPAWN_TIME*30) then
        FGameTicker:= 0
      else
       Inc(FGameTicker);

       // for a smooth rising
      if IsBirdUp and (BirdUpCount <= BIRD_UP_SPEED)then
      begin
       if BirdAngle > -15 then
        BirdAngle:= BirdAngle-(90/(BIRD_UP_SPEED));
       BirdYPos:= -Round(BIRD_UP_HEIGHT/BIRD_UP_SPEED);
       Inc(BirdUpCount);
      end
      else
      begin
       IsBirdUp:= false;
       BirdUpCount:= 0;

       if BirdAngle<90 then
        BirdAngle:= BirdAngle+5;
       BirdYPos:= Max(BirdAngle,1)/BIRD_DOWN_SPEED;
      end;

      if FGameTicker mod 4 = 0 then
       Flap:= true
      else
       Flap:= false;

      Sleep(35);
    end;
  end;
end;

end.
