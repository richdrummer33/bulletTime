{
	_unit = _x;
	_weapons = weapons _unit;
	_unitName = name _x;
	_magList = magazines _unit;
	_totalMagCount = 0;
	_ammoList = _this select 0;
						
	_previousMag = "";
	_magNameList = [];
	_ammoCount = 0;
	
		
		{ 
			if ((_x select 0) isEqualTo _unitName) then
			{
				_previousMag = (_x select 1);
				_magNameList = (_x select 2);
			}  
		} forEach _ammoList;
					
		{  	
			if (toLower _x find toLower "tracer" >= 0 ) then
			{
				_unit removeMagazine _x;
				_totalMagCount = _totalMagCount + 1;
				hint format ["%1", _totalMagCount];
			}
		} forEach magazines _unit;

		for "_i" from 1 to _totalMagCount do
		{		
			_magName = _magNameList select _i;
			_unit addMagazine _magName;
			hint format ["%1", _i];
		};
	
	{	
		switch (_x) do
		{
			case primaryWeapon _unit:
			{
				_ammoCount = _unit ammo primaryWeapon _unit;
				_unit removePrimaryWeaponItem ((primaryWeaponMagazine _unit) select 0);
				_unit addPrimaryWeaponItem _previousMag;
			};
			case secondaryWeapon _unit:
			{
				_ammoCount = _unit ammo secondaryWeapon _unit;
				_unit removeSecondaryWeaponItem ((secondaryWeaponMagazine _unit) select 0);
				_unit addSecondaryWeaponItem _previousMag;
			};
			case handgunWeapon _unit:
			{
				_ammoCount = _unit ammo handgunWeapon _unit;
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