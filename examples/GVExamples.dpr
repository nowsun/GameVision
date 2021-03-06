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

program GVExamples;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  GVT in '..\libs\GVT.pas',
  uExamples in 'uExamples.pas',
  uConfig in 'uConfig.pas',
  uActor in 'uActor.pas',
  uAstroBlaster in 'uAstroBlaster.pas',
  uBitmap in 'uBitmap.pas',
  uChainAction in 'uChainAction.pas',
  uCommon in 'uCommon.pas',
  uElastic in 'uElastic.pas',
  uEntity in 'uEntity.pas',
  uEntityCollision in 'uEntityCollision.pas',
  uEntityCollisionPoint in 'uEntityCollisionPoint.pas',
  uIMGUI in 'uIMGUI.pas',
  uMusic in 'uMusic.pas',
  uPathEditor in 'uPathEditor.pas',
  uPhysics in 'uPhysics.pas',
  uPolygon in 'uPolygon.pas',
  uRotateViewport in 'uRotateViewport.pas',
  uScreenshake in 'uScreenshake.pas',
  uScroll in 'uScroll.pas',
  uSound in 'uSound.pas',
  uSpeech in 'uSpeech.pas',
  uStarfield in 'uStarfield.pas',
  uTemplate in 'uTemplate.pas',
  uText in 'uText.pas',
  uTiledBitmap in 'uTiledBitmap.pas',
  uUnicodeFont in 'uUnicodeFont.pas',
  uVideo in 'uVideo.pas',
  uViewports in 'uViewports.pas',
  uMessageDialog in 'uMessageDialog.pas',
  uConfirmDialog in 'uConfirmDialog.pas',
  uOpenDirDialog in 'uOpenDirDialog.pas',
  uOpenFileDialog in 'uOpenFileDialog.pas',
  uSaveFileDialog in 'uSaveFileDialog.pas';

begin
  try
    { TODO -oUser -cConsole Main : Insert code here }
    RunExamples;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
