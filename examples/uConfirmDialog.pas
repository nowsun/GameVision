unit uConfirmDialog;

interface

uses
  GVT;

type
  { TConfirmDialogEx }
  TConfirmDialogEx = class(TGVCustomgame)
  public
    function Run: Boolean; override;
  end;


implementation

{ TConfirmDialogEx }

function TConfirmDialogEx.Run: Boolean;
begin
  case GV_ConfirmDialog('Please confirm?', []) of
    cdYes   : GV_MessageDialog('Confirm', 'Accept', [], mdInfo);
    cdNo    : GV_MessageDialog('Confirm', 'Did not accept', [], mdInfo);
    cdCancel: GV_MessageDialog('Confirm', 'Cancelled', [], mdInfo);
  end;
  Result := False;
end;

end.
