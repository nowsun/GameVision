unit uMessageDialog;

interface

uses
  GVT;

type

  { TMessageDialogEx }
  TMessageDialogEx = class(TGVCustomgame)
  public
    function Run: Boolean; override;
  end;


implementation

{ TMessageDialogEx }
function TMessageDialogEx.Run: Boolean;
begin
  GV_MessageDialog('Default', 'Default message dialog', [], mdDefault);
  GV_MessageDialog('Error', 'Error message dialog', [], mdError);
  GV_MessageDialog('Warning', 'Warning message dialog', [], mdWarning);
  GV_MessageDialog('Info', 'Info message dialog', [], mdInfo);
  Result := False;
end;


end.
