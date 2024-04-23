/*
	Author:
		leonz2019

	Description:
		Return correction stance on unit status

	Parameters(s):
		None

	Returns:
		Select 0 - BOOLEAN: Is stance changed
		Select 1 - STRING: Current stance
		Select 2 - STRING: New stance
	
	Example:
		call LEON_Autorun_fnc_getStance;
*/

private ["_asl", "_isSit", "_currentStance", "_isCrouch", "_isProne", "_stance"];

_currentStance = stance player;
_isSit = animationState player select [1, 7] == "adjppne";
_currentStance = switch (true) do {
	case (_isSit): { "Sit" };
	case (_currentStance == "PRONE"): { "Prone" };
	case (_currentStance == "CROUCH"): { "Crouch" };
	default {"Stand"};
};

// switch stance feature
_isCrouch = inputAction "MoveUp" > 0;
_isProne = inputAction "MoveDown" > 0;
_stance = switch (true) do {
	case (_isProne && "Prone" == _currentStance): { "Stand" };
	case (_isProne): { "Prone" };
	case (_isCrouch && "Crouch" == _currentStance): { "Stand" };
	case (_isCrouch): { "Crouch" };
	case (_isProne && _isSit): { "Prone" };
	case (_isCrouch && _isSit): { "Crouch" };
	default { _currentStance };
};

// _asl < -1.2 can be crouch
// _asl < -0.5 can be prone
_asl = getPosASL player select 2;
_stance = switch (true) do {
	case (_asl <= -1.2 && _stance == "Crouch"): { "Stand" };
	case (_asl <= -0.5 && _stance == "Prone"): { "Crouch" };
	case (_asl <= -0.5 && _stance == "Sit"): { "Crouch" };
	default { _stance };
};
[_currentStance != _stance, _currentStance, _stance];
