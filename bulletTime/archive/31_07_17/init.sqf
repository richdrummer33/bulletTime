missionNamespace setvariable ["bTimeAvail", true]; // bullettime ready indicator
missionNamespace setvariable ["bTimeActive",false]; // indicates when bulllettime is on
missionNamespace setvariable ["reactionCooldown",false];
missionNamespace setvariable ["btPassedDammage", 0];
missionNamespace setvariable ["autoReact", true];
ammoList = [];

nul = [] execVM "\bulletTime\removeReaction.sqf";

["KeyDown", 
{	
	if ((_this select 1) == 58) then { 
		//if (missionNamespace getVariable "godMode") then
		//{
		//	_godModeBTvars = godModeBTvars;
		//	godModeBTvars = _godModeBTvars execVM "\bulletTime\bulletTime_godMode.sqf"; 
		//} 
		//else 
		//{
			nul = [] execVM "\bulletTime\bulletTime.sqf"; 
			hint "called";
		//};
	
	};
}] call CBA_fnc_addDisplayHandler;

{ 
	if (side _x != playerSide) then
	{
		nul = [_x, "FiredMan", 
		{		
			_actor = _this select 0;
			_bullet = _this select 6;	
				
			_wpn = _this select 1;
			_wpnp = currentWeapon player;
			_pos0 = getPosASL _actor;
			_pos1 = getPosASL player;
			_wdir = _actor weaponDirection _wpn;
			_wdirp = player weaponDirection _wpnp;
			_dst = _pos0 distance _pos1;
			
			_pos2 = [(_pos0 select 0) + _dst * (_wdir select 0), (_pos0 select 1) + _dst * (_wdir select 1), (_pos0 select 2) + _dst * (_wdir select 2)];
			_deviation = _pos2 distance _pos1;
			
			
			_pos3 = [(_pos1 select 0) + _dst * (_wdirp select 0), (_pos1 select 1) + _dst * (_wdirp select 1), (_pos1 select 2) + _dst * (_wdirp select 2)];
			_deviationPlayer = _pos3 distance _pos0;
	
			if (_deviation < 5) then
			{
				if ((_deviationPlayer > 10) && !(missionNamespace getVariable "reactionCooldown" ) && (missionNamespace getVariable "autoReact")) then 
				{ 
					nul = [] execVM "\bulletTime\bulletTime.sqf"; 
				};
				
				nul = [] spawn 
				{ 
					_j = 0;
					while{ _j < 750} do   
					{ 
						missionNamespace setvariable ["reactionCooldown",true];
						sleep 0.01; _j = _j + 1;  
					};   
					missionNamespace setvariable ["reactionCooldown",false]; 
				};
				
			};
			
			// Slowmo bullet feature 
			if (missionNamespace getVariable "bTimeActive") then
			{
				nul = [_bullet, _dst] execVM "\bulletTime\slowMoBullets.sqf";
			};
			
		}] call CBA_fnc_addBISEventHandler;
	};
	
	if ((side _x == playerSide) && !(isPlayer _x)) then
	{
		nul = [_x, "FiredMan", 
		{	
			_actor = _this select 0;
			_bullet = _this select 6;	
			
			_targets = _actor nearTargets 150;
			_posFriend = getPos _actor;
			_distTot = 0;
			_distAve = 500;
			
			_cnt = count _targets;
			
			if (_cnt != 0) then
			{
				{	
					_posEn = _x select 0;
					_distToTarg = _posFriend distance _posEn;
					_distTot = _distTot + _distToTarg;
				} forEach _targets;
				
				_distAve = _distTot/_cnt;
			};
		 	
			if ((missionNamespace getVariable "bTimeActive") && !(isPlayer _actor)) then
			{
				nul = [_bullet, _distAve] execVM "\bulletTime\slowMoBullets.sqf";
			};
		}] call CBA_fnc_addBISEventHandler;
	};
	
} forEach allUnits;

fnc_replaceWithTracer = {

	_weapons = weapons _this;
	
	{
		_compMags = getArray (configfile >> "CfgWeapons" >> _x >> "magazines");
		// Determine right tracer color
		_tracerColor = "red";
		switch (side _this) do
		{
			case east: {_tracerColor = "green"};
			case independent: {_tracerColor = "green"};
		};
		// Find correct tracer mag name
		_correctMag = _compMags select {toLower _x find "tracer" > 0};
		if (count _correctMag == 0) exitWith {/*No tracer mags for this weapon*/};
		_correctMag = _compMags select {toLower _x find _tracerColor > 0};
		if (count _correctMag > 0) then {
			_correctMag = _correctMag select 0;
		} else {
			_correctMag = _compMags select {toLower _x find "tracer" > 0};
			_correctMag = _correctMag select {toLower _x find "red" < 0 && toLower _x find "green" < 0 && toLower _x find "yellow" < 0};
			_correctMag = _correctMag select 0;
		};

		// Add magazines and remove non tracer ones
		_currentMags = (magazines _this) select {_x in _compMags};
		_nonTracerMags = _currentMags select {toLower _x find "tracer" < 0};
		_amount = count _nonTracerMags;
		_tracerMags = _currentMags select {toLower _x find "tracer" > 0};

		{_this removeMagazines _x} forEach _nonTracerMags;
		_this addMagazines [_correctMag, _amount];

		switch (_x) do
		{
			case primaryWeapon _this:
			{
				_this removePrimaryWeaponItem ((primaryWeaponMagazine _this) select 0);
				_this addPrimaryWeaponItem _correctMag;
			};
			case secondaryWeapon _this:
			{
				_this removeSecondaryWeaponItem ((secondaryWeaponMagazine _this) select 0);
				_this addSecondaryWeaponItem _correctMag;
			};
			case handgunWeapon _this:
			{
				_this removeSecondaryWeaponItem ((handgunMagazine _this) select 0);
				_this addHandgunItem _correctMag;
			};
			default
			{
				/* maybe lasermarker? */
			};
		};
		
	} forEach _weapons;
};