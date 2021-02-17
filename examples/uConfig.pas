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

unit uConfig;

interface

const
  cCaption           = 'GameVision: Examples';
  {$J+}
  cArchivePassword: array[0..32] of Char = ('0', '1', '1', '2', '2', '3', '3', '4', '4', '5', '5', '6', '6', '7', '7', '8', '8', '9', '9', '0', '1', '1', '2', '2', '3', '3', '4', '4', '5', '5', '6', '6', #0);
  {$J-}
  cArchiveFilename   = 'GVExamples.arc';

implementation


initialization
begin

  //46637e728b06480f87df732f7e1777f5
  cArchivePassword[00] := '4';
  cArchivePassword[01] := '6';
  cArchivePassword[02] := '6';
  cArchivePassword[03] := '3';
  cArchivePassword[04] := '7';
  cArchivePassword[05] := 'e';
  cArchivePassword[06] := '7';
  cArchivePassword[07] := '2';
  cArchivePassword[08] := '8';
  cArchivePassword[09] := 'b';
  cArchivePassword[10] := '0';
  cArchivePassword[11] := '6';
  cArchivePassword[12] := '4';
  cArchivePassword[13] := '8';
  cArchivePassword[14] := '0';
  cArchivePassword[15] := 'f';
  cArchivePassword[16] := '8';
  cArchivePassword[17] := '7';
  cArchivePassword[18] := 'd';
  cArchivePassword[19] := 'f';
  cArchivePassword[20] := '7';
  cArchivePassword[21] := '3';
  cArchivePassword[22] := '2';
  cArchivePassword[23] := 'f';
  cArchivePassword[24] := '7';
  cArchivePassword[25] := 'e';
  cArchivePassword[26] := '1';
  cArchivePassword[27] := '7';
  cArchivePassword[28] := '7';
  cArchivePassword[29] := '7';
  cArchivePassword[30] := 'f';
  cArchivePassword[31] := '5';
  cArchivePassword[32] := #0;


end;

finalization
begin

end;

end.
