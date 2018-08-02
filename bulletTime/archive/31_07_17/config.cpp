class CfgPatches
{
	class bulletTime
	{
		units[] = {};
		weapons[] = {};
		requiredVersion = 1.0;
		requiredAddons[] = {};

	};
};

class CfgMods
{
	class bulletTime_mod
	{
		dir = "bulletTime";
		tooltip = "Bullet-time mod";
		author = "A Bandpass Filter";
		hidePicture = true;
		hideName = false;
	};
};

class Extended_PostInit_EventHandlers
{
	bulletTime_Post_Init = "paintballRampMod_Post_Init_Var = [] execVM ""\bulletTime\init.sqf"" ";
};