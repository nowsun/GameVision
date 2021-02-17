unit uOpenFileDialog;

interface

uses
  GVT;

type
  { TOpenFileDialogEx }
  TOpenFileDialogEx = class(TGVCustomgame)
  public
    function Run: Boolean; override;
  end;


implementation

{ TOpenFileDialogEx }

function TOpenFileDialogEx.Run: Boolean;
var
  LFilename: WideString;
begin
  if GV_OpenFileDialog('Open Source File', 'Source Files|*.pas', 0, '.pas', '', LFilename) then
  begin
    GV_MessageDialog('Open Source File', '%s', [LFilename], mdDefault);
  end;

  Result := False;
end;

end.
