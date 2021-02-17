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

unit uRotateViewport;

interface

uses
  GVT,
  uCommon;

type
  { TRotateViewportEx }
  TRotateViewportEx = class(TBaseExample)
  protected
  protected
    FViewport: TGVViewport;
    FBackground: TGVBitmap;
    FSpeed: Single;
    FAngle: Single;
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

{ TRotateViewportEx }
procedure TRotateViewportEx.OnInitParams(var aParams: TGVGameParams);
begin
  inherited;

  aParams.DisplayTitle := 'GameVision: Rotate Viewport Example';
end;

procedure TRotateViewportEx.OnLoad;
begin
  inherited;
end;

procedure TRotateViewportEx.OnExit;
begin
  inherited;
end;

procedure TRotateViewportEx.OnStartup;
begin
  inherited;

  FViewport := GV_CreateViewport((DisplayWidth - 380) div 2, (DisplayHeight - 280) div 2, 380, 280);

  FBackground := GV_LoadBitmap(Archive, 'arc/bitmaps/backgrounds/bluestone.png', nil);
end;

procedure TRotateViewportEx.OnShutdown;
begin
  GV_FreeBitmap(FBackground);
  GV_FreeViewport(FViewport);

  inherited;
end;

procedure TRotateViewportEx.OnUpdate(aDeltaTime: Double);
begin
  inherited;

  FSpeed := FSpeed + (60 * aDeltaTime);

  FAngle := FAngle + (7 * aDeltaTime);
  GV_ClipValuef(FAngle, 0, 359, True);
  GV_SetViewportAngle(FViewport, FAngle);
end;

procedure TRotateViewportEx.OnRender;
var
  FSize: TGVRectangle;
begin
  inherited;

  GV_SetDisplayViewport(FViewport);
  GV_GetDisplayViewportSize(FSize);

  GV_ClearDisplay(SKYBLUE);
  GV_DrawBitmapTiled(FBackground, 0, FSpeed);
  GV_PrintFont(MonoFont, FSize.Width/2, 3, WHITE, haCenter, 'Viewport', []);

  GV_SetDisplayViewport(nil);
end;

procedure TRotateViewportEx.OnRenderGUI;
begin
  inherited;

  //GV_PrintFontY(MonoFont, HudPos.X, HudPos.Y, 0, GREEN, haLeft, 'xxx       - xxxxxxxxxx', []);
end;

end.
