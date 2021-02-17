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

unit uChainAction;

interface

uses
  GVT,
  uCommon;

const
  // scene
  SCN_COUNT  = 2;
  SCN_CIRCLE = 0;
  SCN_EXPLO  = 1;

  // circle
  SHRINK_FACTOR = 0.65;

  CIRCLE_SCALE = 0.125;
  CIRCLE_SCALE_SPEED   = 0.95;

  CIRCLE_EXP_SCALE_MIN = 0.05;
  CIRCLE_EXP_SCALE_MAX = 0.49;

  CIRCLE_MIN_COLOR = 64;
  CIRCLE_MAX_COLOR = 255;

  CIRCLE_COUNT = 80;

type
{ TCommonEntity }
  TCommonEntity = class(TGVEntityActor)
  public
    constructor Create; override;
    procedure OnCollide(aActor: TGVActor; aHitPos: TGVVector); override;
    function  Collide(aActor: TGVActor; var aHitPos: TGVVector): Boolean; override;
  end;

{ TCircle }
  TCircle = class(TCommonEntity)
  protected
    FColor: TGVColor;
    FSpeed: Single;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure OnUpdate(aDeltaTime: Double); override;
    procedure OnRender; override;
    procedure OnCollide(aActor: TGVActor; aHitPos: TGVVector); override;
    property Speed: Single read FSpeed;
  end;

  { TCircleExplosion }
  TCircleExplosion = class(TCommonEntity)
  protected
    FColor: array[0..1] of TGVColor;
    FState: Integer;
    FFade: Single;
    FSpeed: Single;
  public

    constructor Create; override;
    destructor Destroy; override;
    procedure Setup(aX, aY: Single; aColor: TGVColor); overload;
    procedure Setup(aCircle: TCircle); overload;
    procedure OnUpdate(aDeltaTime: Double); override;
    procedure OnRender; override;
    procedure OnCollide(aActor: TGVActor; aHitPos: TGVVector); override;
  end;

  { TChainActionDemo }
  TChainActionDemo = class(TBaseExample)
  protected
    FExplosions: Integer;
    FChainActive: Boolean;
    FMusic: TGVMusic;
  public
    property Explosions: Integer read FExplosions write FExplosions;
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
    procedure OnBeforeRenderScene(aSceneNum: Integer); override;
    procedure OnAfterRenderScene(aSceneNum: Integer); override;
    procedure SpawnCircle(aNum: Integer); overload;
    procedure SpawnCircle; overload;
    procedure SpawnExplosion(aX, aY: Single; aColor: TGVColor); overload;
    procedure SpawnExplosion(aCircle: TCircle); overload;
    procedure CheckCollision(aEntity: TGVEntityActor);
    procedure StartChain;
    procedure PlayLevel;
    function  ChainEnded: Boolean;
    function  LevelClear: Boolean;
  end;

var
  Game: TChainActionDemo = nil;

implementation

uses
  System.SysUtils;

{ TCommonEntity }
constructor TCommonEntity.Create;
begin
  inherited;
  CanCollide := True;
end;

procedure TCommonEntity.OnCollide(aActor: TGVActor; aHitPos: TGVVector);
begin
  inherited;
end;

function  TCommonEntity.Collide(aActor: TGVActor; var aHitPos: TGVVector): Boolean;
begin
  Result := False;

  if Overlap(aActor) then
  begin
    aHitPos := GV_GetEntityPos(Entity);
    Result := True;
  end;
end;

{ TCircle }
constructor TCircle.Create;
var
  ok: Boolean;
  VP: TGVRectangle;
  A: Single;
begin
  inherited;

  GV_GetDisplayViewportSize(VP);

  Init(Game.Sprite, 0);
  GV_SetEntityShrinkFactor(Entity, SHRINK_FACTOR);
  GV_SetEntityScaleAbs(Entity, CIRCLE_SCALE);
  GV_SetEntityPosAbs(Entity, GV_RandomRangef(32, (VP.Width-1)-32),
    GV_RandomRangef(32, (VP.Width-1)-32));

  ok := False;
  repeat
    Sleep(1);
    FColor := GV_MakeColor(
      GV_RandomRangei(CIRCLE_MIN_COLOR, CIRCLE_MAX_COLOR),
      GV_RandomRangei(CIRCLE_MIN_COLOR, CIRCLE_MAX_COLOR),
      GV_RandomRangei(CIRCLE_MIN_COLOR, CIRCLE_MAX_COLOR),
      GV_RandomRangei(CIRCLE_MIN_COLOR, CIRCLE_MAX_COLOR)
    );

    if GV_ColorEqual(FColor, BLACK) or
       GV_ColorEqual(FColor, WHITE) then
      continue;

    ok := True;
  until ok;

  ok := False;
  repeat
    Sleep(1);
    A := GV_RandomRangef(0, 359);
    if (Abs(A) >=90-10) and (Abs(A) <= 90+10) then continue;
    if (Abs(A) >=270-10) and (Abs(A) <= 270+10) then continue;

    ok := True;
  until ok;

  GV_RotateEntityAbs(Entity, A);
  GV_SetEntityColor(Entity, FColor);
  FSpeed := GV_RandomRangef(3*35, 7*35);
end;

destructor TCircle.Destroy;
begin
  inherited;
end;

procedure TCircle.OnUpdate(aDeltaTime: Double);
var
  V: TGVVector;
  VP: TGVRectangle;
  R: Single;
begin
  GV_GetDisplayViewportSize(VP);

  GV_ThrustEntity(Entity, FSpeed * aDeltaTime);

  V := GV_GetEntityPos(Entity);

  R := GV_GetEntityRadius(Entity) / 2;

  if V.x < -R then
    V.x := VP.Width-1
  else if V.x > (VP.Width-1)+R then
    V.x := -R;

  if V.y < -R then
    V.y := (VP.Height-1)
  else if V.y > (VP.Height-1)+R then
    V.y := -R;

  GV_SetEntityPosAbs(Entity, V.X, V.Y);
end;

procedure TCircle.OnRender;
begin
  inherited;
end;

procedure TCircle.OnCollide(aActor: TGVActor; aHitPos: TGVVector);
var
  LPos: TGVVector;
begin
  Terminated := True;
  LPos := GV_GetEntityPos(Entity);
  Game.SpawnExplosion(LPos.X, LPos.Y, FColor);
  Game.Explosions := Game.Explosions + 1;
end;


{ TCircleExplosion }
constructor TCircleExplosion.Create;
begin
  inherited;
  Init(Game.Sprite, 0);
  GV_SetEntityShrinkFactor(Entity, SHRINK_FACTOR);
  GV_SetEntityScaleAbs(Entity, CIRCLE_SCALE);
  FState := 0;
  FFade := 0;
  FSpeed := 0;
end;

destructor TCircleExplosion.Destroy;
begin
  inherited;
end;

procedure TCircleExplosion.Setup(aX, aY: Single; aColor: TGVColor);
begin
  FColor[0] := aColor;
  FColor[1] := aColor;
  GV_SetEntityPosAbs(Entity, aX, aY);
end;
procedure TCircleExplosion.Setup(aCircle: TCircle);
var
  LPos: TGVVector;
begin
  LPos := GV_GetEntityPos(aCircle.Entity);
  Setup(LPos.X, LPos.Y, GV_GetEntityColor(aCircle.Entity));
  GV_RotateEntityAbs(Entity, GV_GetEntityAngle(aCircle.Entity));
  FSpeed := aCircle.Speed;
end;

procedure TCircleExplosion.OnUpdate(aDeltaTime: Double);
begin
  GV_ThrustEntity(Entity, FSpeed*aDeltaTime);

  case FState of
    0: // expand
    begin
      GV_SetEntityScaleRel(Entity, CIRCLE_SCALE_SPEED*aDeltaTime);
      if GV_GetEntityScale(Entity) > CIRCLE_EXP_SCALE_MAX then
      begin
        FState := 1;
      end;
      GV_SetEntityColor(Entity, FColor[0]);
    end;

    1: // contract
    begin
      GV_SetEntityScaleRel(Entity, -CIRCLE_SCALE_SPEED*aDeltaTime);
      FFade := CIRCLE_SCALE_SPEED*aDeltaTime / GV_GetEntityScale(Entity);
      if GV_GetEntityScale(Entity) < CIRCLE_EXP_SCALE_MIN then
      begin
        FState := 2;
        FFade := 1.0;
        Terminated := True;
      end;
      //C := Engine.Color.Fade(FColor[0], FColor[1], FFade);
      //Entity.SetColor(C);
    end;

    2: // kill
    begin
      Terminated := True;
    end;

  end;

  Game.CheckCollision(Self);
end;

procedure TCircleExplosion.OnRender;
begin
  inherited;
end;

procedure TCircleExplosion.OnCollide(aActor: TGVActor; aHitPos: TGVVector);
begin
end;

{ TChainActionDemo }
constructor TChainActionDemo.Create;
begin
  inherited;
  Game := Self;
end;

destructor TChainActionDemo.Destroy;
begin
  Game := nil;
  inherited;
end;

procedure TChainActionDemo.OnInitParams(var aParams: TGVGameParams);
begin
  inherited;

  aParams.DisplayTitle := 'GameVision: ChainAction Demo';
end;

procedure TChainActionDemo.OnLoad;
begin
  inherited;
end;

procedure TChainActionDemo.OnExit;
begin
  inherited;
end;

procedure TChainActionDemo.OnStartup;
var
  Page: Integer;
  Group: Integer;
begin
  inherited;

  // init circle sprite
  Page := GV_LoadSpritePage(Sprite, Archive, 'arc/bitmaps/sprites/light.png', @COLORKEY);
  Group := GV_AddSpriteGroup(Sprite);
  GV_AddSpriteImageFromGrid(Sprite, Page, Group, 0, 0, 256, 256);

  // init music
  FMusic := GV_LoadMusic(Archive, 'arc/audio/music/song06.ogg');
  GV_PlayMusicEx(FMusic, 1.0, True);

  Scene.Alloc(SCN_COUNT);
  PlayLevel;
end;

procedure TChainActionDemo.OnShutdown;
begin
  GV_UnloadMusic(FMusic);

  inherited;
end;

procedure TChainActionDemo.OnUpdate(aDeltaTime: Double);
begin
  inherited;

  // start  new level
  if GV_KeyboardPressed(KEY_SPACE) then
  begin
    if LevelClear then
      PlayLevel;
  end;

  // start chain reaction
  if GV_MousePressed(MOUSE_BUTTON_LEFT) then
  begin
    if ChainEnded then
      StartChain;
  end;

  GV_UpdateStarfield(Starfield, aDeltaTime);

  // update scene
  Scene.Update([], aDeltaTime);
end;

procedure TChainActionDemo.OnRender;
begin
  GV_RenderStarfield(Starfield);
  Scene.Render([], OnBeforeRenderScene, OnAfterRenderScene);
  inherited;
end;

procedure TChainActionDemo.OnRenderGUI;
var
  VP: TGVRectangle;
  x: Single;
  C: TGVColor;
begin
  inherited;

  //GV_PrintFontY(MonoFont, HudPos.X, HudPos.Y, 0, GREEN, haLeft, 'xxx       - xxxxxxxxxx', []);
    GV_PrintFontY(MonoFont, HudPos.X, HudPos.Y, 0, GREEN, haLeft, 'Circles   : %d', [Scene[SCN_CIRCLE].Count]);

  GV_GetDisplayViewportSize(vp);
  x := vp.Width / 2;

  if ChainEnded and (not LevelClear) then
    C := WHITE
  else
    C := DARKGRAY;

  GV_PrintFont(VariableFont, x, 120, C, haCenter, 'Click mouse to start chain reaction', []);

  if LevelClear then
  begin
    GV_PrintFont(VariableFont, x, 120+21, C, haCenter, 'Press SPACE to start new level', []);
  end;
end;

procedure TChainActionDemo.OnBeforeRenderScene(aSceneNum: Integer);
begin
  case aSceneNum of
    SCN_CIRCLE, SCN_EXPLO:
    begin
      GV_SetDisplayBlender(BLEND_ADD, BLEND_ALPHA, BLEND_INVERSE_ALPHA);
      GV_SetDisplayBlendMode(bmAdditiveAlpha);
    end;
  end;
end;

procedure TChainActionDemo.OnAfterRenderScene(aSceneNum: Integer);
begin
  case aSceneNum of
    SCN_CIRCLE, SCN_EXPLO:
    begin
      GV_RestoreDisplayDefaultBlendMode;
    end;
  end;
end;

procedure TChainActionDemo.SpawnCircle(aNum: Integer);
var
  I: Integer;
begin
  for I := 0 to aNum - 1 do
    Scene[SCN_CIRCLE].Add(TCircle.Create);
end;

procedure TChainActionDemo.SpawnCircle;
begin
  SpawnCircle(GV_RandomRangei(10, 40));
end;

procedure TChainActionDemo.SpawnExplosion(aX, aY: Single; aColor: TGVColor);
var
  obj: TCircleExplosion;
begin
  obj := TCircleExplosion.Create;
  obj.Setup(aX, aY, aColor);
  Scene[SCN_EXPLO].Add(obj);
end;

procedure TChainActionDemo.SpawnExplosion(aCircle: TCircle);
var
  obj: TCircleExplosion;
begin
  obj := TCircleExplosion.Create;
  obj.Setup(aCircle);
  Scene[SCN_EXPLO].Add(obj);
end;

procedure TChainActionDemo.CheckCollision(aEntity: TGVEntityActor);
begin
  Scene[SCN_CIRCLE].CheckCollision([], aEntity);
end;

procedure TChainActionDemo.StartChain;
begin
  if not FChainActive then
  begin
    SpawnExplosion(MousePos.X, MousePos.Y, WHITE);
    FChainActive := True;
  end;
end;

procedure TChainActionDemo.PlayLevel;
begin
  Scene.ClearAll;
  SpawnCircle(CIRCLE_COUNT);
  FChainActive := False;
  FExplosions := 0;
end;

function  TChainActionDemo.ChainEnded: Boolean;
begin
  Result := True;
  if FChainActive then
  begin
    Result := Boolean(Scene[SCN_EXPLO].Count = 0);
    if Result  then
      FChainActive := False;
  end;
end;

function  TChainActionDemo.LevelClear: Boolean;
begin
  Result := Boolean(Scene[SCN_CIRCLE].Count = 0);
end;

end.
