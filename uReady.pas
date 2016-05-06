unit uReady;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.StdCtrls, FMX.Objects, FMX.Advertising, FMX.Filter.Effects, FMX.Effects,
  FMX.Ani, FMX.Controls, FMX.Controls.Presentation, FMX.Types, FMX.Layouts,
  FMX.Forms;

type
  TReadyFrame = class(TFrame)
    GetReadyLayout: TLayout;
    layReady: TLayout;
    GetReadyLBL: TLabel;
    FloatAnimation1: TFloatAnimation;
    GlowEffect3: TGlowEffect;
    Image2: TImage;
    MonochromeEffect1: TMonochromeEffect;
    layTap: TLayout;
    Pie1: TPie;
    Rectangle2: TRectangle;
    imgTap: TImage;
    Rectangle1: TRectangle;
    lblTap: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

end.
