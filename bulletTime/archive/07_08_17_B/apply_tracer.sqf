//ammoList resize 0;
{
	_unit = _x;
	_weapons = weapons _unit;
	_unitName = name _x;
	_x = primaryWeapon _unit;
	_correctMag = "";
	_tracerColor = "";
	_exitWithVar = false;
	_tracerMags = [];
	
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
		
		if ([(side _unit),(side player)] call BIS_fnc_sideIsFriendly) then {_tracerColor = "red";} 
		else { _tracerColor = "green";};
		
		_compStr = _compMags joinString " ";
		
		if (toLower _compStr find "tracer" > 0) then {
			_tracerMags = _compMags select {toLower _x find "tracer" > 0};
		};
		
		if (count _tracerMags > 0) then 
		{
			_tracerMagColoured = _tracerMags select {toLower _x find toLower(_tracerColor) >= 0};
			
			if (count _tracerMagColoured > 0) then 
			{
				_correctMag = _tracerMagColoured select 0;
			}
			else
			{
				_correctMag = _tracerMags select 0;
			};
			
			_magNameAmmoList = [];
			_magList = magazinesAmmo _unit;
			_compMagsString = toLower(_compMags joinString " ");

			{
				if (_compMagsString find toLower (_x select 0) >= 0) then
				{
					_magNameAmmoList pushBack _x; _unit removeMagazines (_x select 0);
				}
			} forEach _magList;
			
			_unit addMagazines [_correctMag, count _magNameAmmoList];
			
			ammoList pushBack [_unitName, _currentMag, _magNameAmmoList, _correctMag];
			
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
		};
		
}forEach allUnits;
