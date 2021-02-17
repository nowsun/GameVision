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

unit uSound;

interface

uses
  GVT,
  uCommon;

type
  { TSoundEx }
  TSoundEx = class(TBaseExample)
  protected
    FSamples: array[ 0..8 ] of Integer;
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
  System.SysUtils;

{ TSoundEx }
procedure TSoundEx.OnInitParams(var aParams: TGVGameParams);
begin
  inherited;

  aParams.DisplayTitle := 'GameVision: Sound Example';
  aParams.DisplayClearColor := DIMWHITE;
end;

procedure TSoundEx.OnLoad;
begin
  inherited;
end;

procedure TSoundEx.OnExit;
begin
  inherited;
end;

procedure TSoundEx.OnStartup;
var
  I: Integer;
begin
  inherited;


  GV_SetSoundChanReserved(0, True);

  for I := 0 to 5 do
  begin
    FSamples[I] := GV_LoadSound(Archive, Format('arc/audio/sfx/samp%d.ogg', [I]));
  end;

  FSamples[6] := GV_LoadSound(Archive, 'arc/audio/sfx/weapon_player.ogg');
  FSamples[7] := GV_LoadSound(Archive, 'arc/audio/sfx/thunder.ogg');
  FSamples[8] := GV_LoadSound(Archive, 'arc/audio/sfx/digthis.ogg');

end;


procedure TSoundEx.OnShutdown;
var
  I: Integer;
begin
  GV_StopAllSoundChans;

  for I := 0 to 8 do
  begin
    GV_UnloadSound(FSamples[i]);
  end;

  inherited;
end;

procedure TSoundEx.OnUpdate(aDeltaTime: Double);
begin
  inherited;

  if GV_KeyboardPressed(KEY_1) then
    GV_PlaySoundEx(AUDIO_DYNAMIC_CHANNEL, FSamples[1], 1, False);

  if GV_KeyboardPressed(KEY_2) then
    GV_PlaySoundEx(AUDIO_DYNAMIC_CHANNEL, FSamples[2], 1, False);

  if GV_KeyboardPressed(KEY_3) then
    GV_PlaySoundEx(AUDIO_DYNAMIC_CHANNEL, FSamples[3], 1, False);

  if GV_KeyboardPressed(KEY_4) then
    GV_PlaySoundEx(0, FSamples[0], 1, True);

  if GV_KeyboardPressed(KEY_5) then
    GV_PlaySoundEx(AUDIO_DYNAMIC_CHANNEL, FSamples[4], 1, False);

  if GV_KeyboardPressed(KEY_6) then
    GV_PlaySoundEx(AUDIO_DYNAMIC_CHANNEL, FSamples[5], 1, False);

  if GV_KeyboardPressed(KEY_7) then
    GV_PlaySoundEx(AUDIO_DYNAMIC_CHANNEL, FSamples[6], 1, False);

  if GV_KeyboardPressed(KEY_8) then
    GV_PlaySoundEx(AUDIO_DYNAMIC_CHANNEL, FSamples[7], 1, False);

  if GV_KeyboardPressed(KEY_9) then
    GV_PlaySoundEx(AUDIO_DYNAMIC_CHANNEL, FSamples[8], 1, False);

  if GV_KeyboardPressed(KEY_0) then
    GV_StopSoundChan(0);
end;

procedure TSoundEx.OnRender;
begin
  inherited;
end;

procedure TSoundEx.OnRenderGUI;
begin
  inherited;

  GV_PrintFontY(MonoFont, HudPos.X, HudPos.Y, 0, GREEN, haLeft, '1-9       - Play sample', []);
  GV_PrintFontY(MonoFont, HudPos.X, HudPos.Y, 0, GREEN, haLeft, '0         - Stop looping sample', []);
end;

end.
