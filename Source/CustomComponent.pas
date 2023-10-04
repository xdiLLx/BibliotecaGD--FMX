unit CustomComponent;

interface

uses
  System.Classes, FMX.Types, FMX.Objects,FMX.Graphics;

type
  TMyCustomComponent = class(TFmxObject)
  private
    FRectangle: TRectangle;
    function GetRectangleFill: TBrush;
    procedure SetRectangleFill(const Value: TBrush);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property RectangleFill: TBrush read GetRectangleFill write SetRectangleFill;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Custom', [TMyCustomComponent]);
end;

constructor TMyCustomComponent.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FRectangle := TRectangle.Create(Self);
  FRectangle.Parent := Self;
end;

destructor TMyCustomComponent.Destroy;
begin
  FRectangle.Free;
  inherited Destroy;
end;

function TMyCustomComponent.GetRectangleFill: TBrush;
begin
  Result := FRectangle.Fill;
end;

procedure TMyCustomComponent.SetRectangleFill(const Value: TBrush);
begin
  FRectangle.Fill.Assign(Value);
end;

end.

