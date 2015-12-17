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
    BannerAd1: TBannerAd;
    Rectangle1: TRectangle;
    Label1: TLabel;
    layReady: TLayout;
    GetReadyLBL: TLabel;
    FloatAnimation1: TFloatAnimation;
    GlowEffect3: TGlowEffect;
    Image2: TImage;
    MonochromeEffect1: TMonochromeEffect;
    Arc2: TArc;
    Arc1: TArc;
    layTap: TLayout;
    Pie1: TPie;
    Rectangle2: TRectangle;
    imgTap: TImage;
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
  //ShowMessage(Error);
  {$ENDIF}
end;

end.
