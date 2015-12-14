unit uReady;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Filter.Effects, FMX.Effects, FMX.Ani, FMX.Layouts,
  FMX.Controls.Presentation, FMX.Advertising;

type
  TReadyFrame = class(TFrame)
    GetReadyLayout: TLayout;
    Arc1: TArc;
    Arc2: TArc;
    GetReadyLBL: TLabel;
    FloatAnimation1: TFloatAnimation;
    GlowEffect3: TGlowEffect;
    Image2: TImage;
    MonochromeEffect1: TMonochromeEffect;
    Rectangle2: TRectangle;
    Rectangle1: TRectangle;
    Label1: TLabel;
    Pie1: TPie;
    BannerAd1: TBannerAd;
    procedure BannerAd1DidFail(Sender: TObject; const Error: string);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

procedure TReadyFrame.BannerAd1DidFail(Sender: TObject; const Error: string);
begin
  {$IFDEF DEBUG}
  ShowMessage(Error);
  {$ENDIF}
end;

end.
