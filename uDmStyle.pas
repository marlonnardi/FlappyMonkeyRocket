unit uDmStyle;

interface

uses
  System.SysUtils, System.Classes, FMX.Types, FMX.Controls;

type
  TdmStyle = class(TDataModule)
    StyleBookW: TStyleBook;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dmStyle: TdmStyle;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

end.
