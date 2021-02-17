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

unit uElastic;

interface

uses
  GVT,
  uCommon;

const
  cGravity          = 0.04;
  cXDecay           = 0.97;
  cYDecay           = 0.97;
  cBeadCount        = 10;
  cXElasticity      = 0.02;
  cYElasticity      = 0.02;
  cWallDecay        = 0.9;
  cSlackness        = 1;
  cBeadSize         = 12;
  cBedHalfSize      = cBeadSize / 2;
  cBeadFilled       = True;


type

  { TBead }
  TBead = record
    X    : Single;
    Y    : Single;
    XMove: Single;
    YMove: Single;
  end;


  { TElasticDemo }
  TElasticDemo = class(TBaseExample)
  protected
    FViewWidth: Single;
    FViewHeight: Single;
    FBead : array[0..cBeadCount] of TBead;
    FTimer: Single;
    FMusic: TGVMusic;
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

{ TElasticDemo }
procedure TElasticDemo.OnInitParams(var aParams: TGVGameParams);
begin
  inherited;

  aParams.DisplayTitle := 'GameVision: Elastic Demo';
end;

procedure TElasticDemo.OnLoad;
begin
  inherited;
end;

procedure TElasticDemo.OnExit;
begin
  inherited;
end;

procedure TElasticDemo.OnStartup;
var
  vp: TGVRectangle;
begin
  inherited;

  FillChar(FBead, SizeOf(FBead), 0);

  GV_GetDisplayViewportSize(vp);
  FViewWidth := vp.Width;
  FViewHeight := vp.Height;

  FMusic := GV_LoadMusic(Archive, 'arc/audio/music/song04.ogg');
  GV_PlayMusicEx(FMusic, 0.5, True);

end;

procedure TElasticDemo.OnShutdown;
begin
  GV_UnloadMusic(FMusic);

  inherited;
end;

procedure TElasticDemo.OnUpdate(aDeltaTime: Double);
var
  i: Integer;
  Dist, DistX, DistY: Single;
begin
  inherited;

  if not GV_FrameSpeed(FTimer, GV_GetUpdateSpeed) then
    Exit;

  FBead[0].X := MousePos.X;
  FBead[0].Y := MousePos.Y;

  if FBead[0].X - (cBeadSize+10)/2<0 then
  begin
   FBead[0].X := (cBeadSize+10)/2;
  end;

  if FBead[0].X + ((cBeadSize+10)/2) >FViewWidth then
  begin
   FBead[0].X := FViewWidth - (cBeadSize+10)/2;
  end;

  if FBead[0].Y - ((cBeadSize+10)/2) < 0 then
  begin
   FBead[0].Y := (cBeadSize+10)/2;
  end;

  if FBead[0].Y + ((cBeadSize+10)/2) > FViewHeight then
  begin
   FBead[0].Y := FViewHeight - (cBeadSize+10)/2;
  end;

  // loop though other beads
  for i := 1 to cBeadCount do
  begin
    // calc X and Y distance between the bead and the one before it
    DistX := FBead[i].X - FBead[i-1].X;
    DistY := FBead[i].Y - FBead[i-1].Y;

    // calc total distance
    Dist := sqrt(DistX*DistX + DistY * DistY);

    // if the beads are far enough apart, decrease the movement to create elasticity
    if Dist > cSlackness then
    begin
       FBead[i].XMove := FBead[i].XMove - (cXElasticity * DistX);
       FBead[i].YMove := FBead[i].YMove - (cYElasticity * DistY);
    end;

    // if bead is not last bead
    if i <> cBeadCount then
    begin
       // calc distances between the bead and the one after it
       DistX := FBead[i].X - FBead[i+1].X;
       DistY := FBead[i].Y - FBead[i+1].Y;
       Dist  := sqrt(DistX*DistX + DistY*DistY);

       // if beads are far enough apart, decrease the movement to create elasticity
       if Dist > 1 then
       begin
          FBead[i].XMove := FBead[i].XMove - (cXElasticity * DistX);
          FBead[i].YMove := FBead[i].YMove - (cYElasticity * DistY);
       end;
    end;

    // decay the movement of the beads to simulate loss of energy
    FBead[i].XMove := FBead[i].XMove * cXDecay;
    FBead[i].YMove := FBead[i].YMove * cYDecay;

    // apply cGravity to bead movement
    FBead[i].YMove := FBead[i].YMove + cGravity;

    // move beads
    FBead[i].X := FBead[i].X + FBead[i].XMove;
    FBead[i].Y := FBead[i].Y + FBead[i].YMove;

    // ff the beads hit a wall, make them bounce off of it
    if FBead[i].X - ((cBeadSize + 10 ) / 2) < 0 then
    begin
       FBead[i].X     :=  FBead[i].X     + (cBeadSize+10)/2;
       FBead[i].XMove := -FBead[i].XMove * cWallDecay;
    end;

    if FBead[i].X + ((cBeadSize+10)/2) > FViewWidth then
    begin
       FBead[i].X     := FViewWidth - (cBeadSize+10)/2;
       FBead[i].xMove := -FBead[i].XMove * cWallDecay;
    end;

    if FBead[i].Y - ((cBeadSize+10)/2) < 0 then
    begin
       FBead[i].YMove := -FBead[i].YMove * cWallDecay;
       FBead[i].Y     :=(cBeadSize+10)/2;
    end;

    if FBead[i].Y + ((cBeadSize+10)/2) > FViewHeight then
    begin
       FBead[i].YMove := -FBead[i].YMove * cWallDecay;
       FBead[i].Y     := FViewHeight - (cBeadSize+10)/2;
    end;
  end;

end;

procedure TElasticDemo.OnRender;
var
  I: Integer;
begin
  inherited;

  // draw last bead
  GV_DrawFilledRectangle(FBead[0].X, FBead[0].Y, cBeadSize, cBeadSize, GREEN);

  // loop though other beads
  for I := 1 to cBeadCount do
  begin
    // draw bead and string from it to the one before it
    GV_DrawLine(FBead[i].x+cBedHalfSize,
      FBead[i].y+cBedHalfSize, FBead[i-1].x+cBedHalfSize,
      FBead[i-1].y+cBedHalfSize, YELLOW, 1);
    GV_DrawFilledRectangle(FBead[i].X, FBead[i].Y, cBeadSize,
     cBeadSize, GREEN);
  end;

end;

procedure TElasticDemo.OnRenderGUI;
begin
  inherited;

  //GV_PrintFontY(MonoFont, HudPos.X, HudPos.Y, 0, GREEN, haLeft, 'xxx       - xxxxxxxxxx', []);
end;

end.
