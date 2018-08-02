removeReaction = [["Disable tracer-vision", 
{
	missionNamespace setvariable ["tracerVision", false];
	//nul = [] execVM "\bulletTime\addReaction.sqf";
}
]] call CBA_fnc_addPlayerAction;

nul = [] spawn {sleep 10; [removeReaction] call CBA_fnc_removePlayerAction;}