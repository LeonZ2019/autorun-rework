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
private ["_uniform", "_isWetSuit", "_isWater", "_isLegHits", "_atl", "_asl", "_isSA", "_isFW", "_loaded", "_fatigue", "_cw", "_pw", "_isRfl", "_isPst", "_isLnr", "_isBin", "_action", "_pose", "_movement", "_stance", "_weapon", "_direction","_name"];

_uniform = uniform _unit;
_isWetSuit = getText (configfile >> "CfgWeapons" >> _uniform >> "ItemInfo" >> "uniformType") == "Neopren";
_isWater = surfaceIsWater (position _unit);
_isLegHits = (_unit getHitPointDamage "hitlegs") >= 0.5;
_atl = ASLToATL [position _unit select 0, position _unit select 1, 0] select 2;
_asl = getPosASL _unit select 2;

_isSA = isSprintAllowed _unit;
_isFW = isForcedWalk _unit;
// _isSE = isStaminaEnabled _unit;
_loaded = load player;
_fatigue = getFatigue _unit;
_cw = currentWeapon _unit;
_pw = primaryWeapon _unit;
_isRfl = _cw == _pw;
_isPst = _cw == handgunWeapon _unit;
_isLnr = _cw == secondaryWeapon _unit;
_isBin = _cw == binocular _unit;
// _canFireUnderWater = getNumber (configfile >> "CfgWeapons" >> _cw >> "canShootInWater") == 1;

_action = switch (true) do {
	case (LEON_Autorun_stance == "Sit"): { "adj" };
	case (_isWater && _isWetSuit && _asl <= -1.65 && _atl + _asl >= -1.65 ): { "dve" };
	case (_isWater && !_isWetSuit && _atl > 1.65 && _asl <= -2.2): { "bsw" };
	case (_isWater && _isWetSuit && _atl + _asl < -1.65): { "bdv" };
	case (_isWater && !_isWetSuit && _atl > 1.65): { "ssw" };
	case (_isWater && _isWetSuit && _atl > 1.65): { "sdv" };
	default { "mov" };
};
_pose = switch (true) do {
	case (LEON_Autorun_stance == "Crouch") : { "knl" };
	case (LEON_Autorun_stance == "Prone") : { "pne" };
	case (LEON_Autorun_stance == "Sit") : { "pne" };
	default { "erc" };
};
_movement = switch (true) do {
	case (_stop): { "stp" };
	case (_isFW): { "wlk" };
	case (_loaded >= 1): { "wlk" };
	case (LEON_Autorun_stance == "Sit") : { "wlk" };
	case (_fatigue == 1): { "run" };
	case (_isWater && LEON_Autorun_stance == "Stand" && _isLnr): { "eva" };
	case (_isWater && LEON_Autorun_stance == "Prone" && _isPst): { "spr" };
	case (_isWater && LEON_Autorun_stance == "Prone"): { "eva" };
	case (_isWater && _atl > 1.2 && _atl <= 1.65 && _isLegHits): { "lmp" };
	case (_isWater && _atl > 1.2 && _atl <= 1.65 && !_isLegHits): { "run" };
	case (_isWater && _atl > 1.2 && _atl <= 1.65 && _isWetSuit): { "eva" };
	case (_isWater && _atl > 1.65 && !_isWetSuit): { "run" };

	case (_isBin && _atl <= 1.2): { "eva" };
	case (_isWater && _atl > 1.65 && _isWetSuit && _isLegHits): { "wlk" };
	case (_isWater && _atl > 1.65 && _isWetSuit && !_isLegHits): { "spr" };
	case (_isWater && _atl < 1.65 && !_isLegHits): { "run" };
	case (_isLegHits): { "lmp" };
	case (_isPst && LEON_Autorun_stance == "Prone" && _fatigue == 1): { "run" };
	case (_isPst && LEON_Autorun_stance == "Prone" && _fatigue < 1): { "spr" };
	case (_isSA && !_isWater && _fatigue < 1): { "eva" };
	default { "run" };
};
_stance = switch (true) do {
	case (_action in ["sdv", "ssw"]): { "non" };
	case (_isBin): { "non" };
	case (LEON_Autorun_stance == "Sit"): { "ras" };
	case (_isLnr && (_stop || _fatigue == 1)): { "ras" };
	case (_isLnr && _fatigue < 1 && _movement == "eva"): { "low" };
	case (_isLnr && _fatigue < 1 && _movement == "run"): { "ras" };
	case (_cw != "" && _atl > 1.65): { "non" };
	case (_isPst && LEON_Autorun_stance == "Prone"): { "low" };
	case (_isPst && LEON_Autorun_stance == "Crouch"): { "ras" };
	case (_isLnr && LEON_Autorun_stance == "Crouch" && (_isWater || _fatigue == 1)): { "ras" };
	case (_cw != ""): { "low" };
	default { "non" };
};
_weapon = switch (true) do {
	case (_action == "sdv" && _pw != ""): { "rfl" };
	case (!_isWetSuit && _atl > 1.65): { "non" };
	case (_cw == ""): { "non" };
	case (_isRfl): { "rfl" };
	case (_isPst): { "pst" };
	case (_isLnr): { "lnr" };
	case (_isBin): { "bin" };
	default { "rfl" };
};

_direction = switch (true) do {
	case (LEON_Autorun_stance == "Sit" && _stop): { "up" };
	case (_stop): { "non" };
	case (LEON_Autorun_stance == "Sit"): { "up_f" };
	default { "f" };
};

_name = format ["a%1p%2m%3s%4w%5d%6", _action, _pose, _movement, _stance, _weapon, _direction];
_name;
