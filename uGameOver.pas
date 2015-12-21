unit uGameOver;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Ani, FMX.Layouts, FMX.Controls.Presentation, FMX.Advertising,
  FMX.Effects;

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
    BannerAd1: TBannerAd;
    CircleMedal: TCircle;
    imgMedal: TImage;
    CircleMedal1: TCircle;
    imgMedal1: TImage;
    CircleMedal2: TCircle;
    imgMedal2: TImage;
    CircleMedal3: TCircle;
    imgMedal3: TImage;
    CircleMedal4: TCircle;
    imgMedal4: TImage;
    GlowEffect3: TGlowEffect;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

uses uDmStyle;

end.
