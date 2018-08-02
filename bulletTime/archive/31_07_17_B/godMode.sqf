godMode = [["Enable god mode (unlimited bullet-time)", 
{
	missionNamespace setvariable ["godMode", true];
}
]] call CBA_fnc_addPlayerAction;

sleep 15; 
[godMode] call CBA_fnc_removePlayerAction; 