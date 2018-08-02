0 = ["WetDistortion", 300, [
	0.075, 
	0, 1, 
	4.10, 3.70, 2.50, 1.85, 
	0.0000054, 0.0000041, 0.00005, 0.0000070, 
	1, 1, 1, 1
]] spawn {
	params ["_name", "_priority", "_effect", "_handle"];
	while {
		_handle = ppEffectCreate [_name, _priority];
		_handle < 0
	} do {
		_priority = _priority + 1;
	};
	_handle ppEffectEnable true;
	_handle ppEffectAdjust _effect;
	_handle ppEffectCommit 3;
	waitUntil {ppEffectCommitted _handle};
	uiSleep 3; 
	comment "admire effect for a sec";
	_handle ppEffectEnable false;
	ppEffectDestroy _handle;
};