![GameVision Toolkit](/images/logo.png)&nbsp;&nbsp;&nbsp;&nbsp;[![Powered by Delphi](/images/delphi.png)](https://www.embarcadero.com/products/delphi)

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;**GameVision Toolkit**&trade;

![GitHub last commit](https://img.shields.io/github/last-commit/tinyBigGAMES/GameVision) ![GitHub contributors](https://img.shields.io/github/contributors/tinyBigGAMES/GameVision) ![GitHub stars](https://img.shields.io/github/stars/tinyBigGAMES/GameVision?style=social) ![GitHub forks](https://img.shields.io/github/forks/tinyBigGAMES/GameVision?style=social)

![Twitter Follow](https://img.shields.io/twitter/follow/tinyBigGAMES?style=social) 

## Overview
GameVision Toolkit (GVT) is an advanced 2D [Delphi](https://www.embarcadero.com/products/delphi) based game library for PC's running Microsoft Windows® and uses Direct3D® for hardware accelerated rendering.

It's robust, designed for easy use and suitable for making all types of 2D games and other graphic simulations, You access the features from a simple and intuitive procedural API, to allow you to rapidly and efficiently develop your graphics simulations. There is support for buffers, bitmaps, audio samples, streaming music, video playback, loading resources directly from a standard zip archive, and much more.

## History
It began life back in the mid 1990's as a high speed rendering library and over the years evolved into a game application framework with many nice features that allow you to make a complete game project. I enjoy the space shooter genre, so all of my games have been been of this type. 

Some of the games that I created with it include:
* Astro3D
* Star Blazer
* Outpost 9
* Quest
* Planetstrike 
* Stellar Defense
* Xarlor
* FreeStrike

The new 2.x releases on GitHub is the evolution of the product bringing new features and support for modern hardware. The first project I plan to do with the updated version will be FreeStrike 2.

## Features
* Made using the latest version of Delphi
* Long history (since 2001, across several released and unreleased projects)
* Color (create rgba colors in integer and float formats)
* Archive (create, read standard zip archives)
* Bitmap (BMP, DDS, PCX, TGA, JPEG, PNG formats)
* Viewport (multiple, scale, rotatee)
* Display (antialias, primatives, pixels, save to disk)
* Input (keyboard, mouse, joystick)
* Font (truetype, unicode)
* Text (fast static text, multi-color, rotate, scale)
* Sprite (pages, groups, define image in grid/rectangle space)
* Entity (position, scale, rotate, thrust, polypoint collision)
* EntityAction (automated entity action sequences)
* Audio (streaming music, sound effects, .wav, .flac, .ogg, .opus, .it, .mod, .s3m, .xm, .voc formats)
* Physics (basic physics for now)
* Highscores (highscores to a remote MySQL database, asynchronous operations, event callback)
* Telemetry (send telemetry data to your google analytics account)
* Network (httpget, sendmain, reliable UDP)
* Database (local SQLite, remote MySQL, asynchronous operations, event callback) 
* Bezier (define local point, render curved points)
* Easing (all the easing methods)
* Starfield (3d starfield simulation)
* Collision (basic collision routines)
* ConfigFile (ini based configuration file)
* IAP (desktop in-app purchase, low level and higher level versions)
* Dialogs (contact us, feedback)
* IMGUI (immediate mode gui system)
* Lua (fast and easy lua intergration, can make standalone EXEs, jit compiled via MoonJit)
* TreeMenu (tree view menu box)
* Screenshake (nice and juicy screenshake effects)
* Screenshot (save sequenced screenshot files)
* Speech (speech playback)
* PathEditor (create paths that your game objects can follow)
* Path (access the path data created by PathEditor)
* StartupDialog (optional startup dialog for your game)
* Video (.ogv format, play, pause, rewind, render)
* Polygon (high level polygon object, add local points, transform and render world points)
* Actor (high level actor system, actor, entity actor, actor list, actor scene)
* Game (game framework that drives gvt. All system events is managed by a derive game object)
* All supported resources can be loaded from a standard zip archive

## Installation
* [Download](https://github.com/tinyBigGAMES/GameVision/archive/main.zip) and unzip to a desired location on your computer
* Add **installdir/libs** to Delphi's Library search path or to your projects search path
* Add GVT.pas to your project to access toolkit features
* See examples and GVDocs.exe for information on usage and API information

## Usage
This is a minimal example of using the GameVision Toolkit:

```Pascal
uses
  GVT;

type

  { TMinimal }
  TMinimal = class(TGVGame)
  public
    procedure OnUpdate(aDeltaTime: Double); override;
    procedure OnRender; override;
    procedure OnRenderGUI; override;
    procedure OnInitParams(var aParams: TGVGameParams); override;
  end;
  
...
  
{ TMinimal }
procedure TMinimal.OnInitParams(var aParams: TGVGameParams);
begin
  // init params
  aParams.ArchivePassword := cArchivePassword;
  aParams.DisplayTitle := 'Minimal Example';
end;

procedure TMinimal.OnUpdate(aDeltaTime: Double);
begin
  inherited;

  // process keys
  if GV_KeyboardPressed(KEY_ESCAPE) then
    GV_SetTerminate(True);

  if GV_KeyboardPressed(KEY_F11) then
    GV_ToggleFullscreenDisplay;

  if GV_KeyboardPressed(KEY_F12) then
    GV_TakeScreenshot;

end;

procedure TMinimal.OnRender; override;
begin
  inherited;
  
  // draw some graphics
  GV_DrawFilledRectangle(50, 50, 50, 50, YELLOW);
end;

procedure TMinimal.OnRenderGUI;
begin
  inherited;
  
  // print some text
  HudPos.X := 3;
  HudPos.Y := 3;
  GV_PrintFontY(MonoFont, HudPos.X, HudPos.Y, 0, WHITE, haLeft, 'fps %d', [GV_GetFrameRate]);
  GV_PrintFontY(MonoFont, HudPos.X, HudPos.Y, 0, GREEN, haLeft, 'ESC       - Quit', []);
  GV_PrintFontY(MonoFont, HudPos.X, HudPos.Y, 0, GREEN, haLeft, 'F11       - Toggle fullscreen', []);
  GV_PrintFontY(MonoFont, HudPos.X, HudPos.Y, 0, GREEN, haLeft, 'F12       - Screenshot', []);
end;  

...

// just call GV_RunGame to instantiate and run game class
GV_RunGame(TMinimal);
```
You can GVArc (GameVision Archive Utility) to create resource archive files:
```
GVArc password archivename directoryname
```
This will zip up **directoryname** and save it to **archivename.arc** using **password**. You can then access all your password protected resources at runtime:
```Pascal
var
  Arc: TGVArchive;
  Bmp: TGVBitmap;
...
Arc := GV_OpenArchive('mypassword', 'myarchivefile.arc');
Bmp := GV_LoadBitmap(Arc, 'arc/bitmaps/sprites/ship.png', @COLORKEY);
```
Any routine that accepts an **TGVArchive**, if you pass nil, it will try to load the file directly from the filesystem. If you keep your path on disk the same as inside the archive, you can quicly access files on disk while testing and making changes, then when you create an archive, you will not have to change any paths in your sources.

## Distribution
In addition to your own redistributable files, you must also include:
* GVT.dll - GameVision Toolkit 
* Any .arc (zip archive files) used by your project

## Screenshots
![](/images/image01.jpg)

![](/images/image02.jpg)

![](/images/image03.jpg)

![](/images/image04.jpg)

![](/images/image05.jpg)

![](/images/image06.jpg)

## Support
You can requrest support via:
* [submitting](https://github.com/tinyBigGAMES/GameVision/issues) an issue
* Our support [forums](https://tinybiggames.com/forums/)
* Our [twitter](https://twitter.com/tinyBigGAMES) page

## Known Issues
* The documention are WIP
* The examples/demos are WIP
* Delphi only (Object Pascal)
* Windows 10 Desktop.
* For now grab the [latest](https://github.com/tinyBigGAMES/GameVision/archive/main.zip) from the main branch. Major features for the 2.x is locked down now, just bug fixes and WIPs. It's very stable.
