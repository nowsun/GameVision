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

unit uScroll;

interface

uses
  GVT,
  uCommon;

const

  // player
  PLAYER_TURNRATE            = 162;
  PLAYER_FRICTION            = 1;
  PLAYER_ACCEL               = 7;
  PLAYER_MAGNITUDE           = 14;
  PLAYER_SIZE_HALF           = 32.0;
  PLAYER_FRAME_FPS           = 12;
  PLAYER_FRAME_NEUTRAL       = 0;
  PLAYER_FRAME_FIRST         = 1;
  PLAYER_FRAME_LAST          = 3;
  PLAYER_TURN_ACCEL          = 300;
  PLAYER_TURN_MAX            = 150;
  PLAYER_TURN_DRAG           = 150;


type

  TView = record
    Move     : Single;
    Bounce   : Single;
    Dir      : TGVVector;
    FixOffset: TGVVector;
    RunAhead : TGVVector;
    Pos      : TGVVector;
  end;

  TPlayer = record
    Timer    : Single;
    Frame    : Integer;
    Thrusting: Boolean;
    Angle    : Single;
    Dir      : TGVVector;
    WorldPos : TGVVector;
    ScreenPos: TGVVector;
    TurnSpeed: Single;
  end;

  { TScrollDemo }
  TScrollDemo = class(TBaseExample)
  protected
    FTimer      : Single;
    FColor      : TGVColor;
    FBackground : array[0..3] of TGVBitmap;
    FPlanet     : TGVBitmap;
    FView       : TView;
    FPlayer     : TPlayer;
    FMusic      : TGVMusic;
  public
    procedure OnInitParams(var aParams: TGVGameParams); override;
    procedure OnLoad; override;
    procedure OnExit; override;
    procedure OnStartup; override;
    procedure OnShutdown; override;
    procedure OnUpdate(aDeltaTime: Double); override;
    procedure OnRender; override;
    procedure OnRenderGUI; override;
  end;

implementation

{ TScrollDemo }
procedure TScrollDemo.OnInitParams(var aParams: TGVGameParams);
begin
  inherited;

  aParams.DisplayTitle := 'GameVision: Scroll Demo';
end;

procedure TScrollDemo.OnLoad;
begin
  inherited;
end;

procedure TScrollDemo.OnExit;
begin
  inherited;
end;

procedure TScrollDemo.OnStartup;
begin
  inherited;

  // init colors
  FColor := WHITE;
  FColor.Alpha := 128;

  // init textures
  FBackground[0] := GV_LoadBitmap(Archive, 'arc/bitmaps/backgrounds/space.png',  @BLACK);
  FBackground[1] := GV_LoadBitmap(Archive, 'arc/bitmaps/backgrounds/nebula.png', @BLACK);
  FBackground[2] := GV_LoadBitmap(Archive, 'arc/bitmaps/backgrounds/spacelayer1.png', @BLACK);
  FBackground[3] := GV_LoadBitmap(Archive, 'arc/bitmaps/backgrounds/spacelayer2.png', @BLACK);

  FPlanet := GV_LoadBitmap(Archive, 'arc/bitmaps/backgrounds/Planet.png', nil);

  // init spirtes
  GV_LoadSpritePage(Sprite, Archive, 'arc/bitmaps/sprites/ship.png', nil);
  GV_AddSpriteGroup(Sprite);
  GV_AddSpriteImageFromGrid(Sprite, 0, 0, 0, 0, 64, 64);
  GV_AddSpriteImageFromGrid(Sprite, 0, 0, 1, 0, 64, 64);
  GV_AddSpriteImageFromGrid(Sprite, 0, 0, 2, 0, 64, 64);
  GV_AddSpriteImageFromGrid(Sprite, 0, 0, 3, 0, 64, 64);

  FillChar(FView, SizeOf(FView), 0);
  FillChar(FPlayer, SizeOf(FPlayer), 0);

  FView.Move       := 0.004;
  FView.Bounce     := 1.10;
  FView.RunAhead.X := 45;
  FView.RunAhead.Y := 35;
  FView.Pos.X      := 1000;
  FView.Pos.Y      := 1000;
  FPlayer.Angle        := 0;
  FPlayer.WorldPos.X   := DisplayWidth  / 2;
  FPlayer.WorldPos.Y   := DisplayHeight / 2;

  FMusic := GV_LoadMusic(Archive, 'arc/audio/music/song01.ogg');
  GV_PlayMusicEx(FMusic, 0.5, True);

end;

procedure TScrollDemo.OnShutdown;
begin
  GV_UnloadMusic(FMusic);
  GV_FreeBitmap(FPlanet);
  GV_FreeBitmap(FBackground[3]);
  GV_FreeBitmap(FBackground[2]);
  GV_FreeBitmap(FBackground[1]);
  GV_FreeBitmap(FBackground[0]);

  inherited;
end;

procedure TScrollDemo.OnUpdate(aDeltaTime: Double);
begin
  inherited;

  // update keys
  if GV_KeyboardDown(KEY_RIGHT) then
  begin
    GV_SmoothMove(FPlayer.TurnSpeed, PLAYER_TURN_ACCEL*aDeltaTime, PLAYER_TURN_MAX, PLAYER_TURN_DRAG*aDeltaTime);
  end
  else if GV_KeyboardDown(KEY_LEFT) then
    begin
      GV_SmoothMove(FPlayer.TurnSpeed, -PLAYER_TURN_ACCEL*aDeltaTime, PLAYER_TURN_MAX, PLAYER_TURN_DRAG*aDeltaTime);
    end
  else
    begin
      GV_SmoothMove(FPlayer.TurnSpeed, 0, PLAYER_TURN_MAX, PLAYER_TURN_DRAG*aDeltaTime);
    end;

  FPlayer.Angle := FPlayer.Angle + (FPlayer.TurnSpeed*aDeltaTime);
  if FPlayer.Angle > 360 then
    FPlayer.Angle := FPlayer.Angle - 360
  else if FPlayer.Angle < 0 then
    FPlayer.Angle := FPlayer.Angle + 360;

  FPlayer.Thrusting := False;
  if (GV_KeyboardDown(KEY_UP)) then
  begin
    FPlayer.Thrusting := True;

    //if (Vector_Magnitude(FPlayer.Dir) < PLAYER_MAGNITUDE) then
    if (FPlayer.Dir.Magnitude < PLAYER_MAGNITUDE) then
    begin
      //Vector_Thrust(FPlayer.Dir, FPlayer.Angle, PLAYER_ACCEL*aDeltaTime);
      FPlayer.Dir.Thrust(FPlayer.Angle, PLAYER_ACCEL*aDeltaTime);
    end;
  end;

  GV_SmoothMove(FPlayer.Dir.X, 0, PLAYER_MAGNITUDE, PLAYER_FRICTION*aDeltaTime);
  GV_SmoothMove(FPlayer.Dir.Y, 0, PLAYER_MAGNITUDE, PLAYER_FRICTION*aDeltaTime);

  FPlayer.WorldPos.X := FPlayer.WorldPos.X + FPlayer.Dir.X;
  FPlayer.WorldPos.Y := FPlayer.WorldPos.Y + FPlayer.Dir.Y;

  if (FPlayer.Thrusting) then
    begin
      if (GV_FrameSpeed(FPlayer.Timer, PLAYER_FRAME_FPS)) then
      begin
        FPlayer.Frame := FPlayer.Frame + 1;
        if (FPlayer.Frame > PLAYER_FRAME_LAST) then
        begin
          FPlayer.Frame := PLAYER_FRAME_FIRST;
        end
      end
    end
  else
    begin
      FPlayer.Timer := 0;
      FPlayer.Frame := PLAYER_FRAME_NEUTRAL;
    end;

  // update world
  FView.Dir.X := (FView.Dir.X+(FPlayer.WorldPos.X - FView.Fixoffset.X - FView.Pos.X + FView.RunAhead.X * FPlayer.Dir.X) * FView.Move) / FView.Bounce;
  FView.Dir.Y := (FView.Dir.Y+(FPlayer.WorldPos.Y - FView.Fixoffset.y - FView.Pos.Y + FView.RunAhead.Y * FPlayer.Dir.Y) * FView.Move) / FView.Bounce;
  FView.Pos.X := FView.Pos.X + FView.Dir.X;
  FView.Pos.Y := FView.Pos.Y + FView.Dir.Y;

  // update FPlayer
  FPlayer.ScreenPos.X := FPlayer.WorldPos.X - FView.Pos.X + DisplayWidth  /2;
  FPlayer.ScreenPos.Y := FPlayer.WorldPos.Y - FView.Pos.Y + DisplayHeight /2;

end;

procedure TScrollDemo.OnRender;
var
  LOrigin: TGVVector;
begin
  // render FBackground
  GV_DrawBitmapTiled(FBackground[0], -(FView.Pos.X/1.9), -(FView.Pos.Y/1.9));
  //GV_SetDisplayBlender(BLEND_ADD, BLEND_ALPHA, BLEND_INVERSE_ALPHA);
  GV_SetDisplayBlendMode(bmAdditiveAlpha);
  GV_DrawBitmapTiled(FBackground[1], -(FView.Pos.X/1.9), -(FView.Pos.Y/1.9));
  GV_RestoreDisplayDefaultBlendMode;
  GV_DrawBitmapTiled(FBackground[2], -(FView.Pos.X/1.6), -(FView.Pos.Y/1.6));
  GV_DrawBitmapTiled(FBackground[3], -(FView.Pos.X/1.3), -(FView.Pos.Y/1.3));

  GV_DrawBitmap(FPlanet,
    -Round(FView.Pos.X/1.0)+(DisplayWidth),
    -Round(FView.Pos.Y/1.0)+(DisplayHeight),
    1.0, 0.0, WHITE, haCenter, vaCenter);

  // render FPlayer
  LOrigin.X := 0.50;
  LOrigin.Y := 0.50;
  GV_DrawSpriteImage(Sprite, FPlayer.Frame, 0, FPlayer.ScreenPos.X, FPlayer.ScreenPos.Y, @LOrigin, nil, FPlayer.Angle, WHITE, False, False, False);

  inherited;
end;

procedure TScrollDemo.OnRenderGUI;
begin
  inherited;

  GV_PrintFontY(MonoFont, HudPos.X, HudPos.Y, 0, GREEN,  haLeft, 'Left      - Rotate left', []);
  GV_PrintFontY(MonoFont, HudPos.X, HudPos.Y, 0, GREEN,  haLeft, 'Right     - Rotate right', []);
  GV_PrintFontY(MonoFont, HudPos.X, HudPos.Y, 0, GREEN,  haLeft, 'Up        - Thrust', []);
  GV_PrintFontY(MonoFont, HudPos.X, HudPos.Y, 0, YELLOW, haLeft, 'Pos:        [X:%7.0f Y:%7.0f]', [FPlayer.WorldPos.X, FPlayer.WorldPos.Y]);


  //GV_PrintFontY(MonoFont, HudPos.X, HudPos.Y, 0, GREEN, haLeft, 'xxx       - xxxxxxxxxx', []);
end;

end.
