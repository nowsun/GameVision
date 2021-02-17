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

unit uMusic;

interface

uses
  GVT,
  uCommon;

type
  { TMusicEx }
  TMusicEx = class(TBaseExample)
  protected
    FFilename: string;
    FNum: Integer;
    FMusic: TGVMusic;
    procedure Play(aNum: Integer; aVol: Single);
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

uses
  System.SysUtils,
  System.IOUtils;

{ TMusicEx }
procedure TMusicEx.OnInitParams(var aParams: TGVGameParams);
begin
  inherited;

  aParams.DisplayTitle := 'GameVision: Music Example';
  aParams.DisplayClearColor := DIMWHITE;
end;

procedure TMusicEx.OnLoad;
begin
  inherited;
end;

procedure TMusicEx.OnExit;
begin
  inherited;
end;

procedure TMusicEx.OnStartup;
begin
  inherited;
  FNum := 1;
  FFilename := '';
  FMusic := nil;
  Play(1, 1.0);
end;

procedure TMusicEx.OnShutdown;
begin
  GV_UnloadMusic(FMusic);
  inherited;
end;

procedure TMusicEx.OnUpdate(aDeltaTime: Double);
begin
  inherited;

  if GV_KeyboardPressed(KEY_PGUP) then
  begin
    Inc(FNum);
    if FNum > 13 then
      FNum := 1;
    Play(FNum, 1.0);
  end
  else
  if GV_KeyboardPressed(KEY_PGDN) then
  begin
    Dec(FNum);
    if FNum < 1 then
      FNum := 13;
    Play(FNum, 1.0);
  end

end;

procedure TMusicEx.OnRender;
begin
  inherited;
end;

procedure TMusicEx.OnRenderGUI;
begin
  inherited;

  GV_PrintFontY(MonoFont, HudPos.X, HudPos.Y, 0, GREEN, haLeft, 'PgUp/PgDn - Play sample', []);
  GV_PrintFontY(MonoFont, HudPos.X, HudPos.Y, 0, YELLOW, haLeft, 'Song:       %s', [TPath.GetFileName(FFilename)]);
end;

procedure TMusicEx.Play(aNum: Integer; aVol: Single);
begin
  FFilename := Format('arc/audio/music/song%.*d.ogg', [2,aNum]);
  GV_UnloadMusic(FMusic);
  FMusic := GV_LoadMusic(Archive, FFilename);
  GV_PlayMusicEx(FMusic, aVol, True);
end;

end.
