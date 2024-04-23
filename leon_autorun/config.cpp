class CfgPatches
{
	class LEON_AutorunRework
	{
		author = "Leon & Legion";
		name = "Autorun Rework";
		requiredAddons[] = {"A3_Functions_F"};
		requiredVersion = 0.50;
		units[] = {};
		weapons[] = {};
	};
};
class CfgFunctions
{
	class LEON_Autorun
	{
		class Autorun_rework
		{
			file = "\leon\autorun_rework\leon_autorun";
			class addEHKeybind {
				preInit = 1;
			};
			class checkDisplay {};
			class getAnimation {};
			class getStance {};
			class onKeyDown {};
			class onload {};
			class stopRunning {};
			class swimToLand {};
			class updateStance {};
			class updateSwimAnim {};
		};
	};
};
class CfgUserActions
{
	class LEON_Autorun_Key
	{
		displayName = "Auto Run Key";
		tooltip = "Activate auto run feature.";
		onActivate = "[true] call LEON_Autorun_fnc_onKeyDown";
		onDeactivate = "";
		onAnalog = "";
		analogChangeThreshold = 0.1;
	};
	class Leon_Autorun_walkKey
	{
		displayName = "Auto Walk Key";
		tooltip = "Activate auto walk feature.";
		onActivate = "[false] call LEON_Autorun_fnc_onKeyDown";
		onDeactivate = "";
		onAnalog = "";
		analogChangeThreshold = 0.1;
	};
	class LEON_Autorun_disabledKey
	{
		displayName = "Disabled Key";
		tooltip = "Key ignore by Autorun.";
		onActivate = "";
		onDeactivate = "";
		onAnalog = "";
		analogChangeThreshold = 0.1;
	};
	class LEON_Autorun_stopKey
	{
		displayName = "Stop Key";
		tooltip = "Stop the run if it is activated.";
		onActivate = "";
		onDeactivate = "";
		onAnalog = "";
		analogChangeThreshold = 0.1;
	};
};
class CfgDefaultKeysPresets
{
	class Arma2
	{
		class Mappings
		{
			LEON_Autorun_Key[] = {
				0x3F
			};
			Leon_Autorun_walkKey[] = {
				0x40
			};
			LEON_Autorun_disabledKey[] = {
				0x18, // watch
				"256 + 0x18", // watch (toggle)
				0x25, // compass
				"256 + 0x25", // compass (toggle)
				0x32, // map
				0x31 // night vision

			};
			LEON_Autorun_stopKey[] = {};
		};
	};
};
class UserActionGroups
{
	class Leon_AutoRun_KeyCategory
	{
		name = "Autorun Rework";
		isAddon = 1;
		group[] = {"Leon_Autorun_Key", "Leon_Autorun_walkKey", "LEON_Autorun_disabledKey", "LEON_Autorun_stopKey"};
	};
};
class RscTitles
{
	class AutoRunIndicator
	{
		duration = 1e+6;
		idd = 80424;
		movingEnable = 0;
		onLoad = "_this call LEON_Autorun_fnc_onload";
		enableSimulation = 1;
		fadein = 0;
		fadeOut = 0;
		class controls
		{
			class Info
			{
				idc = -1;
				type = 0;
				style = 2;
				x = 0;
				y = 0.75;
				w = 1;
				h = 0.25;
				font = "robotoCondensed";
				sizeEx = 0.035;
				colorBackground[] = {0,0,0,0};
				colorText[] = {1,1,1,1};
				text = "PRESS ANY KEY TO STOP";
			};
			class Indicator
			{
				idc = 80425;
				type = 0;
				style = 2096;
				colorBackground[] = {0,0,0,0};
				colorText[] = {1,1,1,1};
				deletable = 0;
				font = "robotoCondensed";
				sizeEx = 0.004;
				text = "leon\autorun_rework\leon_autorun\running\run_01.paa";
				x = 0;
				y = 0.8;
				w = 1;
				h = 0.05;
			};
		};
	};
};
