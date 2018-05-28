GB68K v0.5.1 by Ben Ingram
ingramb AT gmail DOT com (questions welcome, but please at least read this file first)
MastaZog on TIGCC boards
Zog on most other boards (if I even post)
Project Page at: http://www.ti-news.net/project_view.php?project=gb68k

IF YOU DOWNLOADED THIS FROM ANYWHERE EXCEPT TI-NEWS, IT MAY NOT BE THE LATEST VERSION!  CHECK THE ABOVE LINK!

DISCLAIMER

Emulation is a touchy legal subject.  Primarily, this is due to the use of copyrighted game images, or ROMs.  Public domain ROMs do exist, and these are certainly legal to use.  This software doesn't include any copyrighted game software.  Users of this software are responsible for the decisions they make while using it.

INTRODUCTION

This is a Nintendo Gameboy emulator for the various TI-89 and TI-92+ graphing calculators.  It is programmed in a combination of C and ASM using TIGCC.  C is used for some initialization and user interface code.  The emulation engine itself is pure ASM.  Some games work and some don't.  Most have small graphics errors, and most run slowly.  A few games run fast enough for me to consider them playable.

Currently emulated:

* All Gameboy instructions except stop
* MBC1, MBC2, MBC3 (with clock), and MBC5
* Save ram up to 32k
* Timer (timing not that accurate)
* Background layer, sprite layer, and partial window layer

Not emulated:

* Gameboy Color features
* Sound
* Linking
* All other memory controllers (special carts that have things like rumble support)
* Sprite priority behind background layer
* Raster effects - The actual Gameboy draws the screen one line at a time.  Gameboy instructions are allowed to modify display parameters as the screen is being drawn.  This   allows certain special effects to be achieved.  This emulator currently draws the entire   screen in one pass, which means these special effects won't work.  This makes some games   unplayable, but it's also faster. (And easier to program...)
* Probably other things

I'd like to add the second sprite priority and support for raster effects.  Link play seems unlikely, but it may be possible.  Sound would be neat, but I don't think it will happen.  Gameboy color features will never be emulated.  Besides a color screen, the GBC has 4 times the ram, twice the VRAM, and (most importantly), a CPU that can run twice as fast.  Some gameboy color games will still run on a regular gameboy; these should work on the emulator as well.

USING THE EMULATOR

Required:
* TI-89 (titanium) OR
* TI-92+ OR
* V200
* Lots of free memory
* Game ROMS to play

The required files are gb68k.89z (launcher), gb68kppg.89y (packed program), and gb68klib.89y (dll).  Other launchers can be used.  All the files should work regardless of the calculator model.

The first thing to do is convert some Gameboy games for use on the calculator.  To do this, you'll need to acquire the ROM images of Gameboy games.  The internet has more information on how to do this.  I won't answer questions related to the acquisition of commercial ROMs.

Once you have a ROM, it needs to be converted with the included utility.  It runs from the command line and has two parameters, plus an optional third parameter.  The first is the name of the ROM file; the second is the on calc name you would like.  This second name must be 6 characters or less.  The utility will generate a number of files with the name you specify, appended with numbers.  For example, if you run 'CartConvert mygame.gb mygame', you'll get files mygame00, mygame01, mygameXX.  For this to work, mygame.gb will need to be in the same directory as CartConvert.  The generated files will also be in this directory.  The exact number will depend on the size of the original ROM.  Send all these files to your calculator.  They should be archived, but they don't have to be.

The optional third parameter is the flag "-pack".  This will convert the rom such that it takes MORE space, but fits in fewer files.  Normally, roms are packed in files of 48kb each.  With the pack option, the base file size is 56kb, and then every other file is padded with 6000 very important extra bytes.  Pack mode is useful, because archive memory is divided into blocks of 64kb.  There are a limited number of blocks, and files CAN'T be broken up between them.  So even if you have archive space left, if each block is filled with a 48kb file, you won't be able to archive anything else over 16kb.  You should use pack mode if you're filling most of your archive up with gb roms, or other large files.  You should use default mode if you want to archive lots of other, smaller files in addition to gb roms.

Now that you have your rom, send the emulator to your calculator, make sure you have lots of free memory, and run it.  You'll get a list of all the ROMs on the calculator.  All folders will be scanned.  Select the game you want.  If all goes well, you should be playing.  If not, the emulator will quit with an error message, or maybe crash =(

Press [ESC] during emulation to open the menu.  Here you can change options, save or load the state, or quit the emulator.  With save states, you can save your progress at any point, even in games that don't normally allow saving.  The save state files are compressed, but still quite large.  The compression also takes a while (in certain extreme cases, a VERY long while...if your calc seems to freeze, give it at least 5 minutes).  The options are as follows:

* Frame Skip: Larger values will cause the game to run faster, but less smooth.  Higher values lead to diminishing returns.  A good value is 2 or 3.

* Timer Enable: Some games need the timer to run.  Some games don't use it at all.  Some games use it for unimportant (at least on the calc) things like * sound.  So...Some games will run faster without the timer, some games won't run at all without the timer, and some games won't care.  Experiment with each game to see.

* Serial Enable: GB68k tries to emulate the serial port so games will detect that no external gb is present.  This emulation isn't perfect.  Some games won't work unless this is on, and some won't work unless it's off.  Speed is unaffected by this setting.

* Sram in savestates: This option can exclude the built in save ram from save states.  This will make save state files smaller.  Also, loading a save state will no longer overwrite games saved with the standard, in game save feature.  However, some games use sram for stuff besides save games.  So, save states created with this option may not work with certain games.

* Auto archive: If enabled, all files generated by gb68k will automatically be archived.  This is a good idea, unless you're worried about the life of your flash (flash memory will wear out eventually...but it does last a long time).

When you exit the emulator, settings will be stored in two files: mygamesv, and gb68ksv.  The fps and archive settings are saved in gb68k.  The other settings are game specific, and are stored for each game.  If a game has save ram, this will also be compressed and stored in mygamesv.

Press [ON] during emulation to save the state in slot 9, and then exit with no prompt.  This feature is included for certain, er...situations where you may need to quickly stop playing games with little warning.

The TI-89 has a resolution of 160 x 100.  The bigger calculators have 240 x 128.  The Gameboy has 160 x 144.  This means that some of the vertical screen will be chopped off.  The plus and minus keys can be used to shift the view up and down.  The multiply and divide keys will set the view to the top or bottom of the screen.

Controls

All calcs
[+/-] - shift view up and down
[divide] - shift view to the top
[multiply] - shift view to the bottom
[ESC] - menu
[ON] - quick save and exit

TI-89
Arrow keys
[2nd] - A
[Shift] - B
[Dmd] - select
[Alpha] - start

TI-92+
Arrow keys
[F1] - A
[F5] - B
[Enter] - Start (the one below the keypad)
[Apps] - Select

V200
Arrow keys
[Hand] - A
[Q] - B
[Enter] - Start (the one below the keypad)
[Apps] - Select

Lots of things can go wrong unfortunately.  Most likely, a game won't work properly, or just won't work at all.  If this happens, first check the exact same ROM using a PC based emulator (VGBA, No$GB, or whatever).  If your ROM works on the PC, let me know what ROM you're trying to use, and what's wrong (if it's not obvious).  Have a look at the un-emulated features first though.  I don't need reports of sprites showing up at the wrong priority, for example.  That's not supposed to work right yet.

Less likely, but still possible, the entire calculator could crash.  Sorry, but nobody's perfect.  If this happens, I'd also like a report.  If the emulator crashes at a specific point in a game, a list of steps to get to that point would be nice.

TECHNICAL DETAILS

The emulation is interpretive.  It uses the instruction decoding technique described by the author of TEZXAS (http://tezxas.ticalc.org).  In the future, I'd like to try some sort of recompiling engine, but I'm not sure how it will work out.

The palette algorithms are based on those in TIGB (http://natsumi.boogersoft.com/projects/tigb).  My emulator seems to by quite a bit faster than TIGB.  TIGB has more accurate video emulation, and timer emulation.  It only emulates MBC1, and doesn't have any support for the window layer (which makes most RPGs unplayable).

Save files are compressed first using rle encoding written by me, and then with the LZFO1 compressor written by Francesco Orabona.  My rle code doesn't really help compression ratios, but it often makes the LZFO process MUCH faster by dramatically reducing the input size.

The gameboy_opcodes.S file is automatically generated by the OpcodeGenerator.cpp program.  Since each unique opcode has its own function handler, this saves me from having to type lots of duplicate code, and reduces the chance for errors.  For example, lots of instructions operate on the memory location addressed by the hl register.  The code for finding this memory is the same, regardless of what the final operation will be.  This design was inspired by the Generator Sega Genesis emulator.  Its author, James Ponder, wrote a very nice report about his emulator, which has provided me with several ideas.  I plan to implement some more of his ideas eventually, which will hopefully speed things up.

LICENCE

This software is open source.  You can use the source as you see fit, with a few exceptions.  First, give credit where it's due.  Don't claim my work as your own.  Second, I don't want modified versions of this software being distributed.  If you want add something, or improve this emulator, send the change to me so I can incorporate it into the official version.  I will of course give you credit.  If you want to build you own emulator and use pieces of my code, that's fine, as long as most of the code is your own.  I realize this is somewhat subjective.  Hopefully it won't be a problem.

THANKS
* Kevin Kofler for his constant support and development of TIGCC
* Keven Kofler again, for his work to make TiEmu compatible with gb68k
* The rest of the TiEmu team (Thomas Corvazier, Romain Lievin, Julien Blache)
* Rusty Wagner for Virtual TI
* The TICT team (Lionel Debroux, Thomas Nussbaumer, and others) for hosting the TIGCC boards, and for many other contributions to the TI community
* Everyone who answers questions on the TIGCC boards (too many to list here, but you know who you are =)
* Samir Ribic for the TEZXAS emulator, a major source of inspiration
* Boogerman for the TIGB emulator, another major inspiration =) (not sure what his real name is...)
* James Ponder, for the Generator emulator and its accompanying technical report
* Martin Korth, for the No$GMB emulator, and its debugger, which helped me locate many bugs in my own emulator
* Francesco Orabona for his LZFO1 compression library
* Machinae Supremacy for the soundtrack (http://www.machinaesupremacy.com/)
* Everyone else who ever did anything for me
A big thanks to the following people for testing and/or moral support:
* Malcolm Smith (TRgenius)
* Craig Messner
* Mateo872111
* Kodi Mosley
* Reginald Tucker
* Rakka
* Andy Janata 
* jschmidty89
* everyone else who's given me feedback
Thanks to the following for optimization suggestions:
* Samuel Stearley
* jackiechan

HISTORY

Project started August 2004

v0.1 4/9/2005
initial release

v0.1a 4/14/2005
* Fixed problem that was causing sprites to not show up sometimes.  I still don't know exactly what was wrong before.
* Improved accuracy of LCD controller while LCD is turned off (fixed Lamborghini Challenge)
* Fixed error with back to back EI instructions (Faceball)
* Changed VBlank slightly to occur at line 144 instead of 145 (Simpsons Camp Deadly)

v0.2.0 4/25/2005
* Changed version numbering system =)  The new system is MAJOR.MINOR.REVISION  Hopefully I'll be happy with this.
* Added (mostly untested) support for MBC5
* Game roms can now be placed in any folder.  Despite what I said before, they had to be in the same folder as the emulator.
* Fixed bug with EI instruction.  Pending interrupts after an EI instruction would previously incorrectly save the PC on the stack, if the stack pointer was between ff00 and ffff. (Megaman 1 - Megaman 5)
* Decided previous method of special 16 bit memory access, using false opcodes, was too dirty, so now it's rewritten to use the event system (fixes possible, obscure bug)
* Fixed typo causing mode1 to not be set in LCDC
* Fixed useless LD instructions, such as LD A, A.  Previously, they would crash =/ (Hunt for Red October)
* Added some support for the link cable.  Or rather, when a game tries to initialize the link cable, it will properly behave as though no other gameboy is present (Play Action Football)
* +/- now scroll by 4 pixels instead of 1

v0.3.0 5/7/2005
* In order to fix the megaman games in the previous version, I broke some other games (marioland for example).  Now they should all work.  The issue here is where to redraw the screen, either at LY=144 (marioland works), LY=0 (megaman works), or LY=67 (both work).
* Sprites can now be turned off by games 
* Link interrupts are no longer generated if SC is set to external clock (space invaders)
* DIV now register incs during VBlank (Dr. Mario)
* Better key bindings on TI-92/V200
* Increased speed of TI-92/V200 screen draw (only need 17 rows, not 18)
* You can now quit the emulator while the gameboy screen is turned off
* Added quit confirmation
* Moved gameboy SP into a 68k address register.  This gives a noticeable speed increase on most games, but could potentially cause crashes or other issues.

v0.3.1 5/17/2005
* Changed ROM file format.  Now only 3 banks per file instead of 3.5 banks per file.  This is unfortunate from a storage perspective, but necessary because splitting banks across files didn't work with multi-byte instructions
* Removed calculation of half-carry and subtract flags from all instructions except ADD, SUB, ADC, and SBC.  I'd be surprised if any game relied on these flags being set by other instructions.  This gives a nice speed increase.

v0.4.0 5/30/2005
* Added timer support.  The timing is not particularly accurate, but it should be good enough for most games to work (such as SQRXZ and Montezuma's Return).  More importantly, the speed of games that don't use the timer isn't affected
* Games that have internal ram, but no battery won't generate save files (SQRXZ and others)
* Small optimization to instruction decoding.  bpl.w (usually taken) -> bmi.b (usually not taken).  This saves 2 cycles and 2 bytes per instruction decode
* Increased size of file pointer array to allow 2 MB games to actually have a chance to run
* Added menu that allows you to change various setting while a game is playing
* Added options menu
* Added multiply/divide keys to quickly scroll to top or bottom of screen
* jackiechan has used his considerable ASM graphics skills to help optimize the drawing code.  Emulating the gameboy cpu is much more expensive than drawing the screen, so the overall speed increase isn't that great.  But it's still greatly appreciated.

v0.5.0 8/16/2005
* Fixed a stupid bug that's been around since day 1.  The 68k addx and subx instructions will clear the zero flag, but not set it.  So...this behavior was incorrectly carrying over to the gb adc and sbc instructions.  Ouch.  (Donkey Kong Land works, fixes sprite problems in Megaman games)
* Added save state support
* Reduced uncompressed size of main program by ~10k, by dynamically creating some code at run time (reduce runtime mem required by 10k)
* Increased speed of memory access, using some ideas found in the palm gb emulator, phoinix.  Overall speed increase is less than I hoped for.
* Rearanged lots of stuff so now all gb registers are kept in 68k register...small speed increase
* Only check for events after instructions that modify PC...larger speed increase
* Lots of small size/speed optimizations, reduced run time memory requirement
* Faster ADC and SBC instructions by Samuel Stearley
* Support for real time clock on mbc3 (used by pokemon silver, harvest moon, and others)
* New rom format "pack", replacing "dirty" format from previous versions.  This format allows 2MB games to (barely) fit on the titanium and V200 calcs.  Default format is the same.
* Illegal gb instructions now cause the emulator to safely quit.

v0.5.1 10/5/2005
* Fixed bug introduced in last version: adda.l -> adda.w in "ADD SP, nn" (fixes Earthworm Jim, SQRXZ, Super RC Pro-AM, and probably many others)
* Added ON as quick save and exit key (teacher/boss/whatever key)

