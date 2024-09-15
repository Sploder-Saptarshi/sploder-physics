# sploder-physics

WIP Decompiled client-side AS3/Flash source code for the Sploder Physics Puzzle Maker 

## History

The Sploder physics puzzle maker was originally launched on Sploder (shut down) in May, 2011. Hundreds of thousands of game levels were created with this software, and it has received many updates over the years. This is a decompiled version of the code for version b21.

## How

The Sploder physics puzzle maker was decompiled with the help of FFdec, a flash decompiler. Some files were modified by me to allow for compilation. The source code was compiled with version [4.6.0.23201B](http://fpdownload.adobe.com/pub/flex/sdk/builds/flex4.6/flex_sdk_4.6.0.23201B.zip) of the Flex SDK.

## Why

This was decompiled just for having the ability to modify it or updating the creator with new features without the fear of corruption of the SWF for use with the [Sploder Revival](https://github.com/Sploder-Saptarshi/Sploder-Launcher) Project. I'd gladly appreciate if someone would take the responsibility to port this to HTML5.

## Sub-projects

There are several `.as3proj` files which are FlashDevelop projects.

- fullgame5_b20.as3proj - the game engine
- creator5_b21.as3proj - the creator

## Source code

Much of the source code is in `com/sploder` but the physics engine is a version of `nape` from 2010. All of the fla files in `fla` directory are untested and have been automatically decompiled using FFdec. However, the creator and engine code should work perfectly fine with some fine-tuning. Please submit issues/pull requests if there is any mismatch between the working of the original creator and this decompilation.

## License

I have no right to host this whatsoever but since the web site has shut down, it has been posted here as abandonware.
