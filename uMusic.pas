unit uMusic;

interface

uses
  System.Classes, System.SysUtils, System.IOUtils, FMX.Media;

type
  TSom = (Wing, Pointer, Swooshing, Hit, Die);

  TMusic = class(TThread)
    private
      FSom : TSom;
      FMediaPlayer : TMediaPlayer;
    protected
      procedure Execute; override;
    public
      constructor Create(Som: TSom);
      destructor Destroy; override;
  end;

implementation

{ TMusic }

uses uConfig;

constructor TMusic.Create(Som: TSom);
begin
  FSom  := Som;
  FMediaPlayer  := TMediaPlayer.Create(nil);
  { executada automaticamente após a instância ser criada }
  inherited Create(False);
  { limpa da memória após seu termino }
  Self.FreeOnTerminate := True;
end;

destructor TMusic.Destroy;
begin
  {$IFDEF MSWINDOWS}
  FreeAndNil(FMediaPlayer);
  {$ELSE}
  FMediaPlayer.DisposeOf;
  {$ENDIF}
  inherited;
end;

procedure TMusic.Execute;
begin
  inherited;
  if not(FSingletonConfig.SomLigado) then
    Exit;

  case FSom of
    Wing: FMediaPlayer.FileName := TPath.GetDocumentsPath + PathDelim + 'sfx_wing.mp3';
    Pointer: FMediaPlayer.FileName := TPath.GetDocumentsPath + PathDelim +  'sfx_point.mp3';
    Swooshing: FMediaPlayer.FileName := TPath.GetDocumentsPath + PathDelim +  'sfx_swooshing.mp3';
    Hit: FMediaPlayer.FileName := TPath.GetDocumentsPath + PathDelim +  'sfx_hit.mp3';
    Die: FMediaPlayer.FileName := TPath.GetDocumentsPath + PathDelim +  'sfx_die.mp3';
  end;

  FMediaPlayer.Play;
  Sleep(1000);
end;

end.
