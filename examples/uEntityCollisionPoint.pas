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

unit uEntityCollisionPoint;

interface

uses
  GVT,
  uCommon;

type
  { TEntityCollisionPointEx }
  TEntityCollisionPointEx = class(TBaseExample)
  protected
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

{ TEntityCollisionPointEx }
procedure TEntityCollisionPointEx.OnInitParams(var aParams: TGVGameParams);
begin
  inherited;

  aParams.DisplayTitle := 'GameVision: Entity Collision Point Example';
end;

procedure TEntityCollisionPointEx.OnLoad;
begin
  inherited;
end;

procedure TEntityCollisionPointEx.OnExit;
begin
  inherited;
end;

procedure TEntityCollisionPointEx.OnStartup;
begin
  inherited;

  GV_LoadSpritePage(Sprite, Archive, 'arc/bitmaps/sprites/figure.png', @COLORKEY);
  GV_AddSpriteGroup(Sprite);
  GV_AddSpriteImageFromGrid(Sprite, 0, 0, 0, 0, 128, 128);

  FFigure := GV_CreateEntity(Sprite, 0);
  GV_SetEntityPosAbs(FFigure, DisplayWidth/2, DisplayHeight/2);
  GV_TraceEntityPolyPoint(FFigure, 6,12,70);
  GV_SetRenderEntityPolyPoint(FFigure, True);
end;

procedure TEntityCollisionPointEx.OnShutdown;
begin
  GV_FreeEntity(FFigure);

  inherited;
end;

procedure TEntityCollisionPointEx.OnUpdate(aDeltaTime: Double);
begin
  inherited;

  FHitPos.Assign(MousePos);

  if GV_CollideEntityPolyPointPoint(FFigure, FHitPos) then
    FCollide := true
  else
    FCollide := False;

  FFigureAngle := FFigureAngle + (30.0 * aDeltaTime);
  GV_ClipValuef(FFigureAngle, 0, 359, True);
  GV_RotateEntityAbs(FFigure, FFigureAngle);
end;

procedure TEntityCollisionPointEx.OnRender;
var
  LPos: TGVVector;
begin
  inherited;

  GV_RenderEntity(FFigure, 0, 0);

  if FCollide then
  begin
    LPos := GV_GetEntityPos(FFigure);
    GV_PrintFont(MonoFont, LPos.X-64, LPos.Y-64, WHITE, haLeft, '(%3f,%3f)', [FHitPos.X, FHitPos.Y]);
    GV_DrawFilledRectangle(FHitPos.X, FHitPos.Y, 10, 10, RED);
  end;
end;

procedure TEntityCollisionPointEx.OnRenderGUI;
begin
  inherited;

  //GV_PrintFontY(MonoFont, HudPos.X, HudPos.Y, 0, GREEN, haLeft, 'xxx       - xxxxxxxxxx', []);
  GV_PrintFont(MonoFont, FCenterPos.X, FCenterPos.Y - 100, YELLOW, haCenter, 'Move mouse pointer over figure outline', []);
end;

end.
