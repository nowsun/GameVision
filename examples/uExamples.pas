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

unit uExamples;

interface

uses
  GVT,
  uCommon;

type
  { TMenuItem }
  TMenuItem = (
    //Examples
      miViewports,
      miRotateViewport,
      miScreenshake,

      miUnicodeFont,
      miText,
      miStarfield,
      miTiledBitmap,
      miBitmap,
      miPolygon,
      miVideo,

      miMusic,
      miSound,
      miSpeech,

      miActor,
      miEntity,
      miEntityCollision,
      miEntityCollisionPoint,
      miPhysics,

      miIMGUI,

    //Dialogs
      miConfirmDialog,
      miOpenDirDialog,
      miOpenFileDialog,
      miSaveFileDialog,

    //Tools
      miPathEditor,

    //Demos
      miElastic,
      miChainAction,
      miAstroBlaster,
      miScroll,

    //Testbed
      miHighscores,
      miContactUS,
      miFeedback

  );



  { TExamples }
  TExamples = class(TGVGame)
  public
    FSelItem: Integer;
  public
    function  OnStartupDialogShow: Boolean; override;
    procedure OnStartupDialogMore; override;
    function  OnStartupDialogRun: Boolean; override;
    procedure OnInitParams(var aParams: TGVGameParams); override;
  end;

procedure RunExamples;

implementation

uses
  uConfig,
  {$IFDEF TESTBED}
  uHighscores,
  uContactUs,
  uFeedback,
  {$ENDIF}
  uScreenshake,
  uActor,
  uViewports,
  uRotateViewport,
  uUnicodeFont,
  uTiledBitmap,
  uBitmap,
  uPolygon,
  uVideo,
  uMusic,
  uSound,
  uEntity,
  uEntityCollision,
  uEntityCollisionPoint,
  uPhysics,
  uIMGUI,
  uPathEditor,
  uElastic,
  uChainAction,
  uAstroBlaster,
  uScroll,
  uText,
  uStarfield,
  uSpeech,
  uConfirmDialog,
  uOpenDirDialog,
  uOpenFileDialog,
  uSaveFileDialog
  ;

procedure RunExamples;
begin
  GV_RunGame(TExamples);
end;

{ TTestbed }
function  TExamples.OnStartupDialogShow: Boolean;
begin
  GV_SetStartupDialogCaption(cCaption);
  GV_SetStartupDialogLogo(Archive, 'arc/startup/banner.png');
  GV_SetStartupDialogLogoClickUrl('https://gamevision.dev');
  GV_SetStartupDialogReadme(Archive, 'arc/startup/readme.txt');
  GV_SetStartupDialogLicense(Archive, 'arc/startup/license.txt');
  GV_SetStartupDialogReleaseInfo('Version ' + GV_GetVersion);
  Result := True;
end;

procedure TExamples.OnStartupDialogMore;
begin
  inherited;
end;

function  TExamples.OnStartupDialogRun: Boolean;
const
  {$IFDEF TESTBED}
    IsTestbed = True;
  {$ELSE}
    IsTestbed = False;
  {$ENDIF}

var
  Menu: TGVTreeMenu;
  CoreMenu: Integer;
  DialogsMenu: Integer;
  ToolsMenu: Integer;
  DemosMenu: Integer;
  TestbedMenu: Integer;
begin
  Menu := GV_CreateTreeMenu;
  GV_SetTreeMenuTitle(Menu, 'GameVision: Examples');

  // Examples
  CoreMenu := GV_AddTreeMenuItem(Menu, 0, 'Core', TREEMENU_NONE, True);
    GV_AddTreeMenuItem(Menu, CoreMenu, 'Viewports', Ord(miViewports), True);
    GV_AddTreeMenuItem(Menu, CoreMenu, 'Rotate Viewport', Ord(miRotateViewport), True);
    GV_AddTreeMenuItem(Menu, CoreMenu, 'Screenshake', Ord(miScreenshake), True);
    GV_AddTreeMenuItem(Menu, CoreMenu, 'UnicodeFont', Ord(miUnicodeFont), True);
    GV_AddTreeMenuItem(Menu, CoreMenu, 'Starfield', Ord(miStarfield), True);
    GV_AddTreeMenuItem(Menu, CoreMenu, 'Tiled Bitmap', Ord(miTiledBitmap), True);
    GV_AddTreeMenuItem(Menu, CoreMenu, 'Bitmap', Ord(miBitmap), True);
    GV_AddTreeMenuItem(Menu, CoreMenu, 'Polygon', Ord(miPolygon), True);
    GV_AddTreeMenuItem(Menu, CoreMenu, 'Video', Ord(miVideo), True);
    GV_AddTreeMenuItem(Menu, CoreMenu, 'Music', Ord(miMusic), True);
    GV_AddTreeMenuItem(Menu, CoreMenu, 'Sound', Ord(miSound), True);
    GV_AddTreeMenuItem(Menu, CoreMenu, 'Speech', Ord(miSpeech), True);
    GV_AddTreeMenuItem(Menu, CoreMenu, 'Actor', Ord(miActor), True);
    GV_AddTreeMenuItem(Menu, CoreMenu, 'Entity', Ord(miEntity), True);
    GV_AddTreeMenuItem(Menu, CoreMenu, 'Entity Collision', Ord(miEntityCollision), True);
    GV_AddTreeMenuItem(Menu, CoreMenu, 'Entity Collision Point', Ord(miEntityCollisionPoint), True);
    GV_AddTreeMenuItem(Menu, CoreMenu, 'Physics', Ord(miPhysics), True);
    GV_AddTreeMenuItem(Menu, CoreMenu, 'IMGUI', Ord(miIMGUI), True);
  GV_SortTreeMenu(Menu, CoreMenu);

  // Dialogs
  DialogsMenu := GV_AddTreeMenuItem(Menu, 0, 'Dialogs', TREEMENU_NONE, True);
    GV_AddTreeMenuItem(Menu, DialogsMenu, 'Confirm', Ord(miConfirmDialog), True);
    GV_AddTreeMenuItem(Menu, DialogsMenu, 'Open Directory', Ord(miOpenDirDialog), True);
    GV_AddTreeMenuItem(Menu, DialogsMenu, 'Open File', Ord(miOpenFileDialog), True);
    GV_AddTreeMenuItem(Menu, DialogsMenu, 'Save File', Ord(miSaveFileDialog), True);
  GV_SortTreeMenu(Menu, DialogsMenu);

  // Tools
  ToolsMenu := GV_AddTreeMenuItem(Menu, 0, 'Tools', TREEMENU_NONE, True);
    GV_AddTreeMenuItem(Menu, ToolsMenu, 'Path Editor', Ord(miPathEditor), True);
  GV_SortTreeMenu(Menu, ToolsMenu);

  // Demos
  DemosMenu := GV_AddTreeMenuItem(Menu, 0, 'Demos', TREEMENU_NONE, True);
    GV_AddTreeMenuItem(Menu, DemosMenu, 'Elastic', Ord(miElastic), True);
    GV_AddTreeMenuItem(Menu, DemosMenu, 'ChainAction', Ord(miChainAction), True);
    GV_AddTreeMenuItem(Menu, DemosMenu, 'AstroBlaster', Ord(miAstroBlaster), True);
    GV_AddTreeMenuItem(Menu, DemosMenu, 'Scroll', Ord(miScroll), True);
  GV_SortTreeMenu(Menu, DemosMenu);

  // Testbed
  {$IFDEF TESTBED}
  TestbedMenu := GV_AddTreeMenuItem(Menu, 0, 'GVTestbed.exe', TREEMENU_NONE, True);
    GV_AddTreeMenuItem(Menu, TestbedMenu, 'Highscores', Ord(miHighscores), IsTestbed);
    GV_AddTreeMenuItem(Menu, TestbedMenu, 'Contact Us', Ord(miContactUs), IsTestbed);
    GV_AddTreeMenuItem(Menu, TestbedMenu, 'Feedback', Ord(miFeedback), IsTestbed);
  GV_SortTreeMenu(Menu, TestbedMenu);
  {$ENDIF}

  FSelItem := GV_GetConfigFileIntValue(ConfigFile, 'Menu', 'SelItem', -1);

  if FSelItem = -1 then
    FSelItem := GV_GetFirstTreeMenuItem(Menu, 0);

  repeat
    FSelItem := GV_ShowTreeMenu(Menu, FSelItem);
    case TMenuItem(FSelItem) of
      miViewports           : GV_RunGame(TViewportsEx);
      miRotateViewport      : GV_RunGame(TRotateViewportEx);
      miScreenshake         : GV_RunGame(TScreenshakeEx);
      miUnicodeFont         : GV_RunGame(TUnicodeFontEx);
      miText                : GV_RunGame(TTextEx);
      miStarfield           : GV_RunGame(TStarfieldEx);
      miTiledBitmap         : GV_RunGame(TTiledBitmapEx);
      miBitmap              : GV_RunGame(TBitmapEx);
      miPolygon             : GV_RunGame(TPolygonEx);
      miVideo               : GV_RunGame(TVideoEx);
      miMusic               : GV_RunGame(TMusicEx);
      miSound               : GV_RunGame(TSoundEx);
      miSpeech              : GV_RunGame(TSpeechEx);
      miActor               : GV_RunGame(TActorEx);
      miEntity              : GV_RunGame(TEntityEx);
      miEntityCollision     : GV_RunGame(TEntityCollisionEx);
      miEntityCollisionPoint: GV_RunGame(TEntityCollisionPointEx);
      miPhysics             : GV_RunGame(TPhysicsEx);
      miIMGUI               : GV_RunGame(TIMGUIEx);
      miPathEditor          : GV_RunGame(TPathEditorEx);
      miElastic             : GV_RunGame(TElasticDemo);
      miChainAction         : GV_RunGame(TChainActionDemo);
      miAstroBlaster        : GV_RunGame(TAstroBlasterDemo);
      miScroll              : GV_RunGame(TScrollDemo);
      miConfirmDialog       : GV_RunGame(TConfirmDialogEx);
      miOpenDirDialog       : GV_RunGame(TOpenDirDialogEx);
      miOpenFileDialog      : GV_RunGame(TOpenFileDialogEx);
      miSaveFileDialog      : GV_RunGame(TSaveFileDialogEx);
      {$IFDEF TESTBED}
      miHighscores          : GV_RunGame(THighscoresEx);
      miContactUS           : GV_RunGame(TContactUsEx);
      miFeedback            : GV_RunGame(TFeedbackEx);
      {$ENDIF}

    end;
  until FSelItem = TREEMENU_QUIT;

  FSelItem := GV_GetTreeMenuLastSelectedId(Menu);
  GV_SetConfigFileIntValue(ConfigFile, 'Menu', 'SelItem', FSelItem);

  GV_FreeTreeMenu(Menu);

  Result := False;
end;

procedure TExamples.OnInitParams(var aParams: TGVGameParams);
begin
  aParams.ArchivePassword := cArchivePassword;
end;

end.
