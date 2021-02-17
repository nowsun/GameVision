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

unit uStarfield;

interface

uses
  GVT,
  uCommon;

type
  { TStarfieldEx }
  TStarfieldEx = class(TBaseExample)
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

{ TStarfieldEx }
procedure TStarfieldEx.OnInitParams(var aParams: TGVGameParams);
begin
  inherited;

  aParams.DisplayTitle := 'GameVision: Starfield Example';
end;

procedure TStarfieldEx.OnLoad;
begin
  inherited;
end;

procedure TStarfieldEx.OnExit;
begin
  inherited;
end;

procedure TStarfieldEx.OnStartup;
begin
  inherited;
end;

procedure TStarfieldEx.OnShutdown;
begin
  inherited;
end;

procedure TStarfieldEx.OnUpdate(aDeltaTime: Double);
begin
  inherited;

  // starfield #1
  if GV_KeyboardPressed(KEY_1) then
  begin
    GV_SetStarfieldXSpeed(FStarfield, 25*7);
    GV_SetStarfieldYSpeed(FStarfield, 0);
    GV_SetStarfieldZSpeed(FStarfield, -(5*25));
    GV_SetStarfieldVirtualPos(FStarfield, 0, 0);
  end;

  // starfield #2
  if GV_KeyboardPressed(KEY_2) then
  begin
    GV_SetStarfieldXSpeed(FStarfield, 0);
    GV_SetStarfieldYSpeed(FStarfield, -(25*5));
    GV_SetStarfieldZSpeed(FStarfield, -(5*25));
    GV_SetStarfieldVirtualPos(FStarfield, 0, 0);
  end;

  // starfield #3
  if GV_KeyboardPressed(KEY_3) then
  begin
    GV_SetStarfieldXSpeed(FStarfield, -(25*5));
    GV_SetStarfieldYSpeed(FStarfield, 0);
    GV_SetStarfieldZSpeed(FStarfield, -(5*25));
    GV_SetStarfieldVirtualPos(FStarfield, 0, 0);
  end;

  // starfield #4
  if GV_KeyboardPressed(KEY_4) then
  begin
    GV_SetStarfieldXSpeed(FStarfield, 0);
    GV_SetStarfieldYSpeed(FStarfield, 25*5);
    GV_SetStarfieldZSpeed(FStarfield, -(5*25));
    GV_SetStarfieldVirtualPos(FStarfield, 0, 0);
  end;

  // starfield #5
  if GV_KeyboardPressed(KEY_5) then
  begin
    GV_SetStarfieldXSpeed(FStarfield, 0);
    GV_SetStarfieldYSpeed(FStarfield, 0);
    GV_SetStarfieldZSpeed(FStarfield, 5*25);
    GV_SetStarfieldVirtualPos(FStarfield, 0, 0);
  end;

  // starfield #6
  if GV_KeyboardPressed(KEY_6) then
  begin
    GV_SetStarfieldZSpeed(FStarfield, 0);
    GV_SetStarfieldYSpeed(FStarfield, 15*10);
  end;

  // starfield #7
  if GV_KeyboardPressed(KEY_7) then
  begin
    GV_SetStarfieldXSpeed(FStarfield, 0);
    GV_SetStarfieldYSpeed(FStarfield, 0);
    GV_SetStarfieldZSpeed(FStarfield, -(5*25));
    GV_SetStarfieldVirtualPos(FStarfield, 0, 0);
  end;

  GV_UpdateStarfield(Starfield, aDeltaTime);
end;

procedure TStarfieldEx.OnRender;
begin
  inherited;
  GV_RenderStarfield(Starfield);
end;

procedure TStarfieldEx.OnRenderGUI;
begin
  inherited;

  GV_PrintFontY(MonoFont, HudPos.X, HudPos.Y, 0, GREEN, haLeft, '1-7       - Starfield', []);
end;

end.
