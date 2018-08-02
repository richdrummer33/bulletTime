ammoList = [];
{
	_unit = _x;
	_weapons = weapons _unit;
	_unitName = name _x;

	{	
		_currentMag = "";
		_ammoCount = 0;
		
		switch (_x) do
		{
			case primaryWeapon _unit:
			{
				_currentMag = (primaryWeaponMagazine _unit) select 0;	
				_ammoCount = _unit ammo primaryWeapon _unit;
			};
			case secondaryWeapon _unit:
			{
				_currentMag = (secondaryWeaponMagazine _unit) select 0;	
				_ammoCount = _unit ammo secondaryWeapon _unit;
			};
			case handgunWeapon _unit:
			{
				_currentMag = (handgunMagazine _unit) select 0;	
				_ammoCount = _unit ammo handgunWeapon _unit;
			};
			default
			{
			};
		};		
		
		_compMags = getArray (configfile >> "CfgWeapons" >> _x >> "magazines");
		
		if ([(side _unit),(side player)] call BIS_fnc_sideIsFriendly) then {_tracerColor = "green";} 
		else { _tracerColor = "yellow";};
		
		_correctMag = _compMags select {toLower _x find "tracer" > 0};
		if (count _correctMag == 0) exitWith {};
		
		if (count _correctMag > 0) then 
		{
			_tracerSuffix = "";
			_tracerList = [];
			{ 
				_magNameArray = toArray _x;
				_magNameArray deleteRange [0, count (toArray _currentMag)];
				_tracerSuffix = toLower (toString _magNameArray);
				_tracerList pushBack _tracerSuffix;
			} forEach _correctMag;
			
			_correctMag = _currentMag + _tracerSuffix;
		}
		else
		{
			_correctMag = _compMags select {toLower _x find "tracer" > 0};
			_correctMag = _correctMag select 0;
		};

		_magNameList = [];
		_magList = magazinesAmmoFull _unit;
		
		_magBaseName = _compMags select {toLower _x find "tracer" < 0};
		_magBaseName = _magBaseName select 0;
		
		{
			if (toLower(_x select 0) find toLower(_magBaseName) >= 0) then 
			{
				_magNameList pushBack (_x select 0);
			};
		} forEach _magList;
		
		ammoList pushBack [_unitName, _currentMag, _magNameList];
		
		_currentMags = (magazines _unit) select {_x in _compMags};
		_nonTracerMags = _currentMags select {toLower _x find "tracer" < 0};
		_amount = count _nonTracerMags;
		_tracerMags = _currentMags select {toLower _x find "tracer" > 0};

		{_unit removeMagazines _x} forEach _nonTracerMags;
		_unit addMagazines [_correctMag, _amount];
		
		switch (_x) do
		{
			case primaryWeapon _unit:
			{
				_unit removePrimaryWeaponItem ((primaryWeaponMagazine _unit) select 0);
				_unit addPrimaryWeaponItem _correctMag;
			};
			case secondaryWeapon _unit:
			{
				_unit removeSecondaryWeaponItem ((secondaryWeaponMagazine _unit) select 0);
				_unit addSecondaryWeaponItem _correctMag;
			};
			case handgunWeapon _unit:
			{
				_unit removeSecondaryWeaponItem ((handgunMagazine _unit) select 0);
				_unit addHandgunItem _correctMag;
			};
			default
			{
			};
		};
		
		_unit setAmmo [_x, _ammoCount];
		
	} forEach _weapons;
	
}forEach allUnits;
