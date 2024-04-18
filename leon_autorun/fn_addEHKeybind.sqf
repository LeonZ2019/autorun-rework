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
if (!isNil "LEON_Autorun_stopKeyID") exitWith {};
if (isNil "LEON_Autorun_active") then { LEON_Autorun_active = false };
if (isNil "LEON_Autorun_updatingStance") then { LEON_Autorun_updatingStance = false };
if (isNil "LEON_Autorun_displayAllow") then { LEON_Autorun_displayAllow = [12] };

[] spawn {
	waitUntil { !isNull (findDisplay 46) };

	LEON_Autorun_stopKeyID = (findDisplay 46) displayAddEventHandler ["KeyDown", {
		if (LEON_Autorun_active && count (actionKeys "LEON_Autorun_stopKey") == 0 && (call LEON_Autorun_fnc_checkDisplay) && !(inputAction "lookAroundToggle" > 0) && !(inputAction "personView" > 0) && !(inputAction "commandWatch" > 0) && !(inputAction "MoveUp" > 0) && !(inputAction "MoveDown" > 0) && !(inputAction "LEON_Autorun_disabledKey" > 0)) exitWith {
			call LEON_Autorun_fnc_onKeyDown;
			true;
		};
		if (LEON_Autorun_active && !LEON_Autorun_isSwim && (call LEON_Autorun_fnc_checkDisplay) && ((inputAction "MoveUp" > 0) || (inputAction "MoveDown" > 0))) exitWith {
			call LEON_Autorun_fnc_updateStance;
			true;
		};
		if (LEON_Autorun_active && inputAction "LEON_Autorun_stopKey" > 0 && (call LEON_Autorun_fnc_checkDisplay)) exitWith {
			call LEON_Autorun_fnc_onKeyDown;
			true;
		};
		false;
	}];

	LEON_Autorun_stopMouseID = (findDisplay 46) displayAddEventHandler ["MouseButtonDown", {
		private _handler = false;
		params ["_display", "_button"];
		if (LEON_Autorun_active && (call LEON_Autorun_fnc_checkDisplay) && _button == 0) then {
			call LEON_Autorun_fnc_onKeyDown;
			_handler = true;
		};
		_handler;
	}];
};
