//A set of constants used to determine which type of mute an admin wishes to apply:
//Please read and understand the muting/automuting stuff before changing these. MUTE_IC_AUTO etc = (MUTE_IC << 1)
//Therefore there needs to be a gap between the flags for the automute flags
#define MUTE_IC			1
#define MUTE_OOC		2
#define MUTE_PRAY		4
#define MUTE_ADMINHELP	8
#define MUTE_DEADCHAT	16
#define MUTE_MENTORHELP	32
#define MUTE_ALL		63

//Some constants for DB_Ban
#define BANTYPE_PERMA		1
#define BANTYPE_TEMP		2
#define BANTYPE_JOB_PERMA	3
#define BANTYPE_JOB_TEMP	4
#define BANTYPE_ANY_FULLBAN	5 //used to locate stuff to unban.
#define BANTYPE_APPEARANCE	6
#define BANTYPE_ADMIN_PERMA	7
#define BANTYPE_ADMIN_TEMP	8
#define BANTYPE_ANY_JOB		9 //used to remove jobbans

//Please don't edit these values without speaking to Errorage first	~Carn
//Admin Permissions
#define R_TRIALADMIN		1
#define R_SECONDARYADMIN 	2
#define R_ADMIN				4
#define R_PRIMARYADMIN		8
#define R_SENIORADMIN		16
#define R_DEBUG				32

#define R_MAXPERMISSION 32 //This holds the maximum value for a permission. It is used in iteration, so keep it updated.
