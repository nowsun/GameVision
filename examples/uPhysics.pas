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

unit uPhysics;

interface

uses
  GVT,
  uCommon;

const
  cPhyBallSize       = 60;
  cMinSize           = 16;
  cMaxSize           = 64;

type
  { TPhysicsEx }
  TPhysicsEx = class(TBaseExample)
  protected
    FBmpBall: TGVBitmap;
    FPhyBall: TGVPhysicsBody;
    FPhyRamp: TGVPhysicsBody;
  public
    procedure OnInitParams(var aParams: TGVGameParams); override;
    procedure OnLoad; override;
    procedure OnExit; override;
    procedure OnStartup; override;
    procedure OnShutdown; override;
    procedure OnUpdate(aDeltaTime: Double); override;
    procedure OnRender; override;
    procedure OnRenderGUI; override;
    procedure OnPhysicsDrawBodyShapes(aBody: TGVPhysicsBody); override;
    procedure OnPhysicsUpdateBody(aBody: TGVPhysicsBody); override;
    procedure InitBodies;
    procedure Reset;
  end;

implementation

{ xxx }
procedure TPhysicsEx.OnInitParams(var aParams: TGVGameParams);
begin
  inherited;

  aParams.DisplayTitle := 'GameVision: Physics Example';
end;

procedure TPhysicsEx.OnLoad;
begin
  inherited;

end;

procedure TPhysicsEx.OnExit;
begin

  inherited;
end;

procedure TPhysicsEx.OnStartup;
begin
  inherited;

  FbmpBall := GV_LoadBitmap(Archive, 'arc/bitmaps/sprites/circle00.png', @COLORKEY);
  InitBodies;
end;

procedure TPhysicsEx.OnShutdown;
begin
  GV_FreeBitmap(FbmpBall);
  inherited;
end;

procedure TPhysicsEx.OnUpdate(aDeltaTime: Double);
var
  LSize: Single;
begin
  inherited;

  if GV_KeyboardPressed(KEY_1) or GV_MousePressed(MOUSE_BUTTON_LEFT) then
  begin
    LSize := GV_RandomRangef(cMinSize, cMaxSize);
    GV_CreatePhysicsRectangleBody(pbDynamic, MousePos, LSize, LSize, 1.0, 0.3);
  end;

  if GV_KeyboardPressed(KEY_2) or GV_MousePressed(MOUSE_BUTTON_RIGHT) then
  begin
    LSize := GV_RandomRangef(cMinSize, cMaxSize);
    GV_CreatePhysicsCircleBody(pbDynamic, MousePos, LSize, 1.0, 0.3);
  end;

  if GV_KeyboardPressed(KEY_R) then
    Reset;

  GV_UpdatePhysicsBodies;
end;

procedure TPhysicsEx.OnRender;
begin
  inherited;

  GV_DrawPhysicsBodyShapes(True);
end;

procedure TPhysicsEx.OnRenderGUI;
begin
  inherited;

  GV_PrintFontY(MonoFont, HudPos.X, HudPos.Y, 0, GREEN,  haLeft, 'R         - Reset bodies', []);
  GV_PrintFontY(MonoFont, HudPos.X, HudPos.Y, 0, GREEN,  haLeft, '1,LMB     - Drop rectangle', []);
  GV_PrintFontY(MonoFont, HudPos.X, HudPos.Y, 0, GREEN,  haLeft, '2,RMB     - Drop circle', []);
  GV_PrintFontY(MonoFont, HudPos.X, HudPos.Y, 0, YELLOW, haLeft, 'Bodies:     %d', [GV_GetPhysicsBodyCount]);
  //GV_PrintFontY(MonoFont, HudPos.X, HudPos.Y, 0, GREEN,  haLeft, 'xxx       - xxxxxxxxxx', []);
end;

procedure TPhysicsEx.OnPhysicsDrawBodyShapes(aBody: TGVPhysicsBody);
var
  LData: TGVPhysicsBodyData;
  LAngle: Single;
  LPos: TGVVector;
  LScale: Single;
begin
  LData := GV_GetPhysicsBodyData(aBody);
  if LData.Shape = bsCircle then
  begin
    LAngle := GV_GetPhysicsBodyRotation(aBody);
    LPos   := GV_GetPhysicsBodyPosition(aBody);
    LScale := LData.CircleRadius;
    LScale := LScale * 0.016;
    GV_DrawBitmap(FbmpBall, LPos.X, LPos.Y, LScale, LAngle, WHITE, haCenter, vaCenter);
  end;
end;

procedure TPhysicsEx.OnPhysicsUpdateBody(aBody: TGVPhysicsBody);
var
  LPos: TGVVector;
begin
  if GV_GetPhysicsBodyType(aBody) = pbDynamic then
  begin
    LPos := GV_GetPhysicsBodyPosition(aBody);
    if LPos.Y > DisplayHeight + cMaxSize then
    begin
      GV_DestroyPhysicsBody(aBody)
    end;
  end;
end;

procedure TPhysicsEx.InitBodies;
begin
  GV_CreatePhysicsCircleBody(pbStatic, GV_Vector(DisplayWidth/2, 200), 45, 1.0, 0.3);

  FphyBall := GV_CreatePhysicsCircleBody(pbDynamic, GV_Vector(100, -cPhyBallSize), cPhyBallSize, 1.0, 0.3);

  FphyRamp := GV_CreatePhysicsRectangleBody(pbStatic, GV_Vector(120, 250-20), 200, 25, 1.0, 0.3);
  GV_SetPhysicsBodyRotation(FphyRamp, 14);

  FphyRamp := GV_CreatePhysicsRectangleBody(pbStatic, GV_Vector(DisplayWidth-120, 250+10), 200, 25, 1.0, 0.3);
  GV_SetPhysicsBodyRotation(FphyRamp, -14);

  FphyRamp := GV_CreatePhysicsRectangleBody(pbStatic, GV_Vector(DisplayWidth/2, DisplayHeight-25), 240+60, 25, 1.0, 0.3);

end;

procedure TPhysicsEx.Reset;
begin
  GV_ClearPhysics;
  InitBodies()
end;

end.
