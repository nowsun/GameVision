unit uOpenDirDialog;

interface

uses
  GVT;

type
  { TOpenDirDialogEx }
  TOpenDirDialogEx = class(TGVCustomgame)
  public
    function Run: Boolean; override;
  end;


implementation

{ TOpenDirDialogEx }

function TOpenDirDialogEx.Run: Boolean;
var
  LDirName: WideString;
begin
  if GV_OpenDirDialog('Directory Name', '', LDirName) then
  begin
    GV_MessageDialog('Open Directory', '%s', [LDirName], mdDefault);
  end;

  Result := False;
end;

end.
