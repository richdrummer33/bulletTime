addTracerVision = [["Enable tracer-vision", 
{
	missionNamespace setvariable ["tracerVision", true];
}
]] call CBA_fnc_addPlayerAction;

nul = [] spawn {sleep 15; [addTracerVision] call CBA_fnc_removePlayerAction;}