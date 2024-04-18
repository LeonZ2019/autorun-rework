/*
	Author:
		leonz2019

	Description:
		Check the visible display

	Parameters(s):
		None

	Returns:
		BOOLEAN: TRUE if whole list from LEON_Autorun_displayAllow is closed
	
	Example:
		call LEON_Autorun_fnc_checkDisplay;
*/

private _isDisplayClosed = true;
{
	if (_x == 12) then {
		_isDisplayClosed = !visibleMap;
	} else {
		if (_isDisplayClosed) then {
			_isDisplayClosed = isNull (findDisplay _x);
		};
	};
} forEach (LEON_Autorun_displayAllow select { typeName _x == "SCALAR" && _x >= 0 });
_isDisplayClosed;