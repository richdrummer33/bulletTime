if (missionNamespace getvariable ["bTimeAvail",true]) then 
{
		sleep 0.1;
			{ _x  call fnc_replaceWithTracer; } forEach allUnits;
			_damage = getDammage player;
			playSound3D ["bulletTime\sounds\powerdown.wav", player, false, getPosASL player, 5, 1, 0]; 
			hint "BULLET-TIME!!!";
			player setDammage 0; 
			missionNamespace setvariable ["btPassedDammage", _damage];
			setAccTime 0.8;
			player setAnimSpeedCoef 1.25;
			chromAb =  ["ChromAberration", 1000, [0.03, 0.02, true]] call compile preprocessFileLineNumbers "\bulletTime\chromAb.sqf";
			chromAb ppEffectCommit 10;
			_ammoList = [] execVM "\bulletTime\apply_tracer.sqf";
			//waitUntil {ppEffectCommitted chromAb};
			// nul = [] execVM "radialBlur.sqf";
		sleep 0.33;
			setAccTime 0.6;	
			player setAnimSpeedCoef 1.67;
		sleep 0.33;
			setAccTime 0.4; 
			player setAnimSpeedCoef 2;
			missionNamespace setvariable ["bTimeAvail",false]; 
			missionNamespace setvariable ["bTimeActive",true]; 
		sleep 3;
			if (missionNamespace getvariable ["bTimeActive",true]) then { playSound3D ["bulletTime\sounds\powerup.wav", player, false, getPosASL player, 5, 1, 0]; };
			player setAnimSpeedCoef 1.67;
			setAccTime 0.6;	
			chromAb ppEffectAdjust [0.0133, 0.0133, true];
		sleep 0.33;
			player setAnimSpeedCoef 1.25;
			setAccTime 0.8;	
			chromAb ppEffectAdjust [0.0067, 0.0067, true];
		sleep 0.33;
			player setDammage _damage;
			player setAnimSpeedCoef 1;
			setAccTime 1; 
			missionNamespace setvariable ["bTimeActive",false];
			chromAb ppEffectAdjust [0.0025, 0.0025, true];
		sleep 0.33;
			chromAb ppEffectEnable false;
			ppEffectDestroy [chromAb];
		sleep 0.5;
			hint "bullet-time recovering!";
		sleep 4.5; 
			hint "";
		sleep 4;
			missionNamespace setvariable ["bTimeAvail",true];
			if (missionNamespace getvariable ["bTimeAvail",true]) then {hint "bullet-time available!";};
		sleep 3;
			hint "";
} 
else
{
	if (missionNamespace getvariable ["bTimeActive",true]) then 
	{
		// { _x  call fnc_replaceWithNonTracer; } forEach allUnits;
		setAccTime 1; 
		player setAnimSpeedCoef 1;
		sleep 0.1;
			nul = [_ammoList] execVM "\bulletTime\resetAmmo.sqf";
			chromAb ppEffectEnable false;
			ppEffectDestroy [chromAb];
			hint ""; // clear messages
			playSound3D ["bulletTime\sounds\powerup.wav", player, false, getPosASL player, 5, 1, 0];
			missionNamespace setvariable ["bTimeActive",false];
			missionNamespace setvariable ["bTimeAvail",false]; 
		sleep 5; 
			missionNamespace setvariable ["bTimeAvail",true];
	}
	else
	{
		sleep 0.1;
			hint "bullet-time recovering!";
		sleep 3; 
			hint "";
	};
};