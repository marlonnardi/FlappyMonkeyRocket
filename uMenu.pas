unit uMenu;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Ani, FMX.Effects, FMX.Platform,
  FMX.Controls.Presentation, uConfig, FMX.MultiView, FMX.Layouts, FMX.ListBox;

type
  TMenuForm = class(TForm)
    PlayBTN: TButton;
    Image1: TImage;
    GroundA: TImage;
    Ground: TRectangle;
    Image2: TImage;
    Rectangle1: TRectangle;
    LogoLBL: TLabel;
    GlowEffect3: TGlowEffect;
    FMonkeyA: TImage;
    FloatAnimation1: TFloatAnimation;
    swtchSom: TSwitch;
    lblPropaganda: TLabel;
    layPrincipal: TLayout;
    tlbControle: TToolBar;
    btnMenu: TButton;
    btnFechar: TButton;
    MultiView1: TMultiView;
    pnlTop: TPanel;
    pnlBottom: TPanel;
    imgMonkey: TImage;
    lstMenu: TListBox;
    lstItem1: TListBoxItem;
    procedure PlayBTNClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure swtchSomSwitch(Sender: TObject);
  private
    { Private declarations }


  public
    function HandleAppEvent(AAppEvent: TApplicationEvent;
      AContext: TObject): Boolean;
  end;

var
  MenuForm: TMenuForm;

implementation

{$R *.fmx}

uses uGame, uDmStyle;

procedure TMenuForm.FormCreate(Sender: TObject);
begin
{$IFDEF MSWINDOWS}
  BorderStyle := TFmxFormBorderStyle.bsSizeable;
{$ELSE}
  // BorderStyle:= TFmxFormBorderStyle.None; {BUG}

  FSingletonConfig.SetFullScren(Self);
{$ENDIF}
  swtchSom.IsChecked := FSingletonConfig.SomLigado;
end;

procedure TMenuForm.PlayBTNClick(Sender: TObject);
begin
  GameForm.Run;
  MenuForm.Hide;
{$IFDEF MSWINDOWS}
  GameForm.ShowModal;
{$ELSE}
  GameForm.Show;
{$ENDIF}
end;

procedure TMenuForm.swtchSomSwitch(Sender: TObject);
begin
  if swtchSom.IsChecked then
    FSingletonConfig.LigaSom
  else
    FSingletonConfig.DesligaSom;
end;

function TMenuForm.HandleAppEvent(AAppEvent: TApplicationEvent;
  AContext: TObject): Boolean;
begin
  case AAppEvent of
    TApplicationEvent.FinishedLaunching:
      begin
      end;
    TApplicationEvent.BecameActive:
      begin
      end;
    TApplicationEvent.WillBecomeInactive:
      begin
      end;
    TApplicationEvent.EnteredBackground:
      begin
      end;
    TApplicationEvent.WillBecomeForeground:
      begin
      end;
    TApplicationEvent.WillTerminate:
      begin
      end;
    TApplicationEvent.LowMemory:
      begin
      end;
    TApplicationEvent.TimeChange:
      begin
      end;
    TApplicationEvent.OpenURL:
      begin
      end;
  end;
  Result := True;
end;

end.
