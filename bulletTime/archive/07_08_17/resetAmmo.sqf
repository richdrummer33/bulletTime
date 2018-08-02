{
    _unit          = _x;
    _weapons       = weapons _unit;
    _unitName      = name _x;
    _totalMagCount = 0;
    _magList       = magazines _unit;   
    _primWeap      = primaryWeapon _unit;  
                        
    _previousMag     = "";  
    _magNameAmmoList = [];
    _ammoCount       = 0;
    _magDetail       = [];
    
    _compMags    = getArray (configfile >> "CfgWeapons" >> _primWeap >> "magazines");
    _magBaseName = _compMags select {toLower _primWeap find "tracer" < 0};
    _magBaseName = _magBaseName select 0;
   
        { 
            if ((_x select 0) isEqualTo _unitName) then
            {
                _previousMag     = (_x select 1);
                _magNameAmmoList = (_x select 2);
                
            }  
        } forEach ammoList;
                                
        {  
            if ( (toLower _x find toLower "tracer" >= 0) && (_x find _magBaseName >= 0) ) then
            {
                _unit removeMagazine _x;
                _totalMagCount = _totalMagCount + 1;
            }
        } forEach _magList;

            
        for "_i" from 0 to (_totalMagCount - 1) do
        {       
            _magDetail = _magNameAmmoList select _i;
            _unit addMagazine _magDetail;
        };
        nameList = _magNameAmmoList;
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
ammoList resize 0;