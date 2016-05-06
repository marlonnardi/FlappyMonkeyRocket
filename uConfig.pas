unit uConfig;

interface

uses System.SysUtils, System.UITypes, FMX.Forms, FMX.Platform;

type
  TConfig = class
  private
    FSomLigado: Boolean;
  protected
    constructor Create();
    destructor Destroy; override;
  public
    property SomLigado: Boolean read FSomLigado write FSomLigado;

    function GetColorPoints(Points: Integer): TAlphaColor;
  end;

  TSingletonConfig = class(TConfig)
  private

  public
    constructor Create;
    destructor Destroy; override;

    procedure LigaSom;
    procedure DesligaSom;
    procedure SetFullScren(Form : TForm);

    class function GetInstance: TSingletonConfig; virtual;
    class procedure LeaveInstance; virtual;
  end;

var
  FSingletonConfig : TSingletonConfig;

implementation

{ TConfig }

constructor TConfig.Create;
begin
end;

destructor TConfig.Destroy;
begin
  inherited;
end;

function TConfig.GetColorPoints(Points: Integer): TAlphaColor;
begin
  Result  := TAlphaColorRec.Chocolate;
  if Points >= 50 then
    Result  := TAlphaColorRec.Chartreuse;
  if Points >= 100 then
    Result  := TAlphaColorRec.Yellow;
  if Points >= 200 then
    Result  := TAlphaColorRec.Blueviolet;
  if Points >= 400 then
    Result  := TAlphaColorRec.Cornflowerblue;
end;

{ TSingletonConfig }

constructor TSingletonConfig.Create;
begin
  raise Exception.Create('Classe Singleton, para obter o objeto utilize o ' +
    'metodo GetInstance');
end;

destructor TSingletonConfig.Destroy;
begin
  raise Exception.Create('Classe Singleton, para liberar o objeto utilize o '
    + 'metodo LeaveInstance');
  inherited;
end;

class function TSingletonConfig.GetInstance: TSingletonConfig;
begin
  if not Assigned(FSingletonConfig) then
    FSingletonConfig := NewInstance as TSingletonConfig;
  Result := FSingletonConfig;
end;

class procedure TSingletonConfig.LeaveInstance;
begin
  if Assigned(FSingletonConfig) then
  begin
    FSingletonConfig.FreeInstance;
    FSingletonConfig := nil;
  end;
end;

procedure TSingletonConfig.DesligaSom;
begin
  Self.FSomLigado := False;
end;

procedure TSingletonConfig.LigaSom;
begin
  Self.FSomLigado := True;
end;

procedure TSingletonConfig.SetFullScren(Form: TForm);
var
  FFullScreenSrvice: IFMXFullScreenWindowService;
begin
  { se a versão suportar FullScren então aplica-se }
  {$IFDEF ANDROID}
  TPlatformServices.Current.SupportsPlatformService(IFMXFullScreenWindowService,
    FFullScreenSrvice);
  if FFullScreenSrvice <> nil then
    FFullScreenSrvice.SetFullScreen(Form, True);
  {$ENDIF}
end;

initialization
  FSingletonConfig  := TSingletonConfig.GetInstance;
  FSingletonConfig.LigaSom;

finalization
  TSingletonConfig.LeaveInstance;

end.
