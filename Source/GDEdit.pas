unit GDEdit;

interface

uses
  System.SysUtils, System.Classes, FMX.Edit, Data.DB, GD.Types, System.Types,
  System.Math, FMX.Types, System.UITypes;

type
  TGDEdit = class(TEdit)
  private
    FDataSource: TDataSource;
    FDataField: string;
    FOriginalText: string;
    FOriginalDataChange: TDataChangeEvent;
    FOnKeyDown: TKeyEvent;
    procedure SetDataSource(const Value: TDataSource);
    procedure SetDataField(const Value: string);
    procedure UpdateControlState;
    procedure UpdateData;
    procedure DataSetEvent(DataSet: TDataSet);
    procedure DataSourceChanged(Sender: TObject; Field: TField);
    function GetVersion: string;
    procedure IntermediateDataChange(Sender: TObject; Field: TField);
    procedure ValidateInput(Sender: TObject);
    function IsDigit(const Value: string): Boolean;
  protected
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    procedure DoEnter; override;
    procedure DoExit; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property About: String read GetVersion;
    property DataSource: TDataSource read FDataSource write SetDataSource;
    property DataField: string read FDataField write SetDataField;
    property OnKeyDown: TKeyEvent read FOnKeyDown write FOnKeyDown;
  end;

procedure register;

implementation

procedure register;
begin
  RegisterComponents('Delphi | Biblioteca GD', [TGDEdit]);
end;

constructor TGDEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ReadOnly := True;
  OnTyping := ValidateInput;
end;

destructor TGDEdit.Destroy;
begin
  SetDataSource(nil);
  inherited Destroy;
end;

procedure TGDEdit.SetDataSource(const Value: TDataSource);
begin
  if FDataSource <> Value then
  begin
    if Assigned(FDataSource) then
    begin
      FDataSource.RemoveFreeNotification(Self);
    end;

    FDataSource := Value;

    if Assigned(FDataSource) then
    begin
      FDataSource.FreeNotification(Self);

      // Guarde o evento OnDataChange anterior
      FOriginalDataChange := FDataSource.OnDataChange;
      FDataSource.OnDataChange := IntermediateDataChange;
    end;

    UpdateControlState;
  end;
end;

procedure TGDEdit.SetDataField(const Value: string);
begin
  if FDataField <> Value then
  begin
    FDataField := Value;
    UpdateData;
  end;
end;

procedure TGDEdit.UpdateControlState;
var
  Field: TField;
begin
  Field := nil;

  if Assigned(FDataSource) and Assigned(FDataSource.DataSet) then
  begin
    Field := FDataSource.DataSet.FindField(FDataField);

    ReadOnly := not(FDataSource.DataSet.State in [dsEdit, dsInsert]) or
      (Field = nil);
    if Assigned(Field) then
      Text := Field.AsString
    else
      Text := '';
  end
  else
  begin
    ReadOnly := True;
    Text := '';
  end;
end;

procedure TGDEdit.UpdateData;
var
  Field: TField;
begin
  Field := nil;
  if ReadOnly and Assigned(FDataSource) and Assigned(FDataSource.DataSet) then
    Field := FDataSource.DataSet.FieldByName(FDataField);

  if Assigned(Field) then
    Text := Field.AsString
  else
    Text := '';
end;

procedure TGDEdit.ValidateInput(Sender: TObject);
var
  Field: TField;
  LastChar: Char;
  DecimalSeparator: Char;
begin
  Field := nil;

  if Assigned(FDataSource) and Assigned(FDataSource.DataSet) then
    Field := FDataSource.DataSet.FieldByName(FDataField);

  if Assigned(Field) and not Text.IsEmpty then
  begin
    LastChar := Text[Length(Text)];
    DecimalSeparator := FormatSettings.DecimalSeparator;

    case Field.DataType of
      ftString, ftWideString, ftMemo, ftWideMemo:
        ; // Sem validações para strings e memos

      ftInteger, ftWord, ftSmallint, ftLargeint, ftByte:
        if not IsDigit(LastChar) then
          Text := Copy(Text, 1, Length(Text) - 1);

      ftFloat, ftCurrency, ftBCD, ftFMTBcd:
        if not CharInSet(LastChar, ['0' .. '9', DecimalSeparator, '-', '+']) or
          ((Text.CountChar(DecimalSeparator) > 1) or
          ((LastChar in ['-', '+']) and (Length(Text) > 1))) then
          Text := Text.Remove(Length(Text) - 1);

      ftDate, ftDateTime, ftTime:
        // Simples verificação para datas e horários; isso pode precisar ser aprimorado
        if not CharInSet(LastChar, ['0' .. '9', '-', '/', ':']) then
          Text := Text.Remove(Length(Text) - 1);

      ftBoolean:
        if not CharInSet(LastChar, ['0', '1', 't', 'T', 'f', 'F']) then
          Text := Text.Remove(Length(Text) - 1);

      // Adicione outros tipos e validações conforme necessário
      // Para outros tipos, como Blob, Graphic, etc., pode não ser apropriado validar aqui

    end;
  end;
end;

procedure TGDEdit.DataSetEvent(DataSet: TDataSet);
begin
  UpdateControlState;
end;

procedure TGDEdit.DoEnter;
begin
  inherited DoEnter;
  FOriginalText := Text;
end;

procedure TGDEdit.DoExit;
var
  Field: TField;
begin
  inherited DoExit;

  if Assigned(FDataSource) and Assigned(FDataSource.DataSet) then
  begin
    Field := FDataSource.DataSet.FieldByName(FDataField);
    if (Field <> nil) and (Field.AsString <> Text) then
    begin
      Field.AsString := Text;
    end;
  end;
end;

function TGDEdit.GetVersion: string;
begin
  Result := GetComponentVersion;
end;

procedure TGDEdit.IntermediateDataChange(Sender: TObject; Field: TField);
begin
  if Assigned(FOriginalDataChange) then
    FOriginalDataChange(Sender, Field);

  DataSourceChanged(Sender, Field);
end;

function TGDEdit.IsDigit(const Value: string): Boolean;
begin
  Result := (Length(Value) = 1) and (Value[1] >= '0') and (Value[1] <= '9');
end;

procedure TGDEdit.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FDataSource) then
    DataSource := nil;
end;

procedure TGDEdit.DataSourceChanged(Sender: TObject; Field: TField);
begin
  UpdateControlState;
end;

end.
