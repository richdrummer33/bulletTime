// Private varialbes - DO NOT CHANGE
missionNamespace setvariable ["bTimeAvail", true]; // bullettime ready indicator
missionNamespace setvariable ["bTimeActive", false]; // indicates when bulllettime is on
missionNamespace setvariable ["reactionCooldown", false];
missionNamespace setvariable ["btPassedDammage", 0]; // Saves the amount of damage that the player had before entering bullet time mode. Value is applied back to player when godmode is enabled (no damage sustained in god mode while in BT mode)

// Public variables - CHANGE TO YOUR LIKING
missionNamespace setvariable ["autoReact", true]; // Automatically react to enemy fire and enter bullet time. Has baked-in cooldown.
missionNamespace setvariable ["tracerVision", true]; // Switch all weapon ammo to tracers while in bullet time mode
missionNamespace setvariable ["godMode", true]; // Player is invincible while in bullet time mode

ammoList = [];

nul = [] execVM "bulletTime\removeReaction.sqf"; // (reverted back) ~~~ RB 2023: Previously "\bulletTime\____.sqf", with the \ included at the beginning of the path. This caused the script to fail to execute.~~~~
nul = [] execVM "bulletTime\removeTracerVision.sqf";
nul = [] execVM "bulletTime\setGodMode.sqf";

["KeyDown", 
{	
	if ((_this select 1) == 58) then { 
		//if (missionNamespace getVariable "godMode") then
		//{
		//	_godModeBTvars = godModeBTvars;
		//	godModeBTvars = _godModeBTvars execVM "bulletTimebulletTime_godMode.sqf"; 
		//} 
		//else 
		//{
			nul = [] execVM "bulletTime\bulletTime.sqf"; 
		//};
	
	};
}] call CBA_fnc_addDisplayHandler;
{ 
	if (side _x != playerSide) then
	{
		hint "Enemy Slowmo Bullets Applied";
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
			
			// Calculate the deviation of the bullet from the player
			_pos2 = [(_pos0 select 0) + _dst * (_wdir select 0), (_pos0 select 1) + _dst * (_wdir select 1), (_pos0 select 2) + _dst * (_wdir select 2)];
			_deviation = _pos2 distance _pos1; // Distance between the bullet and the player
			
			// Is the player facing the enemy when shot at? I.e. "caught by surprise"?
			_pos3 = [(_pos1 select 0) + _dst * (_wdirp select 0), (_pos1 select 1) + _dst * (_wdirp select 1), (_pos1 select 2) + _dst * (_wdirp select 2)]; 
			_deviationPlayer = _pos3 distance _pos0; // True / false?

			// hint the deviation
			// hint format ["Deviation: %1", _deviation];

			if (_deviation < 10) then // bullet is 10 meters from player
			{
				// if ((_deviationPlayer > 10) && 
				if (missionNamespace getVariable "reactionCooldown" == false && missionNamespace getVariable "autoReact") then 
				{ 
					hint "Reaction cooldown active";
					nul = [] execVM "bulletTime\bulletTime.sqf"; 
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
				nul = [_bullet, _dst] execVM "bulletTime\slowMoBullets.sqf";
			};
			
		}] call CBA_fnc_addBISEventHandler;
	};
	
	if ((side _x == playerSide) && !(isPlayer _x)) then
	{
		hint "Detected enemy fire";
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

			// hint the _distAve
			//hint format ["_distAve: %1", _distAve];
		 	
			if ((missionNamespace getVariable "bTimeActive") && !(isPlayer _actor)) then
			{
				nul = [_bullet, _distAve] execVM "bulletTime\slowMoBullets.sqf";
			};
		}] call CBA_fnc_addBISEventHandler;
	};
	
} forEach allUnits;

fnc_replaceWithTracer = {

	hint "Replace all units with tracers";
	_weapons = weapons _this;
	
	{
		_compMags = getArray (configfile >> "CfgWeapons" >> _x >> "magazines");
		// Determine right tracer color
		_tracerColor = "red";
		switch (side _this) do
		{
			case east: {_tracerColor = "green"};
			case independent: {_tracerColor = "green"};
			case civilian: {_tracerColor = "yellow"};
			case west: {_tracerColor = "yellow"};
		};

		// Try to set the default tracer mag name (empty string if no mag with that color exists)
		_correctMag = _compMags select {toLower _x find _tracerColor > 0}; //_correctMag = _compMags select {toLower _x find "tracer" > 0};
		
		// loop through all possible tracer colors if the default did not work
		if (count _correctMag == 0) then
		{
			_possibleTracerColors = ["orange", "pink", "yellow", "white", "purple", "green", "red", ""];
			{
				_correctMag = _compMags select {toLower _x find _x > 0};
				if (count _correctMag > 0) then // BREAK OUT OF lookAtPos
				{
					_tracerColor = _x;
					_correctMag = _correctMag select 0;
				};
			} forEach _possibleTracerColors;
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