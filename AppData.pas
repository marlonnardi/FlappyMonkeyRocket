unit AppData;

interface

uses
  SysUtils, Classes, IOUtils, IniFiles;

type
  TAppData = class
  private
   FFileName: String;
   FScore: Integer;
   FHighscore: Integer;
  public
   constructor Create;
   procedure SaveScore(AScore: Integer);
   procedure IncScore;
   procedure ResetScore;
   function GetScore: Integer;
   function GetHighscore: Integer;
  end;

implementation

{ TAppData }

constructor TAppData.Create;
var IniFile: TIniFile;
FGetDocumentsPath : string;
FPathDelim : string;
begin
 FScore:= 0;
 FHighscore:= 0;
 FGetDocumentsPath := TPath.GetHomePath;
 FPathDelim := System.SysUtils.PathDelim;
 FFileName:= TPath.GetDocumentsPath + System.SysUtils.PathDelim + 'Scores.dat';
 try
  IniFile:= TIniFile.Create(FFileName);
  FHighscore:= IniFile.ReadInteger('Settings','Best',0);
  IniFile.Free;
 except on E: Exception do;
 end;
end;

procedure TAppData.SaveScore(AScore: Integer);
var IniFile: TIniFile;
begin
 FScore:= AScore;
 if FScore >= FHighscore then
 begin
  FHighscore:= FScore;
  try
   IniFile:= TIniFile.Create(FFileName);
   IniFile.WriteInteger('Settings','Best',FHighscore);
   IniFile.Free;
  except on E: Exception do;
  end;
 end;
end;

procedure TAppData.IncScore;
var IniFile: TIniFile;
begin
 Inc(FScore);
 if FScore > FHighscore then
 begin
  FHighscore:= FScore;
  try
   IniFile:= TIniFile.Create(FFileName);
   IniFile.WriteInteger('Settings','Best',FHighscore);
   IniFile.Free;
  except on E: Exception do;
  end;
 end;
end;

procedure TAppData.ResetScore;
begin
 FScore:= 0;
end;

function TAppData.GetScore: Integer;
begin
 Result:= FScore;
end;

function TAppData.GetHighscore: Integer;
begin
 Result:= FHighscore;
end;

end.
