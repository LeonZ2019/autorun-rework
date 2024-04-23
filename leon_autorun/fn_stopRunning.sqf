/*
	Author:
		leonz2019

	Description:
		Stop Autorun

	Parameters(s):
		None

	Returns:
		None
	
	Example:
		call LEON_Autorun_fnc_stopRunning;
*/

if (!hasInterface) exitWith {};
LEON_Autorun_active = false;
LEON_Autorun_rscId cutText ["", "PLAIN"];
if (alive player && isNull objectParent player && incapacitatedState player == "") then {
	player setVelocity [0,0,0];
	LEON_Autorun_damageAllowed = isDamageAllowed player;
	if (LEON_Autorun_damageAllowed) then {
		player allowDamage false;
	};
	if (LEON_Autorun_isSwim) then {
		LEON_Autorun_isSwim = false;
	};
	LEON_Autorun_animation = [player, true] call LEON_Autorun_fnc_getAnimation;
	player playMoveNow LEON_Autorun_animation;
};
