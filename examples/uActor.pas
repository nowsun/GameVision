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

unit uActor;

interface

uses
  GVT,
  uCommon;

type

  { TMyActor }
  TMyActor = class(TGVActor)
  protected
    FPos: TGVVector;
    FRange: TGVRange;
    FSpeed: TGVVector;
    FColor: TGVColor;
    FSize: Integer;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure OnUpdate(aDeltaTime: Double); override;
    procedure OnRender; override;
  end;

  { TActorEx }
  TActorEx = class(TBaseExample)
  public
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
    procedure Spawn;
end;

var
  Game: TActorEx = nil;

implementation

{ TMyActor }
constructor TMyActor.Create;
var
  R,G,B: Byte;
begin
  inherited;
  FPos.Assign( GV_RandomRangef(0, Game.DisplayWidth-1), GV_RandomRangef(0, Game.DisplayHeight-1));
  FRange.MinX := 0;
  FRange.MinY := 0;
  FSize := GV_RandomRangei(25, 100);
  FRange.MaxX := (Game.DisplayWidth-1) - FSize;
  FRange.MaxY := (Game.DisplayHeight-1) - FSize;
  FSpeed.x := GV_RandomRangef(120, 120*3);
  FSpeed.y := GV_RandomRangef(120, 120*3);
  R := GV_RandomRangei(1, 255);
  G := GV_RandomRangei(1, 255);
  B := GV_RandomRangei(1, 255);
  FColor := GV_MakeColor(R,G,B,255);
end;

destructor TMyActor.Destroy;
begin
  inherited;
end;

procedure TMyActor.OnUpdate(aDeltaTime: Double);
begin
  // update horizontal movement
  FPos.x := FPos.x + (FSpeed.x * aDeltaTime);
  if (FPos.x < FRange.MinX) then
    begin
      FPos.x  := FRange.Minx;
      FSpeed.x := -FSpeed.x;
    end
  else if (FPos.x > FRange.Maxx) then
    begin
      FPos.x  := FRange.Maxx;
      FSpeed.x := -FSpeed.x;
    end;

  // update horizontal movement
  FPos.y := FPos.y + (FSpeed.y * aDeltaTime);
  if (FPos.y < FRange.Miny) then
    begin
      FPos.y  := FRange.Miny;
      FSpeed.y := -FSpeed.y;
    end
  else if (FPos.y > FRange.Maxy) then
    begin
      FPos.y  := FRange.Maxy;
      FSpeed.y := -FSpeed.y;
    end;
end;

procedure TMyActor.OnRender;
begin
  GV_DrawFilledRectangle(FPos.X, FPos.Y, FSize, FSize, FColor);
end;

{ TActorEx }
constructor TActorEx.Create;
begin
  inherited;
  Game := Self;
end;

destructor TActorEx.Destroy;
begin
  Game := nil;
  inherited;
end;

procedure TActorEx.OnInitParams(var aParams: TGVGameParams);
begin
  inherited;

  aParams.DisplayTitle := 'GameVision: Actor Example';
end;

procedure TActorEx.OnLoad;
begin
  inherited;
end;

procedure TActorEx.OnExit;
begin
  inherited;
end;

procedure TActorEx.OnStartup;
begin
  inherited;
end;

procedure TActorEx.OnShutdown;
begin
  inherited;
end;

procedure TActorEx.OnUpdate(aDeltaTime: Double);
begin
  inherited;

  if GV_KeyboardPressed(KEY_S) then
    Spawn;

  Scene.Update([], aDeltaTime);
end;

procedure TActorEx.OnRender;
begin
  inherited;

  Scene.Render([], nil, nil);
end;

procedure TActorEx.OnRenderGUI;
begin
  inherited;

  GV_PrintFontY(MonoFont, HudPos.X, HudPos.Y, 0, GREEN, haLeft, 'S         - Spawn actor', []);
  GV_PrintFontY(MonoFont, HudPos.X, HudPos.Y, 0, YELLOW,haLeft, 'Count:      %d', [Scene.Lists[0].Count]);
end;

procedure TActorEx.Spawn;
var
  I,C: Integer;
begin
  Scene.ClearAll;
  C := GV_RandomRangei(3, 25);
  for I := 1 to C do
    Scene.Lists[0].Add(TMyActor.Create);
end;end.
