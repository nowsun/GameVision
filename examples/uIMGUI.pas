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

unit uIMGUI;

interface

uses
  GVT,
  uCommon;

const
  cGuiWindowFlags: array[0..4] of Cardinal = (GUI_WINDOW_BORDER, GUI_WINDOW_MOVABLE,
   GUI_WINDOW_SCALABLE, GUI_WINDOW_CLOSABLE, GUI_WINDOW_TITLE);
  cGuiThemes: array[0..4] of WideString = ('Default', 'White', 'Red', 'Blue', 'Dark');

type
  { TIMGUIEx }
  TIMGUIEx = class(TBaseExample)
  protected
    MusicVolume: Single;
    Difficulty: Integer;
    Chk1: Boolean;
    Chk2: Boolean;
    Theme: Integer;
    ThemeChanged: Boolean;
    FMusic: TGVMusic;
    FSfx: Integer;
  public
    procedure OnInitParams(var aParams: TGVGameParams); override;
    procedure OnLoad; override;
    procedure OnExit; override;
    procedure OnStartup; override;
    procedure OnShutdown; override;
    procedure OnUpdate(aDeltaTime: Double); override;
    procedure OnRender; override;
    procedure OnRenderGUI; override;
    procedure OnProcessIMGUI; override;
  end;

implementation

{ TIMGUIEx }
procedure TIMGUIEx.OnInitParams(var aParams: TGVGameParams);
begin
  inherited;

  aParams.DisplayTitle := 'GameVision: IMGUI Example';
end;

procedure TIMGUIEx.OnLoad;
begin
  inherited;
  MusicVolume := 0.3;
  Difficulty := 0;
  Chk1 := False;
  Chk2 := False;
  Theme := 0;
  ThemeChanged := False;
end;

procedure TIMGUIEx.OnExit;
begin
  inherited;
end;

procedure TIMGUIEx.OnStartup;
begin
  inherited;

  FSfx := GV_LoadSound(Archive, 'arc/audio/sfx/digthis.ogg');

  FMusic := GV_LoadMusic(Archive, 'arc/audio/music/song07.ogg');
  GV_PlayMusicEx(FMusic, MusicVolume, True);
end;

procedure TIMGUIEx.OnShutdown;
begin
  GV_UnloadMusic(FMusic);
  GV_UnloadSound(FSfx);
  inherited;
end;

procedure TIMGUIEx.OnUpdate(aDeltaTime: Double);
begin
  inherited;

  GV_UpdateStarfield(Starfield, aDeltaTime);
end;

procedure TIMGUIEx.OnRender;
begin
  inherited;

  if GV_KeyboardPressed(KEY_S) then
    GV_StartScreenshake(60, 5);

  GV_RenderStarfield(Starfield);

  GV_DrawFilledRectangle(FCenterPos.X+100, FCenterPos.Y, 100, 100, DARKGREEN);

end;

procedure TIMGUIEx.OnRenderGUI;
begin
  inherited;

  GV_PrintFontY(MonoFont, HudPos.X, HudPos.Y, 0, GREEN, haLeft, 'S         - Shake screen', []);
end;

procedure TIMGUIEx.OnProcessIMGUI;
begin
  if GV_GuiWindowBegin('Window 1', 'Window 1', 50, 50, 270, 220, cGuiWindowFlags) then
  begin
    GV_GuiLayoutRowStatic(30, 80, 2);
    GV_GuiButton('One');
    GV_GuiButton('Two');

    GV_GuiLayoutRowDynamic(30, 2);
    if GV_GuiOption('easy', Boolean(Difficulty = 0)) then
      Difficulty := 0;

    if GV_GuiOption('hard', Boolean(Difficulty = 1)) then
      Difficulty := 1;

    GV_GuiLayoutRowBegin(GUI_STATIC, 30, 2);
    GV_GuiLayoutRowPush(50);
    GV_GuiLabel('Volume:', GUI_TEXT_LEFT);
    GV_GuiLayoutRowPush(110);
    if GV_GuiSlider(0, 1, 0.01, MusicVolume) then
      GV_SetMusicVolume(FMusic, MusicVolume);
    GV_GuiLayoutRowPush(120);
    if GV_GuiCheckbox('Dig this', chk1) then
    begin
      if chk1 then
      begin
        GV_PlaySoundEx(AUDIO_DYNAMIC_CHANNEL, FSfx, 0.5, False);
      end;
    end;
    GV_GuiCheckbox('Change theme', chk2);
    GV_GuiLayoutRowEnd;
  end;
  GV_GuiWindowEnd;


  if chk2 then
  begin
    if GV_GuiWindowBegin('Window 2', 'Window 2', 350, 150, 320, 220, cGuiWindowFlags) then
      begin
       GV_GuiLayoutRowStatic(25, 190, 1);
       Theme := GV_GuiCombobox(cGuiThemes, Theme, 25, 200, 200, ThemeChanged);
      end
    else
      begin
       chk2 := False;
      end;
    GV_GuiWindowEnd;

    if ThemeChanged then
      GV_SetGuiStyle(Theme);
  end;

end;

end.
