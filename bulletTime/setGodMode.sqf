setGodMode = [["Enable god-mode (indefinite slowmo)", 
{
	missionNamespace setvariable ["godMode", true];
	[setGodMode] call CBA_fnc_removePlayerAction;
}
]] call CBA_fnc_addPlayerAction;

nul = [] spawn {sleep 11; [setGodMode] call CBA_fnc_removePlayerAction;}