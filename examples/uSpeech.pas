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

unit uSpeech;

interface

uses
  GVT,
  uCommon;

const
  SpeechTextCount = 2;
  SpeechText: array[0 .. SpeechTextCount-1] of string =(

    // speech text #1
    'You are Cadet John Blake. Reports are ' +
    'showing some activity in the newly ' +
    'established "free zones" bordering the ' +
    'outer regions of the Earth Alliance ' +
    'Defense Grid.' +
    ' ' +
    'These areas were established to promote ' +
    'free commerce and attract new members to ' +
    'the Alliance. A new resistance group has ' +
    'formed and they are stirring up trouble;' +
    'Known as the New Space Resistance  or (NSR),' +
    'they are considered extremely hostile and ' +
    'you are authorized to neutralize this ' +
    'threat by any means necessary.' +
    ' ' +
    'You''ve been assigned to patrol zones one ' +
    'through seven; Your mission is called ' +
    'Operation freestrike; and you will pilot ' +
    'the LRTD-50X; This is an experimental ' +
    'long-range tactical defense ship. It is ' +
    'equipped with new advanced weaponry and ' +
    'shield technology as well as an enhanced ' +
    'quantum pulse engine.' +
    ' ' +
    'This is a top-priority mission cadet; and ' +
    'confidence is high; I repeat, confidence is high!',

    // speech text #2
    'GameVision Toolkit, is an advanced 2D game development system for desktop PC''s ' +
    'and uses Direct3D for hardware accelerated rendering. ' +
    'You access the features from a minimal exposed API, and a thin object oriented framework, to allow ' +
    'you to rapidly and efficiently develop your graphics simulations. ' +
    'It''s robust, designed for easy use and suitable for making all types ' +
    'of 2D games and other graphic simulations. There is support ' +
    'for virtual buffers, bitmaps, audio samples, streaming music, video playback, ' +
    'loading resources directly from a standard zip archive, and much more. ' +
    'GameVision, easy, fast, fun.'
  );

type
  { TSpeechEx }
  TSpeechEx = class(TBaseExample)
  protected
    FVoiceNum: Integer;
    FOldVoiceNum: Integer;
    FSpeechTextNum: Integer;
    FSpeechWord: string;
    FVoiceCount: Integer;
    FVoiceDesc: string;
  public
    procedure OnInitParams(var aParams: TGVGameParams); override;
    procedure OnLoad; override;
    procedure OnExit; override;
    procedure OnStartup; override;
    procedure OnShutdown; override;
    procedure OnUpdate(aDeltaTime: Double); override;
    procedure OnRender; override;
    procedure OnRenderGUI; override;
    procedure OnSpeechWord(const aWord: WideString; const aText: WideString); override;
  end;

implementation

{ xxx }
procedure TSpeechEx.OnInitParams(var aParams: TGVGameParams);
begin
  inherited;

  aParams.DisplayTitle := 'GameVision: Speech Example';
  aParams.VariableFontSize := 38;
end;

procedure TSpeechEx.OnLoad;
begin
  inherited;
end;

procedure TSpeechEx.OnExit;
begin
  inherited;
end;

procedure TSpeechEx.OnStartup;
begin
  inherited;

  FSpeechTextNum := 0;

  FVoiceNum := 0;
  FOldVoiceNum := 0;
  FVoiceCount := GV_GetSpeechVoiceCount;
  FVoiceDesc  := GV_GetSpeechVoiceAttribute(0, vaDescription);
end;

procedure TSpeechEx.OnShutdown;
begin
  inherited;
end;

procedure TSpeechEx.OnUpdate(aDeltaTime: Double);

  procedure ChangeVoice;
  begin
    if FOldVoiceNum <> FVoiceNum then
    begin
      FVoiceDesc  := GV_GetSpeechVoiceAttribute(FVoiceNum, vaDescription);
      GV_ChangeSpeechVoice(FVoiceNum);
      FOldVoiceNum := FVoiceNum;
    end;
  end;

begin
  inherited;

  if GV_KeyboardPressed(KEY_DOWN) then
    begin
      Dec(FSpeechTextNum);
      GV_ClipValuei(FSpeechTextNum, 0, SpeechTextCount-1, False);
    end
  else
  if GV_KeyboardPressed(KEY_UP) then
    begin
      Inc(FSpeechTextNum);
      GV_ClipValuei(FSpeechTextNum, 0, SpeechTextCount-1, False);
    end;

  if GV_KeyboardPressed(KEY_PGDN) then
    begin
      Dec(FVoiceNum);
      GV_ClipValuei(FVoiceNum, 0, FVoiceCount-1, False);
      ChangeVoice;
    end
  else
  if GV_KeyboardPressed(KEY_PGUP) then
    begin
      Inc(FVoiceNum);
      GV_ClipValuei(FVoiceNum, 0, FVoiceCount-1, False);
      ChangeVoice;
    end;

  if GV_KeyboardPressed(KEY_S) then
  begin
    GV_Speak(SpeechText[FSpeechTextNum], True);
  end;

  GV_UpdateStarfield(Starfield, aDeltaTime);
end;

procedure TSpeechEx.OnRender;
begin
  inherited;

  GV_RenderStarfield(Starfield);
end;

procedure TSpeechEx.OnRenderGUI;
begin
  inherited;

  GV_PrintFontY(MonoFont, HudPos.x, HudPos.y, 0, GREEN,  haLeft, 'S         - Speek', []);
  GV_PrintFontY(MonoFont, HudPos.x, HudPos.y, 0, GREEN,  haLeft, 'Up/Down   - Speech text (%d/%d)', [FSpeechTextNum+1, SpeechTextCount]);
  GV_PrintFontY(MonoFont, HudPos.x, HudPos.y, 0, GREEN,  haLeft, 'PgUp/PgDn - Speech voice (%d/%d)', [FVoiceNum+1, FVoiceCount]);
  GV_PrintFontY(MonoFont, HudPos.x, HudPos.y, 0, YELLOW, haLeft, 'Voice     - %s', [FVoiceDesc]);

  GV_PrintFont(VariableFont, 15, 160, ORANGE, haLeft, 'Speech: %s', [FSpeechWord]);

  //GV_PrintFontY(MonoFont, HudPos.X, HudPos.Y, 0, GREEN, haLeft, 'xxx       - xxxxxxxxxx', []);
end;

procedure TSpeechEx.OnSpeechWord(const aWord: WideString; const aText: WideString);
begin
  FSpeechWord := aWord;
end;

end.
