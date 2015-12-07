unit Interfaces.Controller.GUI;

interface

uses System.Generics.Collections, Classes, Sysutils, System.Types, FMX.Layouts;

type
  TBird = class
  private
   FPosition: TPointF;
   FAngle: Double;
   FFlap: Boolean;
   FLayout: TLayout;
   class var FDefPosition: TPointF;
   class var FSize: TSizeF;
  public
   function GetRect: TRectF;
   property Position: TPointF read FPosition write FPosition;
   property Angle: Double read FAngle write FAngle;
   property Flap: Boolean read FFlap write FFlap;
   property Layout: TLayout read FLayout write FLayout;
   class property Size: TSizeF read FSize write FSize;
   class property DefPosition: TPointF read FDefPosition write FDefPosition;
  end;

type
  TPipe = class
  private
   FPosition: TPointF;
   FAngle: Double;
   FTag: Integer;
   FTagFloat: Double;
   FAdded: Boolean;
   FDelete: Boolean;
   FLayout: TLayout;
   class var FSize: TSizeF;
  public
   function GetRect: TRectF;
   property Position: TPointF read FPosition write FPosition;
   property Angle: Double read FAngle write FAngle;
   property Tag: Integer read FTag write FTag;
   property TagFloat: Double read FTagFloat write FTagFloat;
   property Added: Boolean read FAdded write FAdded;
   property Delete: Boolean read FDelete write FDelete;
   property Layout: TLayout read FLayout write FLayout;
   class property Size: TSizeF read FSize write FSize;
  end;

  TPipes = TObjectList<TPipe>;

type
  IAppGUI = interface;

  IAppController = interface
   procedure RegisterGUI(const AGUI: IAppGUI);
   procedure StartGame;
   procedure StopGame;
   procedure Replay;
   procedure Tapped;
  end;

  IAppGUI = interface
   procedure RegisterController(const AController: IAppController);
   function GetGamePanelSize: TSizeF;
   function GetPipeSize: TSizeF;
   function GetBirdSize: TSizeF;
   function GetBirdPoint: TPointF;

   procedure ResetGame;
   procedure SetScore(AScore: Integer);
   procedure GameOver(AScore, ABestScore: Integer);
   procedure SetBird(ABird: TBird);
   procedure AddPipe(APipe: TPipe);
   procedure RemovePipe(APipe: TPipe);
   procedure MovePipe(APipe: TPipe);
  end;

implementation

{ TBird }

function TBird.GetRect: TRectF;
begin
 Result:= RectF(FPosition.X,FPosition.Y,FPosition.X+FSize.Width,FPosition.Y+FSize.Height);
end;

{ TPipe }

function TPipe.GetRect: TRectF;
begin
 Result:= RectF(FPosition.X,FPosition.Y,FPosition.X+FSize.Width,FPosition.Y+FSize.Height);
end;

end.


