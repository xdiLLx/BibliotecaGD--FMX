unit GDImage;

interface

uses
  System.SysUtils, System.Classes, FMX.Types, FMX.Controls, FMX.Graphics, FMX.Objects,System.Types,System.UITypes;

type
  TGDImage = class(TImage)
  private
    FXRadius, FYRadius: Single;
    procedure SetXRadius(const Value: Single);
    procedure SetYRadius(const Value: Single);
  protected
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property XRadius: Single read FXRadius write SetXRadius;
    property YRadius: Single read FYRadius write SetYRadius;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Delphi | Biblioteca GD', [TGDImage]);
end;

{ TRoundedImage }

constructor TGDImage.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FXRadius := 10;
  FYRadius := 10;
end;

procedure TGDImage.Paint;
var
  R: TRectF;
begin
  R := LocalRect;

  // Draw the rounded rectangle
  Canvas.Fill.Kind := TBrushKind.Solid;
  Canvas.FillRect(R, FXRadius, FYRadius, AllCorners, 1);

  // Draw the image
  if Bitmap <> nil then
    Canvas.DrawBitmap(Bitmap, Bitmap.BoundsF, R, 1, True);

  // Draw the border of the image if needed
  Canvas.DrawRect(R, FXRadius, FYRadius, AllCorners, 1);
end;

procedure TGDImage.SetXRadius(const Value: Single);
begin
  if FXRadius <> Value then
  begin
    FXRadius := Value;
    Repaint;
  end;
end;

procedure TGDImage.SetYRadius(const Value: Single);
begin
  if FYRadius <> Value then
  begin
    FYRadius := Value;
    Repaint;
  end;
end;

end.

