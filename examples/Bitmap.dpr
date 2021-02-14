program Bitmap;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  GVT in '..\libs\GVT.pas';

const
  cArchivePassword   = '46637e728b06480f87df732f7e1777f5';
  cArchiveFilename   = 'Data.arc';

type
  { TBitmapEx }
  TBitmapEx = class(TGVGame)
  protected
    FCenterPos: TGVVector;
    FDimColor: TGVColor;
    FBitmap: array[ 0..1] of TGVBitmap;
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

{ TBitmapEx }
constructor TBitmapEx.Create;
begin
  inherited;

end;

destructor TBitmapEx.Destroy;
begin

  inherited;
end;

procedure TBitmapEx.OnInitParams(var aParams: TGVGameParams);
begin
  aParams.ArchivePassword := cArchivePassword;
  aParams.ArchiveFilename := cArchiveFilename;
  aParams.DisplayTitle := 'GameVision: Bitmap Example';
  aParams.DisplayClearColor := DARKGRAY;
  FCenterPos.X := aParams.DisplayWidth / 2;
  FCenterPos.Y := aParams.DisplayHeight / 2;
  FDimColor := GV_MakeColor(16, 16, 16, 255);
end;

procedure TBitmapEx.OnLoad;
begin
  inherited;

end;

procedure TBitmapEx.OnExit;
begin

  inherited;
end;

procedure TBitmapEx.OnStartup;
begin
  inherited;

  // load a bitmap that has true transparancy
  FBitmap[0] := GV_LoadBitmap(Archive, 'arc/bitmaps/sprites/gamevision1.png', nil);

  // load a bitmap and use colorkey transparancy
  FBitmap[1] := GV_LoadBitmap(Archive, 'arc/bitmaps/sprites/circle00.png', @COLORKEY);

end;

procedure TBitmapEx.OnShutdown;
begin
  GV_FreeBitmap(FBitmap[1]);
  GV_FreeBitmap(FBitmap[0]);

  inherited;
end;

procedure TBitmapEx.OnUpdate(aDeltaTime: Double);
begin
  inherited;

  if GV_KeyboardPressed(KEY_F11) then
    GV_ToggleFullscreenDisplay;

  if GV_KeyboardPressed(KEY_ESCAPE) then
    GV_TakeScreenshot;
end;

procedure TBitmapEx.OnRender;
begin
  inherited;

  // draw transparancy bitmap
  GV_DrawBitmap(FBitmap[0], DisplayWidth/2, 140, 0.5, 0, WHITE, haCenter, vaCenter);

  // draw colorkey transparancy bitmap
  GV_DrawBitmap(FBitmap[1], DisplayWidth/2, 320, 1, 0, WHITE, haCenter, vaCenter);

end;

procedure TBitmapEx.OnRenderGUI;
begin
  HudPos.X := 3;
  HudPos.Y := 3;
  GV_PrintFontY(MonoFont, HudPos.X, HudPos.Y, 0, WHITE, haLeft, 'fps %d', [GV_GetFrameRate]);
  GV_PrintFontY(MonoFont, HudPos.X, HudPos.Y, 0, GREEN, haLeft, 'ESC       - Quit', []);
  GV_PrintFontY(MonoFont, HudPos.X, HudPos.Y, 0, GREEN, haLeft, 'F11       - Toggle fullscreen', []);
  GV_PrintFontY(MonoFont, HudPos.X, HudPos.Y, 0, GREEN, haLeft, 'F12       - Screenshot', []);
  GV_PrintFont(MonoFont, FCenterPos.X, DisplayHeight-(MonoFontSize+2), FDimColor, haCenter, 'GameVision Toolkit™ - gamevision.dev', []);

  GV_PrintFont(MonoFont, DisplayWidth/2, 205, YELLOW, haCenter, 'true trans', []);
  GV_PrintFont(MonoFont, DisplayWidth/2, 385, YELLOW, haCenter, 'colorkey trans', []);

end;

{ main }
begin
  try
    GV_RunGame(TBitmapEx);
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
