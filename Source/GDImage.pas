unit GDImage;

interface

uses
  System.SysUtils, System.Classes, FMX.Types, FMX.Controls, FMX.Objects,
  FMX.ImgList, System.Types,FMX.MultiResBitmap, GD.Types;

type
  TGDImage = class(TImage)
  private
    FImageList: TImageList;
    FImageName: string;
    procedure SetImageList(const Value: TImageList);
    procedure SetImageName(const Value: string);
    procedure SetImageFromImageList(AImageName: String; AImage: TImage;
      AImageList: TImageList);
    function GetVersion: string;
  protected
    procedure Loaded; override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property About: String read GetVersion;
    property ImageList: TImageList read FImageList write SetImageList;
    property ImageName: string read FImageName write SetImageName;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Delphi | Biblioteca GD', [TGDImage]);
end;

constructor TGDImage.Create(AOwner: TComponent);
begin
  inherited;
end;

function TGDImage.GetVersion: string;
begin
 Result := GetComponentVersion;
end;

procedure TGDImage.Loaded;
begin
  inherited;
  if (FImageList <> nil) and (FImageName <> '') then
    SetImageFromImageList(FImageName, Self, FImageList);
end;

procedure TGDImage.SetImageFromImageList(AImageName: String; AImage: TImage;
  AImageList: TImageList);
var
  Bmp: TCustomBitmapItem;
  Size: TSize;
begin
  AImageList.BitmapItemByName(AImageName, Bmp, Size);
  AImage.Bitmap := Bmp.MultiResBitmap.Bitmaps[1.0];
end;

procedure TGDImage.SetImageList(const Value: TImageList);
begin
  if FImageList <> Value then
  begin
    FImageList := Value;
  end;
end;

procedure TGDImage.SetImageName(const Value: string);
begin
  if FImageName <> Value then
  begin
    FImageName := Value;
    if not(csLoading in ComponentState) then
      SetImageFromImageList(FImageName, Self, FImageList);
  end;
end;

end.
