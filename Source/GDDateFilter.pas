unit GDDateFilter;

interface

uses
  System.SysUtils, System.Classes, FMX.Types, FMX.Controls, FMX.Objects, GD.Types,
  Data.DB, FMX.Bind.DBEngExt;

type
  TGDDateFilter = class(TControl)
  private
    FRectangleBackground: TRectangle;
    FDataSource: TDataSource;
    FDataField: string;
    function GetVersion: string;
    procedure SetDataSource(const Value: TDataSource);
    procedure SetDataField(const Value: string);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Background: TRectangle read FRectangleBackground;
    property About: String read GetVersion;
    property DataSource: TDataSource read FDataSource write SetDataSource;
    property DataField: string read FDataField write SetDataField;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Delphi | Biblioteca GD', [TGDDateFilter]);
end;

{ TGDDateFilter }

constructor TGDDateFilter.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FRectangleBackground := TRectangle.Create(Self);
  FRectangleBackground.Parent := Self;
  FRectangleBackground.Align := TAlignLayout.Client;
  Width := 100;
  Height := 100;
end;

destructor TGDDateFilter.Destroy;
begin
  FRectangleBackground.Free;
  inherited;
end;

function TGDDateFilter.GetVersion: string;
begin
  Result := GetComponentVersion;
end;

procedure TGDDateFilter.SetDataSource(const Value: TDataSource);
begin
  if FDataSource <> Value then
  begin
    FDataSource := Value;
  end;
end;

procedure TGDDateFilter.SetDataField(const Value: string);
var
  LField: TField;
begin
  if Assigned(FDataSource) and Assigned(FDataSource.DataSet) then
  begin
    LField := FDataSource.DataSet.FindField(Value);
    if Assigned(LField) and (LField.DataType in [ftDate, ftDateTime]) then
    begin
      if FDataField <> Value then
      begin
        FDataField := Value;
        // Atualize o componente conforme necess�rio aqui, se necess�rio
      end;
    end
    else
      raise Exception.CreateFmt('O campo "%s" n�o � um campo Date ou DateTime.', [Value]);
  end
  else if Value = '' then
    FDataField := Value;  // Caso queira permitir valor vazio para DataField
end;

end.

