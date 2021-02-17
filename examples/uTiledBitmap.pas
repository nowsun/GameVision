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

unit uTiledBitmap;

interface

uses
  GVT,
  uCommon;

type
  { TTiledBitmapEx }
  TTiledBitmapEx = class(TBaseExample)
  protected
    FTexture: array[0..3] of TGVBitmap;
    FSpeed: array[0..3] of Single;
    FPos: array[0..3] of TGVVector;
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

{ TTiledBitmapEx }
procedure TTiledBitmapEx.OnInitParams(var aParams: TGVGameParams);
begin
  inherited;

  aParams.DisplayTitle := 'GameVision: Tiled Bitmap Example';
end;

procedure TTiledBitmapEx.OnLoad;
begin
  inherited;
end;

procedure TTiledBitmapEx.OnExit;
begin
  inherited;
end;

procedure TTiledBitmapEx.OnStartup;
begin
  inherited;

  // Load bitmap images
  FTexture[0] := GV_LoadBitmap(Archive, 'arc/bitmaps/backgrounds/space.png', nil);
  FTexture[1] := GV_LoadBitmap(Archive, 'arc/bitmaps/backgrounds/nebula.png', @BLACK);
  FTexture[2] := GV_LoadBitmap(Archive, 'arc/bitmaps/backgrounds/spacelayer1.png', @BLACK);
  FTexture[3] := GV_LoadBitmap(Archive, 'arc/bitmaps/backgrounds/spacelayer2.png', @BLACK);

  // Set bitmap speeds
  FSpeed[0] := 0.3 * 30;
  FSpeed[1] := 0.5 * 30;
  FSpeed[2] := 1.0 * 30;
  FSpeed[3] := 2.0 * 30;

  // Clear pos
  FPos[0].Clear;
  FPos[1].Clear;
  FPos[2].Clear;
  FPos[3].Clear;
end;

procedure TTiledBitmapEx.OnShutdown;
var
  I: Integer;
begin
  for I := 0 to 3 do
    GV_FreeBitmap(FTexture[I]);

  inherited;
end;

procedure TTiledBitmapEx.OnUpdate(aDeltaTime: Double);
var
  I: Integer;
begin
  inherited;

  // update bitmap position
  for I := 0 to 3 do
  begin
    FPos[I].Y := FPos[I].Y + (FSpeed[I] * aDeltaTime);
  end;
end;

procedure TTiledBitmapEx.OnRender;
var
  I: Integer;
begin
  inherited;

  // render bitmaps
  for i := 0 to 3 do
  begin
    //if i = 1 then GV_SetDisplayBlendMode(bmAdditiveAlpha);
    if i = 1 then
    begin
      //GV_SetDisplayBlender(BLEND_ADD, BLEND_ALPHA, BLEND_INVERSE_ALPHA);
      GV_SetDisplayBlendMode(bmAdditiveAlpha);
    end;
    GV_DrawBitmapTiled(FTexture[i], FPos[i].X, FPos[i].Y);
    if i = 1 then GV_RestoreDisplayDefaultBlendMode;
  end;
end;

procedure TTiledBitmapEx.OnRenderGUI;
begin
  inherited;

  //GV_PrintFontY(MonoFont, HudPos.X, HudPos.Y, 0, GREEN, haLeft, 'xxx       - xxxxxxxxxx', []);
end;

end.
