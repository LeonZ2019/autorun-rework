/*
	Author:
		leonz2019

	Description:
		Add Vanilla keybind & setup default variable

	Parameters(s):
		None

	Returns:
		None
	
	Example:
		call LEON_Autorun_fnc_addEHKeybind;
*/

if (!hasInterface) exitWith {};
if (!isNil "LEON_Autorun_keyDownID") exitWith {};
if (isNil "LEON_Autorun_active") then { LEON_Autorun_active = false };
if (isNil "LEON_Autorun_updatingStance") then { LEON_Autorun_updatingStance = false };

[] spawn {
	waitUntil { !isNull (findDisplay 46) };

	LEON_Autorun_stopKeyID = (findDisplay 46) displayAddEventHandler ["KeyDown", {
		_handler = false;
		if (LEON_Autorun_active && isNull (findDisplay 312) && isNull (findDisplay 60492) && isNull (findDisplay 632) && isNull (findDisplay 602) && isNull (findDisplay 160) && !(inputAction "lookAroundToggle" > 0) && !(inputAction "personView" > 0) && !(inputAction "commandWatch" > 0) && !(inputAction "MoveUp" > 0) && !(inputAction "MoveDown" > 0)) then {
			call LEON_Autorun_fnc_onKeyDown;
			_handler = true;
		};
		if (LEON_Autorun_active && !LEON_Autorun_isSwim && ((inputAction "MoveUp" > 0) || (inputAction "MoveDown" > 0))) then {
			call LEON_Autorun_fnc_updateStance;
			_handler = true;
		};
		_handler;
	}];

	LEON_Autorun_stopMouseID = (findDisplay 46) displayAddEventHandler ["MouseButtonDown", {
		_handler = false;
		params ["_display", "_button"];
		if (LEON_Autorun_active && _button == 0) then {
			call LEON_Autorun_fnc_onKeyDown;
			_handler = true;
		};
		_handler;
	}]
};
