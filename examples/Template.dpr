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

program Template;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  GVT in '..\libs\GVT.pas';

const
  cArchivePassword   = '46637e728b06480f87df732f7e1777f5';
  cArchiveFilename   = 'Data.arc';

type
  { xxx }
  TTemplate = class(TGVGame)
  protected
    FCenterPos: TGVVector;
    FDimColor: TGVColor;
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
  end;

{ xxx }
constructor TTemplate.Create;
begin
  inherited;

end;

destructor TTemplate.Destroy;
begin

  inherited;
end;

procedure TTemplate.OnInitParams(var aParams: TGVGameParams);
begin
  aParams.ArchivePassword := cArchivePassword;
  aParams.ArchiveFilename := cArchiveFilename;
  aParams.DisplayTitle := 'GameVision: Template';
  FCenterPos.X := aParams.DisplayWidth / 2;
  FCenterPos.Y := aParams.DisplayHeight / 2;
  FDimColor := GV_MakeColor(16, 16, 16, 255);
end;

procedure TTemplate.OnLoad;
begin
  inherited;

end;

procedure TTemplate.OnExit;
begin

  inherited;
end;

procedure TTemplate.OnStartup;
begin
  inherited;

end;

procedure TTemplate.OnShutdown;
begin

  inherited;
end;

procedure TTemplate.OnUpdate(aDeltaTime: Double);
begin
  inherited;

  if GV_KeyboardPressed(KEY_F11) then
    GV_ToggleFullscreenDisplay;

  if GV_KeyboardPressed(KEY_ESCAPE) then
    GV_TakeScreenshot;
end;

procedure TTemplate.OnRender;
begin
  inherited;
end;

procedure TTemplate.OnRenderGUI;
begin
  HudPos.X := 3;
  HudPos.Y := 3;
  GV_PrintFontY(MonoFont, HudPos.X, HudPos.Y, 0, WHITE, haLeft, 'fps %d', [GV_GetFrameRate]);
  GV_PrintFontY(MonoFont, HudPos.X, HudPos.Y, 0, GREEN, haLeft, 'ESC       - Quit', []);
  GV_PrintFontY(MonoFont, HudPos.X, HudPos.Y, 0, GREEN, haLeft, 'F11       - Toggle fullscreen', []);
  GV_PrintFontY(MonoFont, HudPos.X, HudPos.Y, 0, GREEN, haLeft, 'F12       - Screenshot', []);

  GV_PrintFont(MonoFont, FCenterPos.X, DisplayHeight-(MonoFontSize+2), FDimColor, haCenter, 'GameVision Toolkit™ - gamevision.dev', []);

end;

{ main }
begin
  try
    GV_RunGame(TTemplate);
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
