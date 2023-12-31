unit GDCornerButton;

interface

uses
  System.SysUtils, System.Classes, FMX.Types, FMX.Controls, FMX.StdCtrls,
  FMX.Graphics, System.UITypes, FMX.Objects, System.Math, System.Math.Vectors,
  GD.Types;

type
  TGDCornerButton = class(TCornerButton)
  private
    FColorSettings: TColorSettings;
    procedure DoMouseEnter(Sender: TObject);
    procedure DoMouseLeave(Sender: TObject);
    procedure SetColorSettings(Value: TColorSettings);
    procedure ColorSettingsChanged(Sender: TObject);
    procedure ChildOnMouseEnter(Sender: TObject);
    procedure ChildOnMouseLeave(Sender: TObject);
    function GetVersion: string;
  protected
    procedure ApplyStyle; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Single); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Single); override;
    procedure Loaded; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

  published
    property About: String read GetVersion;
    property ColorSettings: TColorSettings read FColorSettings
      write SetColorSettings;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Delphi | Biblioteca GD', [TGDCornerButton]);
end;

{ TGDCornerButton }

procedure TGDCornerButton.ChildOnMouseEnter(Sender: TObject);
begin
  Self.OnMouseEnter(Self);
end;

procedure TGDCornerButton.ChildOnMouseLeave(Sender: TObject);
begin
  Self.OnMouseLeave(Self);
end;

procedure TGDCornerButton.ColorSettingsChanged(Sender: TObject);
begin
  ApplyStyle;
end;

constructor TGDCornerButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  // FFillKind := TBrushKind.Solid;
  // FUseActiveColor := False;
  FColorSettings := TColorSettings.Create;
  FColorSettings.OnChange := ColorSettingsChanged;
  OnMouseEnter := DoMouseEnter;
  OnMouseLeave := DoMouseLeave;
end;

procedure TGDCornerButton.Loaded;
var
  i: Integer;
  ChildControl: TControl;
begin
  inherited;

  for i := 0 to Self.ChildrenCount - 1 do
  begin
    if Self.Children[i] is TControl then
    begin
      ChildControl := TControl(Self.Children[i]);
      ChildControl.OnMouseEnter := ChildOnMouseEnter;
      ChildControl.OnMouseLeave := ChildOnMouseLeave;
    end;
  end;
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
      Fill.Color := ColorSettings.Color;
      Fill.Kind := ColorSettings.FillKind;
      Stroke.Color := ColorSettings.StrokeColor;
      Stroke.Thickness := ColorSettings.StrokeThickness;
    end;
  end;
end;

procedure TGDCornerButton.SetColorSettings(Value: TColorSettings);
begin

end;

destructor TGDCornerButton.Destroy;
begin
  FColorSettings.Free;
  inherited;
end;

procedure TGDCornerButton.DoMouseEnter;
begin
  if Sender = Self then
  begin
    if ColorSettings.UseActiveColor then
    begin
      ColorSettings.FColorBackup := ColorSettings.Color;
      ColorSettings.FStrokeColorBackup := ColorSettings.StrokeColor;
      ColorSettings.Color := ColorSettings.ActiveColor;
      ColorSettings.StrokeColor := ColorSettings.ActiveColor;
      if Assigned(Scene) then
        ApplyStyle;
    end;
  end;
end;

procedure TGDCornerButton.DoMouseLeave;
begin
  if Sender = Self then
  begin
    if ColorSettings.UseActiveColor then
    begin
      ColorSettings.StrokeColor := ColorSettings.FStrokeColorBackup;
      ColorSettings.Color := ColorSettings.FColorBackup;
      if Assigned(Scene) then
        ApplyStyle;
    end;
  end;
end;

function TGDCornerButton.GetVersion: string;
begin
  result := GetComponentVersion;
end;

procedure TGDCornerButton.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Single);
begin
  inherited;

end;

procedure TGDCornerButton.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Single);
begin
  inherited;

end;

end.
