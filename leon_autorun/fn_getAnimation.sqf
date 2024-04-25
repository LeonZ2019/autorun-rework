/*
	Author:
		leonz2019

	Description:
		Return correction animation based on unit status

	Parameters(s):
		Select 0 - Object: Must be unit
		Select 1 (OPTIONAL) - Boolean: TRUE if need stop

	Returns:
		STRING: Animation name
	
	Example:
		[player, true] call LEON_Autorun_fnc_getAnimation;
*/

params ["_unit", ["_stop", false, [false]]];
private ["_uniform", "_isWetSuit", "_isWater", "_isLegHits", "_atl", "_asl", "_uw", "_isSA", "_isFW", "_terrainAngle", "_loaded", "_fatigue", "_cw", "_isRfl", "_isPst", "_isLnr", "_isBin", "_action", "_pose", "_movement", "_stance", "_weapon", "_direction","_name"];

_uniform = uniform _unit;
_isWetSuit = getText (configfile >> "CfgWeapons" >> _uniform >> "ItemInfo" >> "uniformType") == "Neopren";
_isWater = surfaceIsWater (position _unit);
_isLegHits = (_unit getHitPointDamage "hitlegs") >= 0.5;
_atl = ASLToATL [position _unit select 0, position _unit select 1, 0] select 2;
_asl = eyePos _unit select 2;
_uw = underwater _unit;

_isSA = isSprintAllowed _unit;
_isFW = (isForcedWalk _unit || LEON_Autorun_type == 1);
_terrainAngle = [getPos _unit, getDir _unit] call BIS_fnc_terrainGradAngle;
_loaded = load _unit;
_fatigue = getFatigue _unit;
if (_terrainAngle >= 30) then {
	_isFW = true;
} else {
	if (_terrainAngle >= 17) then {
		_fatigue = 1;
	};
};
if (LEON_Autorun_type == 2) then {
	_fatigue = 1;
};
_cw = currentWeapon _unit;
_isRfl = _cw != "" && _cw == primaryWeapon _unit;
_isPst = _cw != "" && _cw == handgunWeapon _unit;
_isLnr = _cw != "" && _cw == secondaryWeapon _unit;
_isBin = _cw != "" && _cw == binocular _unit;

_action = switch (true) do {
	case (LEON_Autorun_stance == "Sit"): { "adj" };

	case (_isWater && _atl >= 1.7 && _isWetSuit && !_uw): { "sdv" };
	case (_isWater && _atl >= 1.7 && _isWetSuit && _uw && _atl >= 2 && _asl / _atl <= -0.6): { "bdv" };
	case (_isWater && _atl >= 1.7 && _isWetSuit && _uw): { "dve" };

	case (_isWater && _atl >= 1.7 && !_isWetSuit && !_uw): { "ssw" };
	case (_isWater && _atl >= 1.7 && !_isWetSuit && _uw && _atl >= 2 && _asl / _atl <= -0.6): { "bsw" };
	case (_isWater && _atl >= 1.7 && !_isWetSuit && _uw): { "swm" };

	default { "mov" };
};

_pose = switch (true) do {
	case (_action in ["sdv", "bdv", "dve", "ssw", "bsw", "swm"]): { "erc" };
	case (LEON_Autorun_stance == "Crouch"): { "knl" };
	case (LEON_Autorun_stance == "Prone"): { "pne" };
	case (LEON_Autorun_stance == "Sit"): { "pne" };
	default { "erc" };
};
_movement = switch (true) do {
	case (_stop): { "stp" };
	case (LEON_Autorun_stance == "Sit"): { "wlk" };

	case (!_isFW && _fatigue < 1 && _isWetSuit && _action in ["sdv", "bdv", "dve", "ssw", "bsw", "swm"]): { "spr" };
	case (!_isFW && _fatigue == 1 && _isWetSuit && _action in ["sdv", "bdv", "dve", "ssw", "bsw", "swm"]): { "run" };
	case (!_isFW && _fatigue < 1 && !_isWetSuit && _action in ["sdv", "bdv", "dve", "ssw", "bsw", "swm"]): { "run" };
	case (!_isFW && _fatigue == 1 && !_isWetSuit && _action in ["sdv", "bdv", "dve", "ssw", "bsw", "swm"]): { "wlk" };
	case ((_isFW || _isLegHits) && _action in ["dve", "sdv", "ssw", "bdv"]): { "wlk" };

	case (_isLegHits && LEON_Autorun_stance == "Prone" && _isBin): { "wlk" };
	case (_isLegHits && LEON_Autorun_stance == "Prone"): { "run" };
	case (_isLegHits): { "lmp" };

	case (_isFW && LEON_Autorun_stance == "Prone" && !_isBin): { "run" };
	case (_isFW): { "wlk" };

	case (_fatigue < 1 && _cw == "" && LEON_Autorun_stance == "Prone"): { "spr" };
	case (_fatigue < 1): { "eva" };

	case (_fatigue == 1 && _isRfl && LEON_Autorun_stance == "Prone"): { "spr" };
	case (_fatigue == 1): { "run" };
	default { "run" };
};

_stance = switch (true) do {
	case (_action in ["sdv", "bdv", "dve", "ssw", "bsw", "swm"]): { "non" };
	case (_isBin && _movement != "run" && _movement != "eva"): { "opt" };
	case (_isBin): { "non" };
	case (LEON_Autorun_stance == "Sit"): { "ras" };
	case (_cw == ""): { "non" };
	case (_isLnr && _movement == "eva"): { "low" };
	case (_isLnr): { "ras" };
	case (_isLegHits && (_isRfl || _isPst)): { "low" };
	case ((_pose == "pne" || _isFW) && (_isRfl || _isPst)): { "low" };
	case (_pose != "pne" && (_isRfl || _isPst)): { "ras" };
	default { "low" };
};
_weapon = switch (true) do {
	case (_cw == ""): { "non" };
	case (_isRfl): { "rfl" };
	case (_isPst): { "pst" };
	case (_isLnr): { "lnr" };
	case (_isBin): { "bin" };
	default { "non" };
};
_direction = switch (true) do {
	case (LEON_Autorun_stance == "Sit" && _stop): { "up" };
	case (_stop): { "non" };
	case (LEON_Autorun_stance == "Sit"): { "up_f" };
	case (!(_action in ["sdv", "bdv", "dve", "ssw", "bsw", "swm"]) &&_movement == "wlk" && _isRfl && _pose == "erc"): { "f_ver2" };
	default { "f" };
};

_name = format ["a%1p%2m%3s%4w%5d%6", _action, _pose, _movement, _stance, _weapon, _direction];
_name;
