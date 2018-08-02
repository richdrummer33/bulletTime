// slowMoBullets 

_bullet = _this select 0;
_dist = _this select 1;
_vel = velocity _bullet;
_dir = direction _bullet;

_speedMod = 0.9;
if (_dist < 200) then {_speedMod = 0.8;};
if (_dist < 175) then {_speedMod = 0.7;};
if (_dist < 150) then {_speedMod = 0.6;};
if (_dist < 125) then {_speedMod = 0.5;};
if (_dist < 100) then {_speedMod = 0.4;};
if (_dist < 65) then {_speedMod = 0.3;};
if (_dist < 55) then {_speedMod = 0.24;};
if (_dist < 45) then {_speedMod = 0.2;};
if (_dist < 35) then {_speedMod = 0.14;};
if (_dist < 25) then {_speedMod = 0.1;};

_bullet setVelocity [
	(_vel select 0)*_speedMod, 
	(_vel select 1)*_speedMod, 
	(_vel select 2)*_speedMod
];