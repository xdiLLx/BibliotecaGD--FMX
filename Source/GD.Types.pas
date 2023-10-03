unit GD.Types;

interface

uses
  System.SysUtils, System.Classes, FMX.Types, FMX.Controls, FMX.StdCtrls,
  FMX.Graphics, System.UITypes, FMX.Objects, System.Math, System.Math.Vectors;

const
    COMPONENT_VERSION = '1.7.0';
function GetComponentVersion: String;
type
  TNotifyChange = procedure(Sender: TObject) of object;

type
  TColorSettings = class(TPersistent)
  private
    FColor: TAlphaColor;
    FFillKind: TBrushKind;
    FStrokeColor: TAlphaColor;
    FStrokeThickness: Single;
    FActiveColor: TAlphaColor;
    FUseActiveColor: Boolean;
    FOnChange: TNotifyChange;

    procedure SetColor(const Value: TAlphaColor);
    procedure SetFillKind(const Value: TBrushKind);
    procedure SetStrokeColor(const Value: TAlphaColor);
    procedure SetStrokeThickness(const Value: Single);
    procedure SetActiveColor(const Value: TAlphaColor);
    procedure SetUseActiveColor(const Value: Boolean);

  protected
    procedure DoChange; virtual;
  public
    FColorBackup: TAlphaColor;
    FStrokeColorBackup: TAlphaColor;
    constructor Create;
  published
{$REGION 'ColorSettings'}
    property Color: TAlphaColor read FColor write SetColor;
    property FillKind: TBrushKind read FFillKind write SetFillKind
      default TBrushKind.Solid;
    property StrokeColor: TAlphaColor read FStrokeColor write SetStrokeColor;
    property StrokeThickness: Single read FStrokeThickness
      write SetStrokeThickness;
    property ActiveColor: TAlphaColor read FActiveColor write SetActiveColor;
    property UseActiveColor: Boolean read FUseActiveColor
      write SetUseActiveColor default False;
{$ENDREGION}
    property OnChange: TNotifyChange read FOnChange write FOnChange;
  end;

implementation

{ Get Version}
function GetComponentVersion: String;
begin
  Result := COMPONENT_VERSION;
end;

{ TColorSettings }

constructor TColorSettings.Create;
begin
  FColor := TAlphaColorRec.White;
  FStrokeThickness := 0;
  FUseActiveColor := False;
  FFillKind := TBrushKind.Solid;
end;

procedure TColorSettings.DoChange;
begin
  if Assigned(FOnChange) then
    FOnChange(Self);
end;

procedure TColorSettings.SetActiveColor(const Value: TAlphaColor);
begin
  if FActiveColor <> Value then
  begin
    FActiveColor := Value;
    DoChange;
  end;
end;



procedure TColorSettings.SetColor(const Value: TAlphaColor);
begin
  if FColor <> Value then
  begin
    FColor := Value;
    DoChange;
  end;
end;

procedure TColorSettings.SetFillKind(const Value: TBrushKind);
begin
  if FFillKind <> Value then
  begin
    FFillKind := Value;
    DoChange;
  end;
end;

procedure TColorSettings.SetStrokeColor(const Value: TAlphaColor);
begin
  if FStrokeColor <> Value then
  begin
    FStrokeColor := Value;
    DoChange;
  end;
end;

procedure TColorSettings.SetStrokeThickness(const Value: Single);
begin
  if not SameValue(FStrokeThickness, Value, TEpsilon.Position) then
  begin
    FStrokeThickness := Value;
    DoChange;
  end;
end;

procedure TColorSettings.SetUseActiveColor(const Value: Boolean);
begin
  if FUseActiveColor <> Value then
  begin
    FUseActiveColor := Value;
    DoChange;
  end;
end;

end.
