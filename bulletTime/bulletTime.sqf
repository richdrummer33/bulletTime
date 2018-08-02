if (missionNamespace getvariable ["bTimeAvail",true]) then 
{           
            missionNamespace setvariable ["bTimeAvail",false]; 
            missionNamespace setvariable ["bTimeActive",true]; 
            if (missionNamespace getvariable ["tracerVision",true]) then { nul = call compile preprocessFileLineNumbers "bulletTime\apply_tracer.sqf"; };
            
        sleep 0.1;
            damagePlyr = getDammage player;
            playSound3D ["bulletTime\sounds\powerdown.wav", player, false, getPosASL player, 5, 1, 0]; 
            hint "BULLET-TIME!!!";
            player setDammage 0; 
            missionNamespace setvariable ["btPassedDammage", damagePlyr];
            setAccTime 0.8;
            player setAnimSpeedCoef 1.25;
            chromAb =  ["ChromAberration", 1000, [0.03, 0.02, true]] call compile preprocessFileLineNumbers "bulletTime\chromAb.sqf";
            chromAb ppEffectCommit 10;
        sleep 0.33;
            setAccTime 0.6; 
            player setAnimSpeedCoef 1.67;
        sleep 0.33;
            setAccTime 0.4; 
            player setAnimSpeedCoef 2;
        sleep 4.4;
            if (missionNamespace getVariable "godMode") exitWith {chromAb ppEffectAdjust [0.0133, 0.0133, true]; sleep 0.33; chromAb ppEffectAdjust [0.0067, 0.0067, true]; sleep 0.33; chromAb ppEffectAdjust [0.0025, 0.0025, true];};
            if (missionNamespace getvariable ["bTimeActive",true]) then { playSound3D ["bulletTime\sounds\powerup.wav", player, false, getPosASL player, 5, 1, 0]; };
            player setAnimSpeedCoef 1.67;
            setAccTime 0.6; 
            chromAb ppEffectAdjust [0.0133, 0.0133, true];
        sleep 0.33;
            player setAnimSpeedCoef 1.25;
            setAccTime 0.8; 
            chromAb ppEffectAdjust [0.0067, 0.0067, true];
        sleep 0.33;
            player setDammage damagePlyr;
            player setAnimSpeedCoef 1;
            setAccTime 1; 
            if ((missionNamespace getvariable ["bTimeActive",true]) && (missionNamespace getvariable ["bulletTime\tracerVision",true])) then 
            {  nul = call compile preprocessFileLineNumbers  "bulletTime\resetAmmo.sqf";  };
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
		 sleep 0.1;
            if (missionNamespace getvariable ["tracerVision",true]) then { nul = call compile preprocessFileLineNumbers "bulletTime\resetAmmo.sqf"; };
            hint "";
            playSound3D ["bulletTime\sounds\powerup.wav", player, false, getPosASL player, 5, 1, 0];
			
			missionNamespace setvariable ["bTimeActive",false];
			if (!(missionNamespace getVariable "godMode")) then { missionNamespace setvariable ["bTimeAvail",false]; };
		    player setAnimSpeedCoef 1.67;
            setAccTime 0.6; 
		sleep 0.23;
            player setAnimSpeedCoef 1.25;
            setAccTime 0.8; 
		sleep 0.33;
			player setDammage damagePlyr;
            player setAnimSpeedCoef 1;
            setAccTime 1; 
			chromAb ppEffectEnable false; ppEffectDestroy [chromAb];
		if (missionNamespace getVariable "godMode") then {
			sleep 0.1; missionNamespace setvariable ["bTimeAvail",true];
		} else {
			sleep 4.5; missionNamespace setvariable ["bTimeAvail",true];
		};
    }
    else
    {
		if (!(missionNamespace getVariable "godMode")) then 
		{
			sleep 0.1;
				hint "bullet-time recovering!";
			sleep 3; 
				hint "";
		};
    };
};