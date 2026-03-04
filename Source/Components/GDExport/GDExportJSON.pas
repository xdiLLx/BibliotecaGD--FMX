unit GDExportJSON;

interface

uses
  System.SysUtils, System.Classes, FMX.Dialogs, Data.DB, System.JSON,System.IOUtils;

type
  TGDExportJSON = class(TComponent)
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

procedure TGDExportJSON.Export;
var
  SaveDlg: TSaveDialog;
  JSONArr: TJSONArray;
  JSONObj: TJSONObject;
  Field: TField;
  i: Integer;
begin
  if not Assigned(FDataSource) then
    raise Exception.Create('DataSource not assigned.');

  if not Assigned(FDataSource.DataSet) then
    raise Exception.Create('DataSet not assigned to DataSource.');

  SaveDlg := TSaveDialog.Create(nil);
  JSONArr := TJSONArray.Create;
  try
    SaveDlg.Filter := 'JSON File|*.json';
    SaveDlg.DefaultExt := 'json';
    if SaveDlg.Execute then
    begin
      // Iterate through records
      FDataSource.DataSet.First;
      while not FDataSource.DataSet.Eof do
      begin
        JSONObj := TJSONObject.Create;
        for i := 0 to FDataSource.DataSet.FieldCount - 1 do
        begin
          Field := FDataSource.DataSet.Fields[i];
          JSONObj.AddPair(Field.FieldName, TJSONString.Create(Field.AsString));
        end;
        JSONArr.AddElement(JSONObj);
        FDataSource.DataSet.Next;
      end;
      TFile.WriteAllText(SaveDlg.FileName, JSONArr.ToString);
    end;
  finally
    SaveDlg.Free;
    JSONArr.Free;
  end;
end;

procedure Register;
begin
  RegisterComponents('Delphi | Biblioteca GD', [TGDExportJSON]);
end;

function TGDExportJSON.GetVersion: string;
begin
  Result := GetComponentVersion;
end;

end.

