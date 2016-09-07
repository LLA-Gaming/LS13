/*
The coldsauce codebase currently requires you to have 9 z-levels of the same size dimensions.
z-level order is important, the order you put them in inside this file will determine what z level number they are assigned ingame.
Names of z-level do not matter, but order does greatly, for instances such as checking alive status of revheads on z1

current as of 2016/3/27
z1 = station
z2 = centcomm
z3 = planet
z4 = planet
z5 = lavaland
z6 = planet
z7 = empty space
z8 = empty space
z9 = empty space
*/

#if !defined(MAP_FILE)

		#define TITLESCREEN "title" //Add an image in misc/fullscreen.dmi, and set this define to the icon_state, to set a custom titlescreen for your map

		#define MINETYPE "lavaland"

        #include "map_files\IceStation\icestation.dmm"
        #include "map_files\IceStation\z2.dmm"
        #include "map_files\IceStation\z3.dmm"
        #include "map_files\IceStation\z4.dmm"
        #include "map_files\IceBox\lavaland.dmm"
        #include "map_files\IceStation\z6.dmm"
        #include "map_files\IceStation\z7.dmm"
        #include "map_files\IceStation\z8.dmm"
		#include "map_files\IceStation\z9.dmm"

		#define MAP_PATH "map_files/IceStation"
        #define MAP_FILE "icestation.dmm"
        #define MAP_NAME "Ice Station Zebra"

        #define MAP_TRANSITION_CONFIG	list(MAIN_STATION = PLANETLINKED, CENTCOMM = SELFLOOPING, PLANET_SECTION_A = PLANETLINKED, PLANET_SECTION_B = PLANETLINKED, MINING = SELFLOOPING, PLANET_SECTION_C = PLANETLINKED, ORBITAL_SATELLITE = SPACELINKED, OPEN_SPACE_A = SPACELINKED, OPEN_SPACE_B = SPACELINKED)

#elif !defined(MAP_OVERRIDE)

	#warn a map has already been included, ignoring icestation.

#endif