if !(isNil "removeReaction") then { [removeReaction] call CBA_fnc_removePlayerAction; };

addReaction = [["Enable bullet-time auto-react feature", 
{
	missionNamespace setvariable ["autoReact", true];
	nul = [] execVM "\bulletTime\removeReaction.sqf";
}
]] call CBA_fnc_addPlayerAction;