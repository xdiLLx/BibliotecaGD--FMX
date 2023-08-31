unit GDCornerButton;

interface

uses
  System.SysUtils, System.Classes, FMX.Types, FMX.Controls, FMX.StdCtrls,
  FMX.Graphics, System.UITypes, FMX.Objects;

type
  TGDCornerButton = class(TCornerButton)
  private
    FColor: TAlphaColor;
    procedure SetColor(const Value: TAlphaColor);
  protected
    procedure ApplyStyle; override;
  published
    property Color: TAlphaColor read FColor write SetColor;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Delphi | Biblioteca GD', [TGDCornerButton]);
end;

{ TCustomCornerButton }

procedure TGDCornerButton.ApplyStyle;
var
  Background: TFmxObject;
begin
  inherited;
  Background := FindStyleResource('background');
  if Assigned(Background) and (Background is TShape) then
  begin
    TShape(Background).Fill.Color := FColor;
    TShape(Background).Fill.Kind := TBrushKind.Solid;
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

end.
