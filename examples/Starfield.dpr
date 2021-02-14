program Starfield;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  GVT in '..\libs\GVT.pas';

const
  cArchivePassword   = '46637e728b06480f87df732f7e1777f5';
  cArchiveFilename   = 'Data.arc';

type
  { TStarfieldEx }
  TStarfieldEx = class(TGVGame)
  protected
    FCenterPos: TGVVector;
    FDimColor: TGVColor;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure OnInitParams(var aParams: TGVGameParams); override;
    procedure OnLoad; override;
    procedure OnExit; override;
    procedure OnStartup; override;
    procedure OnShutdown; override;
    procedure OnUpdate(aDeltaTime: Double); override;
    procedure OnRender; override;
    procedure OnRenderGUI; override;
  end;

{ TStarfieldEx }
constructor TStarfieldEx.Create;
begin
  inherited;

end;

destructor TStarfieldEx.Destroy;
begin

  inherited;
end;

procedure TStarfieldEx.OnInitParams(var aParams: TGVGameParams);
begin
  aParams.ArchivePassword := cArchivePassword;
  aParams.ArchiveFilename := cArchiveFilename;
  aParams.DisplayTitle := 'GameVision: Starfield Example';
  FCenterPos.X := aParams.DisplayWidth / 2;
  FCenterPos.Y := aParams.DisplayHeight / 2;
  FDimColor := GV_MakeColor(16, 16, 16, 255);
end;

procedure TStarfieldEx.OnLoad;
begin
  inherited;

end;

procedure TStarfieldEx.OnExit;
begin

  inherited;
end;

procedure TStarfieldEx.OnStartup;
begin
  inherited;

end;

procedure TStarfieldEx.OnShutdown;
begin

  inherited;
end;

procedure TStarfieldEx.OnUpdate(aDeltaTime: Double);
begin
  inherited;

  if GV_KeyboardPressed(KEY_F11) then
    GV_ToggleFullscreenDisplay;

  if GV_KeyboardPressed(KEY_ESCAPE) then
    GV_TakeScreenshot;

  // starfield #1
  if GV_KeyboardPressed(KEY_1) then
  begin
    GV_SetStarfieldXSpeed(FStarfield, 25*7);
    GV_SetStarfieldYSpeed(FStarfield, 0);
    GV_SetStarfieldZSpeed(FStarfield, -(5*25));
    GV_SetStarfieldVirtualPos(FStarfield, 0, 0);
  end;

  // starfield #2
  if GV_KeyboardPressed(KEY_2) then
  begin
    GV_SetStarfieldXSpeed(FStarfield, 0);
    GV_SetStarfieldYSpeed(FStarfield, -(25*5));
    GV_SetStarfieldZSpeed(FStarfield, -(5*25));
    GV_SetStarfieldVirtualPos(FStarfield, 0, 0);
  end;

  // starfield #3
  if GV_KeyboardPressed(KEY_3) then
  begin
    GV_SetStarfieldXSpeed(FStarfield, -(25*5));
    GV_SetStarfieldYSpeed(FStarfield, 0);
    GV_SetStarfieldZSpeed(FStarfield, -(5*25));
    GV_SetStarfieldVirtualPos(FStarfield, 0, 0);
  end;

  // starfield #4
  if GV_KeyboardPressed(KEY_4) then
  begin
    GV_SetStarfieldXSpeed(FStarfield, 0);
    GV_SetStarfieldYSpeed(FStarfield, 25*5);
    GV_SetStarfieldZSpeed(FStarfield, -(5*25));
    GV_SetStarfieldVirtualPos(FStarfield, 0, 0);
  end;

  // starfield #5
  if GV_KeyboardPressed(KEY_5) then
  begin
    GV_SetStarfieldXSpeed(FStarfield, 0);
    GV_SetStarfieldYSpeed(FStarfield, 0);
    GV_SetStarfieldZSpeed(FStarfield, 5*25);
    GV_SetStarfieldVirtualPos(FStarfield, 0, 0);
  end;

  // starfield #6
  if GV_KeyboardPressed(KEY_6) then
  begin
    GV_SetStarfieldZSpeed(FStarfield, 0);
    GV_SetStarfieldYSpeed(FStarfield, 15*10);
  end;

  // starfield #7
  if GV_KeyboardPressed(KEY_7) then
  begin
    GV_SetStarfieldXSpeed(FStarfield, 0);
    GV_SetStarfieldYSpeed(FStarfield, 0);
    GV_SetStarfieldZSpeed(FStarfield, -(5*25));
    GV_SetStarfieldVirtualPos(FStarfield, 0, 0);
  end;


  GV_UpdateStarfield(Starfield, aDeltaTime);
end;

procedure TStarfieldEx.OnRender;
begin
  inherited;

  GV_RenderStarfield(Starfield);
end;

procedure TStarfieldEx.OnRenderGUI;
begin
  HudPos.X := 3;
  HudPos.Y := 3;
  GV_PrintFontY(MonoFont, HudPos.X, HudPos.Y, 0, WHITE, haLeft, 'fps %d', [GV_GetFrameRate]);
  GV_PrintFontY(MonoFont, HudPos.X, HudPos.Y, 0, GREEN, haLeft, 'ESC       - Quit', []);
  GV_PrintFontY(MonoFont, HudPos.X, HudPos.Y, 0, GREEN, haLeft, 'F11       - Toggle fullscreen', []);
  GV_PrintFontY(MonoFont, HudPos.X, HudPos.Y, 0, GREEN, haLeft, 'F12       - Screenshot', []);

  GV_PrintFontY(MonoFont, HudPos.X, HudPos.Y, 0, GREEN, haLeft, '1-7       - Starfield', []);

  GV_PrintFont(MonoFont, FCenterPos.X, DisplayHeight-(MonoFontSize+2), FDimColor, haCenter, 'GameVision Toolkit™ - gamevision.dev', []);

end;

{ main }
begin
  try
    GV_RunGame(TStarfieldEx);
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
