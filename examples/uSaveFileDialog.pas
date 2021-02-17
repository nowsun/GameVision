unit uSaveFileDialog;

interface

uses
  GVT;

type
  { TSaveFileDialogEx }
  TSaveFileDialogEx = class(TGVCustomgame)
  public
    function Run: Boolean; override;
  end;


implementation

{ TSaveFileDialogEx }

function TSaveFileDialogEx.Run: Boolean;
var
  LFilename: WideString;
begin
  if GV_SaveFileDialog('Save Source File', 'Source Files|*.pas', 0, '.pas', LFilename) then
  begin
    GV_MessageDialog('Save Source File', '%s', [LFilename], mdDefault);
  end;

  Result := False;
end;

end.
