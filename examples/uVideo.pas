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

unit uVideo;

interface

uses
  GVT,
  uCommon;

type
  { TVideoEx }
  TVideoEx = class(TBaseExample)
  protected
    FVideo: array[0..3] of TGVVideo;
    FFilename: array[0..3] of string;
    FNum: Integer;
  public
    procedure OnInitParams(var aParams: TGVGameParams); override;
    procedure OnLoad; override;
    procedure OnExit; override;
    procedure OnStartup; override;
    procedure OnShutdown; override;
    procedure OnUpdate(aDeltaTime: Double); override;
    procedure OnRender; override;
    procedure OnRenderGUI; override;
    procedure Play(aNum: Integer; aVol: Single);
  end;

implementation

{ TVideoEx }
procedure TVideoEx.OnInitParams(var aParams: TGVGameParams);
begin
  inherited;

  aParams.DisplayTitle := 'GameVision: Video Example';
  aParams.DisplayClearColor := DIMWHITE;

end;

procedure TVideoEx.OnLoad;
begin
  inherited;
end;

procedure TVideoEx.OnExit;
begin
  inherited;
end;

procedure TVideoEx.OnStartup;
begin
  inherited;
  FNum := -1;

  FFilename[0] := 'tbgintro.ogv';
  FFilename[1] := 'test.ogv';
  FFilename[2] := 'wildlife.ogv';
  FFilename[3] := 'small.ogv';


  FVideo[0] := GV_LoadVideo(Archive, 'arc/videos/'+FFilename[0]);
  FVideo[1] := GV_LoadVideo(Archive, 'arc/videos/'+FFilename[1]);
  FVideo[2] := GV_LoadVideo(Archive, 'arc/videos/'+FFilename[2]);
  FVideo[3] := GV_LoadVideo(Archive, 'arc/videos/'+FFilename[3]);

  Play(0, 1.0);

end;

procedure TVideoEx.OnShutdown;
begin
  GV_FreeVideo(FVideo[3]);
  GV_FreeVideo(FVideo[2]);
  GV_FreeVideo(FVideo[1]);
  GV_FreeVideo(FVideo[0]);
  inherited;
end;

procedure TVideoEx.OnUpdate(aDeltaTime: Double);
begin
  inherited;

  if GV_KeyboardPressed(KEY_1) then
    Play(0, 1.0);

  if GV_KeyboardPressed(KEY_2) then
    Play(1, 1.0);

  if GV_KeyboardPressed(KEY_3) then
    Play(2, 1.0);

  if GV_KeyboardPressed(KEY_4) then
    Play(3, 1.0);

end;

procedure TVideoEx.OnRender;
var
  x,y,w,h: Single;
  vp: TGVRectangle;
begin
  inherited;

  GV_GetDisplayViewportSize(vp);
  GV_GetVideoSize(FVideo[FNum], @w, @h);
  x := (vp.Width  - w) / 2;
  y := (vp.Height - h) / 2;
  GV_DrawVideo(FVideo[FNum], x, y);
end;


procedure TVideoEx.OnRenderGUI;
begin
  inherited;

  GV_PrintFontY(MonoFont, HudPos.X, HudPos.Y, 0, GREEN, haLeft, '1-4       - Video (%s)', [FFilename[FNum]]);


  //GV_PrintFontY(MonoFont, HudPos.X, HudPos.Y, 0, GREEN, haLeft, 'xxx       - xxxxxxxxxx', []);
end;

procedure TVideoEx.Play(aNum: Integer; aVol: Single);
begin
  if (aNum < 0) or (aNum > 3) then Exit;
  if  (aNum = FNum) then Exit;
  if (FNum >=0) and (FNum <=3) then
    GV_SetPlaying(FVideo[FNum], False);
  FNum := aNum;
  GV_PlayVideo(FVideo[FNum], True, 1.0);
end;

end.
