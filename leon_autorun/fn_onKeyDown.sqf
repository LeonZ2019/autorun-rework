/*
	Author:
		leonz2019

	Description:
		Main function for autorun

	Parameters(s):
		None

	Returns:
		None
	
	Example:
		call LEON_Autorun_fnc_onKeyDown;
*/

if (!hasInterface) exitWith {};
if (!isNull (findDisplay 312) || !isNull (findDisplay 60492) || !isNull (findDisplay 632) || !isNull (findDisplay 602) || !isNull (findDisplay 160)) exitWith {};
if (focusOn != player) exitWith {};
if (!isNull objectParent player) exitWith {};
if (visibleMap) exitWith {};
if (getUnitFreefallInfo player select 0) exitWith {};
LEON_Autorun_stance = (call LEON_Autorun_fnc_getStance) select 1;
if (LEON_Autorun_active) exitWith {
	LEON_Autorun_active = false;
	call LEON_Autorun_fnc_stopRunning;
};
// rsc stuff
LEON_Autorun_rscId = ["AutoRunIndicator"] call BIS_fnc_rscLayer;
LEON_Autorun_rscId cutRsc ["AutoRunIndicator", "PLAIN"];

LEON_Autorun_animation = player call LEON_Autorun_fnc_getAnimation;
LEON_Autorun_isSwim = LEON_Autorun_animation select [0,4] in ["assw", "asdv", "adve", "absw", "abdv"];
LEON_Autorun_active = true;
player addEventHandler ["AnimDone", {
	call LEON_Autorun_fnc_updateStance;
	LEON_Autorun_animation = player call LEON_Autorun_fnc_getAnimation;
	if (!alive player || !LEON_Autorun_active || focusOn != player || !isNull objectParent player || getUnitFreefallInfo player select 0) exitWith {
		if (LEON_Autorun_active) then {
			LEON_Autorun_active = false;
			call LEON_Autorun_fnc_stopRunning;
		} else {
			if (LEON_Autorun_damageAllowed) then {
				player allowDamage false;
				LEON_Autorun_damageAllowed = false;
			};
		};
		player removeEventHandler ["AnimDone", _thisEventHandler];
	};
	if (!LEON_Autorun_isSwim && (LEON_Autorun_animation select [0,4] in ["assw", "asdv", "adve", "absw", "abdv"])) then {
		LEON_Autorun_isSwim = true;
		0 spawn LEON_Autorun_fnc_swimToLand;
	};
	if (!LEON_Autorun_updatingStance) then {
		player playMoveNow LEON_Autorun_animation;
	}
}];
player playMoveNow LEON_Autorun_animation;
