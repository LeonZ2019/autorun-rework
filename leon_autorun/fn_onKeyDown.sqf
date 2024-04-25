/*
	Author:
		leonz2019

	Description:
		Main function for autorun

	Parameters(s):
		Select 0 - BOOLEAN: FALSE if walk only

	Returns:
		None
	
	Example:
		call LEON_Autorun_fnc_onKeyDown;
*/

if (!hasInterface) exitWith {};
if (!(call LEON_Autorun_fnc_checkDisplay)) exitWith {};
if (LEON_Autorun_active && !(isNil "_this") && { typeName _this == "ARRAY" && { typeName (_this select 0) == "SCALAR" } }) exitWith {
	LEON_Autorun_type = _this select 0;
};
if (LEON_Autorun_active && count (actionKeys "LEON_Autorun_stopKey") > 0 && inputAction "LEON_Autorun_stopKey" == 0) exitWith {};
if (focusOn != player) exitWith {};
if (!isNull objectParent player) exitWith {};
if (visibleMap && !(12 in LEON_Autorun_displayAllow)) exitWith {};
if (getUnitFreefallInfo player select 0) exitWith {};
LEON_Autorun_stance = (call LEON_Autorun_fnc_getStance) select 1;
if (LEON_Autorun_active) exitWith {
	LEON_Autorun_active = false;
	0 spawn LEON_Autorun_fnc_stopRunning;
};
// rsc stuff
LEON_Autorun_rscId = ["AutoRunIndicator"] call BIS_fnc_rscLayer;
LEON_Autorun_rscId cutRsc ["AutoRunIndicator", "PLAIN"];

LEON_Autorun_type = _this select 0;
LEON_Autorun_animation = player call LEON_Autorun_fnc_getAnimation;
LEON_Autorun_isSwim = LEON_Autorun_animation select [1, 3] in ["sdv", "bdv", "dve", "ssw", "bsw", "swm"];
LEON_Autorun_active = true;
player addEventHandler ["AnimDone", {
	if (!alive player || !LEON_Autorun_active || focusOn != player || !isNull objectParent player || (getUnitFreefallInfo player select 0 && {(ATLToASL [getPos player select 0, getPos player select 1, 0]) distance (getPosASL player) > getUnitFreefallInfo player select 2}) || incapacitatedState player == "UNCONSCIOUS") exitWith {
		if (LEON_Autorun_active) then {
			LEON_Autorun_active = false;
			0 spawn LEON_Autorun_fnc_stopRunning;
		};
		player removeEventHandler ["AnimDone", _thisEventHandler];
	};
	call LEON_Autorun_fnc_updateStance;
	LEON_Autorun_animation = player call LEON_Autorun_fnc_getAnimation;
	if (!LEON_Autorun_isSwim && (LEON_Autorun_animation select [1, 3] in ["sdv", "bdv", "dve", "ssw", "bsw", "swm"])) then {
		LEON_Autorun_stance = (call LEON_Autorun_fnc_getStance) select 1;
		LEON_Autorun_isSwim = true;
		0 spawn LEON_Autorun_fnc_swimToLand;
		0 spawn LEON_Autorun_fnc_updateSwimAnim;
	};
	if (!LEON_Autorun_updatingStance) then {
		player playMoveNow LEON_Autorun_animation;
	};
}];
player playMoveNow LEON_Autorun_animation;
