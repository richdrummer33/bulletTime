removeTracerVision = [["Disable tracer-vision", 
{
	missionNamespace setvariable ["tracerVision", true];
	[removeTracerVision] call CBA_fnc_removePlayerAction;
}
]] call CBA_fnc_addPlayerAction;

nul = [] spawn {sleep 15; [removeTracerVision] call CBA_fnc_removePlayerAction;}