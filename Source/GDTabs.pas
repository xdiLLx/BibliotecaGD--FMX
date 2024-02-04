unit GDTabs;

interface

uses
  System.SysUtils, System.Classes, Vcl.Controls, Vcl.Forms,
  Vcl.ComCtrls, ChromeTabs, ChromeTabsClasses, ChromeTabsTypes;

type
  TGDTabs = class(TChromeTabs)
  private
    FPageControl: TPageControl;
    procedure SetPageControl(const Value: TPageControl);
  public
    procedure AbrirFormulario(FormClass: TFormClass; const ATitle: string);
  published
    property PageControl: TPageControl read FPageControl write SetPageControl;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Delphi | Biblioteca GD', [TGDTabs]);
end;

{ TGDTabs }

procedure TGDTabs.AbrirFormulario(FormClass: TFormClass; const ATitle: string);
var
  TabSheet: TTabSheet;
  Form: TForm;
  Tab: TChromeTab;
begin
  if not Assigned(FPageControl) then Exit;

  // Cria uma nova guia no ChromeTabs
  Tab := Self.Tabs.Add;
  Tab.Caption := ATitle;

  // Cria um novo TabSheet no PageControl
  TabSheet := TTabSheet.Create(FPageControl);
  TabSheet.PageControl := FPageControl;
  TabSheet.TabVisible := False;

  // Cria o formulário dentro do TabSheet
  Form := FormClass.Create(TabSheet);
  Form.Parent := TabSheet;
  Form.Align := alClient;
  Form.BorderStyle := bsNone;
  Form.Show;

  // Ativa a nova guia e o TabSheet correspondente
  Self.ActiveTabIndex := Tab.Index;
  FPageControl.ActivePage := TabSheet;
end;

procedure TGDTabs.SetPageControl(const Value: TPageControl);
begin
  FPageControl := Value;
end;

end.

