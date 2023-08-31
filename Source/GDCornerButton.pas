unit GDCornerButton;

interface

uses
  System.SysUtils, System.Classes, FMX.Types, FMX.Controls, FMX.StdCtrls,
  FMX.Graphics, System.UITypes, FMX.Objects,System.Math,System.Math.Vectors;

type
  TGDCornerButton = class(TCornerButton)
  private
    FColor: TAlphaColor;
    FFillKind: TBrushKind;
    FStrokeColor: TAlphaColor;
    FStrokeThickness: Single;
    procedure SetColor(const Value: TAlphaColor);
    procedure SetFillKind(const Value: TBrushKind);
    procedure SetStrokeColor(const Value: TAlphaColor);
    procedure SetStrokeThickness(const Value: Single);
  protected
    procedure ApplyStyle; override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Color: TAlphaColor read FColor write SetColor;
    property FillKind: TBrushKind read FFillKind write SetFillKind default TBrushKind.Solid;
    property StrokeColor: TAlphaColor read FStrokeColor write SetStrokeColor;
    property StrokeThickness: Single read FStrokeThickness write SetStrokeThickness;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Delphi | Biblioteca GD', [TGDCornerButton]);
end;

{ TGDCornerButton }

constructor TGDCornerButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FFillKind := TBrushKind.Solid;
end;

procedure TGDCornerButton.ApplyStyle;
var
  Background: TFmxObject;
begin
  inherited;
  Background := FindStyleResource('background');
  if Assigned(Background) and (Background is TShape) then
  begin
    with TShape(Background) do
    begin
      Fill.Color := FColor;
      Fill.Kind := FFillKind;
      Stroke.Color := FStrokeColor;
      Stroke.Thickness := FStrokeThickness;
    end;
  end;
end;

procedure TGDCornerButton.SetColor(const Value: TAlphaColor);
begin
  if FColor <> Value then
  begin
    FColor := Value;
    if Assigned(Scene) then ApplyStyle;
  end;
end;

procedure TGDCornerButton.SetFillKind(const Value: TBrushKind);
begin
  if FFillKind <> Value then
  begin
    FFillKind := Value;
    if Assigned(Scene) then ApplyStyle;
  end;
end;

procedure TGDCornerButton.SetStrokeColor(const Value: TAlphaColor);
begin
  if FStrokeColor <> Value then
  begin
    FStrokeColor := Value;
    if Assigned(Scene) then ApplyStyle;
  end;
end;

procedure TGDCornerButton.SetStrokeThickness(const Value: Single);
begin
  if not SameValue(FStrokeThickness, Value, TEpsilon.Position) then
  begin
    FStrokeThickness := Value;
    if Assigned(Scene) then ApplyStyle;
  end;
end;

end.

