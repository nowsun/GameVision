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

unit uBitmap;

interface

uses
  GVT,
  uCommon;

type
  { TBitmapEx }
  TBitmapEx = class(TBaseExample)
  protected
    FBitmap: array[ 0..1] of TGVBitmap;
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

{ TBitmapEx }
procedure TBitmapEx.OnInitParams(var aParams: TGVGameParams);
begin
  inherited;

  aParams.DisplayTitle := 'GameVision: Bitmap Example';
  aParams.DisplayClearColor := DIMWHITE;
end;

procedure TBitmapEx.OnLoad;
begin
  inherited;
end;

procedure TBitmapEx.OnExit;
begin
  inherited;
end;

procedure TBitmapEx.OnStartup;
begin
  inherited;

  // load a bitmap that has true transparancy
  FBitmap[0] := GV_LoadBitmap(Archive, 'arc/bitmaps/sprites/gamevision1.png', nil);

  // load a bitmap and use colorkey transparancy
  FBitmap[1] := GV_LoadBitmap(Archive, 'arc/bitmaps/sprites/circle00.png', @COLORKEY);

end;

procedure TBitmapEx.OnShutdown;
begin
  GV_FreeBitmap(FBitmap[1]);
  GV_FreeBitmap(FBitmap[0]);
  inherited;
end;

procedure TBitmapEx.OnUpdate(aDeltaTime: Double);
begin
  inherited;
end;

procedure TBitmapEx.OnRender;
begin
  inherited;

  // draw transparancy bitmap
  GV_DrawBitmap(FBitmap[0], DisplayWidth/2, 140, 0.5, 0, WHITE, haCenter, vaCenter);

  // draw colorkey transparancy bitmap
  GV_DrawBitmap(FBitmap[1], DisplayWidth/2, 320, 1, 0, WHITE, haCenter, vaCenter);
end;

procedure TBitmapEx.OnRenderGUI;
begin
  inherited;

  GV_PrintFont(MonoFont, DisplayWidth/2, 205, YELLOW, haCenter, 'true trans', []);
  GV_PrintFont(MonoFont, DisplayWidth/2, 385, YELLOW, haCenter, 'colorkey trans', []);

  //GV_PrintFontY(MonoFont, HudPos.X, HudPos.Y, 0, GREEN, haLeft, 'xxx       - xxxxxxxxxx', []);
end;

end.
