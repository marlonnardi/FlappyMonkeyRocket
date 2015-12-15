unit uConfig;

interface

uses System.SysUtils;

type
  TConfig = class
  private
    FSomLigado: Boolean;
  protected
    constructor Create();
    destructor Destroy; override;
  public
    property SomLigado: Boolean read FSomLigado write FSomLigado;
  end;

  TSingletonConfig = class(TConfig)
    private
    public
      constructor Create;
      destructor Destroy; override;

      procedure LigaSom;
      procedure DesligaSom;

      class function GetInstance : TSingletonConfig; virtual;
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

initialization
  FSingletonConfig  := TSingletonConfig.GetInstance;
  FSingletonConfig.LigaSom;

finalization
  TSingletonConfig.LeaveInstance;

end.
