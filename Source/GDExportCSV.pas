unit GDExportCSV;

interface

uses
  System.SysUtils, System.Classes, FMX.Dialogs, Data.DB;

type
  TGDExportCSV = class(TComponent)
  private
    FDataSource: TDataSource;
    function GetVersion: string;
  public
    procedure Export;
  published
    property About: String read GetVersion;
    property DataSource: TDataSource read FDataSource write FDataSource;
  end;

procedure Register;

implementation

uses GD.Types;

procedure TGDExportCSV.Export;
var
  SaveDlg: TSaveDialog;
  Lines: TStringList;
  Field: TField;
  LineValue: string;
  i: Integer;
begin
  if not Assigned(FDataSource) then
    raise Exception.Create('DataSource not assigned.');

  if not Assigned(FDataSource.DataSet) then
    raise Exception.Create('DataSet not assigned to DataSource.');

  SaveDlg := TSaveDialog.Create(nil);
  Lines := TStringList.Create;
  try
    SaveDlg.Filter := 'CSV File|*.csv';
    SaveDlg.DefaultExt := 'csv';
    if SaveDlg.Execute then
    begin
      // Add header row
      LineValue := '';
      for i := 0 to FDataSource.DataSet.FieldCount - 1 do
      begin
        Field := FDataSource.DataSet.Fields[i];
        LineValue := LineValue + '"' + Field.DisplayName + '"';
        if i < FDataSource.DataSet.FieldCount - 1 then
          LineValue := LineValue + ';'; // Use semicolon as delimiter
      end;
      Lines.Add(LineValue);

      // Iterate through records
      FDataSource.DataSet.First;
      while not FDataSource.DataSet.Eof do
      begin
        LineValue := '';
        for i := 0 to FDataSource.DataSet.FieldCount - 1 do
        begin
          Field := FDataSource.DataSet.Fields[i];
          LineValue := LineValue + '"' + Field.AsString + '"';
          if i < FDataSource.DataSet.FieldCount - 1 then
            LineValue := LineValue + ';'; // Use semicolon as delimiter
        end;
        Lines.Add(LineValue);
        FDataSource.DataSet.Next;
      end;
      Lines.SaveToFile(SaveDlg.FileName);
    end;
  finally
    SaveDlg.Free;
    Lines.Free;
  end;
end;


procedure Register;
begin
  RegisterComponents('Delphi | Biblioteca GD', [TGDExportCSV]);
end;

function TGDExportCSV.GetVersion: string;
begin
  Result := GetComponentVersion;
end;

end.
