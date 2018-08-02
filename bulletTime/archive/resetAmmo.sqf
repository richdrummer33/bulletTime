{
	_unit = _x;
	_weapons = weapons _unit;
	_magAmmoList = magazinesAmmo _unit;
	_unitName = name _x;

	_previousMag = "";
	_magNameList = [];
	_ammoCount = 0;
	
	{	
		{ 
			if ((_x select 0) isEqualTo _unitName) then
			{
				_previousMag = (_x select 1);
				_magNameList = (_x select 2);
			}  
		} forEach ammoList;
		magNameList = _magNameList;		
	
		
		switch (_x) do
		{
			case primaryWeapon _unit:
			{
				_ammoCount = _unit ammo primaryWeapon _unit;
			};
			case secondaryWeapon _unit:
			{
				_ammoCount = _unit ammo secondaryWeapon _unit;
			};
			case handgunWeapon _unit:
			{
				_ammoCount = _unit ammo handgunWeapon _unit;
			};
			default
			{
			};
		};		
		
		_compMags = getArray (configfile >> "CfgWeapons" >> _x >> "magazines");
		
		_tracerMags = _compMags select {toLower _x find "tracer" > 0};
		

		_magList = magazines _unit;
		_magTracerName = _magList select {toLower _x find "tracer" > 0};
		hint format ["%1", _magTracerName];
		
		_ind = 1;
		
		_unit removeMagazines _magTracerName;
		_magBaseName = "";
		
		{
			if (((_x select 0) find _magTracerName >= 0) && (_ind < (count _magNameList - 1))) then 
			{
				_magName = _magNameList select _ind;
				_unit addMagazine _magName;
				_ind = _ind + 1;
			}
		} forEach _magList;
		
		switch (_x) do
		{
			case primaryWeapon _unit:
			{
				_unit removePrimaryWeaponItem ((primaryWeaponMagazine _unit) select 0);
				_unit addPrimaryWeaponItem _previousMag;
			};
			case secondaryWeapon _unit:
			{
				_unit removeSecondaryWeaponItem ((secondaryWeaponMagazine _unit) select 0);
				_unit addSecondaryWeaponItem _previousMag;
			};
			case handgunWeapon _unit:
			{
				_unit removeSecondaryWeaponItem ((handgunMagazine _unit) select 0);
				_unit addHandgunItem _previousMag;
			};
			default
			{
			};
		};
		
		_unit setAmmo [_x, _ammoCount];
		
	} forEach _weapons;
	
} forEach allUnits;