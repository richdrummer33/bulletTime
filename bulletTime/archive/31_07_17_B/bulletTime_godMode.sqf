	_damage = _this select 0;
	_chromAb = _this select 1;

	if (missionNamespace getvariable ["bTimeActive",true]) then 
	{
		_chromAb ppEffectAdjust [0.0133, 0.0133, true];
		setAccTime 1; 
		player setAnimSpeedCoef 1;
		player setDammage _damage;
		sleep 0.1;
			hint ""; // clear messages
			playSound3D ["bulletTime\sounds\powerup.wav", player, false, getPosASL player, 5, 1, 0];
			missionNamespace setvariable ["bTimeActive",false];
			_chromAb ppEffectEnable false;
			ppEffectDestroy [_chromAb];
	}
	else
	{
		sleep 0.1;
			_damage = getDammage player;
			playSound3D ["bulletTime\sounds\powerdown.wav", player, false, getPosASL player, 5, 1, 0]; 
			hint "BULLET-TIME!!!";
			player setDammage 0; 
			missionNamespace setvariable ["btPassedDammage", _damage];
			setAccTime 0.8;
			player setAnimSpeedCoef 1.25;
			_chromAb =  ["ChromAberration", 1000, [0.03, 0.02, true]] call compile preprocessFileLineNumbers "chromAb.sqf";
			_chromAb ppEffectCommit 10;
		sleep 0.33;
			setAccTime 0.6;	
			player setAnimSpeedCoef 1.67;
		sleep 0.33;
			setAccTime 0.4; 
			player setAnimSpeedCoef 2;
			missionNamespace setvariable ["bTimeActive",true]; 
			[_damage, _chromAb];
	};
