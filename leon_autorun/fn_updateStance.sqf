/*
	Author:
		leonz2019

	Description:
		Update stance by auto Sea level or player input key

	Parameters(s):
		None

	Returns:
		BOOLEAN, TRUE if stance is same
	
	Example:
		call LEON_Autorun_fnc_updateStance;
*/

if (!hasInterface) exitWith {};
if (!LEON_Autorun_active) exitWith {};
if (!isNull objectParent player) exitWith {};
if (getUnitFreefallInfo player select 0) exitWith {};
if (LEON_Autorun_updatingStance) exitWith {};

private ["_newStance", "_newAnimation", "_animation"];
_newStance = call LEON_Autorun_fnc_getStance;
if (_newStance select 0) then {
	LEON_Autorun_updatingStance = true;
	LEON_Autorun_stance = _newStance select 2;
	_newAnimation = player call LEON_Autorun_fnc_getAnimation;
	_animation = format ["%1_%2", LEON_Autorun_animation, _newAnimation];
	player playMoveNow _animation;
};
LEON_Autorun_updatingStance = false;
(_newStance select 0);
