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

unit uPathEditor;

interface

uses
  GVT,
  uCommon;

type

  { TPathEditorEx }
  TPathEditorEx = class(TGVCustomgame)
  public
    PathIndex: Integer;
    LookAHead: Integer;
    Speed: Single;
    WindowPos: TGVPointi;
    WindowSize: TGVPointi;
    constructor Create; override;
    destructor Destroy; override;
    function Run: Boolean; override;
    procedure OnPathEditorLoad; override;
    procedure OnPathEditorSave; override;
    procedure OnPathEditorTest(aPathIndex: Integer; aLookAHead: Integer; aSpeed: Single; aWindowPos: TGVPointi; aWindowSize: TGVPointi); override;
  end;

  { TPathEditorTest }
  TPathEditorTest = class(TBaseExample)
  protected
    FShip: TGVEntity;
    FPath: TGVPath;
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
    procedure OnDisplayToggleFullscreen(aFullscreen: Boolean); override;
  end;

var
  Game: TPathEditorEx = nil;

implementation

uses
  System.SysUtils;

{ TPathEditorTest }
procedure TPathEditorTest.OnInitParams(var aParams: TGVGameParams);
begin
  inherited;

  aParams.DisplayTitle := Format('PathEditor Test - Path #%.3d', [Game.PathIndex]);
  aParams.DisplayWidth := Game.WindowSize.X;
  aParams.DisplayHeight := Game.WindowSize.Y;

  FCenterPos.X := aParams.DisplayWidth / 2;
  FCenterPos.Y := aParams.DisplayHeight / 2;
end;

procedure TPathEditorTest.OnLoad;
begin
  inherited;
end;

procedure TPathEditorTest.OnExit;
begin
  inherited;
end;

procedure TPathEditorTest.OnStartup;
begin
  inherited;
  GV_SetDisplayPosition(Game.WindowPos.X, Game.WindowPos.Y);

  GV_InitStarfield(Starfield, 150, -1000, -1000, 10, 1000, 1000, 1000, 180);
  GV_SetStarfieldXSpeed(Starfield, 0);
  GV_SetStarfieldZSpeed(Starfield, 0);
  GV_SetStarfieldYSpeed(Starfield, 30*10);


  // init ship sprite
  GV_LoadSpritePage(Sprite, Archive, 'arc/bitmaps/sprites/ship.png', nil);
  GV_AddSpriteGroup(Sprite);
  GV_AddSpriteImageFromGrid(Sprite, 0, 0, 0, 0, 64, 64);
  GV_AddSpriteImageFromGrid(Sprite, 0, 0, 1, 0, 64, 64);
  GV_AddSpriteImageFromGrid(Sprite, 0, 0, 2, 0, 64, 64);
  GV_AddSpriteImageFromGrid(Sprite, 0, 0, 3, 0, 64, 64);

  // init ship entity
  FShip := GV_CreateEntity(Sprite, 0);
  GV_SetEntityFrameFPS(FShip, 17);
  GV_SetEntityScaleAbs(FShip, 0.65);
  GV_SetEntityPosAbs(FShip, -64, -64);

  FPath := GV_CreatePath(GAme.PathIndex, MaxInt);

  FMusic := GV_LoadMusic(Archive, 'arc/audio/music/song01.ogg');
  GV_PlayMusicEx(FMusic, 0.5, True);


end;

procedure TPathEditorTest.OnShutdown;
begin
  GV_FreeEntity(FShip);
  GV_FreePath(FPath);
  GV_UnloadMusic(FMusic);
  inherited;
end;

procedure TPathEditorTest.OnUpdate(aDeltaTime: Double);
var
  LX,LY, LAngle: Single;
begin
  inherited;

  GV_NextEntityFrame(FShip);

  if GV_UpdatePath(FPath, Game.LookAHead, Game.Speed, LX, LY, LAngle) then
  begin
    GV_SetEntityPosAbs(FShip, LX, LY);
    GV_RotateEntityAbs(FShip, LAngle);
  end;

  GV_UpdateStarfield(Starfield, aDeltaTime);
end;

procedure TPathEditorTest.OnRender;
begin
  inherited;
  GV_RenderStarfield(Starfield);
  GV_RenderEntity(FShip, 0, 0);
end;

procedure TPathEditorTest.OnRenderGUI;
begin
  inherited;
end;

procedure TPathEditorTest.OnDisplayToggleFullscreen(aFullscreen: Boolean);
begin
  if not aFullscreen then
    GV_SetDisplayPosition(Game.WindowPos.X, Game.WindowPos.Y);
end;


{ TPathEditorEx }
constructor TPathEditorEx.Create;
begin
  inherited;
  Game := Self;
end;

destructor TPathEditorEx.Destroy;
begin
  Game := nil;
  inherited;
end;

function TPathEditorEx.Run: Boolean;
begin
  GV_ResetPathEditor;
  GV_ShowPathEditor;
  Result := False;
end;

procedure TPathEditorEx.OnPathEditorLoad;
var
  LFilename: WideString;
begin
  if GV_OpenFileDialog('Load Path', 'Path Files|*.path', 0, '.path', '', LFilename) then
  begin
    GV_LoadPathEditor(nil, LFilename);
  end;
end;

procedure TPathEditorEx.OnPathEditorSave;
var
  LFilename: WideString;
begin
  if GV_SaveFileDialog('Save Path', 'Path File|*.path', 0, '.path', LFilename) then
  begin
    GV_SavePathEditor(LFilename);
  end;

end;

procedure TPathEditorEx.OnPathEditorTest(aPathIndex: Integer; aLookAHead: Integer; aSpeed: Single; aWindowPos: TGVPointi; aWindowSize: TGVPointi);
begin
  PathIndex := aPathIndex;
  LookAHead := aLookAHead;
  Speed := aSpeed;
  WindowPos := aWindowPos;
  WindowSize := aWindowSize;
  GV_RunGame(TPathEditorTest);
end;

end.
