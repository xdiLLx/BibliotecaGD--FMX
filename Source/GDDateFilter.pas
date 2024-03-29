﻿unit GDDateFilter;

interface

uses
  System.SysUtils, System.Classes, FMX.Types, FMX.Controls, FMX.Objects,
  GD.Types,
  Data.DB, FMX.Bind.DBEngExt, FMX.Layouts, FMX.Graphics, System.UITypes,
  FMX.StdCtrls, FMX.DateTimeCtrls, FMX.Ani, FMX.Styles.Objects, FMX.Dialogs,
  GD.Styles, System.Types;

Const
  DefaultSecondaryColor: TAlphaColor = $FFDAD8D8;

Const
  DefaultIconColor: TAlphaColor = $FFBBD1EE;

type
  TFilterMethod = (fmFilter, fmRefresh);

type
  TGDDateFilter = class(TControl)
  private
    FRectangleBackground: TRectangle;
    FDataSource: TDataSource;
    FDataField: string;
    FLayout: TLayout;
    FPeriodoInicial: TLabel;
    FPeriodoFinal: TLabel;
    FInitialIcon: TLabel;
    FFinalIcon: TLabel;
    FExpandIcon: TLabel;
    FBackGroundInitialDate, FBackGroundFinalDate: TRectangle;
    FAlign: TAlignLayout;
    FLine: TLine;
    FInicialDateEdit, FFinalDateEdit: TDateEdit;
    FInicialDate, FFinalDate: TDate;
    FStyleBook: TStyleBook;
    FUseDataConnection: boolean;
    FFilterMethod: TFilterMethod;
    function GetVersion: string;
    procedure SetDataSource(const Value: TDataSource);
    procedure SetDataField(const Value: string);
    procedure SetAlign(const Value: TAlignLayout);
    procedure SetInitialDate(const Value: TDate);
    procedure SetFinalDate(const Value: TDate);
    procedure SetFilterMethod(const Value: TFilterMethod);
    procedure SetUseDataConnection(const Value: boolean);
    procedure ChangeBackGround;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Background: TRectangle read FRectangleBackground;
    property InitialBackground: TRectangle read FBackGroundInitialDate;
    property FinalBackground: TRectangle read FBackGroundFinalDate;
    property InitialHeader: TLabel read FPeriodoInicial;
    property FinalHeader: TLabel read FPeriodoFinal;
    property Separator: TLine read FLine;
    property About: String read GetVersion;
    property DataSource: TDataSource read FDataSource write SetDataSource;
    property DataField: string read FDataField write SetDataField;
    property Align: TAlignLayout read FAlign write SetAlign;
    property InitialIcon: TLabel read FInitialIcon;
    property FinalIcon: TLabel read FFinalIcon;
    property ExpandIcon: TLabel read FExpandIcon;
    property InicialDate: TDate read FInicialDate write SetInitialDate;
    property FinalDate: TDate read FFinalDate write SetFinalDate;
    property UseDataConnection: boolean read FUseDataConnection
      write SetUseDataConnection;
    property FilterMethod: TFilterMethod read FFilterMethod
      write SetFilterMethod;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Delphi | Biblioteca GD', [TGDDateFilter]);
end;

{ TGDDateFilter }

procedure TGDDateFilter.ChangeBackGround;
var
  i: Integer;
begin
  FInicialDateEdit.StyleLookup := 'DateEdit1Style1';
  FInicialDateEdit.ApplyStyleLookup;
  FFinalDateEdit.StyleLookup := 'DateEdit1Style1';
  FFinalDateEdit.ApplyStyleLookup;
end;

constructor TGDDateFilter.Create(AOwner: TComponent);
var
  LBackGround, LBackGroundSeta: TFmxObject;
begin
  inherited Create(AOwner);
  // Cria o BackGround
  FRectangleBackground := TRectangle.Create(Self);
  FRectangleBackground.Parent := Self;
  FRectangleBackground.Align := TAlignLayout.Client;
  FRectangleBackground.Stroke.Thickness := 0;
  FRectangleBackground.Fill.Color := TAlphaColorRec.Null;
  Width := 329;
  Height := 53;
  // Cria um Layout para deixar alinhado ao topo
  FLayout := TLayout.Create(Self);
  FLayout.Parent := FRectangleBackground;
  FLayout.Height := 53;
  FLayout.Align := TAlignLayout.top;

  // Cria as Labels
  FPeriodoInicial := TLabel.Create(Self);
  with FPeriodoInicial do
  begin
    Parent := FLayout;
    StyledSettings := [];
    TextSettings.Font.Family := 'Signika';
    TextSettings.Font.Size := 14;
    Text := 'Data Inicial';
    Position.X := 0;
    Position.Y := -2;
  end;
  FPeriodoFinal := TLabel.Create(Self);
  with FPeriodoFinal do
  begin
    Parent := FLayout;
    StyledSettings := [];
    TextSettings.Font.Family := 'Signika';
    TextSettings.Font.Size := 14;
    Text := 'Data Final';
    Position.X := 169;
    Position.Y := -2;
  end;
  // Cria o BackGround do Date Inicial
  FBackGroundInitialDate := TRectangle.Create(Self);
  with FBackGroundInitialDate do
  begin
    Parent := FLayout;
    Height := 35;
    Width := 135;
    Stroke.Thickness := 2;
    Stroke.Color := DefaultSecondaryColor;
    Fill.Color := TAlphaColorRec.White;
    XRadius := 5;
    YRadius := 5;
    Position.X := FPeriodoInicial.Position.X;
    Position.Y := 17;
  end;
  // Cria o BackGround do Date Final
  FBackGroundFinalDate := TRectangle.Create(Self);
  with FBackGroundFinalDate do
  begin
    Parent := FLayout;
    Height := 35;
    Width := 135;
    Stroke.Thickness := 2;
    Stroke.Color := DefaultSecondaryColor;
    Fill.Color := TAlphaColorRec.White;
    XRadius := 5;
    YRadius := 5;
    Position.X := FPeriodoFinal.Position.X;
    Position.Y := 17;
  end;
  Align := TAlignLayout.None;

  FLine := TLine.Create(Self);
  with FLine do
  begin
    Parent := FLayout;
    LineType := TLineType.top;
    Height := 2;
    Width := 18;
    Position.X := 143;
    Position.Y := 33;
    Stroke.Thickness := 2;
    Stroke.Color := DefaultSecondaryColor;
  end;
  FInitialIcon := TLabel.Create(Self);
  with FInitialIcon do
  begin
    Parent := FBackGroundInitialDate;
    StyledSettings := [];
    Align := TAlignLayout.Left;
    Width := 30;
    TextSettings.Font.Family := 'Font Awesome 6 Free';
    TextSettings.Font.Size := 18;
    TextSettings.HorzAlign := TTextAlign.Center;
    TextSettings.VertAlign := TTextAlign.Center;
    TextSettings.FontColor := DefaultIconColor;
    Text := '';
  end;
  FFinalIcon := TLabel.Create(Self);
  with FFinalIcon do
  begin
    Parent := FBackGroundFinalDate;
    StyledSettings := [];
    Align := TAlignLayout.Left;
    Width := 30;
    TextSettings.Font.Family := 'Font Awesome 6 Free';
    TextSettings.Font.Size := 18;
    TextSettings.HorzAlign := TTextAlign.Center;
    TextSettings.VertAlign := TTextAlign.Center;
    TextSettings.FontColor := DefaultIconColor;
    Text := '';
  end;
  FExpandIcon := TLabel.Create(Self);
  with FExpandIcon do
  begin
    Parent := FLayout;
    StyledSettings := [];
    Width := 25;
    Height := 35;
    TextSettings.Font.Family := 'Font Awesome 6 Free Solid';
    TextSettings.Font.Size := 15;
    TextSettings.HorzAlign := TTextAlign.Center;
    TextSettings.VertAlign := TTextAlign.Center;
    TextSettings.FontColor := DefaultSecondaryColor;
    Text := '';
    Position.X := 306;
    Position.Y := 17;
  end;
  FInicialDateEdit := TDateEdit.Create(Self);
  with (FInicialDateEdit) do
  begin
    Parent := FBackGroundInitialDate;
    Height := 32;
    Width := 101;
    StyledSettings := [];
    TextSettings.Font.Family := 'Signika';
    TextSettings.Font.Size := 15;
    TextSettings.HorzAlign := TTextAlign.Center;
    TextSettings.VertAlign := TTextAlign.Center;
    Position.X := 28;
    Position.Y := 2;
  end;
  FFinalDateEdit := TDateEdit.Create(Self);
  with FFinalDateEdit do
  begin
    Parent := FBackGroundFinalDate;
    Height := 32;
    Width := 101;
    StyledSettings := [];
    TextSettings.Font.Family := 'Signika';
    TextSettings.Font.Size := 15;
    TextSettings.HorzAlign := TTextAlign.Center;
    TextSettings.VertAlign := TTextAlign.Center;
    Position.X := 28;
    Position.Y := 2;
  end;
  FFinalDate := FFinalDateEdit.Date;
  FInicialDate := FInicialDateEdit.Date;
  FStyleBook := TStyleBook.Create(Self);
  ReturnStyles(FStyleBook);
  ChangeBackGround;
  FUseDataConnection := true;
  FFilterMethod := fmFilter;
end;

destructor TGDDateFilter.Destroy;
begin
  FLine.Free;
  FPeriodoInicial.Free;
  FPeriodoFinal.Free;
  FExpandIcon.Free;
  FInitialIcon.Free;
  FFinalIcon.Free;
  FInicialDateEdit.Free;
  FFinalDateEdit.Free;
  FBackGroundFinalDate.Free;
  FBackGroundInitialDate.Free;
  FLayout.Free;
  FRectangleBackground.Free;
  FStyleBook.Free;
  inherited;
end;

function TGDDateFilter.GetVersion: string;
begin
  Result := GetComponentVersion;
end;


procedure TGDDateFilter.SetDataSource(const Value: TDataSource);
begin
  if FDataSource <> Value then
  begin
    FDataSource := Value;
  end;
end;

procedure TGDDateFilter.SetFilterMethod(const Value: TFilterMethod);
begin
  if FFilterMethod <> Value then
  begin
    if (not FUseDataConnection) and (Value = fmFilter) then
      FFilterMethod := fmRefresh
    else
      FFilterMethod := Value;
  end;
end;

procedure TGDDateFilter.SetFinalDate(const Value: TDate);
begin
  if FFinalDate <> Value then
  begin
    FFinalDate := Value;
    FFinalDateEdit.Date := Value;
  end;
end;

procedure TGDDateFilter.SetInitialDate(const Value: TDate);
begin
  if FInicialDate <> Value then
  begin
    FInicialDate := Value;
    FInicialDateEdit.Date := Value;
  end;
end;

procedure TGDDateFilter.SetUseDataConnection(const Value: boolean);
begin
  if FUseDataConnection <> Value then
  begin
    FUseDataConnection := Value;
  end;
end;

procedure TGDDateFilter.SetAlign(const Value: TAlignLayout);
begin
  if FAlign <> Value then
  begin
    FAlign := Value;
    inherited Align := FAlign;
  end;
end;

procedure TGDDateFilter.SetDataField(const Value: string);
var
  LField: TField;
begin
  if Assigned(FDataSource) and Assigned(FDataSource.DataSet) then
  begin
    LField := FDataSource.DataSet.FindField(Value);
    if Assigned(LField) and (LField.DataType in [ftDate, ftDateTime,
      ftTimeStamp]) then
    begin
      if FDataField <> Value then
      begin
        FDataField := Value;
        // Atualize o componente conforme necessário aqui, se necessário
      end;
    end
    else
      raise Exception.CreateFmt
        ('O campo "%s" não é um campo Date ou DateTime.', [Value]);
  end
  else if Value = '' then
    FDataField := Value;
end;

end.
