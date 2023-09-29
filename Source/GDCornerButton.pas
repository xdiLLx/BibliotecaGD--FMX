unit GDCornerButton;

interface

uses
  System.SysUtils, System.Classes, FMX.Types, FMX.Controls, FMX.StdCtrls,
  FMX.Graphics, System.UITypes, FMX.Objects, System.Math, System.Math.Vectors;

type
  TGDCornerButton = class(TCornerButton)
  private
    FColor: TAlphaColor;
    FFillKind: TBrushKind;
    FStrokeColor: TAlphaColor;
    FStrokeThickness: Single;
    FActiveColor: TAlphaColor;
    FColorBackup: TAlphaColor;
    FStrokeColorBackup: TAlphaColor;
    FUseActiveColor: Boolean;
    procedure SetColor(const Value: TAlphaColor);
    procedure SetFillKind(const Value: TBrushKind);
    procedure SetStrokeColor(const Value: TAlphaColor);
    procedure SetStrokeThickness(const Value: Single);
    procedure SetActiveColor(const Value: TAlphaColor);
    function GetComponentVersion: String;
    procedure DoMouseEnter(Sender: TObject);
    procedure DoMouseLeave(Sender: TObject);
    procedure SetUseActiveColor(const Value: Boolean);

  const
    COMPONENT_VERSION = '1.5.0';
  protected
    procedure ApplyStyle; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Single); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Single); override;

  public
    constructor Create(AOwner: TComponent); override;
  published
    property Version: String read GetComponentVersion;
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
  FUseActiveColor := False;
  OnMouseEnter := DoMouseEnter;
  OnMouseLeave := DoMouseLeave;
end;

function TGDCornerButton.GetComponentVersion: String;
begin
  Result := COMPONENT_VERSION;
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
    if Assigned(Scene) then
      ApplyStyle;
  end;
end;

procedure TGDCornerButton.SetFillKind(const Value: TBrushKind);
begin
  if FFillKind <> Value then
  begin
    FFillKind := Value;
    if Assigned(Scene) then
      ApplyStyle;
  end;
end;

procedure TGDCornerButton.SetStrokeColor(const Value: TAlphaColor);
begin
  if FStrokeColor <> Value then
  begin
    FStrokeColor := Value;
    if Assigned(Scene) then
      ApplyStyle;
  end;
end;

procedure TGDCornerButton.SetStrokeThickness(const Value: Single);
begin
  if not SameValue(FStrokeThickness, Value, TEpsilon.Position) then
  begin
    FStrokeThickness := Value;
    if Assigned(Scene) then
      ApplyStyle;
  end;
end;

procedure TGDCornerButton.SetUseActiveColor(const Value: Boolean);
begin
  if FUseActiveColor <> Value then
  begin
    FUseActiveColor := Value;
    if Assigned(Scene) then
      ApplyStyle;
  end;
end;

procedure TGDCornerButton.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Single);
begin
  inherited;

end;

procedure TGDCornerButton.DoMouseEnter;
begin
  if Sender = Self then
  begin
    if FUseActiveColor then
    begin
      FStrokeColorBackup := FStrokeColor;
      FColorBackup := FColor;
      FStrokeColor := FActiveColor;
      FColor := FActiveColor;
      if Assigned(Scene) then
        ApplyStyle;
    end;
  end;
end;

procedure TGDCornerButton.DoMouseLeave;
begin
  if Sender = Self then
  begin
    if FUseActiveColor then
    begin
      FStrokeColor := FStrokeColorBackup;
      FColor := FColorBackup;
      if Assigned(Scene) then
        ApplyStyle;
    end;
  end;
end;

procedure TGDCornerButton.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Single);
begin
  inherited;

end;

procedure TGDCornerButton.SetActiveColor(const Value: TAlphaColor);
begin
  if FActiveColor <> Value then
  begin
    FActiveColor := Value;
    if Assigned(Scene) then
      ApplyStyle;
  end;
end;

end.
