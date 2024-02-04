unit GDCornerButton;

interface

uses
  System.SysUtils, System.Classes, FMX.Types, FMX.Controls, FMX.StdCtrls,
  FMX.Graphics, System.UITypes, FMX.Objects, System.Math, System.Math.Vectors,
  GD.Types, FMX.Forms, System.Types;

type
  TGDCornerButton = class(TCornerButton)
  private
    FColorSettings: TColorSettings;
    FSystemClick: TSystemClick;
    procedure DoMouseEnter(Sender: TObject);
    procedure DoMouseLeave(Sender: TObject);
    procedure DoOnClick(Sender: TObject);
    procedure SetColorSettings(Value: TColorSettings);
    procedure ColorSettingsChanged(Sender: TObject);
    procedure ChildOnMouseEnter(Sender: TObject);
    procedure ChildOnMouseLeave(Sender: TObject);
    function GetVersion: string;
    function GetSystemClick: TSystemClick;
    procedure SetSystemClick(const Value: TSystemClick);
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
    property SystemClick: TSystemClick read GetSystemClick write SetSystemClick;
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
  OnClick := DoOnClick;
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

procedure TGDCornerButton.SetSystemClick(const Value: TSystemClick);
begin
  if Value <> FSystemClick then
  begin
    FSystemClick := Value;
  end;

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
      ColorSettings.FColorFontBackup := Self.FontColor;
      Self.FontColor := ColorSettings.ActiveFontColor;
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
      Self.FontColor := ColorSettings.FColorFontBackup;
      if Assigned(Scene) then
        ApplyStyle;
    end;
  end;
end;

procedure TGDCornerButton.DoOnClick(Sender: TObject);
var
  CurrentParent: TFmxObject;
  Form: TForm;
  Monitor: Integer;
begin
  if Sender = Self then
  begin
    // Encontrar o TForm na hierarquia de componentes
    CurrentParent := Parent;
    while (CurrentParent <> nil) and (not(CurrentParent is TForm)) do
      CurrentParent := CurrentParent.Parent;

    if CurrentParent is TForm then
    begin
      Form := TForm(CurrentParent);

      case FSystemClick of
        Close:
          begin
            Form.Close;
          end;
        Expand:
          begin
            Monitor := GetCurrentMonitorIndex(Form);
            if Form.WindowState = TWindowState.wsNormal then
            begin
              Form.WindowState := TWindowState.wsMaximized;
              Form.Height := Trunc(Screen.Displays[Monitor].Bounds.Height - 40);
            end
            else
              Form.WindowState := TWindowState.wsNormal;

          end;
        Minimize:
          begin
            Form.WindowState := TWindowState.wsMinimized
          end;
      end;
    end;
  end;
end;

function TGDCornerButton.GetSystemClick: TSystemClick;
begin
  Result := FSystemClick;
end;

function TGDCornerButton.GetVersion: string;
begin
  Result := GetComponentVersion;
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
