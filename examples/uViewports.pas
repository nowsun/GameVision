{==============================================================================
   ___              __   ___    _
  / __|__ _ _ __  __\ \ / (_)__(_)___ _ _
 | (_ / _` | '  \/ -_) V /| (_-< / _ \ ' \
  \___\__,_|_|_|_\___|\_/ |_/__/_\___/_||_|
             Toolkit™ for Delphi

 Copyright © 2021 tinyBigGAMES™ LLC
 All rights reserved.

 Website: https://tinybiggames.com
 Email  : support@tinybiggames.com

 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:

 1. Redistributions of source code must retain the above copyright notice,
    this list of conditions and the following disclaimer.

 2. Redistributions in binary form must reproduce the above copyright
    notice, this list of conditions and the following disclaimer in the
    documentation and/or other materials provided with the distribution.

 3. Neither the name of the copyright holder nor the names of its
    contributors may be used to endorse or promote products derived from
    this software without specific prior written permission.

 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
 LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
============================================================================== }

unit uViewports;

interface

uses
  GVT,
  uCommon;

const
  GRAVITY        = 0.4;
  XDECAY         = 0.97;
  YDECAY         = 0.97;
  ELASTICITY     = 0.77;
  WALLDECAY      = 1.0;
  BALL_SIZE      = 30;
  BALL_SIZE_HALF = BALL_SIZE div 2;


type

  { TViewportWindow }
  TViewportWindow = record
    w,h: Integer;
    x,y,sx,sy: Single;
    minx,maxx: Single;
    miny,maxy: Single;
    color: TGVColor;
  end;

  { TViewport }
  TViewport = class(TGVActor)
  protected
    FHandle: TGVViewport;
    FSize : TGVVector;
    FPos  : TGVVector;
    FSpeed: TGVVector;
    FRange: TGVRange;
    FColor: TGVColor;
    FCaption: string;
  public
    property Caption: string read FCaption write FCaption;
    constructor Create; override;
    destructor Destroy; override;
    procedure OnUpdate(aDeltaTime: Double); override;
    procedure OnRender; override;
    procedure PrintCaption(aColor: TGVColor);
  end;

  { TViewport1 }
  TViewport1 = class(TViewport)
  protected
    FPolygon: TGVPolygon;
    FOrigin : TGVVector;
    FAngle  : Single;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure OnUpdate(aDeltaTime: Double); override;
    procedure OnRender; override;
  end;

  { TViewport2 }
  TViewport2 = class(TViewport)
  protected
    FBallPos: TGVVector;
    FBallSpeed: TGVVector;
    FTimer: Single;
  public
    constructor Create;  override;
    destructor Destroy; override;
    procedure OnUpdate(aDeltaTime: Double); override;
    procedure OnRender; override;
  end;

  { TViewport3 }
  TViewport3 = class(TViewport)
  protected
    FTileTexture: TGVBitmap;
    FTilePos: TGVVector;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure OnUpdate(aDeltaTime: Double); override;
    procedure OnRender; override;
  end;

  { TViewport4 }
  TViewport4 = class(TViewport)
  protected
    FStarfield: TGVStarfield;
  public
    constructor Create;  override;
    destructor Destroy; override;
    procedure OnUpdate(aDeltaTime: Double); override;
    procedure OnRender; override;
  end;

  { TViewportsEx }
  TViewportsEx = class(TBaseExample)
  protected
    FMusic: TGVMusic;
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

var
  Game: TViewportsEx = nil;

implementation

{  TViewport }
constructor TViewport.Create;
begin
  inherited;
  FPos.X := 10;
  FPos.Y := 10;
  FSize.X := 50;
  FSize.Y := 50;
  FRange.miny := 0;
  FRange.minx := 0;
  FRange.maxx := FRange.minx + 20;
  FRange.maxy := FRange.miny + 20;
  FSpeed.x := GV_RandomRangef(0.1*60,0.3*60);
  FSpeed.y := GV_RandomRangef(0.1*60,0.3*60);

  FColor := WHITE;
  FCaption := 'A Viewport';

  FHandle := nil;
end;

destructor TViewport.Destroy;
begin
  GV_FreeViewport(FHandle);
  inherited;
end;

procedure TViewport.OnUpdate(aDeltaTime: Double);
begin
  // update horizontal movement
  FPos.x := FPos.x + (FSpeed.x * aDeltaTime);
  if (FPos.x < FRange.MinX) then
    begin
      FPos.x  := FRange.Minx;
      FSpeed.x := -FSpeed.x;
    end
  else if (FPos.x > FRange.Maxx) then
    begin
      FPos.x  := FRange.Maxx;
      FSpeed.x := -FSpeed.x;
    end;

  // update horizontal movement
  FPos.y := FPos.y + (FSpeed.y * aDeltaTime);
  if (FPos.y < FRange.Miny) then
    begin
      FPos.y  := FRange.Miny;
      FSpeed.y := -FSpeed.y;
    end
  else if (FPos.y > FRange.Maxy) then
    begin
      FPos.y  := FRange.Maxy;
      FSpeed.y := -FSpeed.y;
    end;

  GV_SetViewportPosition(FHandle, Round(FPos.X), Round(FPos.y));
end;

procedure TViewport.OnRender;
begin
  GV_SetDisplayViewport(FHandle);
  GV_ClearDisplay(FColor);
end;

procedure TViewport.PrintCaption(aColor: TGVColor);
begin
  GV_PrintFont(Game.MonoFont, 3, 3, aColor, haLeft, FCaption, []);
end;


{ TViewport1 }
constructor TViewport1.Create;
begin
  inherited;

  Caption := 'Viewport #1';

  FSize.x := 380;
  FSize.y := 280;

  FPos.x := 10;
  FPos.y := 10;

  FRange.miny := 0;
  FRange.minx := 0;
  FRange.maxx := FRange.minx + 20;
  FRange.maxy := FRange.miny + 20;

  FColor := DIMGRAY;

  FHandle := GV_CreateViewport(Round(FPos.X), Round(FPos.Y), Round(FSize.X), Round(FSize.Y));

  // init polygon
  FPolygon := GV_CreatePolygon;
  GV_AddLocalPolygonPoint(FPolygon, 0, 0, True);
  GV_AddLocalPolygonPoint(FPolygon, 128, 0, True);
  GV_AddLocalPolygonPoint(FPolygon, 128, 128, True);
  GV_AddLocalPolygonPoint(FPolygon, 0, 128, True);
  GV_AddLocalPolygonPoint(FPolygon, 0, 0, True);

  // you can either use local coords such as -64, -64, 64, 64 etc and when
  // transformed it will be center or easier just use specify an origin. In this
  // case this polygon span is 128 so set the origin xy to 64 to center it on
  // screen.
  FOrigin.X := 64;
  FOrigin.Y := 64;
end;

destructor TViewport1.Destroy;
begin
  GV_FreePolygon(FPolygon);
  inherited;
end;

procedure TViewport1.OnUpdate(aDeltaTime: Double);
begin
  inherited;
  // update angle by DeltaTime to keep it constant. In this case the default
  // fps is 30 so we are in effect adding on degree every second.
  FAngle := FAngle + (30.0 * aDeltaTime);

  // just clip between 0 and 360 with wrapping. if greater than max value, it
  // will set min to value-max.
  GV_ClipValuef(FAngle, 0, 360, True);
end;

procedure TViewport1.OnRender;
begin
  inherited;
  // render polygon in center of screen
  //Polygon_Render(FPolygon, Round(FSize.X / 2), Round(FSize.Y / 2), 1, FAngle, 1, YELLOW, FLIP_NONE, @FOrigin);
  GV_RenderPolygon(FPolygon, FSize.X / 2, FSize.Y / 2, 1, FAngle, 1, YELLOW, @FOrigin, False, False);
  PrintCaption(BLACK);

  //FHandle.SetActive(False);
  GV_SetDisplayViewport(nil);
end;

{ TViewport2 }
constructor TViewport2.Create;
begin
  inherited;

  Caption := 'Viewport #2';

  FSize.x := 380;
  FSize.y := 280;

  FPos.x := 410;
  FPos.y := 10;

  FRange.miny := 0;
  FRange.minx := 400-10;
  FRange.maxx := FRange.minx + 20;
  FRange.maxy := FRange.miny + 20;

  FColor := GV_MakeColor(77, 157, 251, 255);

  FHandle  := GV_CreateViewport(Round(FPos.X), Round(FPos.Y), Round(FSize.X), Round(FSize.Y));

  FBallPos.x := GV_RandomRangef(BALL_SIZE_HALF, FSize.x-BALL_SIZE_HALF);
  FBallPos.y := BALL_SIZE_HALF;

  FBallSpeed.x := GV_RandomRangef(-50,50);
  FBallSpeed.y := GV_RandomRangef(3,7);
  FTimer := 0;
end;

destructor TViewport2.Destroy;
begin
  inherited;
end;

procedure TViewport2.OnUpdate(aDeltaTime: Double);
begin
  inherited;

  if not GV_FrameSpeed(FTimer, 60) then
    Exit;

  if GV_SameValuef(FBallSpeed.x, 0, 0.001) then
  begin
    FBallPos.x := GV_RandomRangef(BALL_SIZE_HALF, FSize.x-BALL_SIZE_HALF);
    FBallPos.y := BALL_SIZE_HALF;
    FBallSpeed.x := GV_RandomRangef(-50,50);
    FBallSpeed.y := GV_RandomRangef(3,7);
  end;

  // decay
  FBallSpeed.x := FBallSpeed.x * XDECAY;
  FBallSpeed.y := FBallSpeed.y * XDECAY;

  // gravity
  FBallSpeed.y := FBallSpeed.y + GRAVITY;

  // move
  FBallPos.x := FBallPos.x + FBallSpeed.x;
  FBallPos.y := FBallPos.y + FBallSpeed.y;

  if (FBallPos.x < BALL_SIZE) then
    begin
      FBallPos.x  := BALL_SIZE;
      FBallSpeed.x := -FBallSpeed.x * WALLDECAY;
    end;
  //else
  if (FBallPos.x > FSize.x-BALL_SIZE) then
    begin
      FBallPos.x  := FSize.x-BALL_SIZE;
      FBallSpeed.x := -FBallSpeed.x * WALLDECAY;
    end;

  // update horizontal movement

  if (FBallPos.y < BALL_SIZE) then
    begin
      FBallPos.y  := BALL_SIZE;
      FBallSpeed.y := -FBallSpeed.y * WALLDECAY;
    end;
  //else
  if (FBallPos.y > FSize.y-BALL_SIZE) then
    begin
      FBallPos.y  := FSize.y-BALL_SIZE;
      FBallSpeed.y := -FBallSpeed.y * WALLDECAY;
    end;
end;

procedure TViewport2.OnRender;
begin
  inherited;

  GV_DrawFilledCircle(FBallPos.X, FBallPos.Y, BALL_SIZE, RED);

  PrintCaption(YELLOW);

  GV_PrintFont(Game.MonoFont, 1, 15, WHITE, haLeft, 'x,y: %f,%f',[Abs(FBallSpeed.x),Abs(FBallSpeed.y)]);

  //FHandle.SetActive(False);
  GV_SetDisplayViewport(nil);
end;

{ TViewport3 }
constructor TViewport3.Create;
begin
  inherited;

  Caption := 'Viewport #3';

  FSize.x := 380;
  FSize.y := 280;

  FPos.x := 10;
  FPos.y := 310;

  FRange.miny := 300-10;
  FRange.minx := 0;
  FRange.maxx := FRange.minx + 20;
  FRange.maxy := FRange.miny + 20;

  FColor := BLACK;

  FHandle := GV_CreateViewport(Round(FPos.X), Round(FPos.Y), Round(FSize.X), Round(FSize.Y));

  FTilePos.x := 0;
  FTilePos.y := 0;

  FTileTexture := GV_LoadBitmap(Game.Archive, 'arc/bitmaps/backgrounds/bluestone.png', nil);
end;

destructor TViewport3.Destroy;
begin
  GV_FreeBitmap(FTileTexture);
  inherited;
end;

procedure TViewport3.OnUpdate(aDeltaTime: Double);
begin
  inherited;
  FTilePos.y := FTilePos.y + ((7.0*60) * aDeltaTime);
end;

procedure TViewport3.OnRender;
begin
  inherited;

  // tile texture across viewport
  GV_DrawBitmapTiled(FTileTexture, FTilePos.x,FTilePos.y);

  // display the viewport caption
  PrintCaption(WHITE);

  GV_SetDisplayViewport(nil);
end;



{ TViewport4 }
constructor TViewport4.Create;
begin
  inherited;

  Caption := 'Viewport #4';

  FSize.x := 380;
  FSize.y := 280;

  FPos.x := 410;
  FPos.y := 310;


  FRange.miny := 300-10;
  FRange.minx := 400-10;
  FRange.maxx := FRange.minx + 20;
  FRange.maxy := FRange.miny + 20;

  FColor := BLACK;

  FHandle := GV_CreateViewport(Round(FPos.X), Round(FPos.Y), Round(FSize.X), Round(FSize.Y));

  FStarfield := GV_CreateStarfield;
  GV_SetStarfieldZSpeed(FStarField, -(60*3));
end;

destructor TViewport4.Destroy;
begin
  GV_FreeStarfield(FStarField);
  inherited;
end;

procedure TViewport4.OnUpdate(aDeltaTime: Double);
begin
  inherited;
  GV_UpdateStarfield(FStarfield, aDeltaTime);
end;

procedure TViewport4.OnRender;
begin
  inherited;
  GV_RenderStarfield(FStarfield);
  PrintCaption(WHITE);
  GV_SetDisplayViewport(nil);
end;


{ TViewportsEx }
constructor TViewportsEx.Create;
begin
  inherited;
  Game := Self;
end;

destructor TViewportsEx.Destroy;
begin
  Game := nil;
  inherited;
end;

procedure TViewportsEx.OnInitParams(var aParams: TGVGameParams);
begin
  inherited;

  aParams.DisplayTitle := 'GameVision: Viewports Example';
  aParams.DisplayWidth := 800;
  aParams.DisplayHeight := 600;
  aParams.DisplayClearColor := DIMWHITE;
end;

procedure TViewportsEx.OnLoad;
begin
  inherited;
end;

procedure TViewportsEx.OnExit;
begin
  inherited;
end;

procedure TViewportsEx.OnStartup;
begin
  inherited;

  Scene[0].Add(TViewport1.Create);
  Scene[0].Add(TViewport2.Create);
  Scene[0].Add(TViewport3.Create);
  Scene[0].Add(TViewport4.Create);

  FMusic := GV_LoadMusic(Archive, 'arc/audio/music/song01.ogg');
  GV_PlayMusicEx(FMusic, 1.0, True)

end;

procedure TViewportsEx.OnShutdown;
begin
  GV_UnloadMusic(FMusic);
  inherited;
end;

procedure TViewportsEx.OnUpdate(aDeltaTime: Double);
begin
  inherited;

  Scene.Update([], aDeltaTime);
end;

procedure TViewportsEx.OnRender;
begin
  inherited;

  Scene.Render([], nil, nil);
end;

procedure TViewportsEx.OnRenderGUI;
begin
  inherited;

  //GV_PrintFontY(MonoFont, HudPos.X, HudPos.Y, 0, GREEN, haLeft, 'xxx       - xxxxxxxxxx', []);
end;

end.
