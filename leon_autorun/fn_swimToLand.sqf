/*
	Author:
		leonz2019

	Description:
		Turn player from swimming to walking

	Parameters(s):
		None

	Returns:
		None
	
	Example:
		0 spawn LEON_Autorun_fnc_swimToLand;
*/

if (!hasInterface) exitWith {};
if (!LEON_Autorun_active) exitWith {};
if (!isNull objectParent player) exitWith {};
if (getUnitFreefallInfo player select 0) exitWith {};

private "_newAnimation";
waitUntil {
	sleep 0.2;
	_newAnimation = player call LEON_Autorun_fnc_getAnimation;
	LEON_Autorun_isSwim && !(_newAnimation select [0,4] in ["assw", "asdv", "adve", "absw", "abdv"])
};
player playMoveNow _newAnimation;
LEON_Autorun_isSwim = false;
