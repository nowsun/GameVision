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

unit uEntityCollision;

interface

uses
  GVT,
  uCommon;

type
  { TEntityCollisionEx }
  TEntityCollisionEx = class(TBaseExample)
  protected
    FBoss: TGVEntity;
    FFigure: TGVEntity;
    FFigureAngle: Single;
    FCollide: Boolean;
    FHitPos: TGVVector;
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

{ xxx }
procedure TEntityCollisionEx.OnInitParams(var aParams: TGVGameParams);
begin
  inherited;

  aParams.DisplayTitle := 'GameVision: Entity Collision Example';
end;

procedure TEntityCollisionEx.OnLoad;
begin
  inherited;
end;

procedure TEntityCollisionEx.OnExit;
begin
  inherited;
end;

procedure TEntityCollisionEx.OnStartup;
begin
  inherited;

  GV_LoadSpritePage(Sprite, Archive, 'arc/bitmaps/sprites/boss.png', @COLORKEY);
  GV_AddSpriteGroup(Sprite);
  GV_AddSpriteImageFromGrid(Sprite, 0, 0, 0, 0, 128, 128);
  GV_AddSpriteImageFromGrid(Sprite, 0, 0, 1, 0, 128, 128);
  GV_AddSpriteImageFromGrid(Sprite, 0, 0, 0, 1, 128, 128);

  GV_LoadSpritePage(Sprite, Archive, 'arc/bitmaps/sprites/figure.png', @COLORKEY);
  GV_AddSpriteGroup(Sprite);
  GV_AddSpriteImageFromGrid(Sprite, 1, 1, 0, 0, 128, 128);

  FBoss := GV_CreateEntity(Sprite, 0);
  GV_SetEntityPosAbs(FBoss, DisplayWidth/2, (DisplayHeight/2)-100);
  //GV_SetEntityPosAbs(FBoss, DisplayWidth/2, (DisplayHeight/2));
  GV_TraceEntityPolyPoint(FBoss, 6,12,70);
  GV_SetRenderEntityPolyPoint(FBoss, True);

  FFigure := GV_CreateEntity(Sprite, 1);
  GV_SetEntityPosAbs(FFigure, DisplayWidth/2, DisplayHeight/2);
  GV_TraceEntityPolyPoint(FFigure, 6,12,70);
  GV_SetRenderEntityPolyPoint(FFigure, True);
end;

procedure TEntityCollisionEx.OnShutdown;
begin
  GV_FreeEntity(FFigure);
  GV_FreeEntity(FBoss);
  inherited;
end;

procedure TEntityCollisionEx.OnUpdate(aDeltaTime: Double);
begin
  inherited;

  GV_NextEntityFrame(FBoss);

  GV_ThrustEntityToPos(FBoss, 30*50, 14*50, MousePos.X, MousePos.Y,
    128, 32, 5*50, 0.001, aDeltaTime);


  if GV_CollideEntityPolyPoint(FBoss, FFigure, FHitPos) then
    FCollide := true
  else
    FCollide := False;

  FFigureAngle := FFigureAngle + (30.0 * aDeltaTime);
  GV_ClipValuef(FFigureAngle, 0, 359, True);
  GV_RotateEntityAbs(FFigure, FFigureAngle);
end;

procedure TEntityCollisionEx.OnRender;
begin
  inherited;

  GV_RenderEntity(FFigure, 0, 0);
  GV_RenderEntity(FBoss, 0, 0);
  if FCollide  then
    GV_DrawFilledRectangle(FHitPos.X, FHitPos.Y, 10, 10, RED);
end;

procedure TEntityCollisionEx.OnRenderGUI;
begin
  inherited;

  //GV_PrintFontY(MonoFont, HudPos.X, HudPos.Y, 0, GREEN, haLeft, 'xxx       - xxxxxxxxxx', []);
end;

end.
