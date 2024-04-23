/*
	Author:
		leonz2019

	Description:
		Update swimming animation between surface, dive and bottom

	Parameters(s):
		None

	Returns:
		None
	
	Example:
		call LEON_Autorun_fnc_updateSwimAnim;
*/

if (!hasInterface) exitWith {};
if (!LEON_Autorun_active) exitWith {};
if (!LEON_Autorun_isSwim) exitWith {};
if (!isNull objectParent player) exitWith {};
if (getUnitFreefallInfo player select 0) exitWith {};

private ["_newAnimation", "_action"];
while {sleep 0.1; LEON_Autorun_isSwim && LEON_Autorun_active} do {
	_newAnimation = player call LEON_Autorun_fnc_getAnimation;
	_action = _newAnimation select [1, 3];
	if (_action in ["sdv", "bdv", "dve", "ssw", "bsw", "swm"] && { _newAnimation != LEON_Autorun_animation }) then {
		player playMoveNow _newAnimation;
	};
};
