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

unit GVT;

{$Z4}
{$A8}

interface

uses
  System.SysUtils,
  System.Classes,
  System.Contnrs;

const
  cDllName = 'GVT.dll';

{ === MISC ================================================================== }
type
  { TGVHAlign }
  TGVHAlign = (haLeft, haCenter, haRight);

  { TGVVAlign }
  TGVVAlign = (vaTop, vaCenter, vaBottom);

procedure GV_CryptBuffer(const aBuffer: PByte; aLength: Cardinal; aPassword: PChar; aToCrypt: Boolean); external cDllName;
procedure GV_SmoothMove(var aValue: Single; aAmount: Single; aMax: Single; aDrag: Single); external cDllName;

{ === MATH ================================================================== }
const
  // Degree/Radian conversion
  GV_RAD2DEG = 180.0 / PI;
  GV_DEG2RAD = PI / 180.0;

type
  { TGVPointi }
  PGVPointi = ^TGVPointi;
  TGVPointi = record
    X, Y: Integer;
  end;

  { TGVPointf }
  PGVPointf = ^TGVPointi;
  TGVPointf = record
    X, Y: Single;
  end;

  { TGVRange }
  PGVRange = ^TGVRange;
  TGVRange = record
    MinX, MinY, MaxX, MaxY: Single;
  end;

  { TGVVector }
  PGVVector = ^TGVVector;
  TGVVector = record
    X, Y, Z: Single;
    constructor Create(aX: Single; aY: Single);
    procedure Assign(aX: Single; aY: Single); overload; inline;
    procedure Assign(aVector: TGVVector); overload; inline;
    procedure Clear; inline;
    procedure Add(aVector: TGVVector); inline;
    procedure Subtract(aVector: TGVVector); inline;
    procedure Multiply(aVector: TGVVector); inline;
    procedure Divide(aVector: TGVVector); inline;
    function  Magnitude: Single; inline;
    function  MagnitudeTruncate(aMaxMagitude: Single): TGVVector; inline;
    function  Distance(aVector: TGVVector): Single; inline;
    procedure Normalize; inline;
    function  Angle(aVector: TGVVector): Single; inline;
    procedure Thrust(aAngle: Single; aSpeed: Single); inline;
    function  MagnitudeSquared: Single; inline;
    function  DotProduct(aVector: TGVVector): Single; inline;
    procedure Scale(aValue: Single); inline;
    procedure DivideBy(aValue: Single); inline;
    function  Project(aVector: TGVVector): TGVVector; inline;
    procedure Negate; inline;
  end;

  { TGVRectangle }
  PGVRectangle = ^TGVRectangle;
  TGVRectangle = record
    X: Single;
    Y: Single;
    Width: Single;
    Height: Single;
    constructor Create(aX: Single; aY: Single; aWidth: Single; aHeight: Single);
    procedure Assign(aX: Single; aY: Single; aWidth: Single; aHeight: Single); inline;
    function  Intersect(aRect: TGVRectangle): Boolean; inline;
  end;

{ Routines }
function  GV_Pointi(aX: Integer; aY: Integer): TGVPointi; inline;
function  GV_Pointf(aX: Single; aY: Single): TGVPointf; inline;
function  GV_Vector(aX: Single; aY: Single): TGVVector; inline;
function  GV_Rectangle(aX: Single; aY: Single; aWidth: Single; aHeight: Single): TGVRectangle; inline;

// Random
procedure GV_Randomize; external cDllName;
function  GV_RandomRangei(aMin, aMax: Integer): Integer; external cDllName;
function  GV_RandomRangef(aMin, aMax: Single): Single; external cDllName;
function  GV_RandomBool: Boolean; external cDllName;
function  GV_GetRandomSeed: Integer; external cDllName;
procedure GV_SetRandomSeed(aValue: Integer); external cDllName;

// Angle
function  GV_AngleCos(aAngle: Integer): Single; external cDllName;
function  GV_AngleSin(aAngle: Integer): Single; external cDllName;
function  GV_AngleDifference(aSrcAngle: Single; aDestAngle: Single): Single; external cDllName;
procedure GV_AngleRotatePos(aAngle: Single; var aX: Single; var aY: Single); external cDllName;

// Clip
function  GV_ClipValuef(var aValue: Single; aMin: Single; aMax: Single; aWrap: Boolean): Single; external cDllName;
function  GV_ClipValuei(var aValue: Integer; aMin: Integer; aMax: Integer; aWrap: Boolean): Integer; external cDllName;

// Same sign
function  GV_SameSigni(aValue1: Integer; aValue2: Integer): Boolean; external cDllName;
function  GV_SameSignf(aValue1: Single; aValue2: Single): Boolean; external cDllName;

// Same value
function  GV_SameValued(aA: Double; aB: Double; aEpsilon: Double = 0): Boolean; external cDllName;
function  GV_SameValuef(aA: Single; aB: Single; aEpsilon: Single = 0): Boolean; external cDllName;

{ === COLOR ================================================================= }
type

  { TGVColor }
  PGVColor = ^TGVColor;
  TGVColor = record
    Red, Green, Blue, Alpha: Single;
  end;

{$REGION 'Common Colors'}
var
  LIGHTGRAY: TGVColor;
  GRAY: TGVColor;
  DARKGRAY: TGVColor;
  YELLOW: TGVColor;
  GOLD: TGVColor;
  ORANGE: TGVColor;
  PINK: TGVColor;
  RED: TGVColor;
  MAROON: TGVColor;
  GREEN: TGVColor;
  LIME: TGVColor;
  DARKGREEN: TGVColor;
  SKYBLUE: TGVColor;
  BLUE: TGVColor;
  DARKBLUE: TGVColor;
  PURPLE: TGVColor;
  VIOLET: TGVColor;
  DARKPURPLE: TGVColor;
  BEIGE: TGVColor;
  BROWN: TGVColor;
  DARKBROWN: TGVColor;
  WHITE: TGVColor;
  BLACK: TGVColor;
  BLANK: TGVColor;
  MEGENTA: TGVColor;
  WHITE2: TGVColor;
  RED2: TGVColor;
  COLORKEY: TGVColor;
  OVERLAY1: TGVColor;
  OVERLAY2: TGVColor;
  DIMWHITE: TGVColor;
{$ENDREGION}

{ Exports }
function  GV_MakeColor(aRed: Byte; aGreen: Byte; aBlue: Byte; aAlpha: Byte): TGVColor; external cDllName;
function  GV_MakeColorf(aRed: Single; aGreen: Single; aBlue: Single; aAlpha: Single): TGVColor; external cDllName;
function  GV_FadeColor(aTo: TGVColor; aFrom: TGVColor; aPos: Single): TGVColor; external cDllName;
function  GV_ColorEqual(aColor1: TGVColor; aColor2: TGVColor): Boolean; external cDllName;

{ === ARCHIVE =============================================================== }
type
  { TGVArchive }
  TGVArchive = type Pointer;

function  GV_OpenArchive(const aPassword: WideString; const aFilename: WideString=''): TGVArchive; external cDllName;
procedure GV_CloseArchive(var aArchive: TGVArchive); external cDllName;
function  GV_IsArchiveOpen(aArchive: TGVArchive): Boolean; external cDllName;
function  GV_ArchiveFileExist(aArchive: TGVArchive; const aFilename: WideString; var aFullPath: WideString): Boolean; external cDllName;
function  GV_OpenArchiveFile(aArchive: TGVArchive; const aFilename: WideString): WideString; external cDllName;
procedure GV_ExtractArchiveFile(aArchive: TGVArchive; const aFilename: WideString; aStream: TStream); external cDllName;
function  GV_CloseArchiveFile(aArchive: TGVArchive; const aFilename: WideString=''): Boolean; external cDllName;

{ === BITMAP ================================================================ }
type
  { TGVBitmap }
  TGVBitmap = type Pointer;

function  GV_AllocateBitmap(aWidth: Integer; aHeight: Integer): TGVBitmap; external cDllName;
function  GV_LoadBitmap(aArchive: TGVArchive; const aFilename: WideString; aColorKey: PGVColor): TGVBitmap; external cDllName;
procedure GV_FreeBitmap(var aBitmap: TGVBitmap); external cDllName;
procedure GV_GetBitmapSize(aBitmap: TGVBitmap; var aSize: TGVVector); external cDllName;
procedure GV_GetBitmapSizeEx(aBitmap: TGVBitmap; aWidth: PSingle; aHeight: PSingle); external cDllName;
procedure GV_LockBitmap(aBitmap: TGVBitmap; aRegion: PGVRectangle); external cDllName;
procedure GV_UnlockBitmap(aBitmap: TGVBitmap); external cDllName;
function  GV_GetBitmapPixel(aBitmap: TGVBitmap; aX: Integer; aY: Integer): TGVColor; external cDllName;
procedure GV_DrawBitmapEx(aBitmap: TGVBitmap; aX, aY: Single; aRegion: PGVRectangle; aCenter: PGVVector;  aScale: PGVVector; aAngle: Single; aColor: TGVColor; aHFlip: Boolean; aVFlip: Boolean); external cDllName;
procedure GV_DrawBitmap(aBitmap: TGVBitmap; aX, aY, aScale, aAngle: Single; aColor: TGVColor; aHAlign: TGVHAlign; aVAlign: TGVVAlign); external cDllName;
procedure GV_DrawBitmapTiled(aBitmap: TGVBitmap; aDeltaX: Single; aDeltaY: Single); external cDllName;

{ === VIEWPORT ============================================================== }
type
  { TGVViewport }
  TGVViewport = type Pointer;

function  GV_CreateViewport(aX: Integer; aY: Integer; aWidth: Integer; aHeight: Integer): TGVViewport; external cDllName;
procedure GV_FreeViewport(var aViewport: TGVViewport); external cDllName;
procedure GV_SetViewportActive(aViewport: TGVViewport; aActive: Boolean); external cDllName;
function  GV_GetViewportActive(aViewport: TGVViewport): Boolean; external cDllName;
procedure GV_SetViewportPosition(aViewport: TGVViewport; aX: Integer; aY: Integer); external cDllName;
procedure GV_GetViewportSize(aViewport: TGVViewport; aX: PInteger; aY: PInteger; aWidth: PInteger; aHeight: PInteger); external cDllName;
procedure GV_SetViewportAngle(aViewport: TGVViewport; aAngle: Single); external cDllName;
function  GV_GetViewportAngle(aViewport: TGVViewport): Single; external cDllName;
procedure GV_AlignViewportXY(aViewport: TGVViewport; var aX: Single; var aY: Single); external cDllName;
procedure GV_AlignViewport(aViewport: TGVViewport; var aPos: TGVVector); external cDllName;

{ === DISPLAY =============================================================== }
const
  BLEND_ZERO = 0;
  BLEND_ONE = 1;
  BLEND_ALPHA = 2;
  BLEND_INVERSE_ALPHA = 3;
  BLEND_SRC_COLOR = 4;
  BLEND_DEST_COLOR = 5;
  BLEND_INVERSE_SRC_COLOR = 6;
  BLEND_INVERSE_DEST_COLOR = 7;
  BLEND_CONST_COLOR = 8;
  BLEND_INVERSE_CONST_COLOR = 9;
  BLEND_ADD = 0;
  BLEND_SRC_MINUS_DEST = 1;
  BLEND_DEST_MINUS_SRC = 2;

type

  { TBlendMode }
  TGVBlendMode = (bmPreMultipliedAlpha, bmNonPreMultipliedAlpha, bmAdditiveAlpha,
    bmCopySrcToDest, bmMultiplySrcAndDest);

  { TBlendModeColor }
  TGVBlendModeColor = (bcColorNormal, bcColorAvgSrcDest);

function  GV_OpenDisplay(aWidth: Integer; aHeight: Integer; aFullscreen: Boolean; const aTitle: WideString): Boolean; external cDllName;
function  GV_CloseDisplay: Boolean; external cDllName;
function  GV_DisplayOpened: Boolean; external cDllName;
procedure GV_ClearDisplay(aColor: TGVColor); external cDllName;
procedure GV_ShowDisplay; external cDllName;
procedure GV_ToggleFullscreenDisplay; external cDllName;
procedure GV_ResetDisplayTransform; external cDllName;
procedure GV_SetDisplayTransformPosition(aX: Integer; aY: Integer); external cDllName;
procedure GV_SetDisplayTransformAngle(aAngle: Single); external cDllName;

procedure GV_GetDisplaySize(aWidth: PInteger; aHeight: PInteger); external cDllName;

procedure GV_SetDisplayTarget(aBitmap: TGVBitmap); external cDllName;
procedure GV_ResetDisplayTarget; external cDllName;

procedure GV_AlignDisplayToViewport(var aX: Single; var aY: Single); external cDllName;
procedure GV_SetDisplayViewport(aViewport: TGVViewport); external cDllName;
procedure GV_GetDisplayViewportSizeEx(aX: PInteger; aY: PInteger; aWidth: PInteger; aHeight: PInteger); external cDllName;
procedure GV_GetDisplayViewportSize(var aSize: TGVRectangle); external cDllName;
procedure GV_ResetDisplayViewport; external cDllName;

procedure GV_DrawLine(aX1, aY1, aX2, aY2: Single; aColor: TGVColor; aThickness: Single); external cDllName;
procedure GV_DrawRectangle(aX, aY, aWidth, aHeight, aThickness: Single; aColor: TGVColor); external cDllName;
procedure GV_DrawFilledRectangle(aX, aY, aWidth, aHeight: Single; aColor: TGVColor); external cDllName;
procedure GV_DrawCircle(aX, aY, aRadius, aThickness: Single;  aColor: TGVColor); external cDllName;
procedure GV_DrawFilledCircle(aX, aY, aRadius: Single; aColor: TGVColor); external cDllName;
procedure GV_DrawPolygon(aVertices: System.PSingle; aVertexCount: Integer; aThickness: Single; aColor: TGVColor); external cDllName;
procedure GV_DrawFilledPolygon(aVertices: System.PSingle; aVertexCount: Integer; aColor: TGVColor); external cDllName;
procedure GV_DrawTriangle(aX1, aY1, aX2, aY2, aX3, aY3, aThickness: Single; aColor: TGVColor); external cDllName;
procedure GV_DrawFilledTriangle(aX1, aY1, aX2, aY2, aX3, aY3: Single; aColor: TGVColor); external cDllName;

procedure GV_SetDisplayBlender(aOperation: Integer; aSource: Integer; aDestination: Integer); external cDllName;
procedure GV_GetDisplayBlender(aOperation: PInteger; aSource: PInteger; aDestination: PInteger); external cDllName;
procedure GV_SetDisplayBlendColor(aColor: TGVColor); external cDllName;
function  GV_GetDisplayBlendColor: TGVColor; external cDllName;
procedure GV_SetDisplayBlendMode(aMode: TGVBlendMode); external cDllName;
procedure GV_SetDisplayBlendModeColor(aMode: TGVBlendModeColor; aColor: TGVColor); external cDllName;
procedure GV_RestoreDisplayDefaultBlendMode; external cDllName;

procedure GV_SaveDisplay(const aFilename: WideString); external cDllName;

{ === INPUT ================================================================= }
const
  MAX_AXES = 3;
  MAX_STICKS = 16;
  MAX_BUTTONS = 32;

const
  MOUSE_BUTTON_LEFT = 1;
  MOUSE_BUTTON_RIGHT = 2;
  MOUSE_BUTTON_MIDDLE = 3;

{$REGION 'Keyboard Constants'}

const
  // Keyboard Constants
  KEY_A = 1;
  KEY_B = 2;
  KEY_C = 3;
  KEY_D = 4;
  KEY_E = 5;
  KEY_F = 6;
  KEY_G = 7;
  KEY_H = 8;
  KEY_I = 9;
  KEY_J = 10;
  KEY_K = 11;
  KEY_L = 12;
  KEY_M = 13;
  KEY_N = 14;
  KEY_O = 15;
  KEY_P = 16;
  KEY_Q = 17;
  KEY_R = 18;
  KEY_S = 19;
  KEY_T = 20;
  KEY_U = 21;
  KEY_V = 22;
  KEY_W = 23;
  KEY_X = 24;
  KEY_Y = 25;
  KEY_Z = 26;
  KEY_0 = 27;
  KEY_1 = 28;
  KEY_2 = 29;
  KEY_3 = 30;
  KEY_4 = 31;
  KEY_5 = 32;
  KEY_6 = 33;
  KEY_7 = 34;
  KEY_8 = 35;
  KEY_9 = 36;
  KEY_PAD_0 = 37;
  KEY_PAD_1 = 38;
  KEY_PAD_2 = 39;
  KEY_PAD_3 = 40;
  KEY_PAD_4 = 41;
  KEY_PAD_5 = 42;
  KEY_PAD_6 = 43;
  KEY_PAD_7 = 44;
  KEY_PAD_8 = 45;
  KEY_PAD_9 = 46;
  KEY_F1 = 47;
  KEY_F2 = 48;
  KEY_F3 = 49;
  KEY_F4 = 50;
  KEY_F5 = 51;
  KEY_F6 = 52;
  KEY_F7 = 53;
  KEY_F8 = 54;
  KEY_F9 = 55;
  KEY_F10 = 56;
  KEY_F11 = 57;
  KEY_F12 = 58;
  KEY_ESCAPE = 59;
  KEY_TILDE = 60;
  KEY_MINUS = 61;
  KEY_EQUALS = 62;
  KEY_BACKSPACE = 63;
  KEY_TAB = 64;
  KEY_OPENBRACE = 65;
  KEY_CLOSEBRACE = 66;
  KEY_ENTER = 67;
  KEY_SEMICOLON = 68;
  KEY_QUOTE = 69;
  KEY_BACKSLASH = 70;
  KEY_BACKSLASH2 = 71;
  KEY_COMMA = 72;
  KEY_FULLSTOP = 73;
  KEY_SLASH = 74;
  KEY_SPACE = 75;
  KEY_INSERT = 76;
  KEY_DELETE = 77;
  KEY_HOME = 78;
  KEY_END = 79;
  KEY_PGUP = 80;
  KEY_PGDN = 81;
  KEY_LEFT = 82;
  KEY_RIGHT = 83;
  KEY_UP = 84;
  KEY_DOWN = 85;
  KEY_PAD_SLASH = 86;
  KEY_PAD_ASTERISK = 87;
  KEY_PAD_MINUS = 88;
  KEY_PAD_PLUS = 89;
  KEY_PAD_DELETE = 90;
  KEY_PAD_ENTER = 91;
  KEY_PRINTSCREEN = 92;
  KEY_PAUSE = 93;
  KEY_ABNT_C1 = 94;
  KEY_YEN = 95;
  KEY_KANA = 96;
  KEY_CONVERT = 97;
  KEY_NOCONVERT = 98;
  KEY_AT = 99;
  KEY_CIRCUMFLEX = 100;
  KEY_COLON2 = 101;
  KEY_KANJI = 102;
  KEY_PAD_EQUALS = 103;
  KEY_BACKQUOTE = 104;
  KEY_SEMICOLON2 = 105;
  KEY_COMMAND = 106;
  KEY_BACK = 107;
  KEY_VOLUME_UP = 108;
  KEY_VOLUME_DOWN = 109;
  KEY_SEARCH = 110;
  KEY_DPAD_CENTER = 111;
  KEY_BUTTON_X = 112;
  KEY_BUTTON_Y = 113;
  KEY_DPAD_UP = 114;
  KEY_DPAD_DOWN = 115;
  KEY_DPAD_LEFT = 116;
  KEY_DPAD_RIGHT = 117;
  KEY_SELECT = 118;
  KEY_START = 119;
  KEY_BUTTON_L1 = 120;
  KEY_BUTTON_R1 = 121;
  KEY_BUTTON_L2 = 122;
  KEY_BUTTON_R2 = 123;
  KEY_BUTTON_A = 124;
  KEY_BUTTON_B = 125;
  KEY_THUMBL = 126;
  KEY_THUMBR = 127;
  KEY_UNKNOWN = 128;
  KEY_MODIFIERS = 215;
  KEY_LSHIFT = 215;
  KEY_RSHIFT = 216;
  KEY_LCTRL = 217;
  KEY_RCTRL = 218;
  KEY_ALT = 219;
  KEY_ALTGR = 220;
  KEY_LWIN = 221;
  KEY_RWIN = 222;
  KEY_MENU = 223;
  KEY_SCROLLLOCK = 224;
  KEY_NUMLOCK = 225;
  KEY_CAPSLOCK = 226;
  KEY_MAX = 227;
  KEYMOD_SHIFT = $0001;
  KEYMOD_CTRL = $0002;
  KEYMOD_ALT = $0004;
  KEYMOD_LWIN = $0008;
  KEYMOD_RWIN = $0010;
  KEYMOD_MENU = $0020;
  KEYMOD_COMMAND = $0040;
  KEYMOD_SCROLOCK = $0100;
  KEYMOD_NUMLOCK = $0200;
  KEYMOD_CAPSLOCK = $0400;
  KEYMOD_INALTSEQ = $0800;
  KEYMOD_ACCENT1 = $1000;
  KEYMOD_ACCENT2 = $2000;
  KEYMOD_ACCENT3 = $4000;
  KEYMOD_ACCENT4 = $8000;
{$ENDREGION}

var
  // sticks
  JOY_STICK_LS: Integer = 0;
  JOY_STICK_RS: Integer = 1;
  JOY_STICK_LT: Integer = 2;
  JOY_STICK_RT: Integer = 3;

  // axes
  JOY_AXES_X: Integer = 0;
  JOY_AXES_Y: Integer = 1;
  JOY_AXES_Z: Integer = 2;

  // buttons
  JOY_BTN_A: Integer = 0;
  JOY_BTN_B: Integer = 1;
  JOY_BTN_X: Integer = 2;
  JOY_BTN_Y: Integer = 3;
  JOY_BTN_RB: Integer = 4;
  JOY_BTN_LB: Integer = 5;
  JOY_BTN_RT: Integer = 6;
  JOY_BTN_LT: Integer = 7;
  JOY_BTN_BACK: Integer = 8;
  JOY_BTN_START: Integer = 9;
  JOY_BTN_RDPAD: Integer = 10;
  JOY_BTN_LDPAD: Integer = 11;
  JOY_BTN_DDPAD: Integer = 12;
  JOY_BTN_UDPAD: Integer = 13;

procedure GV_ClearInput; external cDllName;

function  GV_KeyboardPressed(aKey: Integer): Boolean; external cDllName;
function  GV_KeyboardReleased(aKey: Integer): Boolean; external cDllName;
function  GV_KeyboardDown(aKey: Integer): Boolean; external cDllName;
function  GV_KeyboardGetPressed: Integer; external cDllName;

function  GV_MousePressed(aButton: Integer): Boolean; external cDllName;
function  GV_MouseReleased(aButton: Integer): Boolean; external cDllName;
function  GV_MouseDown(aButton: Integer): Boolean; external cDllName;
procedure GV_MouseGetInfoEx(aX: PInteger; aY: PInteger; aWheel: PInteger); external cDllName;
procedure GV_MouseGetInfo(var aPos: TGVVector); external cDllName;
procedure GV_MouseSetPos(aX: Integer; aY: Integer); external cDllName;

function  GV_JoystickPressed(aButton: Integer): Boolean; external cDllName;
function  GV_JoystickReleased(aButton: Integer): Boolean; external cDllName;
function  GV_JoystickDown(aButton: Integer): Boolean; external cDllName;
function  GV_JoystickGetPos(aStick: Integer; aAxes: Integer): Single; external cDllName;

{ === FONT ================================================================== }
type
  { TGVDefaultFont }
  TGVDefaultFont = (dfMono, dfProp);

  { TGVFont }
  TGVFont = type Pointer;

function  GV_LoadDefaultFont(aType: TGVDefaultFont; aSize: Integer): TGVFont; external cDllName;
function  GV_LoadFont(aArchive: TGVArchive; aSize: Cardinal; const aFilename: WideString): TGVFont; external cDllName;
function  GV_LoadFontFromMem(aSize: Cardinal; aMemory: Pointer; aLength: Int64): TGVFont; external cDllName;
procedure GV_FreeFont(var aFont: TGVFont); external cDllName;
procedure GV_PrintFont(aFont: TGVFont; aX: Single; aY: Single; aColor: TGVColor; aAlign: TGVHAlign; const aMsg: WideString; const aArgs: array of const); external cDllName;
procedure GV_PrintFontY(aFont: TGVFont; aX: Single; var aY: Single; aLineSpace: Single; aColor: TGVColor; aAlign: TGVHAlign; const aMsg: WideString; const aArgs: array of const); external cDllName;
procedure GV_PrintFontAngle(aFont: TGVFont; aX: Single; aY: Single; aColor: TGVColor; aAngle: Single; const aMsg: WideString; const aArgs: array of const); external cDllName;
function  GV_GetFontWidth(aFont: TGVFont; const aMsg: WideString; const aArgs: array of const): Single; external cDllName;
function  GV_GetFontLineHeight(aFont: TGVFont): Single; external cDllName;

{ === TEXT ================================================================== }
type
  { TGVText }
  TGVText = type Pointer;

function  GV_CreateText: TGVText; external cDllName;
procedure GV_FreeText(var aText: TGVText); external cDllName;

procedure GV_ClearText(aText: TGVText); external cDllName;

procedure GV_PrintText(aText: TGVText; aFont: TGVFont; aX: Single; aY: Single; aScale: Single; aAngle: Single; aColors: array of TGVColor; const aMsg: WideString; const aArgs: array of const); external cDllName;
procedure GV_PrintTextY(aText: TGVText; aFont: TGVFont; aX: Single; var aY: Single; aLineSpace: Single; aColors: array of TGVColor; const aMsg: WideString; const aArgs: array of const); external cDllName;

procedure GV_RenderText(aText: TGVText); external cDllName;


{ === SPRITE ================================================================ }
type
  { TGVSprite }
  TGVSprite = type Pointer;

function  GV_CreateSprite: TGVSprite; external cDllName;
procedure GV_FreeSprite(var aSprite: TGVSprite); external cDllName;
procedure GV_ClearSprite(aSprite: TGVSprite); external cDllName;
function  GV_LoadSpritePage(aSprite: TGVSprite; aArchive: TGVArchive; const aFilename: WideString; aColorKey: PGVColor): Integer; external cDllName;

function  GV_AddSpriteGroup(aSprite: TGVSprite): Integer; external cDllName;
function  GV_GetSpriteGroupCount(aSprite: TGVSprite): Integer; external cDllName;

function  GV_AddSpriteImageFromRect(aSprite: TGVSprite; aPage: Integer; aGroup: Integer; aRect: TGVRectangle): Integer; external cDllName;
function  GV_AddSpriteImageFromGrid(aSprite: TGVSprite; aPage: Integer; aGroup: Integer; aGridX: Integer; aGridY: Integer; aGridWidth: Integer; aGridHeight: Integer): Integer; external cDllName;
function  GV_GetSpriteImageCount(aSprite: TGVSprite; aGroup: Integer): Integer; external cDllName;
function  GV_GetSpriteImageWidth(aSprite: TGVSprite; aNum: Integer; aGroup: Integer): Single; external cDllName;
function  GV_GetSpriteImageHeight(aSprite: TGVSprite; aNum: Integer; aGroup: Integer): Single; external cDllName;
function  GV_GetSpriteImageTexture(aSprite: TGVSprite; aNum: Integer; aGroup: Integer): TGVBitmap; external cDllName;
function  GV_GetSpriteImageRect(aSprite: TGVSprite; aNum: Integer; aGroup: Integer): TGVRectangle; external cDllName;
procedure GV_DrawSpriteImage(aSprite: TGVSprite; aNum: Integer; aGroup: Integer; aX: Single; aY: Single; aOrigin: PGVVector; aScale: PGVVector; aAngle: Single; aColor: TGVColor; aHFlip: Boolean; aVFlip: Boolean; aDrawPolyPoint: Boolean); external cDllName;

{ === ENTITY ================================================================ }
type
  { TGVEntity }
  TGVEntity = type Pointer;

function  GV_CreateEntity(aSprite: TGVSprite; aGroup: Integer): TGVEntity; external cDllName;
procedure GV_FreeEntity(var aEntity: TGVEntity); external cDllName;

procedure GV_SetEntityFrameRange(aEntity: TGVEntity; aFirst: Integer; aLast: Integer); external cDllName;
function  GV_NextEntityFrame(aEntity: TGVEntity): Boolean; external cDllName;
function  GV_PrevEntityFrame(aEntity: TGVEntity): Boolean; external cDllName;
function  GV_GetEntityFrame(aEntity: TGVEntity): Integer; external cDllName;
procedure GV_SetEntityFrame(aEntity: TGVEntity; aFrame: Integer); external cDllName;
function  GV_GetEntityFrameFPS(aEntity: TGVEntity): Single; external cDllName;
procedure GV_SetEntityFrameFPS(aEntity: TGVEntity; aFrameFPS: Single); external cDllName;
function  GV_GetEntityFirstFrame(aEntity: TGVEntity): Integer; external cDllName;
function  GV_GetEntityLastFrame(aEntity: TGVEntity): Integer; external cDllName;

procedure GV_SetEntityPosAbs(aEntity: TGVEntity; aX: Single; aY: Single); external cDllName;
procedure GV_SetEntityPosRel(aEntity: TGVEntity; aX: Single; aY: Single); external cDllName;
function  GV_GetEntityPos(aEntity: TGVEntity): TGVVector; external cDllName;
function  GV_GetEntityDir(aEntity: TGVEntity): TGVVector; external cDllName;

procedure GV_SetEntityScaleAbs(aEntity: TGVEntity; aScale: Single); external cDllName;
procedure GV_SetEntityScaleRel(aEntity: TGVEntity; aScale: Single); external cDllName;
function  GV_GetEntityAngle(aEntity: TGVEntity): Single; external cDllName;

function  GV_GetEntityAngleOffset(aEntity: TGVEntity): Single; external cDllName;
procedure GV_SetEntityAngleOffset(aEntity: TGVEntity; aAngle: Single); external cDllName;

procedure GV_RotateEntityAbs(aEntity: TGVEntity; aAngle: Single); external cDllName;
procedure GV_RotateEntityRel(aEntity: TGVEntity; aAngle: Single); external cDllName;
function  GV_RotateEntityToAngle(aEntity: TGVEntity; aAngle: Single; aSpeed: Single): Boolean; external cDllName;
function  GV_RotateEntityToPos(aEntity: TGVEntity; aX: Single; aY: Single; aSpeed: Single): Boolean; external cDllName;
function  GV_RotateEntityToPosAt(aEntity: TGVEntity; aSrcX: Single; aSrcY: Single; aDestX: Single; aDestY: Single; aSpeed: Single): Boolean; external cDllName;

procedure GV_ThrustEntity(aEntity: TGVEntity; aSpeed: Single); external cDllName;
procedure GV_ThrustEntityAngle(aEntity: TGVEntity; aAngle: Single; aSpeed: Single); external cDllName;
function  GV_ThrustEntityToPos(aEntity: TGVEntity; aThrustSpeed: Single; aRotSpeed: Single; aDestX: Single; aDestY: Single; aSlowdownDist: Single; aStopDist: Single; aStopSpeed: Single; aStopSpeedEpsilon: Single; aDeltaTime: Single): Boolean; external cDllName;

function  GV_IsEntityVisible(aEntity: TGVEntity; aVirtualX: Single; aVirtualY: Single): Boolean; external cDllName;
function  GV_IsEntityFullyVisible(aEntity: TGVEntity; aVirtualX: Single; aVirtualY: Single): Boolean; external cDllName;

function  GV_OverlapEntityXY(aEntity: TGVEntity; aX: Single; aY: Single; aRadius: Single; aShrinkFactor: Single): Boolean; external cDllName;
function  GV_OverlapEntity(aEntity1: TGVEntity; aEntity2: TGVEntity): Boolean; external cDllName;

procedure GV_RenderEntity(aEntity: TGVEntity; aVirtualX: Single; aVirtualY: Single); external cDllName;
procedure GV_RenderEntityAt(aEntity: TGVEntity; aX: Single; aY: Single); external cDllName;

function  GV_GetEntitySprite(aEntity: TGVEntity): TGVSprite; external cDllName;
function  GV_GetEntityGroup(aEntity: TGVEntity): Integer; external cDllName;
function  GV_GetEntityScale(aEntity: TGVEntity): Single; external cDllName;

function  GV_GetEntityColor(aEntity: TGVEntity): TGVColor; external cDllName;
procedure GV_SetEntityColor(aEntity: TGVEntity; aColor: TGVColor); external cDllName;

procedure GV_GetEntityFlipMode(aEntity: TGVEntity; aHFlip: PBoolean; aVFlip: PBoolean); external cDllName;
procedure GV_SetEntityFlipMode(aEntity: TGVEntity; aHFlip: PBoolean; aVFlip: PBoolean); external cDllName;

function  GV_GetEntityLoopFrame(aEntity: TGVEntity): Boolean; external cDllName;
procedure GV_SetEntityLoopFrame(aEntity: TGVEntity; aLoop: Boolean); external cDllName;

function  GV_GetEntityWidth(aEntity: TGVEntity): Single; external cDllName;
function  GV_GetEntityHeight(aEntity: TGVEntity): Single; external cDllName;
function  GV_GetEntityRadius(aEntity: TGVEntity): Single; external cDllName;

function  GV_GetEntityShrinkFactor(aEntity: TGVEntity): Single; external cDllName;
procedure GV_SetEntityShrinkFactor(aEntity: TGVEntity; aShrinkFactor: Single); external cDllName;

procedure GV_SetRenderEntityPolyPoint(aEntity: TGVEntity; aRenderPolyPoint: Boolean); external cDllName;
function  GV_GetRenderEntityPolyPoint(aEntity: TGVEntity): Boolean; external cDllName;
procedure GV_TraceEntityPolyPoint(aEntity: TGVEntity; aMju: Single=6; aMaxStepBack: Integer=12; aAlphaThreshold: Integer=70; aOrigin: PGVVector=nil); external cDllName;
function  GV_CollideEntityPolyPoint(aEntity1: TGVEntity; aEntity2: TGVEntity; var aHitPos: TGVVector): Boolean; external cDllName;
function  GV_CollideEntityPolyPointPoint(aEntity: TGVEntity; var aPoint: TGVVector): Boolean; external cDllName;

{ === ENTITYACTION ========================================================== }
type
  { TGVEntityAction }
  TGVEntityAction = type Pointer;

function  GV_CreateEntityAction: TGVEntityAction; external cDllName;
procedure GV_FreeEntityAction(var aEntityAction: TGVEntityAction); external cDllName;
procedure GV_ResetEntityAction(aEntityAction: TGVEntityAction); external cDllName;
procedure GV_StartEntiyActionBatch(aEntityAction: TGVEntityAction); external cDllName;
procedure GV_EndEntityActionBatch(aEntityAction: TGVEntityAction); external cDllName;
function  GV_UpdateEntityAction(aEntityAction: TGVEntityAction; aEntity: TGVEntity; aDeltaTime: Single): Boolean; external cDllName;
procedure GV_SetEntityActionPos(aEntityAction: TGVEntityAction; aX: Single; aY: Single); external cDllName;
procedure GV_MoveEntityAction(aEntityAction: TGVEntityAction; aDX: Single; aDY: Single; aDXA: Single; aDYA: Single; aDuration: Single); external cDllName;
procedure GV_RotateEntityActionAbs(aEntityAction: TGVEntityAction; aAngle: Single); external cDllName;
procedure GV_RotateEntityActionRel(aEntityAction: TGVEntityAction; aAngle: Single; aDuration: Single); external cDllName;
procedure GV_ThrustEntityAction(aEntityAction: TGVEntityAction; aSpeed: Single; aDuration: Single); external cDllName;
procedure GV_ScaleEntityActionAbs(aEntityAction: TGVEntityAction; aScale: Single); external cDllName;
procedure GV_ScaleEntityActionRel(aEntityAction: TGVEntityAction; aScale: Single; aDuration: Single); external cDllName;
procedure GV_RotateEntityActionToAngle(aEntityAction: TGVEntityAction; aAngle: Single; aSpeed: Single); external cDllName;
procedure GV_SaveEntityAction(aEntityAction: TGVEntityAction; const aFilename: WideString); external cDllName;
procedure GV_LoadEntityActionFromStream(aEntityAction: TGVEntityAction; aStream: TStream); external cDllName;
procedure GV_LoadEntityAction(aEntityAction: TGVEntityAction; aArchive: TGVArchive; const aFilename: WideString); external cDllName;

{ === AUDIO ================================================================= }
const
  AUDIO_BUFFER_COUNT = 256;
  AUDIO_CHANNEL_COUNT = 16;
  AUDIO_DYNAMIC_CHANNEL = -1;
  AUDIO_INVALID_INDEX = -2;

type
  { TGVAudioStatus }
  TGVAudioStatus = (asStopped, asPaused, asPlaying);

procedure GV_PauseAudio(aPause: Boolean); external cDllName;

type
  { TGVMusic }
  TGVMusic = type Pointer;

// Music
function  GV_LoadMusic(aArchive: TGVArchive; const aFilename: WideString): TGVMusic; external cDllName;
procedure GV_UnloadMusic(var aMusic: TGVMusic); external cDllName;

procedure GV_SetMusicLoop(aMusic: TGVMusic; aLoop: Boolean); external cDllName;
function  GV_GetMusicLoop(aMusic: TGVMusic): Boolean; external cDllName;

procedure GV_SetMusicVolume(aMusic: TGVMusic; aVolume: Single); external cDllName;
function  GV_GetMusicVolume(aMusic: TGVMusic): Single; external cDllName;

procedure GV_PlayMusic(aMusic: TGVMusic); external cDllName;
procedure GV_PlayMusicEx(aMusic: TGVMusic; aVolume: Single; aLoop: Boolean); external cDllName;

procedure GV_StopMusic(aMusic: TGVMusic); external cDllName;
procedure GV_PauseMusic(aMusic: TGVMusic); external cDllName;

function  GV_GetMusicStatus(aMusic: TGVMusic): TGVAudioStatus; external cDllName;
procedure GV_SetMusicOffset(aMusic: TGVMusic; aSeconds: Single); external cDllName;

// Sound
function  GV_LoadSound(aArchive: TGVArchive; const aFilename: WideString): Integer; external cDllName;
procedure GV_UnloadSound(aSound: Integer); external cDllName;

function  GV_PlaySound(aChannel: Integer; aSound: Integer): Integer; external cDllName;
function  GV_PlaySoundEx(aChannel: Integer; aSound: Integer; aVolume: Single; aLoop: Boolean): Integer; external cDllName;

procedure GV_SetSoundChanReserved(aChannel: Integer; aReserve: Boolean); external cDllName;
function  GV_GetSoundChanReserved(aChannel: Integer): Boolean; external cDllName;

procedure GV_PauseSoundChan(aChannel: Integer; aPause: Boolean); external cDllName;
procedure GV_StopSoundChan(aChannel: Integer); external cDllName;
procedure GV_StopAllSoundChans; external cDllName;

function  GV_GetSoundChanStatus(aChannel: Integer): TGVAudioStatus; external cDllName;

procedure GV_SetSoundChanVol(aChannel: Integer; aVolume: Single); external cDllName;
function  GV_GetSoundChanVol(aChannel: Integer): Single; external cDllName;

procedure GV_SetSoundChanLoop(aChannel: Integer; aLoop: Boolean); external cDllName;
function  GV_GetSoundChanLoop(aChannel: Integer): Boolean; external cDllName;

procedure GV_SetSoundChanPitch(aChannel: Integer; aPitch: Single); external cDllName;
function  GV_GetSoundChanPitch(aChannel: Integer): Single; external cDllName;

procedure GV_SetSoundChanPos(aChannel: Integer; aX: Single; aY: Single); external cDllName;
procedure GV_GetSoundChanPos(aChannel: Integer; var aX: Single; var aY: Single); external cDllName;

procedure GV_SetSoundChanMinDist(aChannel: Integer; aDistance: Single); external cDllName;
function  GV_GetSoundChanMinDist(aChannel: Integer): Single; external cDllName;

procedure GV_SetSoundChanRelToListener(aChannel: Integer; aRelative: Boolean); external cDllName;
function  GV_GetSoundChanRelToListener(aChannel: Integer): Boolean; external cDllName;

procedure GV_SetSoundChanAttenuation(aChannel: Integer; aAttenuation: Single); external cDllName;
function  GV_GetSoundChanAttenuation(aChannel: Integer): Single; external cDllName;

procedure GV_SetGlobalListenerVol(aVolume: Single); external cDllName;
function  GV_GetGlobalListenerVol: Single; external cDllName;
procedure GV_SetListenerPos(aX: Single; aY: Single); external cDllName;
procedure GV_GetListenerPos(var aX: Single; var aY: Single); external cDllName;


{ === PHYSICS =============================================================== }
type

  { TGVPhysicsShapeType }
  TGVPhysicsShapeType = (psCircle, psPolygon, psInvalid);

  { TGVPhysicsBodyType }
  TGVPhysicsBodyType = (pbStatic, pbKinematic, pbDynamic, pbInvalid);

  { TGVPhysicsBody }
  TGVPhysicsBody = type Pointer;

  { TPhysicsBodyShape }
  TGVPhysicsBodyShape = (bsCircle, bsRectangle);

  { TPhysicsBodyData }
  PGVPhysicsBodyData = ^TGVPhysicsBodyData;
  TGVPhysicsBodyData = record
    Shape: TGVPhysicsBodyShape;
    CircleRadius: Single;
    RectangleSize: TGVVector;
  end;

procedure GV_SetPhysicsGravityEx(aX: Single; aY: Single); external cDllName;
procedure GV_SetPhysicsGravity(aGravity: TGVVector); external cDllName;

function  GV_CreatePhysicsCircleBody(aType: TGVPhysicsBodyType; aPos: TGVVector; aRadius: Single; aDensity: Single = 1.0; aFriction: Single = 0.3): TGVPhysicsBody; external cDllName;
function  GV_CreatePhysicsRectangleBody(aType: TGVPhysicsBodyType; aPos: TGVVector; aWidth: Single; aHeight: Single; aDensity: Single = 1.0; aFriction: Single = 0.3): TGVPhysicsBody; external cDllName;
procedure GV_DestroyPhysicsBody(aBody: TGVPhysicsBody); external cDllName;

procedure GV_AddPhysicsForce(aBody: TGVPhysicsBody; aForce: TGVVector); external cDllName;
procedure GV_AddPhysicsTorque(aBody: TGVPhysicsBody; aAmount: Single); external cDllName;

function  GV_GetPhysicsBodyCount: Integer; external cDllName;
function  GV_GetPhysicsFirstBody: TGVPhysicsBody; external cDllName;
function  GV_GetPhysicsNextBody(aBody: TGVPhysicsBody): TGVPhysicsBody; external cDllName;

procedure GV_SetPhysicsBodyRotation(aBody: TGVPhysicsBody; aAngle: Single); external cDllName;
function  GV_GetPhysicsBodyRotation(aBody: TGVPhysicsBody): Single; external cDllName;

function  GV_GetPhysicsBodyPosition(aBody: TGVPhysicsBody): TGVVector; external cDllName;

procedure GV_DrawPhysicsBodyShapes(aDrawDebug: Boolean); external cDllName;
procedure GV_UpdatePhysicsBodies; external cDllName;
function  GV_GetPhysicsBodyType(aBody: TGVPhysicsBody): TGVPhysicsBodyType; external cDllName;
function  GV_GetPhysicsBodyData(aBody: TGVPhysicsBody): TGVPhysicsBodyData; external cDllName;

procedure GV_ClearPhysics; external cDllName;

{ === HIGHSCORES ============================================================ }

type
  { TGVHighscoreAction }
  TGVHighscoreAction = (haClear, haList, haPost);

  { TGVHighscoreRecord }
  TGVHighscoreRecord = record
    Name: WideString;
    Level: Integer;
    Score: Cardinal;
    Skill: Integer;
    Duration: Cardinal;
    Location: WideString;
  end;

{ === ASYNC ================================================================= }
procedure GV_RunAsync(aTask: TProc; aWait: TProc); external cDllName;
procedure GV_EnterAsync; external cDllName;
procedure GV_LeaveAsync; external cDllName;

{ === TELEMETRY ============================================================= }
function  GV_StartTelemetry(const aAppName: WideString; const aAppVersion: WideString; const aAppLicense: WideString; const aAppEdition: WideString; const aPropertyID: WideString; aUserGaveConsent: Boolean): Boolean; external cDllName;
procedure GV_StopTelemetry; external cDllName;
function  GV_SendTelemetryPageview(const aPagePath: WideString; const aPageTitle: WideString): Boolean; external cDllName;
function  GV_SendTelemetryEvent(const aEventAction: WideString; const aEventLabel: WideString; aEventValue: Integer): Boolean; external cDllName;
function  GV_SendTelemetryScreenView(const aScreenName: WideString): Boolean; external cDllName;
function  GV_SendTelemetryException(const aExceptionDesc: WideString; aIsFatal: Boolean): Boolean; external cDllName;

{ === NETWORK =============================================================== }
type
  { TGVNetStatus }
  TGVNetStatus = (nsResolving, nsConnecting, nsConnected,  nsDisconnecting, nsDisconnected, nsStatusText);

function  GV_HttpGet(const aUserAgent: WideString; const aUserName: WideString; const aPassword: WideString; const aHeader: WideString; const aHeaderValue: WideString; const aUrl: WideString): WideString; external cDllName;
function  GV_HttpGetResponseText: WideString; external cDllName;
function  GV_HttpGetResponseCode: Integer; external cDllName;

function  GV_SendMail(const aMailAgent: WideString; const aUserName: WideString; const aPassword: WideString; const aUserHost: WideString; const aSubject: WideString; const aTo: WideString; const aFrom: WideString; const aText: WideString; aPort: Integer): WideString; external cDllName;

function  GV_OpenNet(aPort: Integer): Boolean; external cDllName;
procedure GV_CloseNet; external cDllName;
function  GV_NetOpened: Boolean; external cDllName;

function  GV_SendNet(const aHost: WideString; aPort: Integer; aData: Pointer; aSize: Integer): Boolean; external cDllName;

function  GV_GetNetHostToWord(const aHost: WideString): Cardinal; external cDllName;
function  GV_GetNetHostToIP(const aHost: WideString): WideString; external cDllName;
function  GV_GetNetResolveIP(const aIPAddr: WideString): WideString; external cDllName;
function  GV_GetNetLocalIP: WideString; external cDllName;
function  GV_GetNetLinkDesc: WideString; external cDllName;
function  GV_GetNetBytesReceived: Integer; external cDllName;
function  GV_GetNetBytesSent: Integer; external cDllName;
function  GV_GetNetBytesPerSec: Integer; external cDllName;

function  GV_GetNetLocalPort: Integer; external cDllName;
procedure GV_SetNetLocalPort(aPort: Integer); external cDllName;

function  GV_GetNetBufferSize: Integer; external cDllName;
procedure GV_SetNetBufferSize(aSize: Integer); external cDllName;

function  GV_GetNetResendFreq: Integer; external cDllName;
procedure GV_SetNetResendFreq(aFreq: Integer); external cDllName;

function  GV_GetNetResendCount: Integer; external cDllName;
procedure GV_SetNetResendCount(aCount: Integer); external cDllName;

function  GV_GetNetLinkTimeout: Integer; external cDllName;
procedure GV_SetNetLinkTimeout(aSecs: Integer); external cDllName;

{ === DATABASE ============================================================== }
type
  { TGVDatabase }
  TGVDatabase = type Pointer;

  { TGVDatabaseTable }
  TGVDatabaseTable = type Pointer;

  { TGVRemoteDatabaseState }
  TGVRemoteDatabaseState = (dsDisconnected, dsDisconnecting, dsConnecting,
    dsConnected, dsExecSQLPending, dsExecSQLCompleted, dsGetTablePending,
    dsGetTableCompleted);

  { TRemoteDatabaseAction }
  TGVRemoteDatabaseAction = (daNone, daExecSQL, daGetTable);

  { TGVDatabaseType }
  TGVDatabaseType = (dbLocal, dbRemote);

// Database
function  GV_CreateDb(aType: TGVDatabaseType): TGVDatabase; external cDllName;
procedure GV_FreeDb(var aDatabase: TGVDatabase); external cDllName;
procedure GV_SetupDbSSL(aDatabase: TGVDatabase; aUseSSL: Boolean; aArchive: TGVArchive; const aCertPath: WideString); external cDllName;
function  GV_OpenDb(aDatabase: TGVDatabase; const aFilename: WideString): Boolean; external cDllName;
procedure GV_OpenRemoteDb(aDatabase: TGVDatabase; const aHost: WideString; aPort: Integer; const aUser: WideString; const aPassword: WideString; const aDbName: WideString; aAction: TGVRemoteDatabaseAction); external cDllName;
procedure GV_CloseDb(aDatabase: TGVDatabase); external cDllName;
function  GV_GetDbLastError(aDatabase: TGVDatabase): WideString; external cDllName;
function  GV_ExecDbSQL(aDatabase: TGVDatabase; const aSQL: WideString): Boolean; external cDllName;
function  GV_DbTableExists(aDatabase: TGVDatabase; const aTableName: WideString): Boolean; external cDllName;
function  GV_GetDbTable(aDatabase: TGVDatabase; const aSQL: WideString): TGVDatabaseTable; external cDllName;

// DatabaseTable
procedure GV_FreeDbTable(var aTable: TGVDatabaseTable); external cDllName;
function  GV_GetDbTableBof(aTable: TGVDatabaseTable): Boolean; external cDllName;
function  GV_GetDbTableEof(aTable: TGVDatabaseTable): Boolean; external cDllName;
procedure GV_GetFirstDbTableRec(aTable: TGVDatabaseTable); external cDllName;
procedure GV_GetLastDbTableRec(aTable: TGVDatabaseTable); external cDllName;
procedure GV_NextDbTableRec(aTable: TGVDatabaseTable); external cDllName;
procedure GV_GetPrevDbTableRec(aTable: TGVDatabaseTable); external cDllName;
function  GV_GetDbTableRecNum(aTable: TGVDatabaseTable): Integer; external cDllName;
function  GV_GetDbTableRecCount(aTable: TGVDatabaseTable): Integer; external cDllName;
function  GV_GetDbTableFieldCount(aTable: TGVDatabaseTable): Integer; external cDllName;
function  GV_GetDbTableRowCount(aTable: TGVDatabaseTable): Integer; external cDllName;
function  GV_GetDbTableFieldValue(aTable: TGVDatabaseTable; aIndex: Integer): WideString; external cDllName;
function  GV_GetDbTableFieldValueAsString(aTable: TGVDatabaseTable; const aName: WideString): WideString; external cDllName;
function  GV_GetDbTableFieldValueAsInteger(aTable: TGVDatabaseTable; const aName: WideString): Int64; external cDllName;
function  GV_GetDbTableFieldValueAsFloat(aTable: TGVDatabaseTable; const aName: WideString): Double; external cDllName;

{ === BEZIER ================================================================ }
type
  { TGVBezier }
  TGVBezier = type Pointer;

function  GV_CreateBezier: TGVBezier; external cDllName;
procedure GV_FreeBezier(var aBezier: TGVBezier); external cDllName;
procedure GV_AllocBezier(aBezier: TGVBezier; aMaxCurvePoints: Integer); external cDllName;

procedure GV_ClearBezier(aBezier: TGVBezier); external cDllName;

procedure GV_AddBezierRawPoint(aBezier: TGVBezier; aX: Single; aY: Single); external cDllName;
procedure GV_RemoveBezierRawPoint(aBezier: TGVBezier; aIndex: Integer); external cDllName;
procedure GV_SetBezierRawPoint(aBezier: TGVBezier; aIndex: Integer; aX: Single; aY: Single); external cDllName;
procedure GV_GetBezierRawPoint(aBezier: TGVBezier; aIndex: Integer; var aResult: TGVVector); external cDllName;
function  GV_GetBezierRawPointCount(aBezier: TGVBezier): Integer; external cDllName;

procedure GV_BuildBezierCurvePoints(aBezier: TGVBezier); external cDllName;
procedure GV_GetBezierCurvePoint(aBezier: TGVBezier; aIndex: Integer; var aResult: TGVVector); external cDllName;
function  GV_GetBezierCurvePointCount(aBezier: TGVBezier): Integer; external cDllName;

procedure GV_RenderBezier(aBezier: TGVBezier; var aRawPointColor: TGVColor; var aCurvePointColor: TGVColor); external cDllName;

{ === EASING ================================================================ }
type
  { TGVEaseType }
  TGVEaseType = (etLinearTween, etInQuad, etOutQuad, etInOutQuad, etInCubic,
    etOutCubic, etInOutCubic, etInQuart, etOutQuart, etInOutQuart, etInQuint,
    etOutQuint, etInOutQuint, etInSine, etOutSine, etInOutSine, etInExpo,
    etOutExpo, etInOutExpo, etInCircle, etOutCircle, etInOutCircle);

function GV_EaseValue(aCurrentTime: Double; aStartValue: Double; aChangeInValue: Double; aDuration: Double; aEaseType: TGVEaseType): Double; external cDllName;
function GV_EasePosition(aStartPos: Double; aEndPos: Double; aCurrentPos: Double; aEaseType: TGVEaseType): Double; external cDllName;

{ === STARFIELD ============================================================= }
type
  { TGVStarfield }
  TGVStarfield = type Pointer;

function  GV_CreateStarfield: TGVStarfield; external cDllName;
procedure GV_FreeStarfield(var aStarfield: TGVStarfield); external cDllName;
procedure GV_InitStarfield(aStarfield: TGVStarfield; aStarCount: Cardinal; aMinX, aMinY, aMinZ, aMaxX, aMaxY, aMaxZ, aViewScale: Single); external cDllName;
procedure GV_SetStarfieldVirtualPos(aStarfield: TGVStarfield; aX, aY: Single); external cDllName;
procedure GV_GetStarfieldVirtualPos(aStarfield: TGVStarfield; var aX: Single; var aY: Single); external cDllName;
procedure GV_SetStarfieldXSpeed(aStarfield: TGVStarfield; aSpeed: Single); external cDllName;
procedure GV_SetStarfieldYSpeed(aStarfield: TGVStarfield; aSpeed: Single); external cDllName;
procedure GV_SetStarfieldZSpeed(aStarfield: TGVStarfield; aSpeed: Single); external cDllName;
procedure GV_UpdateStarfield(aStarfield: TGVStarfield; aDeltaTime: Single); external cDllName;
procedure GV_RenderStarfield(aStarfield: TGVStarfield); external cDllName;

{ === COLLISION ============================================================= }
type
  { TGVLineIntersection }
  TGVLineIntersection = (liNone, liTrue, liParallel);

function GV_PointInRectangle(aPoint: TGVVector; aRect: TGVRectangle): Boolean; external cDllName;
function GV_PointInCircle(aPoint, aCenter: TGVVector; aRadius: Single): Boolean; external cDllName;
function GV_PointInTriangle(aPoint, aP1, aP2, aP3: TGVVector): Boolean; external cDllName;
function GV_CirclesOverlap(aCenter1: TGVVector; aRadius1: Single; aCenter2: TGVVector; aRadius2: Single): Boolean; external cDllName;
function GV_CircleInRectangle(aCenter: TGVVector; aRadius: Single; aRect: TGVRectangle): Boolean; external cDllName;
function GV_RectanglesOverlap(aRect1, aRect2: TGVRectangle): Boolean; external cDllName;
function GV_RectangleIntersection(aRect1, aRect2: TGVRectangle): TGVRectangle; external cDllName;
function GV_LineIntersection(aX1, aY1, aX2, aY2, aX3, aY3, aX4, aY4: Integer; var aX: Integer; var aY: Integer): TGVLineIntersection; external cDllName;
function GV_RadiusOverlap(aRadius1, aX1, aY1, aRadius2, aX2, aY2, aShrinkFactor: Single): Boolean; external cDllName;

{ === CONFIGFILE ============================================================ }
type
  { TGVConfigFile }
  TGVConfigFile = type Pointer;

function  GV_CreateConfigFile: TGVConfigFile; external cDllName;
procedure GV_FreeConfigFile(var aConfigFile: TGVConfigFile); external cDllName;
function  GV_OpenConfigFile(aConfigFile: TGVConfigFile; const aFilename: WideString=''): Boolean; external cDllName;
procedure GV_CloseConfigFile(aConfigFile: TGVConfigFile); external cDllName;
function  GV_IsConfigFileOpen(aConfigFile: TGVConfigFile): Boolean; external cDllName;
procedure GV_UpdateConfigFile(aConfigFile: TGVConfigFile); external cDllName;

function  GV_RemoveConfigFileSection(aConfigFile: TGVConfigFile; const aName: WideString): Boolean; external cDllName;

procedure GV_SetConfigFileStrValue(aConfigFile: TGVConfigFile; const aSection: WideString; const aKey: WideString; const aValue: WideString); external cDllName;
procedure GV_SetConfigFileIntValue(aConfigFile: TGVConfigFile; const aSection: WideString; const aKey: WideString; aValue: Integer); external cDllName;
procedure GV_SetConfigFileBoolValue(aConfigFile: TGVConfigFile; const aSection: WideString; const aKey: WideString; aValue: Boolean); external cDllName;

function  GV_GetConfigFileStrValue(aConfigFile: TGVConfigFile; const aSection: WideString; const aKey: WideString; const aDefaultValue: WideString): WideString; external cDllName;
function  GV_GetConfigFileIntValue(aConfigFile: TGVConfigFile; const aSection: WideString; const aKey: WideString; aDefaultValue: Integer): Integer; external cDllName;
function  GV_GetConfigFileBoolValue(aConfigFile: TGVConfigFile; const aSection: WideString; const aKey: WideString; aDefaultValue: Boolean): Boolean; external cDllName;

function  GV_RemoveConfigFileKey(aConfigFile: TGVConfigFile; const aSection: WideString; const aKey: WideString): Boolean; external cDllName;

function  GV_GetConfigFileSectionValues(aConfigFile: TGVConfigFile; const aSection: WideString): Integer; external cDllName;

function  GV_GetConfigFileSectionStrValue(aConfigFile: TGVConfigFile; aIndex: Integer; const aDefaultValue: WideString): WideString; external cDllName;
function  GV_GetConfigFileSectionIntValue(aConfigFile: TGVConfigFile; aIndex: Integer; aDefaultValue: Integer): Integer; external cDllName;
function  GV_GetConfigFileSectionBoolValue(aConfigFile: TGVConfigFile; aIndex: Integer; aDefaultValue: Boolean): Boolean; external cDllName;

{ === SYSTEM ================================================================ }
type
  { TPathType }
  TGVPathType = (ptResources = 0, ptTemp = 1, ptUserData = 2, ptUserHome = 3,
    ptUserSettings = 4, ptUserDocuments = 5);

{ Exports }
// CPU
function  GV_GetCPUCount: Integer; external cDllName;
function  GV_GetRAMSize: Integer; external cDllName;
function  GV_GetHardwareID: Integer; external cDllName;

// Path
function  GV_GetOSPath(aPath: TGVPathType): WideString; external cDllName;

// Application
procedure GV_SetAppName(const aName: WideString); external cDllName;
function  GV_GetAppName: WideString; external cDllName;

// Organization
procedure GV_SetOrgName(const aName: WideString); external cDllName;
function  GV_GetOrgName: WideString; external cDllName;

{ === IAP =================================================================== }
function  GV_GetIAPResponseApproved: Boolean; external cDllName;
function  GV_GetIAPResponseApprovalCode: WideString; external cDllName;
function  GV_GetIAPResponseAVSResult: WideString; external cDllName;
function  GV_GetIAPResponseCode: WideString; external cDllName;
function  GV_GetIAPResponseCVVResult: WideString; external cDllName;
function  GV_GetIAPResponseText: WideString; external cDllName;
function  GV_GetIAPResponseTransactionId: WideString; external cDllName;
function  GV_GetIAPResponseErrorCode: WideString; external cDllName;
function  GV_GetIAPResponseErrorText: WideString; external cDllName;
function  GV_GetIAPTransactionDesc: WideString; external cDllName;
procedure GV_IAPSale(
  // processing
  const aAPIKey           : WideString;

  // transaction
  const aTransactionAmount: WideString;
  const aTransactionDesc  : WideString;

  // credit card
  const aCardCVVData      : WideString;
        aCardExpMonth     : Integer;
        aCardExpYear      : Integer;
  const aCardNumber       : WideString;

  // customer
  const aCustomerName     : WideString;
  const aCustomerCountry  : WideString;
  const aCustomerZip      : WideString
  );  external cDllName;

procedure GV_IAPSaleEx(
  // processing
  const aAPIKey           : WideString;

  // transaction
  const aTransactionAmount: WideString;
  const aTransactionDesc  : WideString;

  // credit card
  const aCardCVVData      : WideString;
        aCardExpMonth     : Integer;
        aCardExpYear      : Integer;
  const aCardNumber       : WideString;

  // customer
  const aCustomerFirstName: WideString;
  const aCustomerLastName : WideString;
  const aCustomerAddress  : WideString;
  const aCustomerCity     : WideString;
  const aCustomerState    : WideString;
  const aCustomerZip      : WideString;
  const aCustomerCountry  : WideString;
  const aCustomerEmail    : WideString;
  const aCustomerPhone    : WideString
  );  external cDllName;

{ === PURCHASE ============================================================== }
type
  { TGVPurchase }
  TGVPurchase = type Pointer;

function  GV_CreatePurchase(aConfigFile: TGVConfigFile): TGVPurchase; external cDllName;
procedure GV_FreePurchase(var aPurchase: TGVPurchase); external cDllName;
procedure GV_AddPurchaseItem(aPurchase: TGVPurchase; const aName: WideString; const aPrice: WideString); external cDllName;
function  GV_GetPurchaseItem(aPurchase: TGVPurchase; aIndex: Integer): WideString; external cDllName;
function  GV_GetPurchaseItemBought(aPurchase: TGVPurchase; aIndex: Integer): Boolean; external cDllName;
procedure GV_SetPurchaseItemBought(aPurchase: TGVPurchase; aIndex: Integer); external cDllName;
function  GV_GetPurchaseItemCount(aPurchase: TGVPurchase): Integer; external cDllName;
procedure GV_BuyPurchaseItems(aPurchase: TGVPurchase; const aTitle: WideString); external cDllName;
procedure GV_SetPurchaseAPIKey(aPurchase: TGVPurchase; const aKey: WideString); external cDllName;
procedure GV_GetPurchaseCustomerName(aPurchase: TGVPurchase; const aName: WideString); external cDllName;
procedure GV_SetPurchaseCustomerZip(aPurchase: TGVPurchase; const aZip: WideString); external cDllName;
procedure GV_SetPurchaseCardExpMonth(aPurchase: TGVPurchase; aMonth: Integer); external cDllName;
procedure GV_SetPurchaseCardExpYear(aPurchase: TGVPurchase; aYear: Integer); external cDllName;
procedure GV_SetPurchaseCardCVVData(aPurchase: TGVPurchase; const aCVV: WideString); external cDllName;
procedure GV_SetPurchaseCardNumber(aPurchase: TGVPurchase; const aNumber: WideString); external cDllName;
procedure GV_SetPurchaseTransAmount(aPurchase: TGVPurchase; const aAmount: WideString); external cDllName;
procedure GV_SetPurchaseTransDesc(aPurchase: TGVPurchase; const aDesc: WideString); external cDllName;

{ === DIALOG ================================================================ }
type
  { TGVDialogMessage }
  TGVMessageDialog = (mdDefault = $00000000, mdError = $00000010,
    mdWarning = $00000030, mdInfo = $00000040);

  { TGVConfirmDialogResult }
  TGVConfirmDialogResult = (cdYes, cdNo, cdCancel);

procedure GV_ContactUsDialog(const aServer: WideString; aPort: Integer; const aUsername: WideString; const aPassword: WideString; const aSubject: WideString); external cDllName;
procedure GV_FeedbackDialog(const aServer: WideString; aPort: Integer; const aUsername: WideString; const aPassword: WideString; const aSubject: WideString); external cDllName;
procedure GV_MessageDialog(const aTitle: WideString; const aMsg: WideString; const aArgs: array of const; aType: TGVMessageDialog); external cDllName;
function  GV_ConfirmDialog(const aMsg: WideString; const aArgs: array of const): TGVConfirmDialogResult; external cDllName;
function  GV_OpenDirDialog(const aTitle: WideString; const aInitialDir: WideString; var aDirName: WideString): Boolean; external cDllName;
function  GV_OpenFileDialog(const aTitle: WideString; const aFilter: WideString; aFilterIndex: Integer; const aDefaultExt: WideString; const aInitialDir: WideString; var aFilename: WideString): Boolean; external cDllName;
function  GV_SaveFileDialog(const aTitle: WideString; const aFilter: WideString; aFilterIndex: Integer; const aDefaultExt: WideString; var aFilename: WideString): Boolean; external cDllName;

{ === GUI =================================================================== }
const
  GUI_THEME_DEFAULT = 0;
  GUI_THEME_WHITE   = 1;
  GUI_THEME_RED     = 2;
  GUI_THEME_BLUE    = 3;
  GUI_THEME_DARK    = 4;

  GUI_WINDOW_BORDER = 1;
  GUI_WINDOW_MOVABLE = 2;
  GUI_WINDOW_SCALABLE = 4;
  GUI_WINDOW_CLOSABLE = 8;
  GUI_WINDOW_MINIMIZABLE = 16;
  GUI_WINDOW_NO_SCROLLBAR = 32;
  GUI_WINDOW_TITLE = 64;
  GUI_WINDOW_SCROLL_AUTO_HIDE = 128;
  GUI_WINDOW_BACKGROUND = 256;
  GUI_WINDOW_SCALE_LEFT = 512;
  GUI_WINDOW_NO_INPUT = 1024;

  GUI_EDIT_FILTER_DEFAULT = 0;
  GUI_EDIT_FILTER_ASCII = 1;
  GUI_EDIT_FILTER_FLOAT = 2;
  GUI_EDIT_FILTER_DECIMAL = 3;
  GUI_EDIT_FILTER_HEX = 4;
  GUI_EDIT_FILTER_OCT = 5;
  GUI_EDIT_FILTER_BINARY = 6;

  GUI_DYNAMIC = 0;
  GUI_STATIC  = 1;

  GUI_TEXT_LEFT = 17;
  GUI_TEXT_CENTERED = 18;
  GUI_TEXT_RIGHT  = 20;

function  GV_GuiWindowBegin(const aName: WideString; const aTitle: WideString; aX: Single; aY: Single; aWidth: Single; aHeight: Single; aFlags: array of cardinal): Boolean; external cDllName;
procedure GV_GuiWindowEnd; external cDllName;

procedure GV_GuiLayoutRowStatic(aHeight: Single; aWidth: Integer; aColumns: Integer); external cDllName;
procedure GV_GuiLayoutRowDynamic(aHeight: Single; aColumns: Integer); external cDllName;
procedure GV_GuiLayoutRowBegin(aFormat: Integer; aHeight: Single; aColumns: Integer); external cDllName;
procedure GV_GuiLayoutRowPush(aValue: Single); external cDllName;
procedure GV_GuiLayoutRowEnd; external cDllName;

procedure GV_GuiButton(const aTitle: WideString); external cDllName;
function  GV_GuiOption(const aTitle: WideString; aActive: Boolean): Boolean; external cDllName;
procedure GV_GuiLabel(const aTitle: WideString; aAlign: Integer); external cDllName;
function  GV_GuiSlider(aMin: Single; aMax: Single; aStep: Single; var aValue: Single): Boolean; external cDllName;
function  GV_GuiCheckbox(const aLabel: WideString; var aActive: Boolean): Boolean; external cDllName;
function  GV_GuiCombobox(const aItems: array of WideString; aSelected: Integer; aItemHeight: Integer; aWidth: Single; aHeight: Single; var aChanged: Boolean): Integer; external cDllName;
function  GV_GuiEdit(aType: Cardinal; aFilter: Integer; var aBuffer: WideString): Integer; external cDllName;
function  GV_GuiValueInt(const aName: WideString; aValue: Integer; aMin: Integer; aMax: Integer; aStep: Integer; aIncPerPixel: Single): Integer; external cDllName;
function  GV_GuiValueFloat(const aName: WideString; aValue: Double; aMin: Double; aMax: Double; aStep: Double; aIncPerPixel: Single): Double; external cDllName;
function  GV_GuiProgress(aCurrent: Cardinal; aMax: Cardinal; aModifyable: Boolean): Cardinal; external cDllName;

procedure GV_SetGuiStyle(aTheme: Integer); external cDllName;

{ === LUA =================================================================== }
type
  { TLuaType }
  TGVLuaType = (ltNone = -1, ltNil = 0, ltBoolean = 1, ltLightUserData = 2,
    ltNumber = 3, ltString = 4, ltTable = 5, ltFunction = 6, ltUserData = 7,
    ltThread = 8);

  { TLuaTable }
  TGVLuaTable = (LuaTable);

  { TGVLuaValueType }
  TGVLuaValueType = (vtInteger, vtDouble, vtString, vtTable, vtPointer,
    vtBoolean);

  { TGVLuaValue }
  TGVLuaValue = record
    AsType: TGVLuaValueType;
    class operator Implicit(const aValue: Integer): TGVLuaValue;
    class operator Implicit(aValue: Double): TGVLuaValue;
    class operator Implicit(aValue: PChar): TGVLuaValue;
    class operator Implicit(aValue: TGVLuaTable): TGVLuaValue;
    class operator Implicit(aValue: Pointer): TGVLuaValue;
    class operator Implicit(aValue: Boolean): TGVLuaValue;

    class operator Implicit(aValue: TGVLuaValue): Integer;
    class operator Implicit(aValue: TGVLuaValue): Double;
    class operator Implicit(aValue: TGVLuaValue): PChar;
    class operator Implicit(aValue: TGVLuaValue): Pointer;
    class operator Implicit(aValue: TGVLuaValue): Boolean;

    case Integer of
      0: (AsInteger: Integer);
      1: (AsNumber: Double);
      2: (AsString: PWideChar);
      3: (AsTable: TGVLuaTable);
      4: (AsPointer: Pointer);
      5: (AsBoolean: Boolean);
  end;

  { IGVLuaContext }
  IGVLuaContext = interface
    ['{6AEC306C-45BC-4C65-A0E1-044739DED1EB}']
    function  ArgCount: Integer;
    function  PushCount: Integer;
    procedure ClearStack;
    procedure PopStack(aCount: Integer);
    function  GetStackType(aIndex: Integer): TGVLuaType;
    function  GetValue(aType: TGVLuaValueType; aIndex: Integer): TGVLuaValue;
    procedure PushValue(aValue: TGVLuaValue);
    procedure SetTableFieldValue(const aName: WideString; aValue: TGVLuaValue; aIndex: Integer); overload;
    function  GetTableFieldValue(const aName: WideString; aType: TGVLuaValueType; aIndex: Integer): TGVLuaValue; overload;
    procedure SetTableIndexValue(const aName: WideString; aValue: TGVLuaValue; aIndex: Integer; aKey: Integer);
    function  GetTableIndexValue(const aName: WideString; aType: TGVLuaValueType; aIndex: Integer; aKey: Integer): TGVLuaValue;
  end;

  { TGVLuaFunction }
  TGVLuaFunction = procedure(aLua: IGVLuaContext) of object;

  { IGVLua }
  IGVLua = interface
    ['{671FAB20-00F2-4C81-96A6-6F675A37D00B}']
    procedure Reset;
    procedure LoadStream(aStream: TStream; aSize: NativeUInt = 0; aAutoRun: Boolean = True);
    procedure LoadFile(const aFilename: WideString; aAutoRun: Boolean = True);
    procedure LoadString(const aData: WideString; aAutoRun: Boolean = True);
    procedure LoadBuffer(aData: Pointer; aSize: NativeUInt; aAutoRun: Boolean = True);
    procedure Run;
    function  RoutineExist(const aName: WideString): Boolean;
    function  Call(const aName: WideString; const aParams: array of TGVLuaValue): TGVLuaValue;
    function  VariableExist(const aName: WideString): Boolean;
    procedure SetVariable(const aName: WideString; aValue: TGVLuaValue);
    function  GetVariable(const aName: WideString; aType: TGVLuaValueType): TGVLuaValue;
    procedure RegisterRoutine(const aName: WideString; aData: Pointer; aCode: Pointer); overload;
    procedure RegisterRoutine(const aName: WideString; aRoutine: TGVLuaFunction); overload;
    procedure RegisterRoutines(aClass: TClass); overload;
    procedure RegisterRoutines(aObject: TObject); overload;
    procedure RegisterRoutines(const aTables: WideString; aClass: TClass; const aTableName: WideString = ''); overload;
    procedure RegisterRoutines(const aTables: WideString; aObject: TObject; const aTableName: WideString = ''); overload;
    procedure AddVerInfo(aValue: Boolean);
    procedure SetNoConsole(aValue: Boolean);
    procedure SetVerInfo(const aCompanyName: WideString; const aFileVersion: WideString;
      const aFileDescription: WideString; const aInternalName: WideString; const aLegalCopyright: WideString;
      const aLegalTrademarks: WideString; const aOriginalFilename: WideString; const aProductName: WideString;
      const aProductVersion: WideString; const aComments: WideString);
    procedure SetExeFilename(const aFilename: WideString);
    procedure SetIconFilename(const aFilename: WideString);
    procedure EnableRuntimeThemes(aValue: Boolean);
    procedure EnableHighDPIAware(aValue: Boolean);
    procedure Compile(const aSourceFilename: WideString; const aPayloadFilename: WideString);
    function  HasPayload: Boolean;
    procedure RunPayload;
  end;

function  GV_GetLua: IGVLua; external cDllName;

{ === TREEMENU ============================================================== }
const
  TREEMENU_NONE = -1;
  TREEMENU_QUIT = -2;

type
  { TGVTreeMenu }
  TGVTreeMenu = type Pointer;

function  GV_CreateTreeMenu: TGVTreeMenu; external cDllName;
procedure GV_FreeTreeMenu(var aTreeMenu: TGVTreeMenu); external cDllName;
procedure GV_SetTreeMenuTitle(aTreeMenu: TGVTreeMenu; const aTitle: WideString); external cDllName;
procedure GV_SetTreeMenuStatus(aTreeMenu: TGVTreeMenu; const aTitle: WideString); external cDllName;
procedure GV_SetTreeMenuIcon(aTreeMenu: TGVTreeMenu; aArchive: TGVArchive; const aFilename: WideString); external cDllName;
procedure GV_ClearTreeMenu(aTreeMenu: TGVTreeMenu); external cDllName;
function  GV_GetFirstTreeMenuItem(aTreeMenu: TGVTreeMenu; aParent: Integer): Integer; external cDllName;
function  GV_AddTreeMenuItem(aTreeMenu: TGVTreeMenu; aParent: Integer; aName: WideString; aId: Integer; aEnabled: Boolean): Integer; external cDllName;
function  GV_InsertTreeMenuItem(aTreeMenu: TGVTreeMenu; aSibling: Integer; const aName: WideString; aId: Integer; aEnabled: Boolean): Integer; external cDllName;
procedure GV_SortTreeMenu(aTreeMenu: TGVTreeMenu; aParent: Integer); external cDllName;
procedure GV_SelTreeMenuItem(aTreeMenu: TGVTreeMenu; aId: Integer); external cDllName;
procedure GV_BoldTreeMenuItemId(aTreeMenu: TGVTreeMenu; aId: Integer; aValue: Boolean); external cDllName;
procedure GV_BoldTreeMenuItem(aTreeMenu: TGVTreeMenu; const aItem: WideString; aValue: Boolean); external cDllName;
function  GV_ShowTreeMenu(aTreeMenu: TGVTreeMenu; aId: Integer): Integer; external cDllName;
function  GV_GetTreeMenuCount(aTreeMenu: TGVTreeMenu): Integer; external cDllName;
function  GV_GetTreeMenuLastSelectedId(aTreeMenu: TGVTreeMenu): Integer; external cDllName;
function  GV_GetTreeMenuSelectableCount(aTreeMenu: TGVTreeMenu): Integer; external cDllName;

{ === SCREENSHAKE =========================================================== }
procedure GV_StartScreenshake(aDuration: Single; aMagnitude: Single); external cDllName;
procedure GV_ClearScreenshake; external cDllName;
function  GV_ScreenshakeActive: Boolean; external cDllName;

{ === SCREENSHOT ============================================================ }
procedure GV_InitScreenshot(const aDir: WideString; const aBaseFilename: WideString); external cDllName;
procedure GV_TakeScreenshot; external cDllName;

{ === SPEECH ================================================================ }
type

  { TGVSpeechVoiceAttribute }
  TGVSpeechVoiceAttribute = (vaDescription, vaName, vaVendor, vaAge, vaGender,
    vaLanguage, vaId);

function  GV_GetSpeechVoiceCount: Integer; external cDllName;
function  GV_GetSpeechVoiceAttribute(aIndex: Integer; aAttribute: TGVSpeechVoiceAttribute): WideString; external cDllName;
procedure GV_ChangeSpeechVoice(aIndex: Integer); external cDllName;

procedure GV_SetSpeechVolume(aVolume: Single); external cDllName;
function  GV_GetSpeechVolume: Single; external cDllName;

procedure GV_SetSpeechRate(aRate: Single); external cDllName;
function  GV_GetSpeechRate: Single; external cDllName;

procedure GV_ClearSpeech; external cDllName;
procedure GV_Speak(const aText: WideString; aPurge: Boolean); external cDllName;
procedure GV_SpeakXML(const aText: WideString; aPurge: Boolean); external cDllName;

function  GV_SpeechActive: Boolean; external cDllName;
procedure GV_PauseSpeech; external cDllName;
procedure GV_ResumeSpeech; external cDllName;
procedure GV_ResetSpeech; external cDllName;

{ === PATHEDITOR ============================================================ }
procedure GV_SetPathEditorInfo(aWidth: Integer; aHeight: Integer; aMargin: Integer); external cDllName;
procedure GV_GetPathEditorInfo(aWidth: PInteger; aHeight: PInteger; aMargin: PInteger); external cDllName;
function  GV_GetPathEditorPathCount: Integer; external cDllName;
function  GV_GetPathEditorPointCount(aPathIndex: Integer): Integer; external cDllName;
procedure GV_ClearPathEditor; external cDllName;
procedure GV_ResetPathEditor; external cDllName;
function  GV_AddPathEditorPath: Integer; external cDllName;
function  GV_RemovePathEditorPath(aPathIndex: Integer): Integer; external cDllName;
procedure GV_ClearPathEditorPath(aPathIndex: Integer); external cDllName;
function  GV_AddPathEditorPoint(aPathIndex: Integer; aPoint: TGVPointi): Integer; external cDllName;
function  GV_GetPathEditorPoint(aPathIndex: Integer; aPointIndex: Integer): TGVPointi; external cDllName;
procedure GV_SavePathEditor(aFilename: WideString); external cDllName;
function  GV_LoadPathEditor(aArchive: TGVArchive; aFilename: WideString): Boolean; external cDllName;
procedure GV_ShowPathEditor; external cDllName;
procedure GV_SetPathEditorIcon(aArchive: TGVArchive; aFilename: WideString); external cDllName;

{ === PATH ================================================================== }
type
  { TGVPath }
  TGVPath = type Pointer;

function  GV_CreatePath(aPathIndex: Integer; aLoopNum: Integer): TGVPath; external cDllName;
procedure GV_FreePath(var aPath: TGVPath); external cDllName;
function  GV_UpdatePath(aPath: TGVPath; aLookAhead: Integer; aSpeed: Single; var aX: Single; var aY: Single; var aAngle: Single): Boolean; external cDllName;
procedure GV_GetPathPos(aPath: TGVPath; aIndex: Integer; var aX: Single; var aY: Single); external cDllName;
procedure GV_ResetPath(aPath: TGVPath); external cDllName;
procedure GV_GetPathLookAheadPos(aPath: TGVPath; aLookAhead: Integer; var aX: Single; var aY: Single); external cDllName;

{ === STARTUPDIALOG ========================================================= }
type
  { TGVStartupDialogState }
  TGVStartupDialogState = (sdsMore = 0, sdsRun = 1, sdsQuit = 2);

procedure GV_SetStartupDialogCaption(const aCaption: WideString); external cDllName;
procedure GV_SetStartupDialogIcon(aArchive: TGVArchive; const aFilename: WideString); external cDllName;
procedure GV_SetStartupDialogLogo(aArchive: TGVArchive; const aFilename: WideString); external cDllName;
procedure GV_SetStartupDialogLogoClickUrl(const aURL: WideString); external cDllName;
procedure GV_SetStartupDialogReadme(aArchive: TGVArchive; const aFilename: WideString); external cDllName;
procedure GV_SetStartupDialogReadmeText(const aText: WideString); external cDllName;
procedure GV_SetStartupDialogLicense(aArchive: TGVArchive; const aFilename: WideString); external cDllName;
procedure GV_SetStartupDialogLicenseText(const aText: WideString); external cDllName;
procedure GV_SetStartupDialogReleaseInfo(const aReleaseInfo: WideString); external cDllName;
procedure GV_SetStartupDialogWordWrap(aWrap: Boolean); external cDllName;
function  GV_ShowStartupDialog: TGVStartupDialogState; external cDllName;
procedure GV_HideStartupDialog; external cDllName;

{ === VIDEO ================================================================= }
type
  { TGVVideo }
  TGVVideo = type Pointer;

function  GV_LoadVideo(aArchive: TGVArchive; const aFilename: WideString): TGVVideo; external cDllName;
procedure GV_FreeVideo(var aVideo: TGVVideo); external cDllName;
procedure GV_PlayVideo(aVideo: TGVVideo; aLoop: Boolean; aGain: Single); external cDllName;
procedure GV_SetPlaying(aVideo: TGVVideo; aPlaying: Boolean); external cDllName;
function  GV_GetPlaying(aVideo: TGVVideo): Boolean; external cDllName;
procedure GV_SetVideoLoop(aVideo: TGVVideo; aLoop: Boolean); external cDllName;
function  GV_GetVideoLoop(aVideo: TGVVideo): Boolean; external cDllName;
procedure GV_DrawVideo(aVideo: TGVVideo; aX: Single; aY: Single); external cDllName;
procedure GV_GetVideoSize(aVideo: TGVVideo; aWidth: PSingle; aHeight: PSingle); external cDllName;
procedure GV_SeekVideo(aVideo: TGVVideo; aPos: Single); external cDllName;
procedure GV_RewindVideo(aVideo: TGVVideo); external cDllName;

{ === POLYGON =============================================================== }
type
  { TGVPolygon }
  TGVPolygon = type Pointer;

function  GV_CreatePolygon: TGVPolygon; external cDllName;
procedure GV_FreePolygon(var aPolygon: TGVPolygon); external cDllName;
procedure GV_SavePolygon(aPolygon: TGVPolygon; const aFilename: WideString); external cDllName;
procedure GV_LoadPolygon(aPolygon: TGVPolygon; aArchive: TGVArchive; const aFilename: WideString); external cDllName;
procedure GV_CopyPolygonFrom(aPolygon: TGVPolygon; aFrom: TGVPolygon); external cDllName;
procedure GV_AddLocalPolygonPoint(aPolygon: TGVPolygon; aX: Single; aY: Single; aVisible: Boolean); external cDllName;
function  GV_TransformPolygon(aPolygon: TGVPolygon; aX: Single; aY: Single; aScale: Single; aAngle: Single; aOrigin: PGVVector; aHFlip: Boolean; aVFlip: Boolean): Boolean; external cDllName;
procedure GV_RenderPolygon(aPolygon: TGVPolygon; aX: Single; aY: Single; aScale: Single; aAngle: Single; aThickness: Integer; aColor: TGVColor; aOrigin: PGVVector; aHFlip: Boolean; aVFlip: Boolean); external cDllName;
procedure GV_SetPolygonSegmentVisible(aPolygon: TGVPolygon; aIndex: Integer; aVisible: Boolean); external cDllName;
function  GV_GetPolygonSegmentVisible(aPolygon: TGVPolygon; aIndex: Integer): Boolean; external cDllName;
function  GV_GetPolygonPointCount(aPolygon: TGVPolygon): Integer; external cDllName;
function  GV_GetPolygonWorldPoint(aPolygon: TGVPolygon; aIndex: Integer): PGVVector; external cDllName;
function  GV_GetLocalPolygonPoint(aPolygon: TGVPolygon; aIndex: Integer): PGVVector; external cDllName;

{ === BASE ================================================================== }
type
  { TGVBaseObject }
  TGVBaseObject = class
  public
    constructor Create; virtual;
    destructor Destroy; override;
  end;

{ === ACTOR ================================================================= }
type

  // Class Forwards
  TGVActorList = class;
  TGVAIStateMachine = class;

  { TGVActorAttributeSet }
  TGVActorAttributeSet = set of Byte;

  { TGVActorMessage }
  PGVActorMessage = ^TGVActorMessage;
  TGVActorMessage = record
    Id: Integer;
    Data: Pointer;
    DataSize: Cardinal;
  end;

  { TGVActor }
  TGVActor = class(TGVBaseObject)
  protected
    FOwner: TGVActor;
    FPrev: TGVActor;
    FNext: TGVActor;
    FAttributes: TGVActorAttributeSet;
    FTerminated: Boolean;
    FActorList: TGVActorList;
    FCanCollide: Boolean;
    FChildren: TGVActorList;
    function GetAttribute(aIndex: Byte): Boolean;
    procedure SetAttribute(aIndex: Byte; aValue: Boolean);
    function GetAttributes: TGVActorAttributeSet;
    procedure SetAttributes(aValue: TGVActorAttributeSet);
  public
    property Owner: TGVActor read FOwner write FOwner;
    property Prev: TGVActor read FPrev write FPrev;
    property Next: TGVActor read FNext write FNext;
    property Attribute[aIndex: Byte]: Boolean read GetAttribute write SetAttribute;
    property Attributes: TGVActorAttributeSet read GetAttributes  write SetAttributes;
    property Terminated: Boolean read FTerminated write FTerminated;
    property Children: TGVActorList read FChildren write FChildren;
    property ActorList: TGVActorList read FActorList write FActorList;
    property CanCollide: Boolean read FCanCollide write FCanCollide;
    procedure OnVisit(aSender: TGVActor; aEventId: Integer; var aDone: Boolean); virtual;
    procedure OnUpdate(aDeltaTime: Single); virtual;
    procedure OnRender; virtual;
    function OnMessage(aMsg: PGVActorMessage): TGVActor; virtual;
    procedure OnCollide(aActor: TGVActor; aHitPos: TGVVector); virtual;
    constructor Create; override;
    destructor Destroy; override;
    function AttributesAreSet(aAttrs: TGVActorAttributeSet): Boolean;
    function Collide(aActor: TGVActor; var aHitPos: TGVVector): Boolean; virtual;
    function Overlap(aX, aY, aRadius, aShrinkFactor: Single): Boolean; overload; virtual;
    function Overlap(aActor: TGVActor): Boolean; overload; virtual;
  end;

  { TGVActorList }
  TGVActorList = class(TGVBaseObject)
  protected
    FHead: TGVActor;
    FTail: TGVActor;
    FCount: Integer;
  public
    property Count: Integer read FCount;
    constructor Create; override;
    destructor Destroy; override;
    procedure Clean;
    procedure Add(aActor: TGVActor);
    procedure Remove(aActor: TGVActor; aDispose: Boolean);
    procedure Clear(aAttrs: TGVActorAttributeSet);
    procedure ForEach(aSender: TGVActor; aAttrs: TGVActorAttributeSet; aEventId: Integer; var aDone: Boolean);
    procedure Update(aAttrs: TGVActorAttributeSet; aDeltaTime: Single);
    procedure Render(aAttrs: TGVActorAttributeSet);
    function SendMessage(aAttrs: TGVActorAttributeSet; aMsg: PGVActorMessage; aBroadcast: Boolean): TGVActor;
    procedure CheckCollision(aAttrs: TGVActorAttributeSet; aActor: TGVActor);
  end;

  { TGVAIState }
  TGVAIState = class(TGVBaseObject)
  protected
    FOwner: TObject;
    FChildren: TGVActorList;
    FStateMachine: TGVAIStateMachine;
  public
    property Owner: TObject read FOwner write FOwner;
    property Children: TGVActorList read FChildren;
    property StateMachine: TGVAIStateMachine read FStateMachine write FStateMachine;
    constructor Create; override;
    destructor Destroy; override;
    procedure OnEnter; virtual;
    procedure OnExit; virtual;
    procedure OnUpdate(aDeltaTime: Single); virtual;
    procedure OnRender; virtual;
  end;

  { TGVAIStateMachine }
  TGVAIStateMachine = class(TGVBaseObject)
  protected
    FOwner: TGVActor;
    FCurrentState: TGVAIState;
    FGlobalState: TGVAIState;
    FPreviousState: TGVAIState;
    FStateList: TObjectList;
    FStateIndex: Integer;
    procedure ChangeStateObj(aValue: TGVAIState);
    procedure SetCurrentStateObj(aValue: TGVAIState);
    procedure RemoveStateObj(aState: TGVAIState);
    procedure SetGlobalStateObj(aValue: TGVAIState);
    procedure SetPreviousStateObj(aValue: TGVAIState);
    function GetStateCount: Integer;
    function GetStateIndex: Integer;
    function GetStates(aIndex: Integer): TGVAIState;
    function GetCurrentState: Integer;
    procedure SetCurrentState(aIndex: Integer);
    function GetGlobalState: Integer;
    procedure SetGlobalState(aIndex: Integer);
    function GetPreviousState: Integer;
    procedure SetPreviousState(aIndex: Integer);
  public
    property Owner: TGVActor read FOwner write FOwner;
    property StateCount: Integer read GetStateCount;
    property StateIndex: Integer read GetStateIndex;
    property States[aIndex: Integer]: TGVAIState read GetStates;
    property CurrentState: Integer read GetCurrentState write SetCurrentState;
    property GlobalState: Integer read GetGlobalState write SetGlobalState;
    property PreviousState: Integer read GetPreviousState write SetPreviousState;
    constructor Create; override;
    destructor Destroy; override;
    procedure Update(aDeltaTime: Single);
    procedure Render;
    procedure RevertToPreviousState;
    procedure ClearStates;
    function AddState(aState: TGVAIState): Integer;
    procedure RemoveState(aIndex: Integer);
    procedure ChangeState(aIndex: Integer);
    function PrevState(aWrap: Boolean): Integer;
    function NextState(aWrap: Boolean): Integer;
  end;

  { TGVAIActor }
  TGVAIActor = class(TGVActor)
  protected
    FStateMachine: TGVAIStateMachine;
  public
    property StateMachine: TGVAIStateMachine read FStateMachine write FStateMachine;
    constructor Create; override;
    destructor Destroy; override;
    procedure OnUpdate(aDeltaTime: Single); override;
    procedure OnRender; override;
  end;

  { TGVActorSceneEvent }
  TGVActorSceneEvent = procedure(aSceneNum: Integer) of object;

  { TGVActorScene }
  TGVActorScene = class(TGVBaseObject)
  protected
    FLists: array of TGVActorList;
    FCount: Integer;
    function GetList(aIndex: Integer): TGVActorList;
    function GetCount: Integer;
  public
    property Lists[aIndex: Integer]: TGVActorList read GetList; default;
    property Count: Integer read GetCount;
    constructor Create; override;
    destructor Destroy; override;
    procedure Alloc(aNum: Integer);
    procedure Dealloc;
    procedure Clean(aIndex: Integer);
    procedure Clear(aIndex: Integer; aAttrs: TGVActorAttributeSet);
    procedure ClearAll;
    procedure Update(aAttrs: TGVActorAttributeSet; aDeltaTime: Single);
    procedure Render(aAttrs: TGVActorAttributeSet; aBefore: TGVActorSceneEvent; aAfter: TGVActorSceneEvent);
    function SendMessage(aAttrs: TGVActorAttributeSet; aMsg: PGVActorMessage; aBroadcast: Boolean): TGVActor;
  end;

  { TGVEntityActor }
  TGVEntityActor = class(TGVActor)
  protected
    FEntity: TGVEntity;
  public
    property Entity: TGVEntity read FEntity write FEntity;
    constructor Create; override;
    destructor Destroy; override;
    procedure Init(aSprite: TGVSprite; aGroup: Integer); virtual;
    function Collide(aActor: TGVActor; var aHitPos: TGVVector): Boolean; override;
    function Overlap(aX, aY, aRadius, aShrinkFactor: Single): Boolean; override;
    function Overlap(aActor: TGVActor): Boolean; override;
    procedure OnRender; override;
  end;

  { TGVAIEntityActor }
  TGVAIEntityActor = class(TGVEntityActor)
  protected
    FStateMachine: TGVAIStateMachine;
  public
    property StateMachine: TGVAIStateMachine read FStateMachine;
    constructor Create; override;
    destructor Destroy; override;
    procedure OnUpdate(aDeltaTime: Single); override;
    procedure OnRender; override;
  end;

{ === GAME ================================================================== }
type

  { TGVCustomGame }
  TGVCustomGame = class(TGVBaseObject)
  public
    constructor Create; override;
    destructor Destroy; override;
    function  Run: Boolean; virtual;
    procedure OnLoad; virtual;
    procedure OnExit; virtual;
    procedure OnStartup; virtual;
    procedure OnShutdown; virtual;
    function  OnStartupDialogShow: Boolean; virtual;
    procedure OnStartupDialogMore; virtual;
    function  OnStartupDialogRun: Boolean; virtual;
    procedure OnProcessIMGUI; virtual;
    procedure OnUpdate(aDeltaTime: Double); virtual;
    procedure OnDisplayOpenBefore; virtual;
    procedure OnDisplayOpenAfter; virtual;
    procedure OnDisplayCloseBefore; virtual;
    procedure OnDisplayCloseAfter; virtual;
    procedure OnDisplayReady(aReady: Boolean); virtual;
    procedure OnDisplayClear; virtual;
    procedure OnRender; virtual;
    procedure OnRenderGUI; virtual;
    procedure OnDisplayShow; virtual;
    procedure OnSpeechWord(const aWord: WideString; const aText: WideString); virtual;
    procedure OnHighscoreAction(aAction: TGVHighscoreAction); virtual;
    procedure OnPathEditorLoad; virtual;
    procedure OnPathEditorSave; virtual;
    procedure OnPathEditorTest(aPathIndex: Integer; aLookAHead: Integer; aSpeed: Single; aWindowPos: TGVPointi); virtual;
    procedure OnPhysicsDrawBodyShapes(aBody: TGVPhysicsBody); virtual;
    procedure OnPhysicsUpdateBody(aBody: TGVPhysicsBody); virtual;
    procedure OnTwitterStatus(const aMsg: WideString; const aFilename: WideString); virtual;
    procedure OnBeforeRenderScene(aSceneNum: Integer); virtual;
    procedure OnAfterRenderScene(aSceneNum: Integer); virtual;
    procedure OnNetReceive(const aHost: WideString; aPort: Integer; aData: Pointer; aSize: Integer); virtual;
    procedure OnNetStatus(const aStatus: TGVNetStatus; const aStatusText: WideString); virtual;
    procedure OnRemoteDatabase(aDatabase: TGVDatabase; aState: TGVRemoteDatabaseState; aAction: TGVRemoteDatabaseAction); virtual;
    procedure OnIAPStatus; virtual;
    procedure OnPurchaseContactUs; virtual;
    procedure OnPurchaseStatus(aApproved: Boolean; aMsg: WideString); virtual;
    procedure OnLuaReset; virtual;
  end;

  { TGVBaseGameClass }
  TGVCustomGameClass = class of TGVCustomGame;

  { TGVGameParams }
  TGVGameParams = record
    ConfigFilename: string;
    ArchivePassword: string;
    ArchiveFilename: string;
    DisplayWidth: Integer;
    DisplayHeight: Integer;
    DisplayFullscreen: Boolean;
    DisplayTitle: string;
    DisplayClearColor: TGVColor;
    MonoFontSize: Integer;
    VariableFontSize: Integer;
    SceneCount: Integer;
  end;

  { TGVGame }
  TGVGame = class(TGVCustomGame)
  protected
    FConfigFile: TGVConfigFile;
    FConfigFilename: string;
    FArchive: TGVArchive;
    FArchivePassword: string;
    FArchiveFilename: string;
    FDisplayWidth: Integer;
    FDisplayHeight: Integer;
    FDisplayFullscreen: Boolean;
    FDisplayTitle: string;
    FMonoFont: TGVFont;
    FMonoFontSize: Integer;
    FVariableFont: TGVFont;
    FVariableFontSize: Integer;
    FScene: TGVActorScene;
    FSceneCount: Integer;
    FStarfield: TGVStarfield;
    FSprite: TGVSprite;
    procedure InitDefaultParams(var aParams: TGVGameParams);
    procedure SetParams(var aParams: TGVGameParams);
  public
    HudPos: TGVVector;
    MousePos: TGVVector;
    DisplayClearColor: TGVColor;
    property ConfigFile: TGVConfigFile read FConfigFile;
    property ConfigFilename: string read FConfigFilename write FConfigFilename;
    property Archive: TGVArchive read FArchive;
    property ArchivePassword: string read FArchivePassword write FArchivePassword;
    property ArchiveFilename: string read FArchiveFilename write FArchiveFilename;
    property DisplayWidth: Integer read FDisplayWidth write FDisplayWidth;
    property DisplayHeight: Integer read FDisplayHeight write FDisplayHeight;
    property DisplayFullscreen: Boolean read FDisplayFullscreen write FDisplayFullscreen;
    property DisplayTitle: string read FDisplayTitle write FDisplayTitle;
    property MonoFont: TGVFont read FMonoFont;
    property MonoFontSize: Integer read FMonoFontSize write FMonoFontSize;
    property VariableFont: TGVFont read FVariableFont;
    property VariableFontSize: Integer read FVariableFontSize write FVariableFontSize;
    property Scene: TGVActorScene read FScene;
    property SceneCount: Integer read FSceneCount write FSceneCount;
    property Starfield: TGVStarfield read FStarfield;
    property Sprite: TGVSprite read FSprite;

    constructor Create; override;
    destructor Destroy; override;
    procedure OnInitParams(var aParams: TGVGameParams); virtual;
    procedure OnLoad; override;
    procedure OnExit; override;
    procedure OnStartup; override;
    procedure OnShutdown; override;
    procedure OnStartupDialogMore; override;
    procedure OnUpdate(aDeltaTime: Double); override;
    procedure OnRender; override;
    procedure OnRenderGUI; override;
    procedure OnDisplayClear; override;
    procedure OnDisplayShow; override;
  end;

procedure GV_RunGame(aGame: TGVCustomGameClass);

{ === CORE ================================================================== }
type
  { TGVLogType }
  TGVLogType = (ltTrace, ltDebug, ltInfo, ltWarning, ltError, ltFatal);

procedure GV_SetTerminate(aTerminate: Boolean);  external cDllName;
function  GV_GetTerminate: Boolean;  external cDllName;

function  GV_GetHandle: THandle; external cDllName;
function  GV_GetVersion: WideString; external cDllName;

procedure GV_ResetTiming; external cDllName;
procedure GV_UpdateTiming; external cDllName;

procedure GV_SetUpdateSpeed(aSpeed: Single); external cDllName;
function  GV_GetUpdateSpeed: Single; external cDllName;

function  GV_GetDeltaTime: Double; external cDllName;
function  GV_GetFrameRate: Cardinal; external cDllName;

function  GV_FrameSpeed(var aTimer: Single; aSpeed: Single): Boolean; external cDllName;
function  GV_FrameElapsed(var aTimer: Single; aFrames: Single): Boolean; external cDllName;

procedure GV_Log(aType: TGVLogType; const aMsg: WideString; const aArgs: array of const; aOutputToConsole: Boolean=false); external cDllName;

function  GV_ConsoleExist: Boolean; external cDllName;
procedure GV_ConsoleWrite(const aMsg: WideString; const aArgs: array of const); external cDllName;
procedure GV_ConsoleWriteLn(const aMsg: WideString; const aArgs: array of const); external cDllName;

function  GV_AllocVirtualMem(aSize: Cardinal): Pointer; external cDllName;
function  GV_FreeVirtualMem(aData: Pointer): Boolean; external cDllName;
function  GV_CreateVirtualDir(const aDirName: WideString): Boolean; external cDllName;
function  GV_VirtualFileExist(const aFilename: WideString): Boolean; external cDllName;
function  GV_DelVirtualFile(const aFilename: WideString): Boolean; external cDllName;

procedure GV_ClearData; external cDllName;
procedure GV_LoadData(aArchive: TGVArchive; const aPassword: WideString; const aFilename: WideString); external cDllName;
procedure GV_SaveData(const aPassword: WideString; const aFilename: WideString); external cDllName;
procedure GV_SetData(const aKey: WideString; const aValue: WideString); external cDllName;
function  GV_GetData(const aKey: WideString): WideString; external cDllName;

procedure GV_Run(aGame: TGVCustomGame); external cDllName;

implementation

uses
  System.Types;

{ === MATH ================================================================== }
function GV_Pointi(aX: Integer; aY: Integer): TGVPointi;
begin
  Result.X := aX;
  Result.Y := aY;
end;

function GV_Pointf(aX: Single; aY: Single): TGVPointf;
begin
  Result.X := aX;
  Result.Y := aY;
end;

function GV_Vector(aX: Single; aY: Single): TGVVector;
begin
  Result.X := aX;
  Result.Y := aY;
  Result.Z := 0;
end;

function GV_Rectangle(aX: Single; aY: Single; aWidth: Single; aHeight: Single): TGVRectangle;
begin
  Result.X := aX;
  Result.Y := aY;
  Result.Width := aWidth;
  Result.Height := aHeight;
end;

{ TGVVector }
constructor TGVVector.Create(aX: Single; aY: Single);
begin
  Assign(aX, aY);
  Z := 0;
end;

procedure TGVVector.Assign(aX: Single; aY: Single);
begin
  X := aX;
  Y := aY;
end;

procedure TGVVector.Clear;
begin
  X := 0;
  Y := 0;
  Z := 0;
end;

procedure TGVVector.Assign(aVector: TGVVector);
begin
  X := aVector.X;
  Y := aVector.Y;
end;

procedure TGVVector.Add(aVector: TGVVector);
begin
  X := X + aVector.X;
  Y := Y + aVector.Y;
end;

procedure TGVVector.Subtract(aVector: TGVVector);
begin
  X := X - aVector.X;
  Y := Y - aVector.Y;
end;

procedure TGVVector.Multiply(aVector: TGVVector);
begin
  X := X * aVector.X;
  Y := Y * aVector.Y;
end;

procedure TGVVector.Divide(aVector: TGVVector);
begin
  X := X / aVector.X;
  Y := Y / aVector.Y;

end;

function TGVVector.Magnitude: Single;
begin
  Result := Sqrt((X * X) + (Y * Y));
end;

function TGVVector.MagnitudeTruncate(aMaxMagitude: Single): TGVVector;
var
  MaxMagSqrd: Single;
  VecMagSqrd: Single;
  Truc: Single;
begin
  Result.Assign(X, Y);
  MaxMagSqrd := aMaxMagitude * aMaxMagitude;
  VecMagSqrd := Result.Magnitude;
  if VecMagSqrd > MaxMagSqrd then
  begin
    Truc := (aMaxMagitude / Sqrt(VecMagSqrd));
    Result.X := Result.X * Truc;
    Result.Y := Result.Y * Truc;
  end;
end;

function TGVVector.Distance(aVector: TGVVector): Single;
var
  DirVec: TGVVector;
begin
  DirVec.X := X - aVector.X;
  DirVec.Y := Y - aVector.Y;
  Result := DirVec.Magnitude;
end;

procedure TGVVector.Normalize;
var
  Len, OOL: Single;
begin
  Len := self.Magnitude;
  if Len <> 0 then
  begin
    OOL := 1.0 / Len;
    X := X * OOL;
    Y := Y * OOL;
  end;
end;

function TGVVector.Angle(aVector: TGVVector): Single;
var
  xoy: Single;
  R: TGVVector;
begin
  R.Assign(self);
  R.Subtract(aVector);
  R.Normalize;

  if R.Y = 0 then
  begin
    R.Y := 0.001;
  end;

  xoy := R.X / R.Y;

  Result := ArcTan(xoy) * GV_RAD2DEG;
  if R.Y < 0 then
    Result := Result + 180.0;
end;

procedure TGVVector.Thrust(aAngle: Single; aSpeed: Single);
var
  A: Single;
begin
  A := aAngle + 90.0;
  GV_ClipValuef(A, 0, 360, True);

  X := X + GV_AngleCos(Round(A)) * -(aSpeed);
  Y := Y + GV_AngleSin(Round(A)) * -(aSpeed);
end;

function TGVVector.MagnitudeSquared: Single;
begin
  Result := (X * X) + (Y * Y);
end;

function TGVVector.DotProduct(aVector: TGVVector): Single;
begin
  Result := (X * aVector.X) + (Y * aVector.Y);
end;

procedure TGVVector.Scale(aValue: Single);
begin
  X := X * aValue;
  Y := Y * aValue;
end;

procedure TGVVector.DivideBy(aValue: Single);
begin
  X := X / aValue;
  Y := Y / aValue;
end;

function TGVVector.Project(aVector: TGVVector): TGVVector;
var
  dp: Single;
begin
  dp := self.DotProduct(aVector);
  Result.X := (dp / (aVector.X * aVector.X + aVector.Y * aVector.Y)) *
    aVector.X;
  Result.Y := (dp / (aVector.X * aVector.X + aVector.Y * aVector.Y)) *
    aVector.Y;
end;

procedure TGVVector.Negate;
begin
  X := -X;
  Y := -Y;
end;

{ TGVRectangle }
constructor TGVRectangle.Create(aX: Single; aY: Single; aWidth: Single;
  aHeight: Single);
begin
  Assign(aX, aY, aWidth, aHeight);
end;

procedure TGVRectangle.Assign(aX: Single; aY: Single; aWidth: Single;
  aHeight: Single);
begin
  X := aX;
  Y := aY;
  Width := aWidth;
  Height := aHeight;
end;

function TGVRectangle.Intersect(aRect: TGVRectangle): Boolean;
var
  r1r, r1b: Single;
  r2r, r2b: Single;
begin
  r1r := X - (Width - 1);
  r1b := Y - (Height - 1);
  r2r := aRect.X - (aRect.Width - 1);
  r2b := aRect.Y - (aRect.Height - 1);

  Result := (X < r2r) and (r1r > aRect.X) and (Y < r2b) and (r1b > aRect.Y);
end;

{ === LUA =================================================================== }
{ TGVLuaValue }
class operator TGVLuaValue.Implicit(const aValue: Integer): TGVLuaValue;
begin
  Result.AsType := vtInteger;
  Result.AsInteger := aValue;
end;

class operator TGVLuaValue.Implicit(aValue: Double): TGVLuaValue;
begin
  Result.AsType := vtDouble;
  Result.AsNumber := aValue;
end;

class operator TGVLuaValue.Implicit(aValue: PChar): TGVLuaValue;
begin
  Result.AsType := vtString;
  Result.AsString := aValue;
end;

class operator TGVLuaValue.Implicit(aValue: TGVLuaTable): TGVLuaValue;
begin
  Result.AsType := vtTable;
  Result.AsTable := aValue;
end;

class operator TGVLuaValue.Implicit(aValue: Pointer): TGVLuaValue;
begin
  Result.AsType := vtPointer;
  Result.AsPointer := aValue;
end;

class operator TGVLuaValue.Implicit(aValue: Boolean): TGVLuaValue;
begin
  Result.AsType := vtBoolean;
  Result.AsBoolean := aValue;
end;

class operator TGVLuaValue.Implicit(aValue: TGVLuaValue): Integer;
begin
  Result := aValue.AsInteger;
end;

class operator TGVLuaValue.Implicit(aValue: TGVLuaValue): Double;
begin
  Result := aValue.AsNumber;
end;

class operator TGVLuaValue.Implicit(aValue: TGVLuaValue): PChar;
const
{$J+}
  Value: string = '';
{$J-}
begin
  Value := aValue.AsString;
  Result := PChar(Value);
end;

class operator TGVLuaValue.Implicit(aValue: TGVLuaValue): Pointer;
begin
  Result := aValue.AsPointer
end;

class operator TGVLuaValue.Implicit(aValue: TGVLuaValue): Boolean;
begin
  Result := aValue.AsBoolean;
end;

{ === BASE ================================================================== }

{ TGVBaseObject }
constructor TGVBaseObject.Create;
begin
  inherited;
end;

destructor TGVBaseObject.Destroy;
begin
  inherited;
end;

{ === ACTOR ================================================================= }
{ TGVActor }
function TGVActor.GetAttribute(aIndex: Byte): Boolean;
begin
  Result := Boolean(aIndex in FAttributes);
end;

procedure TGVActor.SetAttribute(aIndex: Byte; aValue: Boolean);
begin
  if aValue then
    Include(FAttributes, aIndex)
  else
    Exclude(FAttributes, aIndex);
end;

function TGVActor.GetAttributes: TGVActorAttributeSet;
begin
  Result := FAttributes;
end;

procedure TGVActor.SetAttributes(aValue: TGVActorAttributeSet);
begin
  FAttributes := aValue;
end;

procedure TGVActor.OnVisit(aSender: TGVActor; aEventId: Integer; var aDone: Boolean);
begin
  aDone := False;
end;

procedure TGVActor.OnUpdate(aDeltaTime: Single);
begin
  // update all children by default
  FChildren.Update([], aDeltaTime);
end;

procedure TGVActor.OnRender;
begin
  // render all children by default
  FChildren.Render([]);
end;

function TGVActor.OnMessage(aMsg: PGVActorMessage): TGVActor;
begin
  Result := nil;
end;

procedure TGVActor.OnCollide(aActor: TGVActor; aHitPos: TGVVector);
begin
end;

constructor TGVActor.Create;
begin
  inherited;
  FOwner := nil;
  FPrev := nil;
  FNext := nil;
  FAttributes := [];
  FTerminated := False;
  FActorList := nil;
  FCanCollide := False;
  FChildren := TGVActorList.Create;
end;

destructor TGVActor.Destroy;
begin
  FreeAndNil(FChildren);
  inherited;
end;

function TGVActor.AttributesAreSet(aAttrs: TGVActorAttributeSet): Boolean;
var
  A: Byte;
begin
  Result := False;
  for A in aAttrs do
  begin
    if A in FAttributes then
    begin
      Result := True;
      Break;
    end;
  end;
end;

function TGVActor.Collide(aActor: TGVActor; var aHitPos: TGVVector): Boolean;
begin
  Result := False;
end;

function TGVActor.Overlap(aX, aY, aRadius, aShrinkFactor: Single): Boolean;
begin
  Result := False;
end;

function TGVActor.Overlap(aActor: TGVActor): Boolean;
begin
  Result := False;
end;

{ TGVAIState }
constructor TGVAIState.Create;
begin
  inherited;
  FStateMachine := nil;
  FOwner := nil;
  FChildren := TGVActorList.Create;
end;

destructor TGVAIState.Destroy;
begin
  FreeAndNil(FChildren);
  inherited;
end;

procedure TGVAIState.OnEnter;
begin
end;

procedure TGVAIState.OnExit;
begin
end;

procedure TGVAIState.OnUpdate(aDeltaTime: Single);
begin
  // update all children by default
  FChildren.Update([], aDeltaTime);
end;

procedure TGVAIState.OnRender;
begin
  // render all children by default
  FChildren.Render([]);
end;

{ TGVAIStateMachine }
procedure TGVAIStateMachine.ChangeStateObj(aValue: TGVAIState);
begin
  if not Assigned(aValue) then
    Exit;

  FPreviousState := FCurrentState;

  if Assigned(FCurrentState) then
    FCurrentState.OnExit;

  FCurrentState := aValue;
  FCurrentState.Owner := FOwner;

  FCurrentState.OnEnter;
end;

procedure TGVAIStateMachine.SetCurrentStateObj(aValue: TGVAIState);
begin
  FCurrentState := aValue;
  FCurrentState.Owner := FOwner;
  if Assigned(FCurrentState) then
  begin
    FCurrentState.OnEnter;
  end;
end;

procedure TGVAIStateMachine.RemoveStateObj(aState: TGVAIState);
begin
  FStateList.Remove(aState);
  if FStateList.Count < 1 then
    FStateIndex := -1
  else
    FStateIndex := 0;
end;

procedure TGVAIStateMachine.SetGlobalStateObj(aValue: TGVAIState);
begin
  FGlobalState := aValue;
  FGlobalState.Owner := FOwner;
  if Assigned(FGlobalState) then
  begin
    FGlobalState.OnEnter;
  end;
end;

procedure TGVAIStateMachine.SetPreviousStateObj(aValue: TGVAIState);
begin
  FPreviousState := aValue;
  FPreviousState.Owner := FOwner;
end;

function TGVAIStateMachine.GetStateCount: Integer;
begin
  Result := FStateList.Count;
end;

function TGVAIStateMachine.GetStateIndex: Integer;
begin
  Result := FStateIndex;
end;

function TGVAIStateMachine.GetStates(aIndex: Integer): TGVAIState;
begin
  Result := nil;
  if (aIndex < 0) or (aIndex > FStateList.Count - 1) then
    Exit;
  Result := TGVAIState(FStateList.Items[aIndex]);
end;

function TGVAIStateMachine.GetCurrentState: Integer;
begin
  Result := FStateList.IndexOf(FCurrentState);
end;

procedure TGVAIStateMachine.SetCurrentState(aIndex: Integer);
var
  obj: TGVAIState;
begin
  obj := GetStates(aIndex);
  if Assigned(obj) then
  begin
    SetCurrentStateObj(obj);
    FStateIndex := aIndex;
  end;
end;

function TGVAIStateMachine.GetGlobalState: Integer;
begin
  Result := FStateList.IndexOf(FGlobalState);
end;

procedure TGVAIStateMachine.SetGlobalState(aIndex: Integer);
var
  obj: TGVAIState;
begin
  obj := GetStates(aIndex);
  if Assigned(obj) then
  begin
    SetGlobalStateObj(obj);
  end;
end;

function TGVAIStateMachine.GetPreviousState: Integer;
begin
  Result := FStateList.IndexOf(FPreviousState);
end;

procedure TGVAIStateMachine.SetPreviousState(aIndex: Integer);
var
  obj: TGVAIState;
begin
  obj := GetStates(aIndex);
  if Assigned(obj) then
  begin
    SetPreviousStateObj(obj);
  end;
end;

constructor TGVAIStateMachine.Create;
begin
  inherited;
  FOwner := nil;
  FCurrentState := nil;
  FGlobalState := nil;
  FPreviousState := nil;
  FStateList := FStateList.Create(True);
  FStateIndex := -1;
end;

destructor TGVAIStateMachine.Destroy;
begin
  FreeAndNil(FStateList);
  inherited;
end;

procedure TGVAIStateMachine.Update(aDeltaTime: Single);
begin
  if Assigned(FGlobalState) then
    FGlobalState.OnUpdate(aDeltaTime);
  if Assigned(FCurrentState) then
    FCurrentState.OnUpdate(aDeltaTime);
end;

procedure TGVAIStateMachine.Render;
begin
  if Assigned(FGlobalState) then
    FGlobalState.OnRender;
  if Assigned(FCurrentState) then
    FCurrentState.OnRender;
end;

procedure TGVAIStateMachine.RevertToPreviousState;
begin
  ChangeStateObj(FPreviousState);
end;

procedure TGVAIStateMachine.ClearStates;
begin
  FStateList.Clear;
  FStateIndex := -1;
end;

function TGVAIStateMachine.AddState(aState: TGVAIState): Integer;
begin
  Result := -1;
  if FStateList.IndexOf(aState) = -1 then
  begin
    Result := FStateList.Add(aState);
    if GetStateCount <= 1 then
    begin
      SetCurrentState(Result);
    end;
    aState.StateMachine := self;
  end;
end;

procedure TGVAIStateMachine.RemoveState(aIndex: Integer);
var
  obj: TGVAIState;
begin
  if (aIndex < 0) or (aIndex > FStateList.Count - 1) then
    Exit;
  obj := TGVAIState(FStateList.Items[aIndex]);
  RemoveStateObj(obj);
end;

procedure TGVAIStateMachine.ChangeState(aIndex: Integer);
var
  obj: TGVAIState;
begin
  obj := GetStates(aIndex);
  if Assigned(obj) then
  begin
    ChangeStateObj(obj);
    FStateIndex := aIndex;
  end;
end;

function TGVAIStateMachine.PrevState(aWrap: Boolean): Integer;
var
  I: Integer;
begin
  Result := -1;
  if FStateList.Count < 2 then
    Exit;

  I := FStateIndex;
  Dec(I);
  if I < 0 then
  begin
    if not aWrap then
      Exit;
    I := FStateList.Count - 1;
  end;
  ChangeState(I);
end;

function TGVAIStateMachine.NextState(aWrap: Boolean): Integer;
var
  I: Integer;
begin
  Result := -1;
  if FStateList.Count < 2 then
    Exit;

  I := FStateIndex;
  Inc(I);
  if I > FStateList.Count - 1 then
  begin
    if not aWrap then
      Exit;
    I := 0;
  end;
  ChangeState(I);
end;

{ TGVAIActor }
constructor TGVAIActor.Create;
begin
  inherited;
  FStateMachine := TGVAIStateMachine.Create;
  FStateMachine.Owner := self;
end;

destructor TGVAIActor.Destroy;
begin
  FreeAndNil(FStateMachine);
  inherited;
end;

procedure TGVAIActor.OnUpdate(aDeltaTime: Single);
begin
  // process states
  FStateMachine.Update(aDeltaTime);
end;

procedure TGVAIActor.OnRender;
begin
  // render state
  FStateMachine.Render;
end;

{ TGVActorList }
constructor TGVActorList.Create;
begin
  inherited;
  FHead := nil;
  FTail := nil;
  FCount := 0;
end;

destructor TGVActorList.Destroy;
begin
  Clear([]);
  inherited;
end;

procedure TGVActorList.Add(aActor: TGVActor);
begin
  if not Assigned(aActor) then
    Exit;

  aActor.Prev := FTail;
  aActor.Next := nil;

  if FHead = nil then
  begin
    FHead := aActor;
    FTail := aActor;
  end
  else
  begin
    FTail.Next := aActor;
    FTail := aActor;
  end;

  Inc(FCount);
end;

procedure TGVActorList.Remove(aActor: TGVActor; aDispose: Boolean);
var
  Flag: Boolean;
begin
  if not Assigned(aActor) then
    Exit;

  Flag := False;

  if aActor.Next <> nil then
  begin
    aActor.Next.Prev := aActor.Prev;
    Flag := True;
  end;

  if aActor.Prev <> nil then
  begin
    aActor.Prev.Next := aActor.Next;
    Flag := True;
  end;

  if FTail = aActor then
  begin
    FTail := FTail.Prev;
    Flag := True;
  end;

  if FHead = aActor then
  begin
    FHead := FHead.Next;
    Flag := True;
  end;

  if Flag = True then
  begin
    Dec(FCount);
    if aDispose then
    begin
      aActor.Free;
    end;
  end;
end;

procedure TGVActorList.Clear(aAttrs: TGVActorAttributeSet);
var
  P: TGVActor;
  N: TGVActor;
  NoAttrs: Boolean;
begin
  // get pointer to head
  P := FHead;

  // exit if list is empty
  if P = nil then
    Exit;

  // check if we should check for attrs
  NoAttrs := Boolean(aAttrs = []);

  repeat
    // save pointer to next object
    N := P.Next;

    if NoAttrs then
    begin
      Remove(P, True);
    end
    else
    begin
      if P.AttributesAreSet(aAttrs) then
      begin
        Remove(P, True);
      end;
    end;

    // get pointer to next object
    P := N;

  until P = nil;
end;

procedure TGVActorList.Clean;
var
  P: TGVActor;
  N: TGVActor;
begin
  // get pointer to head
  P := FHead;

  // exit if list is empty
  if P = nil then
    Exit;

  repeat
    // save pointer to next object
    N := P.Next;

    if P.Terminated then
    begin
      Remove(P, True);
    end;

    // get pointer to next object
    P := N;

  until P = nil;
end;

procedure TGVActorList.ForEach(aSender: TGVActor; aAttrs: TGVActorAttributeSet; aEventId: Integer; var aDone: Boolean);
var
  P: TGVActor;
  N: TGVActor;
  NoAttrs: Boolean;
begin
  // get pointer to head
  P := FHead;

  // exit if list is empty
  if P = nil then
    Exit;

  // check if we should check for attrs
  NoAttrs := Boolean(aAttrs = []);

  repeat
    // save pointer to next actor
    N := P.Next;

    // destroy actor if not terminated
    if not P.Terminated then
    begin
      // no attributes specified so update this actor
      if NoAttrs then
      begin
        aDone := False;
        P.OnVisit(aSender, aEventId, aDone);
        if aDone then
        begin
          Exit;
        end;
      end
      else
      begin
        // update this actor if it has specified attribute
        if P.AttributesAreSet(aAttrs) then
        begin
          aDone := False;
          P.OnVisit(aSender, aEventId, aDone);
          if aDone then
          begin
            Exit;
          end;
        end;
      end;
    end;

    // get pointer to next actor
    P := N;

  until P = nil;
end;

procedure TGVActorList.Update(aAttrs: TGVActorAttributeSet; aDeltaTime: Single);
var
  P: TGVActor;
  N: TGVActor;
  NoAttrs: Boolean;
begin
  // get pointer to head
  P := FHead;

  // exit if list is empty
  if P = nil then
    Exit;

  // check if we should check for attrs
  NoAttrs := Boolean(aAttrs = []);

  repeat
    // save pointer to next actor
    N := P.Next;

    // destroy actor if not terminated
    if not P.Terminated then
    begin
      // no attributes specified so update this actor
      if NoAttrs then
      begin
        // call actor's OnUpdate method
        P.OnUpdate(aDeltaTime);
      end
      else
      begin
        // update this actor if it has specified attribute
        if P.AttributesAreSet(aAttrs) then
        begin
          // call actor's OnUpdate method
          P.OnUpdate(aDeltaTime);
        end;
      end;
    end;

    // get pointer to next actor
    P := N;

  until P = nil;

  // perform garbage collection
  Clean;
end;

procedure TGVActorList.Render(aAttrs: TGVActorAttributeSet);
var
  P: TGVActor;
  N: TGVActor;
  NoAttrs: Boolean;
begin
  // get pointer to head
  P := FHead;

  // exit if list is empty
  if P = nil then
    Exit;

  // check if we should check for attrs
  NoAttrs := Boolean(aAttrs = []);

  repeat
    // save pointer to next actor
    N := P.Next;

    // destroy actor if not terminated
    if not P.Terminated then
    begin
      // no attributes specified so update this actor
      if NoAttrs then
      begin
        // call actor's OnRender method
        P.OnRender;
      end
      else
      begin
        // update this actor if it has specified attribute
        if P.AttributesAreSet(aAttrs) then
        begin
          // call actor's OnRender method
          P.OnRender;
        end;
      end;
    end;

    // get pointer to next actor
    P := N;

  until P = nil;
end;

function TGVActorList.SendMessage(aAttrs: TGVActorAttributeSet; aMsg: PGVActorMessage; aBroadcast: Boolean): TGVActor;
var
  P: TGVActor;
  N: TGVActor;
  NoAttrs: Boolean;
begin
  Result := nil;

  // get pointer to head
  P := FHead;

  // exit if list is empty
  if P = nil then
    Exit;

  // check if we should check for attrs
  NoAttrs := Boolean(aAttrs = []);

  repeat
    // save pointer to next actor
    N := P.Next;

    // destroy actor if not terminated
    if not P.Terminated then
    begin
      // no attributes specified so update this actor
      if NoAttrs then
      begin
        // send message to object
        Result := P.OnMessage(aMsg);
        if not aBroadcast then
        begin
          if Result <> nil then
          begin
            Exit;
          end;
        end;
      end
      else
      begin
        // update this actor if it has specified attribute
        if P.AttributesAreSet(aAttrs) then
        begin
          // send message to object
          Result := P.OnMessage(aMsg);
          if not aBroadcast then
          begin
            if Result <> nil then
            begin
              Exit;
            end;
          end;

        end;
      end;
    end;

    // get pointer to next actor
    P := N;

  until P = nil;
end;

procedure TGVActorList.CheckCollision(aAttrs: TGVActorAttributeSet; aActor: TGVActor);
var
  P: TGVActor;
  N: TGVActor;
  NoAttrs: Boolean;
  HitPos: TGVVector;
begin
  // check if terminated
  if aActor.Terminated then
    Exit;

  // check if can collide
  if not aActor.CanCollide then
    Exit;

  // get pointer to head
  P := FHead;

  // exit if list is empty
  if P = nil then
    Exit;

  // check if we should check for attrs
  NoAttrs := Boolean(aAttrs = []);

  repeat
    // save pointer to next actor
    N := P.Next;

    // destroy actor if not terminated
    if not P.Terminated then
    begin
      // no attributes specified so check collision with this actor
      if NoAttrs then
      begin

        if P.CanCollide then
        begin
          // HitPos.Clear;
          HitPos.X := 0;
          HitPos.Y := 0;
          if aActor.Collide(P, HitPos) then
          begin
            P.OnCollide(aActor, HitPos);
            aActor.OnCollide(P, HitPos);
            // Exit;
          end;
        end;

      end
      else
      begin
        // check collision with this actor if it has specified attribute
        if P.AttributesAreSet(aAttrs) then
        begin
          if P.CanCollide then
          begin
            // HitPos.Clear;
            HitPos.X := 0;
            HitPos.Y := 0;
            if aActor.Collide(P, HitPos) then
            begin
              P.OnCollide(aActor, HitPos);
              aActor.OnCollide(P, HitPos);
              // Exit;
            end;
          end;

        end;
      end;
    end;

    // get pointer to next actor
    P := N;

  until P = nil;
end;

{ TGVActorScene }
function TGVActorScene.GetList(aIndex: Integer): TGVActorList;
begin
  Result := FLists[aIndex];
end;

function TGVActorScene.GetCount: Integer;
begin
  Result := FCount;
end;

constructor TGVActorScene.Create;
begin
  inherited;
  FLists := nil;
  FCount := 0;
end;

destructor TGVActorScene.Destroy;
begin
  Dealloc;
  inherited;
end;

procedure TGVActorScene.Alloc(aNum: Integer);
var
  I: Integer;
begin
  Dealloc;
  FCount := aNum;
  SetLength(FLists, FCount);
  for I := 0 to FCount - 1 do
  begin
    FLists[I] := TGVActorList.Create;
  end;
end;

procedure TGVActorScene.Dealloc;
var
  I: Integer;
begin
  ClearAll;
  for I := 0 to FCount - 1 do
  begin
    FLists[I].Free;
  end;
  FLists := nil;
  FCount := 0;
end;

procedure TGVActorScene.Clean(aIndex: Integer);
begin
  if (aIndex < 0) or (aIndex > FCount - 1) then
    Exit;
  FLists[aIndex].Clean;
end;

procedure TGVActorScene.Clear(aIndex: Integer; aAttrs: TGVActorAttributeSet);
begin
  if (aIndex < 0) or (aIndex > FCount - 1) then
    Exit;

  FLists[aIndex].Clear(aAttrs);
end;

procedure TGVActorScene.ClearAll;
var
  I: Integer;
begin
  for I := 0 to FCount - 1 do
  begin
    FLists[I].Clear([]);
  end;
end;

procedure TGVActorScene.Update(aAttrs: TGVActorAttributeSet; aDeltaTime: Single);
var
  I: Integer;
begin
  for I := 0 to FCount - 1 do
  begin
    FLists[I].Update(aAttrs, aDeltaTime);
  end;
end;

procedure TGVActorScene.Render(aAttrs: TGVActorAttributeSet; aBefore: TGVActorSceneEvent; aAfter: TGVActorSceneEvent);
var
  I: Integer;
begin
  for I := 0 to FCount - 1 do
  begin
    if Assigned(aBefore) then
      aBefore(I);
    FLists[I].Render(aAttrs);
    if Assigned(aAfter) then
      aAfter(I);
  end;
end;

function TGVActorScene.SendMessage(aAttrs: TGVActorAttributeSet; aMsg: PGVActorMessage; aBroadcast: Boolean): TGVActor;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to FCount - 1 do
  begin
    Result := FLists[I].SendMessage(aAttrs, aMsg, aBroadcast);
    if not aBroadcast then
    begin
      if Result <> nil then
      begin
        Exit;
      end;
    end;
  end;
end;

{ TGVEntityActor }
constructor TGVEntityActor.Create;
begin
  inherited;
  FEntity := nil;
end;

destructor TGVEntityActor.Destroy;
begin
  GV_FreeEntity(FEntity);
  inherited;
end;

procedure TGVEntityActor.Init(aSprite: TGVSprite; aGroup: Integer);
begin
  FEntity := GV_CreateEntity(aSprite, aGroup);
end;

function TGVEntityActor.Collide(aActor: TGVActor; var aHitPos: TGVVector): Boolean;
begin
  Result := False;
  if FEntity = nil then Exit;
  if aActor is TGVEntityActor then
  begin
    Result := GV_CollideEntityPolyPoint(FEntity, TGVEntityActor(aActor).Entity, aHitPos)
  end
end;

function TGVEntityActor.Overlap(aX, aY, aRadius, aShrinkFactor: Single): Boolean;
begin
  Result := FAlse;
  if FEntity = nil then Exit;
  Result := GV_OverlapEntityXY(FEntity, aX, aY, aRadius, aShrinkFactor);
end;

function TGVEntityActor.Overlap(aActor: TGVActor): Boolean;
var
  e: TGVEntityActor;
begin
  Result := False;
  if FEntity = nil then Exit;
  if aActor is TGVEntityActor then
  begin
    e := TGVEntityActor(aActor);
    Result := GV_OverlapEntity(FEntity, e.Entity);
  end;
end;

procedure TGVEntityActor.OnRender;
begin
  if FEntity = nil then Exit;
  GV_RenderEntity(FEntity, 0, 0);
end;


{ TGVAIEntityActor }
constructor TGVAIEntityActor.Create;
begin
  inherited;
  FStateMachine := TGVAIStateMachine.Create;
end;

destructor TGVAIEntityActor.Destroy;
begin
  FreeAndNil(FStateMachine);
  inherited;
end;

procedure TGVAIEntityActor.OnUpdate(aDeltaTime: Single);
begin
  // process states
  FStateMachine.Update(aDeltaTime);
end;

procedure TGVAIEntityActor.OnRender;
begin
  // render state
  FStateMachine.Render;
end;

{ === GAME ================================================================== }

procedure GV_RunGame(aGame: TGVCustomGameClass);
var
  LGame: TGVCustomGame;
  LQuit: Boolean;
  LParams: TGVGameParams;
begin
  LGame := aGame.Create;
  try
    GV_GetLua.Reset;
    LGame.OnLuaReset;

    if LGame is TGVGame then
    begin
      TGVGame(LGame).InitDefaultParams(LParams);
      TGVGame(LGame).OnInitParams(LParams);
      TGVGame(LGame).SetParams(LParams);
    end;

    LGame.OnLoad;
    try
      if LGame.OnStartupDialogShow then
        begin
          LQuit := False;
          repeat
            case GV_ShowStartupDialog of
              sdsMore:
                begin
                  LGame.OnStartupDialogMore;
                end;
              sdsRun:
                begin
                  if LGame.OnStartupDialogRun then
                    GV_Run(LGame);
                end;
              sdsQuit:
                begin
                  LQuit := True;
                end;
            end;
          until LQuit;
        end
      else
        begin
          GV_Run(LGame);
        end;
    finally
      LGame.OnExit;
    end;
  finally
    FreeAndNil(LGame);
  end;
end;

{ TGVCustomGame }
constructor TGVCustomGame.Create;
begin
  inherited;
end;

destructor TGVCustomGame.Destroy;
begin
  inherited;
end;

function  TGVCustomGame.Run: Boolean;
begin
  Result := True;
end;

procedure TGVCustomGame.OnLoad;
begin
end;

procedure TGVCustomGame.OnExit;
begin
end;

procedure TGVCustomGame.OnStartup;
begin
end;

procedure TGVCustomGame.OnShutdown;
begin
end;

function TGVCustomGame.OnStartupDialogShow: Boolean;
begin
  Result := False;
end;

procedure TGVCustomGame.OnStartupDialogMore;
begin
end;

function  TGVCustomGame.OnStartupDialogRun: Boolean;
begin
  Result := True;
end;

procedure TGVCustomGame.OnProcessIMGUI;
begin
end;

procedure TGVCustomGame.OnUpdate(aDeltaTime: Double);
begin
end;

procedure TGVCustomGame.OnDisplayOpenBefore;
begin
end;

procedure TGVCustomGame.OnDisplayOpenAfter;
begin
end;

procedure TGVCustomGame.OnDisplayCloseBefore;
begin
end;

procedure TGVCustomGame.OnDisplayCloseAfter;
begin
end;

procedure TGVCustomGame.OnDisplayReady(aReady: Boolean);
begin
end;

procedure TGVCustomGame.OnDisplayClear;
begin
end;

procedure TGVCustomGame.OnRender;
begin
end;

procedure TGVCustomGame.OnRenderGUI;
begin
end;

procedure TGVCustomGame.OnDisplayShow;
begin
end;

procedure TGVCustomGame.OnSpeechWord(const aWord: WideString; const aText: WideString);
begin
end;

procedure TGVCustomGame.OnHighscoreAction(aAction: TGVHighscoreAction);
begin
end;

procedure TGVCustomGame.OnPathEditorLoad;
begin
end;

procedure TGVCustomGame.OnPathEditorSave;
begin
end;

procedure TGVCustomGame.OnPathEditorTest(aPathIndex: Integer; aLookAHead: Integer; aSpeed: Single; aWindowPos: TGVPointi);
begin
end;

procedure TGVCustomGame.OnPhysicsDrawBodyShapes(aBody: TGVPhysicsBody);
begin
end;

procedure TGVCustomGame.OnPhysicsUpdateBody(aBody: TGVPhysicsBody);
begin
end;

procedure TGVCustomGame.OnTwitterStatus(const aMsg: WideString; const aFilename: WideString);
begin
end;

procedure TGVCustomGame.OnBeforeRenderScene(aSceneNum: Integer);
begin
end;

procedure TGVCustomGame.OnAfterRenderScene(aSceneNum: Integer);
begin
end;

procedure TGVCustomGame.OnNetReceive(const aHost: WideString; aPort: Integer; aData: Pointer; aSize: Integer);
begin
end;

procedure TGVCustomGame.OnNetStatus(const aStatus: TGVNetStatus; const aStatusText: WideString);
begin
end;

procedure TGVCustomGame.OnRemoteDatabase(aDatabase: TGVDatabase; aState: TGVRemoteDatabaseState; aAction: TGVRemoteDatabaseAction);
begin
end;

procedure TGVCustomGame.OnIAPStatus;
begin
end;

procedure TGVCustomGame.OnPurchaseContactUs;
begin
end;

procedure TGVCustomGame.OnPurchaseStatus(aApproved: Boolean; aMsg: WideString);
begin
end;

procedure TGVCustomGame.OnLuaReset;
begin
end;

{ TGVGame }
procedure TGVGame.InitDefaultParams(var aParams: TGVGameParams);
begin
  // init default params
  aParams.ConfigFilename := '';
  aParams.ArchivePassword := '';
  aParams.ArchiveFilename := '';
  aParams.DisplayWidth := 800;
  aParams.DisplayHeight := 530;
  aParams.DisplayFullscreen := False;
  aParams.DisplayTitle := 'My Game';
  aParams.DisplayClearColor := BLACK;
  aParams.MonoFontSize := 16;
  aParams.VariableFontSize := 18;
  aParams.SceneCount := 1;
end;

procedure TGVGame.SetParams(var aParams: TGVGameParams);
begin
  FConfigFilename := aParams.ConfigFilename;
  FArchivePassword := aParams.ArchivePassword;
  FArchiveFilename := aParams.ArchiveFilename;
  FDisplayWidth := aParams.DisplayWidth;
  FDisplayHeight := aParams.DisplayHeight;
  FDisplayFullscreen := aParams.DisplayFullscreen;
  FDisplayTitle := aParams.DisplayTitle;
  DisplayClearColor := aParams.DisplayClearColor;
  FMonoFontSize := aParams.MonoFontSize;
  FVariableFontSize := aParams.VariableFontSize;
  FSceneCount := aParams.SceneCount;
end;

constructor TGVGame.Create;
begin
  inherited;
  FConfigFile := nil;
  FArchive := nil;
  FArchivePassword := '';
  FArchiveFilename := '';
  FDisplayWidth := 0;
  FDisplayHeight := 0;
  FDisplayFullscreen := False;
  FDisplayTitle := '';
  DisplayClearColor := BLANK;
  FMonoFont := nil;
  FVariableFont := nil;
  HudPos.Clear;
  MousePos.Clear;
end;

destructor TGVGame.Destroy;
begin
  inherited;
end;

procedure TGVGame.OnInitParams(var aParams: TGVGameParams);
begin
end;

procedure TGVGame.OnLoad;
begin
  // init config
  FConfigFile := GV_CreateConfigFile;
  GV_OpenConfigFile(FConfigFile, FConfigFilename);

  // init archive
  FArchive := GV_OpenArchive(FArchivePassword, FArchiveFilename);
end;

procedure TGVGame.OnExit;
begin
  // close archive
  GV_CloseArchive(FArchive);

  // close config
  GV_FreeConfigFile(FConfigFile)
end;

procedure TGVGame.OnStartupDialogMore;
begin
  GV_MessageDialog('OnStartupDialogMore', 'This event can be used to display additiona info and/or allow use to set game configuration before startup.', [], mdInfo);
end;

procedure TGVGame.OnStartup;
begin
  // init display
  GV_OpenDisplay(FDisplayWidth, FDisplayHeight, FDisplayFullscreen, FDisplayTitle);

  // init fonts
  FVariableFont := GV_LoadDefaultFont(dfProp, FVariableFontSize);
  FMonoFont := GV_LoadDefaultFont(dfMono, FMonoFontSize);

  // init sprite
  FSprite := GV_CreateSprite;

  // init starfield
  FStarfield := GV_CreateStarfield;

  // init scene
  FScene := TGVActorScene.Create;
  FScene.Alloc(FSceneCount);
end;

procedure TGVGame.OnShutdown;
begin
  // free scene
  FScene.ClearAll;
  FreeAndNil(FScene);

  // free sprites
  GV_FreeSprite(FSprite);

  // free starfield
  GV_FreeStarfield(FStarfield);

  // free fonts
  GV_FreeFont(FVariableFont);
  GV_FreeFont(FMonoFont);

  // close display
  GV_CloseDisplay;
end;

procedure TGVGame.OnUpdate(aDeltaTime: Double);
begin
  GV_MouseGetInfo(MousePos);

  // quit on ESC key
  if GV_KeyboardPressed(KEY_ESCAPE) then
    GV_SetTerminate(True);
end;

procedure TGVGame.OnRender;
begin
end;

procedure TGVGame.OnRenderGUI;
begin
  HudPos.X := 3;
  HudPos.Y := 3;

  GV_PrintFontY(FMonoFont, HudPos.X, HudPos.Y, 0, WHITE, haLeft, 'fps %d', [GV_GetFrameRate]);
end;

procedure TGVGame.OnDisplayClear;
begin
  GV_ClearDisplay(DisplayClearColor);
end;

procedure TGVGame.OnDisplayShow;
begin
  GV_ShowDisplay;
end;

{ =========================================================================== }
procedure GV_Startup; external cDllName;
procedure GV_Shutdown; external cDllName;

initialization
  ReportMemoryLeaksOnShutdown := True;

  if not IsLibrary then
    GV_Startup;

  GV_Randomize;

{$REGION 'Common Colors'}
  LIGHTGRAY := GV_MakeColor(200, 200, 200, 255);
  GRAY := GV_MakeColor(130, 130, 130, 255);
  DARKGRAY := GV_MakeColor(80, 80, 80, 255);
  YELLOW := GV_MakeColor(253, 249, 0, 255);
  GOLD := GV_MakeColor(255, 203, 0, 255);
  ORANGE := GV_MakeColor(255, 161, 0, 255);
  PINK := GV_MakeColor(255, 109, 194, 255);
  RED := GV_MakeColor(230, 41, 55, 255);
  MAROON := GV_MakeColor(190, 33, 55, 255);
  GREEN := GV_MakeColor(0, 228, 48, 255);
  LIME := GV_MakeColor(0, 158, 47, 255);
  DARKGREEN := GV_MakeColor(0, 117, 44, 255);
  SKYBLUE := GV_MakeColor(102, 191, 255, 255);
  BLUE := GV_MakeColor(0, 121, 241, 255);
  DARKBLUE := GV_MakeColor(0, 82, 172, 255);
  PURPLE := GV_MakeColor(200, 122, 255, 255);
  VIOLET := GV_MakeColor(135, 60, 190, 255);
  DARKPURPLE := GV_MakeColor(112, 31, 126, 255);
  BEIGE := GV_MakeColor(211, 176, 131, 255);
  BROWN := GV_MakeColor(127, 106, 79, 255);
  DARKBROWN := GV_MakeColor(76, 63, 47, 255);
  WHITE := GV_MakeColor(255, 255, 255, 255);
  BLACK := GV_MakeColor(0, 0, 0, 255);
  BLANK := GV_MakeColor(0, 0, 0, 0);
  MEGENTA := GV_MakeColor(255, 0, 255, 255);
  WHITE2 := GV_MakeColor(245, 245, 245, 255);
  RED2 := GV_MakeColor(126, 50, 63, 255);
  COLORKEY := GV_MakeColor(255, 000, 255, 255);
  OVERLAY1 := GV_MakeColor(000, 032, 041, 180);
  OVERLAY2 := GV_MakeColor(001, 027, 001, 255);
  DIMWHITE := GV_MakeColor(16, 16, 16, 16);
{$ENDREGION}

finalization
  if not IsLibrary then
    GV_Shutdown;

end.
