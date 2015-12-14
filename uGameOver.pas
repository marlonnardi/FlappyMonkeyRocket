unit uGameOver;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Ani, FMX.Layouts, FMX.Controls.Presentation;

type
  TGameOverFrame = class(TFrame)
    GameOverLayout: TLayout;
    layBotoes: TLayout;
    OKBTN: TButton;
    ReplayBTN: TButton;
    layGameTop: TLayout;
    GameOverLBL: TLabel;
    GOFloat: TFloatAnimation;
    RectangleScore: TRectangle;
    RectangleTotal: TRectangle;
    lbl1: TLabel;
    lbl2: TLabel;
    BestScoreLBL: TLabel;
    GOScoreLBL: TLabel;
    RectangleMeda: TRectangle;
    lbl3: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

uses uDmStyle;

end.
