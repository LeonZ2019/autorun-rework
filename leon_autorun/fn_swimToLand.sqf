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
if (!LEON_Autorun_isSwim) exitWith {};
if (!isNull objectParent player) exitWith {};
if (getUnitFreefallInfo player select 0) exitWith {};

private "_newAnimation";
waitUntil {
	sleep 0.1;
	_newAnimation = player call LEON_Autorun_fnc_getAnimation;
	LEON_Autorun_isSwim && !(_newAnimation select [1, 3] in ["sdv", "bdv", "dve", "ssw", "bsw", "swm"])
};
player playMoveNow _newAnimation;
LEON_Autorun_isSwim = false;
