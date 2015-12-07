unit uGameOver;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Ani, FMX.Layouts, FMX.Controls.Presentation;

type
  TGameOverFrame = class(TFrame)
    GameOverLayout: TLayout;
    GameOverLBL: TLabel;
    GOFloat: TFloatAnimation;
    Layout1: TLayout;
    OKBTN: TButton;
    ReplayBTN: TButton;
    Rectangle3: TRectangle;
    Label2: TLabel;
    Label4: TLabel;
    GOScoreLBL: TLabel;
    BestScoreLBL: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

end.
