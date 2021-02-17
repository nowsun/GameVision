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

unit uEntity;

interface

uses
  GVT,
  uCommon;

type
  { TEntityEx }
  TEntityEx = class(TBaseExample)
  protected
    FExplo: TGVEntity;
    FShip: TGVEntity;
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

{ TEntityEx }
procedure TEntityEx.OnInitParams(var aParams: TGVGameParams);
begin
  inherited;

  aParams.DisplayTitle := 'GameVision: Entity Example';
end;

procedure TEntityEx.OnLoad;
begin
  inherited;
end;

procedure TEntityEx.OnExit;
begin
  inherited;
end;

procedure TEntityEx.OnStartup;
begin
  inherited;

  // init explosion sprite
  GV_LoadSpritePage(Sprite, Archive, 'arc/bitmaps/sprites/explosion.png', nil);
  GV_AddSpriteGroup(Sprite);
  GV_AddSpriteImageFromGrid(Sprite, 0, 0, 0, 0, 64, 64);
  GV_AddSpriteImageFromGrid(Sprite, 0, 0, 1, 0, 64, 64);
  GV_AddSpriteImageFromGrid(Sprite, 0, 0, 2, 0, 64, 64);
  GV_AddSpriteImageFromGrid(Sprite, 0, 0, 3, 0, 64, 64);

  GV_AddSpriteImageFromGrid(Sprite, 0, 0, 0, 1, 64, 64);
  GV_AddSpriteImageFromGrid(Sprite, 0, 0, 1, 1, 64, 64);
  GV_AddSpriteImageFromGrid(Sprite, 0, 0, 2, 1, 64, 64);
  GV_AddSpriteImageFromGrid(Sprite, 0, 0, 3, 1, 64, 64);

  GV_AddSpriteImageFromGrid(Sprite, 0, 0, 0, 2, 64, 64);
  GV_AddSpriteImageFromGrid(Sprite, 0, 0, 1, 2, 64, 64);
  GV_AddSpriteImageFromGrid(Sprite, 0, 0, 2, 2, 64, 64);
  GV_AddSpriteImageFromGrid(Sprite, 0, 0, 3, 2, 64, 64);

  GV_AddSpriteImageFromGrid(Sprite, 0, 0, 0, 3, 64, 64);
  GV_AddSpriteImageFromGrid(Sprite, 0, 0, 1, 3, 64, 64);
  GV_AddSpriteImageFromGrid(Sprite, 0, 0, 2, 3, 64, 64);
  GV_AddSpriteImageFromGrid(Sprite, 0, 0, 3, 3, 64, 64);

  // init ship sprite
  GV_LoadSpritePage(Sprite, Archive, 'arc/bitmaps/sprites/ship.png', nil);
  GV_AddSpriteGroup(Sprite);
  GV_AddSpriteImageFromGrid(Sprite, 1, 1, 0, 0, 64, 64);
  GV_AddSpriteImageFromGrid(Sprite, 1, 1, 1, 0, 64, 64);
  GV_AddSpriteImageFromGrid(Sprite, 1, 1, 2, 0, 64, 64);
  GV_AddSpriteImageFromGrid(Sprite, 1, 1, 3, 0, 64, 64);

  // init explosion entity
  FExplo := GV_CreateEntity(Sprite, 0);
  GV_SetEntityFrameFPS(FExplo, 14);
  GV_SetEntityScaleAbs(FExplo, 1);
  GV_SetEntityPosAbs(FExplo, DisplayWidth/2, (DisplayHeight/2)-64);

  // init ship entity
  FShip := GV_CreateEntity(Sprite, 1);
  GV_SetEntityFrameFPS(FShip, 17);
  GV_SetEntityScaleAbs(FShip, 1);
  GV_SetEntityPosAbs(FShip, DisplayWidth/2, (DisplayHeight/2)+64);


end;

procedure TEntityEx.OnShutdown;
begin
  GV_FreeEntity(FShip);
  GV_FreeEntity(FExplo);
  inherited;
end;

procedure TEntityEx.OnUpdate(aDeltaTime: Double);
begin
  inherited;
  GV_NextEntityFrame(FExplo);
  GV_NextEntityFrame(FShip);

end;

procedure TEntityEx.OnRender;
begin
  inherited;

  GV_SetDisplayBlender(BLEND_ADD, BLEND_ALPHA, BLEND_INVERSE_ALPHA);
  GV_SetDisplayBlendMode(bmAdditiveAlpha);
  GV_RenderEntity(FExplo, 0,0);
  GV_RestoreDisplayDefaultBlendMode;

  GV_RenderEntity(FShip, 0,0);

end;

procedure TEntityEx.OnRenderGUI;
begin
  inherited;

  //GV_PrintFontY(MonoFont, HudPos.X, HudPos.Y, 0, GREEN, haLeft, 'xxx       - xxxxxxxxxx', []);
end;

end.
