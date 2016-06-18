/*
The coldsauce codebase currently requires you to have 3 z-levels of the same size dimensions.
z-level order is important, the order you put them in inside this file will determine what z level number they are assigned ingame.
Names of z-level do not matter, but order does greatly, for instances such as checking alive status of revheads on z1

current as of June 18th 2016
z1 = surface
z2 = centcom
z3 = space
*/

#if !defined(MAP_FILE)

		#define TITLESCREEN "title" //Add an image in misc/fullscreen.dmi, and set this define to the icon_state, to set a custom titlescreen for your map

		#define MINETYPE "iceplanet"

        #include "map_files\IcePlanet\planet.dmm"
        #include "map_files\IcePlanet\centcom.dmm"
        #include "map_files\IcePlanet\space.dmm"

		#define MAP_PATH "map_files/IcePlanet"
        #define MAP_FILE "planet.dmm"
        #define MAP_NAME "Ice Planet"

        #define MAP_TRANSITION_CONFIG	list(MAIN_STATION = SELFLOOPING, CENTCOMM = SELFLOOPING, SPACE_AREA = SELFLOOPING)

#elif !defined(MAP_OVERRIDE)

	#warn a map has already been included, ignoring ice planet.

#endif