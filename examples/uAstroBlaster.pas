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

unit uAstroBlaster;

interface

uses
  GVT,
  uCommon;

const
  cMultiplier = 60;
  cPlayerMultiplier = 600;

  // player
  cPlayerTurnRate      = 2.7 * cPlayerMultiplier;
  cPlayerFriction      = 0.005* cPlayerMultiplier;
  cPlayerAccel         = 0.1* cPlayerMultiplier;
  cPlayerMagnitude     = 10 * 14;
  cPlayerHalfSize      = 32.0;
  cPlayerFrameFPS      = 12;
  cPlayerNeutralFrame  = 0;
  cPlayerFirstFrame    = 1;
  cPlayerLastFrame     = 3;
  cPlayerTurnAccel     = 300;
  cPlayerMaxTurn       = 150;
  cPlayerTurnDrag      = 150;

  // scene
  cSceneBkgrnd         = 0;
  cSceneRocks          = 1;
  cSceneRockExp        = 2;
  cSceneEnemyWeapon    = 3;
  cSceneEnemy          = 4;
  cSceneEnemyExp       = 5;
  cScenePlayerWeapon   = 6;
  cScenePlayer         = 7;
  cScenePlayerExp      = 8;
  cSceneCount          = 9;

  // sound effects
  cSfxRockExp          = 0;
  cSfxPlayerExp        = 1;
  cSfxEnemyExp         = 2;
  cSfxPlayerEngine     = 3;
  cSfxPlayerWeapon     = 4;

  // volume
  cVolPlayerEngine     = 0.40;
  cVolPlayerWeapon     = 0.30;
  cVolRockExp          = 0.25;
  cVolSong             = 0.55;

  // rocks
  cRocksMin            = 7;
  cRocksMax            = 21;


  DEBUG_RENDERPOLYPOINT = False;

type

  { TSpriteID }
  TSpriteID = record
    Page : Integer;
    Group: Integer;
  end;
  PSpriteID = ^TSpriteID;

  { TRockSize }
  TRockSize = (
    rsLarge, rsMedium, rsSmall
  );

  { TEntity }
  TBaseEntity = class(TGVEntityActor)
  protected
    FTest: string;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure WrapPosAtEdge(var aPos: TGVVector);
  end;

  { TWeapon }
  TWeapon = class(TBaseEntity)
  protected
    FSpeed: Single;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure OnRender; override;
    procedure OnUpdate(aDeltaTime: Double); override;
    procedure OnCollide(aActor: TGVActor; aHitPos: TGVVector); override;
    procedure Spawn(aId: Integer; aPos: TGVVector; aAngle, aSpeed: Single);
  end;

  { TExplosion }
  TExplosion = class(TBaseEntity)
  protected
    FSpeed: Single;
    FCurDir: TGVVector;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure OnRender; override;
    procedure OnUpdate(aElapsedTime: Double); override;
    procedure Spawn(aPos: TGVVector; aDir: TGVVector; aSpeed, aScale: Single);
  end;

  { TParticle }
  TParticle = class(TBaseEntity)
  protected
    FSpeed: Single;
    FFadeSpeed: Single;
    FAlpha: Single;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure OnRender; override;
    procedure OnUpdate(aDeltaTime: Double); override;
    procedure Spawn(aId: Integer; aPos: TGVVector; aAngle, aSpeed, aScale, aFadeSpeed: Single; aScene: Integer);
  end;

  { TRock }
  TRock = class(TBaseEntity)
  protected
    FCurDir: TGVVector;
    FSpeed: Single;
    FRotSpeed: Single;
    FSize: TRockSize;
    function CalcScale(aSize: TRockSize): Single;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure OnRender; override;
    procedure OnUpdate(aDeltaTime: Double); override;
    procedure OnCollide(aActor: TGVActor; aHitPos: TGVVector); override;
    procedure Spawn(aId: Integer; aSize: TRockSize; aPos: TGVVector; aAngle: Single);
    procedure Split(aHitPos: TGVVector);
  end;

  { TPlayer }
  TPlayer = class(TBaseEntity)
  protected
    FTimer    : Single;
    FCurFrame : Integer;
    FThrusting: Boolean;
    FCurAngle : Single;
    FTurnSpeed: Single;
  public
    DirVec    : TGVVector;
    constructor Create; override;
    destructor Destroy; override;
    procedure OnRender; override;
    procedure OnUpdate(aDelta: Double); override;
    procedure Spawn(aX, aY: Single);
    procedure FireWeapon(aSpeed: Single);
  end;

  { TAstroBlasterDemo }
  TAstroBlasterDemo = class(TBaseExample)
  protected
    FBkPos: TGVVector;
    FBkColor: TGVColor;
    FMusic: TGVMusic;
  public
    Sfx: array[0..7] of Integer;
    Background : array[0..3] of TGVBitmap;
    PlayerSprID: TSpriteID;
    EnemySprID: TSpriteID;
    RocksSprID: TSpriteID;
    ShieldsSprID: TSpriteID;
    WeaponSprID: TSpriteID;
    ExplosionSprID: TSpriteID;
    ParticlesSprID: TSpriteID;
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
    procedure SpawnRocks;
    procedure SpawnPlayer;
    procedure SpawnLevel;
    function  LevelCleared: Boolean;

  end;

implementation

const
  cChanPlayerEngine = 0;
  cChanPlayerWeapon = 1;

var
  Player: TPlayer;
  Game: TAstroBlasterDemo;

function RandomRangedslNP(aMin, aMax: Single): Single;
begin
  Result := GV_RandomRangef(aMin, aMax);
  if GV_RandomBool then Result := -Result;
end;

function RangeRangeIntNP(aMin, aMax: Integer): Integer;
begin
  Result := GV_RandomRangei(aMin, aMax);
  if GV_RandomBool then Result := -Result;
end;

{ TBaseEntity }
constructor TBaseEntity.Create;
begin
  inherited;
  CanCollide := True;
end;

destructor TBaseEntity.Destroy;
begin
  inherited;
end;

procedure  TBaseEntity.WrapPosAtEdge(var aPos: TGVVector);
var
  hh,hw: Single;
begin
  hw := GV_GetEntityWidth(Entity) / 2;
  hh := GV_GetEntityHeight(Entity) /2 ;

  if (aPos.X > (Game.DisplayWidth-1)+hw) then
    aPos.X := -hw
  else if (aPos.X < -hw) then
    aPos.X := (Game.DisplayWidth-1)+hw;

  if (aPos.Y > (Game.DisplayHeight-1)+hh) then
    aPos.Y := -hh
  else if (aPos.Y < -hw) then
    aPos.Y := (Game.DisplayHeight-1)+hh;
end;

{ TWeapon }
constructor TWeapon.Create;
begin
  inherited;
  Init(Game.Sprite, Game.WeaponSprId.Group);
  GV_TraceEntityPolyPoint(Entity, 6, 12, 70);
  GV_SetRenderEntityPolyPoint(Entity, DEBUG_RENDERPOLYPOINT);
end;

destructor TWeapon.Destroy;
begin
  inherited;
end;

procedure TWeapon.OnRender;
begin
  inherited;
end;

procedure TWeapon.OnUpdate(aDeltaTime: Double);
begin
  inherited;
  if GV_IsEntityVisible(Entity, 0,0) then
    begin
      GV_ThrustEntity(Entity, FSpeed*aDeltaTime);
      Game.Scene[cSceneRocks].CheckCollision([], Self);
    end
  else
    Terminated := True;
end;

procedure TWeapon.OnCollide(aActor: TGVActor; aHitPos: TGVVector);
begin
  CanCollide := False;
  Terminated := True;
end;

procedure  TWeapon.Spawn(aId: Integer; aPos: TGVVector; aAngle, aSpeed: Single);
begin
  FSpeed := aSpeed;
  GV_SetEntityFrame(Entity, aId);
  GV_SetEntityPosAbs(Entity, aPos.X, aPos.Y);
  GV_RotateEntityAbs(Entity, aAngle);
end;

{ TExplosion }
constructor TExplosion.Create;
begin
  inherited;
  FSpeed := 0;
  FCurDir.X := 0;
  FCurDir.Y := 0;
end;

destructor TExplosion.Destroy;
begin
  inherited;
end;

procedure TExplosion.OnRender;
begin
  inherited;
end;

procedure TExplosion.OnUpdate(aElapsedTime: Double);
var
  P,V: TGVVector;
begin
  if GV_NextEntityFrame(Entity) then
  begin
    Terminated := True;
  end;

  V.X := (FCurDir.X + FSpeed) * aElapsedTime;
  V.Y := (FCurDir.Y + FSpeed) * aElapsedTime;

  P := GV_GetEntityPos(Entity);

  P.X := P.X + V.X;
  P.Y := P.Y + V.Y;

  GV_SetEntityPosAbs(Entity, P.X, P.Y);
end;

procedure TExplosion.Spawn(aPos: TGVVector; aDir: TGVVector; aSpeed, aScale: Single);
begin
  FSpeed := aSpeed;
  FCurDir := aDir;
  Init(Game.Sprite, Game.ExplosionSprID.Group);
  GV_SetEntityFrameFPS(Entity, 14);
  GV_SetEntityScaleAbs(Entity, aScale);
  GV_SetEntityPosAbs(Entity, aPos.X, aPos.Y);
  Game.Scene[cSceneRockExp].Add(Self);
end;

{ TParticle }
constructor TParticle.Create;
begin
  inherited;
end;

destructor TParticle.Destroy;
begin
  inherited;
end;

procedure TParticle.OnRender;
begin
  inherited;
end;

procedure TParticle.OnUpdate(aDeltaTime: Double);
var
  C,C2: TGVColor;
  A: Single;
begin
  GV_ThrustEntity(Entity, FSpeed*aDeltaTime);

  if GV_IsEntityVisible(Entity, 0, 0) then
    begin
      FAlpha := FAlpha - (FFadeSpeed * aDeltaTime);
      if FAlpha <= 0 then
      begin
        FAlpha := 0;
        Terminated := True;
      end;
      A := FAlpha / 255.0;
      c2.Red := 1*a; c2.Green := 1*a; c2.Blue := 1*a; c2.Alpha := a;
      C := GV_MakeColorf(c2.Red, c2.Green, c2.Blue, c2.Alpha);
      GV_SetEntityColor(Entity, C);
    end
  else
    Terminated := True;
end;

procedure TParticle.Spawn(aId: Integer; aPos: TGVVector; aAngle, aSpeed, aScale, aFadeSpeed: Single; aScene: Integer);
begin
  FSpeed := aSpeed;
  FFadeSpeed := aFadeSpeed;
  FAlpha := 255;
  Init(Game.Sprite, Game.ParticlesSprID.Group);
  GV_SetEntityFrame(Entity, aId);
  GV_SetEntityScaleAbs(Entity, aScale);
  GV_SetEntityPosAbs(Entity, aPos.X, aPos.Y);
  GV_RotateEntityAbs(Entity, aAngle);
  Game.Scene[aScene].Add(Self);
end;

{ TRock }
function TRock.CalcScale(aSize: TRockSize): Single;
begin
  case aSize of
    rsLarge: Result := 1.0;
    rsMedium: Result := 0.65;
    rsSmall: Result := 0.45;
  else
    Result := 1.0;
  end;
end;

constructor TRock.Create;
begin
  inherited;
  FSpeed := 0;
  FRotSpeed := 0;
  FSize := rsLarge;
  Init(Game.Sprite, Game.RocksSprId.Group);
  GV_TraceEntityPolyPoint(Entity, 6, 12, 70);
  GV_SetRenderEntityPolyPoint(Entity, DEBUG_RENDERPOLYPOINT);
end;

destructor TRock.Destroy;
begin
  inherited;
end;

procedure TRock.OnRender;
begin
  inherited;
end;

procedure TRock.OnUpdate(aDeltaTime: Double);
var
  P: TGVVector;
  V: TGVVector;
begin
  inherited;
  GV_RotateEntityRel(Entity, FRotSpeed*aDeltaTime);
  V.X := (FCurDir.X + FSpeed);
  V.Y := (FCurDir.Y + FSpeed);
  P := GV_GetEntityPos(Entity);
  P.X := P.X + V.X*aDeltaTime;
  P.Y := P.Y + V.Y*aDeltaTime;
  WrapPosAtEdge(P);
  GV_SetEntityPosAbs(Entity, P.X, P.Y);
end;

procedure TRock.OnCollide(aActor: TGVActor; aHitPos: TGVVector);
begin
  CanCollide := False;
  Split(aHitPos);
end;


procedure TRock.Spawn(aId: Integer; aSize: TRockSize; aPos: TGVVector; aAngle: Single);
begin
  FSpeed := RandomRangedslNP(0.2*cMultiplier, 2*cMultiplier);
  FRotSpeed := RandomRangedslNP(0.2*cMultiplier, 2*cMultiplier);

  FSize := aSize;
  GV_SetEntityFrame(Entity, aId);
  GV_SetEntityPosAbs(Entity, aPos.X, aPos.Y);
  GV_RotateEntityAbs(Entity, GV_RandomRangei(0, 259));
  GV_ThrustEntity(Entity, 1);

  FCurDir := GV_GetEntityDir(Entity);
  //Vector_Normalize(FCurDir);
  FCurDir.Normalize;
  GV_SetEntityScaleAbs(Entity, CalcScale(FSize));
end;

procedure TRock.Split(aHitPos: TGVVector);

  procedure DoSplit(aId: Integer; aSize: TRockSize; aPos: TGVVector);
  var
    r: TRock;
  begin
    r := TRock.Create;
    r.Spawn(aId, aSize, aPos, 0);
    Game.Scene[cSceneRocks].Add(r);
  end;

  procedure DoExplosion(aScale: Single);
  var
    p: TGVVector;
    e: TExplosion;
  begin
    p := GV_GetEntityPos(Entity);
    e := TExplosion.Create;
    e.Spawn(p, FCurDir, FSpeed, aScale);
  end;

  procedure DoParticles;
  var
    c,i: Integer;
    p: TParticle;
    angle,speed,fade: Single;
  begin
    c := 0;
    case FSize of
      rsLarge : c := 50;
      rsMedium: c := 25;
      rsSmall : c := 15;
    end;

    for i := 1 to c do
    begin
      p := TParticle.Create;
      angle := GV_RandomRangef(0, 255);
      speed := GV_RandomRangef(1*cMultiplier, 7*cMultiplier);
      fade := GV_RandomRangef(3*cMultiplier, 7*cMultiplier);

      p.Spawn(0, aHitPos, angle, speed, 0.10, fade, cSceneRockExp);
    end;
  end;

begin
  case FSize of
    rsLarge:
      begin
        DoSplit(GV_GetEntityFrame(Entity), rsMedium, GV_GetEntityPos(Entity));
        DoSplit(GV_GetEntityFrame(Entity), rsMedium, GV_GetEntityPos(Entity));
        DoExplosion(3.0);
        DoParticles;
        //Game.Sfx[cSfxRockExp].Play(cVolRockExp, AUDIO_PAN_NONE, 1, False, nil);
        GV_PlaySoundEx(AUDIO_DYNAMIC_CHANNEL, Game.Sfx[cSfxRockExp], cVolRockExp, False);
      end;

    rsMedium:
      begin
        DoSplit(GV_GetEntityFrame(Entity), rsSmall, GV_GetEntityPos(Entity));
        DoSplit(GV_GetEntityFrame(Entity), rsSmall, GV_GetEntityPos(Entity));
        DoExplosion(2.5);
        DoParticles;
        //Game.Sfx[cSfxRockExp].Play(cVolRockExp, AUDIO_PAN_NONE, 1, False, nil);
        GV_PlaySoundEx(AUDIO_DYNAMIC_CHANNEL, Game.Sfx[cSfxRockExp], cVolRockExp, False);

      end;

    rsSmall:
      begin
        DoExplosion(1.5);
        DoParticles;
        //Game.Sfx[cSfxRockExp].Play(cVolRockExp, AUDIO_PAN_NONE, 1, False, nil);
        GV_PlaySoundEx(AUDIO_DYNAMIC_CHANNEL, Game.Sfx[cSfxRockExp], cVolRockExp, False);
      end;
  end;
  Terminated := True;
end;

{ TPlayer }
constructor TPlayer.Create;
begin
  Player := Self;
  inherited;

  FTimer    := 0;
  FCurFrame := 0;
  FThrusting:= False;
  FCurAngle := 0;
  DirVec.Clear;
  //Vector_Clear(DirVec);
  FTurnSpeed := 0;

  //Entity := GV_CreateEntity(Game.Sprite, Game.PlayerSprID.Group);
  Init(Game.Sprite, Game.PlayerSprID.Group);

  GV_TraceEntityPolyPoint(Entity, 6, 12, 70);

  GV_SetEntityPosAbs(Entity, Game.DisplayWidth /2, Game.DisplayHeight /2);
  GV_SetRenderEntityPolyPoint(Entity, DEBUG_RENDERPOLYPOINT);

end;

destructor TPlayer.Destroy;
begin
  inherited;
  Player := nil;
end;

procedure TPlayer.OnRender;
begin
  inherited;
end;

procedure TPlayer.OnUpdate(aDelta: Double);
var
  P: TGVVector;
  Fire: Boolean;
  Turn: Integer;
  Accel: Boolean;
begin
  if GV_KeyboardPressed(KEY_LCTRL) or
     GV_KeyboardPressed(KEY_RCTRL) or
     GV_JoystickPressed(JOY_BTN_RB) then
    Fire := True
  else
    Fire := False;

  if GV_KeyboardDown(KEY_RIGHT) or
     GV_JoystickDown(JOY_BTN_RDPAD) then
    Turn := 1
  else
  if GV_KeyboardDown(KEY_LEFT) or
     GV_JoystickDown(JOY_BTN_LDPAD) then
    Turn := -1
  else
    Turn := 0;

  if (GV_KeyboardDown(KEY_UP)) or
     GV_JoystickDown(JOY_BTN_UDPAD) then
    Accel := true
  else
    Accel := False;


  // update keys
  if Fire then
  begin
    FireWeapon(10*cMultiplier);
  end;

  if Turn = 1 then
  begin
    GV_SmoothMove(FTurnSpeed, cPlayerTurnAccel*aDelta, cPlayerMaxTurn, cPlayerTurnDrag*aDelta);
  end
  else if Turn = -1 then
    begin
      GV_SmoothMove(FTurnSpeed, -cPlayerTurnAccel*aDelta, cPlayerMaxTurn, cPlayerTurnDrag*aDelta);
    end
  else
    begin
      GV_SmoothMove(FTurnSpeed, 0, cPlayerMaxTurn, cPlayerTurnDrag*aDelta);
    end;

  FCurAngle := FCurAngle + FTurnSpeed*aDelta;
  if FCurAngle > 360 then
    FCurAngle := FCurAngle - 360
  else if FCurAngle < 0 then
    FCurAngle := FCurAngle + 360;

  FThrusting := False;
  if (Accel) then
  begin
    FThrusting := True;

    //if (Vector_Magnitude(DirVec) < cPlayerMagnitude) then
    if (DirVec.Magnitude < cPlayerMagnitude) then
    begin
      //Vector_Thrust(DirVec, FCurAngle, cPlayerAccel*aDelta);
      DirVec.Thrust(FCurAngle, cPlayerAccel*aDelta);
    end;

    //if not Engine.Audio.SamplePlaying(cChanPlayerEngine) then
    if GV_GetSoundChanStatus(cChanPlayerEngine) = asStopped then
    begin
      //Game.Sfx[cSfxPlayerEngine].Play(cVolPlayerEngine, AUDIO_PAN_NONE, 1,
      //  True, @cChanPlayerEngine);
      GV_PlaySoundEx(cChanPlayerEngine, Game.Sfx[cSfxPlayerEngine], cVolPlayerEngine, True);
    end;

  end;

  GV_SmoothMove(DirVec.X, 0, cPlayerMagnitude, cPlayerFriction*aDelta);
  GV_SmoothMove(DirVec.Y, 0, cPlayerMagnitude, cPlayerFriction*aDelta);

  P := GV_GetEntityPos(Entity);

  P.X := P.X + DirVec.X*aDelta;
  P.Y := P.Y + DirVec.Y*aDelta;

  WrapPosAtEdge(P);

  if (FThrusting) then
    begin
      if (GV_FrameSpeed(FTimer, cPlayerFrameFPS)) then
      begin
        FCurFrame := FCurFrame + 1;
        if (FCurFrame > cPlayerLastFrame) then
        begin
          FCurFrame := cPlayerFirstFrame;
        end
      end;

    end
  else
    begin
      FCurFrame := cPlayerNeutralFrame;

      //if Engine.Audio.SamplePlaying(cChanPlayerEngine) then
      if GV_GetSoundChanStatus(cChanPlayerEngine) = asPlaying then
      begin
        //Engine.Audio.SampleStop(cChanPlayerEngine);
        GV_StopSoundChan(cChanPlayerEngine);
      end;
    end;

  GV_RotateEntityAbs(Entity, FCurAngle);
  GV_SetEntityFrame(Entity, FCurFrame);
  GV_SetEntityPosAbs(Entity, P.X, P.Y);
end;

procedure TPlayer.Spawn(aX, aY: Single);
begin
end;

procedure TPlayer.FireWeapon(aSpeed: Single);
var
  P: TGVVector;
  W: TWeapon;
begin
  P := GV_GetEntityPos(Entity);
  P.Thrust(GV_GetEntityAngle(Entity), 16);
  //Vector_Thrust(P, Entity_GetAngle(Entity), 16);
  W := TWeapon.Create;
  W.Spawn(0, P, GV_GetEntityAngle(Entity), aSpeed);
  Game.Scene[cScenePlayerWeapon].Add(W);
  //Game.Sfx[cSfxPlayerWeapon].Play(cVolPlayerWeapon, AUDIO_PAN_NONE, 1, False, @cChanPlayerWeapon);
  GV_PlaySoundEx(cChanPlayerWeapon, Game.Sfx[cSfxPlayerWeapon], cVolPlayerWeapon, False);

end;


{ TAstroBlasterDemo }
constructor TAstroBlasterDemo.Create;
begin
  inherited;
  Game := Self;
end;

destructor TAstroBlasterDemo.Destroy;
begin
  Game := nil;
  inherited;
end;

procedure TAstroBlasterDemo.OnInitParams(var aParams: TGVGameParams);
begin
  inherited;

  aParams.DisplayTitle := 'GameVision: AstroBlaster Demo';
end;

procedure TAstroBlasterDemo.OnLoad;
begin
  inherited;
end;

procedure TAstroBlasterDemo.OnExit;
begin
  inherited;
end;

procedure TAstroBlasterDemo.OnStartup;
begin
  inherited;

  // init background
  FBkColor := GV_MakeColor(255,255,255,128);

  Background[0] := GV_LoadBitmap(Archive, 'arc/bitmaps/backgrounds/space.png',  @BLACK);
  Background[1] := GV_LoadBitmap(Archive, 'arc/bitmaps/backgrounds/nebula.png', @BLACK);
  Background[2] := GV_LoadBitmap(Archive, 'arc/bitmaps/backgrounds/spacelayer1.png', @BLACK);
  Background[3] := GV_LoadBitmap(Archive, 'arc/bitmaps/backgrounds/spacelayer2.png', @BLACK);

    // init player sprites
  PlayerSprID.Page := GV_LoadSpritePage(Sprite, Archive, 'arc/bitmaps/sprites/ship.png', nil);
  PlayerSprID.Group := GV_AddSpriteGroup(Sprite);
  GV_AddSpriteImageFromGrid(Sprite, PlayerSprID.Page, PlayerSprID.Group, 0, 0, 64, 64);
  GV_AddSpriteImageFromGrid(Sprite, PlayerSprID.Page, PlayerSprID.Group, 1, 0, 64, 64);
  GV_AddSpriteImageFromGrid(Sprite, PlayerSprID.Page, PlayerSprID.Group, 2, 0, 64, 64);
  GV_AddSpriteImageFromGrid(Sprite, PlayerSprID.Page, PlayerSprID.Group, 3, 0, 64, 64);


  // init enemy sprites
  EnemySprID.Page := PlayerSprID.Page;
  EnemySprID.Group := GV_AddSpriteGroup(Sprite);
  GV_AddSpriteImageFromGrid(Sprite, EnemySprID.Page, EnemySprID.Group, 0, 1, 64, 64);
  GV_AddSpriteImageFromGrid(Sprite, EnemySprID.Page, EnemySprID.Group, 1, 1, 64, 64);
  GV_AddSpriteImageFromGrid(Sprite, EnemySprID.Page, EnemySprID.Group, 2, 1, 64, 64);

  // init shield sprites
  ShieldsSprID.Page := PlayerSprID.Page;
  ShieldsSprID.Group := GV_AddSpriteGroup(Sprite);
  GV_AddSpriteImageFromGrid(Sprite, ShieldsSprID.Page, ShieldsSprID.Group, 0, 4, 32, 32);
  GV_AddSpriteImageFromGrid(Sprite, ShieldsSprID.Page, ShieldsSprID.Group, 1, 4, 32, 32);
  GV_AddSpriteImageFromGrid(Sprite, ShieldsSprID.Page, ShieldsSprID.Group, 2, 4, 32, 32);

  // init wepason sprites
  WeaponSprID.Page := PlayerSprID.Page;
  WeaponSprID.Group := GV_AddSpriteGroup(Sprite);
  GV_AddSpriteImageFromGrid(Sprite, WeaponSprID.Page, WeaponSprID.Group, 3, 4, 32, 32);
  GV_AddSpriteImageFromGrid(Sprite, WeaponSprID.Page, WeaponSprID.Group, 4, 4, 32, 32);
  GV_AddSpriteImageFromGrid(Sprite, WeaponSprID.Page, WeaponSprID.Group, 5, 4, 32, 32);

  // init rock sprites
  RocksSprID.Page := GV_LoadSpritePage(Sprite, Archive, 'arc/bitmaps/sprites/rocks.png', nil);
  RocksSprID.Group := GV_AddSpriteGroup(Sprite);
  GV_AddSpriteImageFromGrid(Sprite, RocksSprID.Page, RocksSprID.Group, 0, 0, 128, 128);
  GV_AddSpriteImageFromGrid(Sprite, RocksSprID.Page, RocksSprID.Group, 1, 0, 128, 128);
  GV_AddSpriteImageFromGrid(Sprite, RocksSprID.Page, RocksSprID.Group, 0, 1, 128, 128);


  // init explosion sprites
  ExplosionSprID.Page := GV_LoadSpritePage(Sprite, Archive, 'arc/bitmaps/sprites/explosion.png', nil);
  ExplosionSprID.Group := GV_AddSpriteGroup(Sprite);
  GV_AddSpriteImageFromGrid(Sprite, ExplosionSprID.Page, ExplosionSprID.Group, 0, 0, 64, 64);
  GV_AddSpriteImageFromGrid(Sprite, ExplosionSprID.Page, ExplosionSprID.Group, 1, 0, 64, 64);
  GV_AddSpriteImageFromGrid(Sprite, ExplosionSprID.Page, ExplosionSprID.Group, 2, 0, 64, 64);
  GV_AddSpriteImageFromGrid(Sprite, ExplosionSprID.Page, ExplosionSprID.Group, 3, 0, 64, 64);

  GV_AddSpriteImageFromGrid(Sprite, ExplosionSprID.Page, ExplosionSprID.Group, 0, 1, 64, 64);
  GV_AddSpriteImageFromGrid(Sprite, ExplosionSprID.Page, ExplosionSprID.Group, 1, 1, 64, 64);
  GV_AddSpriteImageFromGrid(Sprite, ExplosionSprID.Page, ExplosionSprID.Group, 2, 1, 64, 64);
  GV_AddSpriteImageFromGrid(Sprite, ExplosionSprID.Page, ExplosionSprID.Group, 3, 1, 64, 64);

  GV_AddSpriteImageFromGrid(Sprite, ExplosionSprID.Page, ExplosionSprID.Group, 0, 2, 64, 64);
  GV_AddSpriteImageFromGrid(Sprite, ExplosionSprID.Page, ExplosionSprID.Group, 1, 2, 64, 64);
  GV_AddSpriteImageFromGrid(Sprite, ExplosionSprID.Page, ExplosionSprID.Group, 2, 2, 64, 64);
  GV_AddSpriteImageFromGrid(Sprite, ExplosionSprID.Page, ExplosionSprID.Group, 3, 2, 64, 64);

  GV_AddSpriteImageFromGrid(Sprite, ExplosionSprID.Page, ExplosionSprID.Group, 0, 3, 64, 64);
  GV_AddSpriteImageFromGrid(Sprite, ExplosionSprID.Page, ExplosionSprID.Group, 1, 3, 64, 64);
  GV_AddSpriteImageFromGrid(Sprite, ExplosionSprID.Page, ExplosionSprID.Group, 2, 3, 64, 64);
  GV_AddSpriteImageFromGrid(Sprite, ExplosionSprID.Page, ExplosionSprID.Group, 3, 3, 64, 64);

  // init particles
  ParticlesSprID.Page := GV_LoadSpritePage(Sprite, Archive, 'arc/bitmaps/sprites/particles.png', nil);
  ParticlesSprID.Group := GV_AddSpriteGroup(Sprite);
  GV_AddSpriteImageFromGrid(Sprite, ParticlesSprID.Page, ParticlesSprID.Group, 0, 0, 64, 64);

  //Engine.Audio.ChannelSetReserved(0, True);
  //Engine.Audio.ChannelSetReserved(1, True);
  //Channel_SetReserved(0, True);
  //Channel_SetReserved(1, True);
  GV_SetSoundChanReserved(0, True);
  GV_SetSoundChanReserved(1, True);

  // init sfx
  Sfx[cSfxRockExp] := GV_LoadSound(Archive, 'arc/audio/sfx/explo_rock.ogg');
  Sfx[cSfxPlayerExp] := GV_LoadSound(Archive, 'arc/audio/sfx/explo_player.ogg');
  Sfx[cSfxEnemyExp] := GV_LoadSound(Archive, 'arc/audio/sfx/explo_enemy.ogg');
  Sfx[cSfxPlayerEngine] := GV_LoadSound(Archive, 'arc/audio/sfx/engine_player.ogg');
  Sfx[cSfxPlayerWeapon] := GV_LoadSound(Archive, 'arc/audio/sfx/weapon_player.ogg');

  FMusic := GV_LoadMusic(Archive, 'arc/audio/music/song13.ogg');
  GV_PlayMusicEx(FMusic, 1.0, True);

  // init scene
  Scene.Alloc(cSceneCount);
end;

procedure TAstroBlasterDemo.OnShutdown;
begin
  Scene.ClearAll;

  GV_UnloadMusic(FMusic);

  GV_UnloadSound(Sfx[cSfxRockExp]);
  GV_UnloadSound(Sfx[cSfxPlayerExp]);
  GV_UnloadSound(Sfx[cSfxEnemyExp]);
  GV_UnloadSound(Sfx[cSfxPlayerEngine]);
  GV_UnloadSound(Sfx[cSfxPlayerWeapon]);

  GV_FreeBitmap(Background[3]);
  GV_FreeBitmap(Background[2]);
  GV_FreeBitmap(Background[1]);
  GV_FreeBitmap(Background[0]);


  inherited;
end;

procedure TAstroBlasterDemo.OnUpdate(aDeltaTime: Double);
var
  P: TGVVector;
begin
  inherited;

  if Assigned(Player) then
  begin
    P := Player.DirVec;
    FBkPos.X := FBkPos.X + (P.X * aDeltaTime);
    FBkPos.Y := FBkPos.Y + (P.Y * aDeltaTime);
  end;

  if LevelCleared then
  begin
    SpawnLevel;
  end;

  Scene.Update([], aDeltaTime);
end;

const
  bm = 3;

procedure TAstroBlasterDemo.OnRender;
begin
  // render background
  GV_DrawBitmapTiled(Background[0], -(FBkPos.X/1.9*bm), -(FBkPos.Y/1.9*bm));

  GV_SetDisplayBlendMode(bmAdditiveAlpha);
  GV_DrawBitmapTiled(Background[1], -(FBkPos.X/1.9*bm), -(FBkPos.Y/1.9*bm));
  GV_RestoreDisplayDefaultBlendMode;
  GV_DrawBitmapTiled(Background[2], -(FBkPos.X/1.6*bm), -(FBkPos.Y/1.6*bm));
  GV_DrawBitmapTiled(Background[3], -(FBkPos.X/1.3*bm), -(FBkPos.Y/1.3*bm));

  Scene.Render([], OnBeforeRenderScene, OnAfterRenderScene);

  inherited;
end;

procedure TAstroBlasterDemo.OnRenderGUI;
begin
  inherited;

  GV_PrintFontY(MonoFont, HudPos.X, HudPos.Y, 0, GREEN, haLeft, 'Left      - Rotate left', []);
  GV_PrintFontY(MonoFont, HudPos.X, HudPos.Y, 0, GREEN, haLeft, 'Right     - Rotate right', []);
  GV_PrintFontY(MonoFont, HudPos.X, HudPos.Y, 0, GREEN, haLeft, 'Up        - Thrust', []);
  GV_PrintFontY(MonoFont, HudPos.X, HudPos.Y, 0, GREEN, haLeft, 'Ctrl      - Fire', []);
  GV_PrintFontY(MonoFont, HudPos.X, HudPos.Y, 0, GREEN, haLeft, 'Count:      %d', [Scene[cSceneRocks].Count]);
end;

procedure TAstroBlasterDemo.OnBeforeRenderScene(aSceneNum: Integer);
begin
  case aSceneNum of
    cSceneRockExp:
    begin
      GV_SetDisplayBlender(BLEND_ADD, BLEND_ALPHA, BLEND_INVERSE_ALPHA);
      GV_SetDisplayBlendMode(bmAdditiveAlpha);
    end;
  end;
end;

procedure TAstroBlasterDemo.OnAfterRenderScene(aSceneNum: Integer);
begin
  case aSceneNum of
    cSceneRockExp:
    begin
      GV_RestoreDisplayDefaultBlendMode;
    end;
  end;
end;

procedure TAstroBlasterDemo.SpawnRocks;
var
  i,c: Integer;
  id: Integer;
  size: TRockSize;
  angle: Single;
  rock: TRock;
  radius : Single;
  pos: TGVVector;
begin

  c := GV_RandomRangei(cRocksMin, cRocksMax);

  for i := 1 to c do
  begin
    id := GV_RandomRangei(0, 2);
    size := TRockSize(GV_RandomRangei(0, 2));
    pos.x := DisplayWidth / 2;
    pos.y := DisplayHeight /2;
    radius := (pos.x + pos.y) / 2;
    angle := GV_RandomRangef(0, 359);
    pos.Thrust(angle, radius);
    //Vector_Thrust(Pos, angle, radius);
    rock := TRock.Create;
    rock.Spawn(id, size, pos, angle);
    Game.Scene[cSceneRocks].Add(rock);
  end;
end;

procedure TAstroBlasterDemo.SpawnPlayer;
begin
  Scene.Lists[cScenePlayer].Add(TPlayer.Create);
end;

procedure TAstroBlasterDemo.SpawnLevel;
begin
  Scene.ClearAll;
  SpawnRocks;
  SpawnPlayer;
end;

function TAstroBlasterDemo.LevelCleared: Boolean;
begin
  if (Scene[cSceneRocks].Count        > 0) or
     (Scene[cSceneRockExp].Count      > 0) or
     (Scene[cScenePlayerWeapon].Count > 0) then
    Result := False
  else
    Result := True;
end;

end.
