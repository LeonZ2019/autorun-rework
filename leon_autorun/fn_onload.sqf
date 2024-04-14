/*
	Author:
		leonz2019

	Description:
		Update Running image

	Parameters(s):
		Select 0 - Display: display from AutoRunIndicator

	Returns:
		None
	
	Example:
		call LEON_Autorun_fnc_onload;
*/

params ["_display"];
[_display displayCtrl 80425] spawn {
	params ["_ctrl"];
	private _id = 1;
	while { sleep 0.1; (LEON_Autorun_active || alive player) } do {
		_ctrl ctrlSetText format ["leon\autorun_rework\leon_autorun\running\run_0%1.paa", _id];
		_id = if (_id > 5) then { 1 } else { _id + 1 };
	};
};
