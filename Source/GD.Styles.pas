unit GD.Styles;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.DateTimeCtrls;

type
  TGDStyles = class(TForm)
    DateEdit1: TDateEdit;
    StyleBookGDStyles: TStyleBook;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  GDStyles: TGDStyles;

implementation

{$R *.fmx}

end.
