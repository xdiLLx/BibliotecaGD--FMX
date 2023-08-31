unit GDCornerButton;

interface

uses
  System.SysUtils, System.Classes, FMX.Types, FMX.Controls, FMX.StdCtrls, FMX.Graphics;

type
  TCustomCornerButton = class(TCornerButton)
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

procedure TCustomCornerButton.ApplyStyle;
var
  Background: TFmxObject;
begin
  inherited;
  Background := FindStyleResource('background');
  if Assigned(Background) and (Background is TShape) then
    TShape(Background).Fill.Color := FColor;
end;

procedure TCustomCornerButton.SetColor(const Value: TAlphaColor);
begin
  if FColor <> Value then
  begin
    FColor := Value;
    if Assigned(Scene) then ApplyStyle;
  end;
end;

end.

