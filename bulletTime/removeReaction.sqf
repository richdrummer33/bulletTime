// Adds action to allow player to remove the bullet-time auto-react

if !(isNil "addReaction") then { [addReaction] call CBA_fnc_removePlayerAction; };

removeReaction = [["Disable bullet-time auto-react feature", 
{
	missionNamespace setvariable ["autoReact", false];
	//nul = [] execVM "\bulletTime\addReaction.sqf";
}
]] call CBA_fnc_addPlayerAction;

nul = [] spawn {sleep 10; [removeReaction] call CBA_fnc_removePlayerAction;}