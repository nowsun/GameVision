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

unit uPolygon;

interface

uses
  GVT,
  uCommon;

type
  { TPolygonEx }
  TPolygonEx = class(TBaseExample)
  protected
    FPolygon: TGVPolygon;
    FOrigin : TGVVector;
    FAngle  : Single;
    FScale  : Single;
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

{ TPolygonEx }
procedure TPolygonEx.OnInitParams(var aParams: TGVGameParams);
begin
  inherited;

  aParams.DisplayTitle := 'GameVision: Polygon Example';
  //aParams.DisplayClearColor := DIMGRAY;
  aParams.DisplayClearColor := DIMWHITE;
  //aParams.DisplayClearColor := BLACK;
end;

procedure TPolygonEx.OnLoad;
begin
  inherited;
end;

procedure TPolygonEx.OnExit;
begin
  inherited;
end;

procedure TPolygonEx.OnStartup;
begin
  inherited;

  // init polygon
  FPolygon := GV_CreatePolygon;
  GV_AddLocalPolygonPoint(FPolygon, 0, 0, True);
  GV_AddLocalPolygonPoint(FPolygon, 128, 0, True);
  GV_AddLocalPolygonPoint(FPolygon, 128, 128, True);
  GV_AddLocalPolygonPoint(FPolygon, 0, 128, True);
  GV_AddLocalPolygonPoint(FPolygon, 0, 0, True);

  // you can either use local coords such as -64, -64, 64, 64 etc and when
  // transformed it will be center or easier just use specify an origin. In this
  // case this polygon span is 128 so set the origin xy to 64 to center it on
  // screen.
  FOrigin.X := 64;
  FOrigin.Y := 64;

  FScale := 1;

end;

procedure TPolygonEx.OnShutdown;
begin
  GV_FreePolygon(FPolygon);
  inherited;
end;

procedure TPolygonEx.OnUpdate(aDeltaTime: Double);
begin
  inherited;

  if GV_KeyboardPressed(KEY_UP) then
    begin
      FScale := FScale + 0.1;
      FScale := GV_ClipValuef(FScale, 0.3, 3, False);
    end
  else
  if GV_KeyboardPressed(KEY_DOWN) then
    begin
      FScale := FScale - 0.1;
      FScale := GV_ClipValuef(FScale, 0.3, 3, False);
    end;


  // update angle by DeltaTime to keep it constant. In this case the default
  // fps is 30 so we are in effect adding on degree every second.
  FAngle := FAngle + (30.0 * aDeltaTime);

  // just clip between 0 and 360 with wrapping. if greater than max value, it
  // will set min to value-max.
  GV_ClipValuef(FAngle, 0, 360, True);
end;

procedure TPolygonEx.OnRender;
begin
  inherited;

  // render polygon in center of screen
  GV_RenderPolygon(FPolygon, DisplayWidth / 2, DisplayHeight / 2, FScale, FAngle, 1, DEEPSKYBLUE, @FOrigin, False, False);
end;

procedure TPolygonEx.OnRenderGUI;
begin
  inherited;

  GV_PrintFontY(MonoFont, HudPos.X, HudPos.Y, 0, GREEN, haLeft, 'Up        - Scale up', []);
  GV_PrintFontY(MonoFont, HudPos.X, HudPos.Y, 0, GREEN, haLeft, 'Down      - Scale down', []);
  GV_PrintFontY(MonoFont, HudPos.X, HudPos.Y, 0, YELLOW, haLeft, 'Scale:      %1.1f', [FScale]);
end;

end.
