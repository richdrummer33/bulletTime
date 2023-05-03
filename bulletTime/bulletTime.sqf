// Arma 3 Bullet-Time Mod by Richard Beare (aka "A Bandpass Filter" or "RichDrummer280")

// >>>>>>>>>>>>>>>> USER SETTINGS START >>>>>>>>>>>>>>>>

    // --------------------
    // USER SETTINGS NOTES: 
    //     *DO: 
    //          the numbers below to change things to your liking. 
    //          E.g. To change the bullet-time duration, change the number beside "btDuration" (default of 4.5 seconds) to the desired duration.
    //     *DONT: 
    //          Don't change anything **except for the numbers**...  **unless** you know what you're doing! (̿▀̿‿ ̿▀̿ ̿).
    //     *NOTE: 
    //          "bt" is short for "bullet time"
    // --------------------

    // "btGameTimeScale" is how the game's time-scale will be reduced (i.e. how slow time will be while in bullet-time) while in bullet-time.
    //      E.g. 
    //          0.5 means that time will be half as fast as normal, 0.25 means that time will be 1/4 as fast as normal, etc.
    //      Default setting: 
    //          0.5 times the normal game time scale.
    //      Note: 
    //          You can set this to any non-zero value. There may be a lower limit, but I haven't tested it.
    missionNamespace setvariable ["btGameTimeScale", 0.5];

    // "btPlayerMovementSpeedMultiplier" is the player movement speed while in bullet-time. 
    //      E.g. 
    //          2.0 means that the player will move twice as fast as normal, 0.5 means that the player will move half as fast as normal, etc.
    //      Default setting: 
    //          2 times the normal game speed.
    //      FYI:  
    //          I set this to 2x to make you move at the same speed while in bullet-time (default is 0.5x -- half the normal time scale).
    //          There may be an upper limit, but I haven't tested it.
    missionNamespace setvariable ["btPlayerMovementSpeedMultiplier", 2.0];     
    
    // "btTransitionDuration" is the bullet-time transition duration.
    //      E.g.
    //          0.5 means that the transition will last for 0.5 seconds, 1.0 means that the transition will last for 1.0 seconds, etc.
    //      Default setting:
    //          1 seconds.
    //      Note:
    //          You can set this to any value equal to or greater than 0. Note that I have not tested 0 seconds or the upper limit.
    missionNamespace setvariable ["btTransitionDuration", 1.0];

    // "btDuration" is the bullet-time duration. 
    //      E.g. 
    //          4.5 means that bullet-time will last for 4.5 seconds, 8.0 means that bullet-time will last for 8.0 seconds, etc.
    //      Default setting: 
    //          4.5 seconds.
    //      FYI: 
    //          I set this to 4.5 seconds. But you can set this number to any duration!
    //          It can be set to a **very high** number, with up to 38 zeros -- more time than the universe has existed (°o•).
    missionNamespace setvariable ["btDuration", 10000];   

    // "chromAb" is the chromatic aberration effect.
    //      E.g.
    //          1 means that the chromatic aberration visual effect will be full-strength
    //          0.0 means that the effect will be off.
    //      Default setting:
    //          1.0 - full strength.
    //      Note:
    //          You can set this to any value equal to or greater than 0. Note that I have not tested 0 or the upper limit.
    // ????? missionNamespace setvariable ["btChromAbberationStrength", 1];
    
    // Bullet time recovery time.
    //      E.g.
    //          1 means that the player will recover from bullet-time in 1 seconds.
    //      Default setting:
    //          3 seconds.
    //      Note:
    //          You can set this to any value equal to or greater than 0. Note that I have not tested 0 seconds or the upper limit.
    missionNamespace setvariable ["btRecoveryTime", 4.5];

    // Chromatic abberation screen-effect amount
    //      E.g.
    //          1 means that the screen-effect will be full-strength
    //          0.0 means that the effect will be off.
    //      Default setting:
    //          0.001 - subtle effect
    //      Note:
    //          You can set this to any value equal to or greater than 0. Note that I have not tested 0 or the upper limit.
    missionNamespace setvariable ["btChromAbberationStrength", 0.001];
    
// <<<<<<<<<<<<<<<< USER SETTINGS END <<<<<<<<<<<<<<<<

if (missionNamespace getvariable ["bTimeAvail",true]) then 
{    
    // These variables keep track of the bullet time states, and should not be edited... unless you know what you're doing! (̿▀̿‿ ̿▀̿ ̿)
    missionNamespace setvariable ["bTimeAvail", false]; 
    missionNamespace setvariable ["bTimeActive", true]; 

    _btDuration = missionNamespace getvariable "btDuration";
    
        // ---- Bullet time is in play for btDuration! ---- //

        // Start function StartBulletTime
        call BulletTimeStart;
        sleep _btDuration; // wait (aka "sleep") for the bullet time duration before returnig to normal time....
        if (missionNamespace getvariable ["bTimeActive",true]) then 
        { 
            call BulletTimeEnd; 
        };

        sleep 0.5;
            hint "bullet-time recovering!";

        sleep (missionNamespace getvariable "btRecoveryTime"); // 4.5 seconds is the default value.
            hint "";

        sleep 4;

            missionNamespace setvariable ["bTimeAvail",true];
            if (missionNamespace getvariable ["bTimeAvail",true]) then 
            {
                hint "bullet-time available!";
            };

        sleep 3;

        hint ""; // Clear the hint.
}
else
{
    _btGameTimeScale = missionNamespace getvariable "btGameTimeScale";
    _btPlayerMovementSpeedMultiplier = missionNamespace getvariable "btPlayerMovementSpeedMultiplier";
    _btDuration = missionNamespace getvariable "btDuration";

    if (missionNamespace getvariable ["bTimeActive", true]) then 
    {
		 sleep 0.1;
            if (missionNamespace getvariable ["tracerVision",true]) then 
            { 
                nul = call compile preprocessFileLineNumbers "bulletTime\resetAmmo.sqf"; 
            };
            hint "";
            playSound3D ["bulletTime\sounds\powerup.wav", player, false, getPosASL player, 5, 1, 0];
			missionNamespace setvariable ["bTimeActive",false];
			if (!(missionNamespace getVariable "godMode")) then 
            { 
                missionNamespace setvariable ["bTimeAvail",false]; 
            };
		    player setAnimSpeedCoef (1.67 * _btPlayerMovementSpeedMultiplier);

            _accelTimeStepwise = 1 + (_btGameTimeScale - 1) * 0.6;
            hint format ["_accelTimeStepwise: %1", _accelTimeStepwise];
            setAccTime _accelTimeStepwise; // (1 + (_btGameTimeScale - 1) * 0.6); 

		sleep 0.23;
            player setAnimSpeedCoef (1.25 * _btPlayerMovementSpeedMultiplier);

            _accelTimeStepwise = 1 + (_btGameTimeScale - 1) * 0.8;
            hint format ["_accelTimeStepwise: %1", _accelTimeStepwise];
            setAccTime _accelTimeStepwise; // (1 + (_btGameTimeScale - 1) * 0.8); 

		sleep 0.33;
			player setDammage damagePlyr;
            player setAnimSpeedCoef 1;
            setAccTime 1; 
			chromAb ppEffectEnable false; 
            ppEffectDestroy [chromAb];
            if (missionNamespace getVariable "godMode") then 
            {
                sleep 0.1; 
                missionNamespace setvariable ["bTimeAvail",true];
            } 
            else 
            {
                //sleep the btDuration variable
                sleep _btDuration;
                missionNamespace setvariable ["bTimeAvail",true];
            };
    }
    else
    {
		if (!(missionNamespace getVariable "godMode")) then 
		{
			sleep 0.1;
				hint "bullet-time recovering!";

			sleep 3; 
				hint ""; // Clear the hint.
		};
    };
};


BulletTimeEnd = {
    _btGameTimeScale = missionNamespace getvariable "btGameTimeScale";
    _btPlayerMovementSpeedMultiplier = missionNamespace getvariable "btPlayerMovementSpeedMultiplier";
    _btTransitionDuration = missionNamespace getvariable "btTransitionDuration";
    _btChromAbberationStrength = missionNamespace getvariable "btChromAbberationStrength";

        playSound3D ["bulletTime\sounds\powerup.wav", player, false, getPosASL player, 5, 1, 0]; 

    // Ramp down the player's speed and ramp up the game time-scale, and chormatic abberation, in for loop
    for "_i" from 0 to _btTransitionDuration step 0.1 do
    {
        // Set the game time scale by percent _i / _btTransitionDuration  -- (_i / _btTransitionDuration is the lerp percentage)
        _accelTimeStepwise = 1 + (_btGameTimeScale - 1) * (1 - _i / _btTransitionDuration); 
        // hint format ["_accelTimeStepwise: %1", _accelTimeStepwise];
        setAccTime _accelTimeStepwise; 

        // Set player anim speed by percent _i / _btTransitionDuration.
        player setAnimSpeedCoef 1 + (_btPlayerMovementSpeedMultiplier - 1) * (1 - _i / _btTransitionDuration);

        // Strengthen the pp effect by percent _i / _btTransitionDuration
        chromAb ppEffectAdjust 
        [
            (1 - _i / _btTransitionDuration) * _btChromAbberationStrength, 
            (1 - _i / _btTransitionDuration) * _btChromAbberationStrength, 
            true
        ];

        sleep 0.2;
    };

    if ((missionNamespace getvariable ["bTimeActive",true]) && (missionNamespace getvariable ["bulletTime\tracerVision",true])) then 
    {  
        nul = call compile preprocessFileLineNumbers  "bulletTime\resetAmmo.sqf";  
    };
    missionNamespace setvariable ["bTimeActive",false];

    sleep 0.33;
    chromAb ppEffectEnable false;
    ppEffectDestroy [chromAb];
}


BulletTimeStart = {
    _btGameTimeScale = missionNamespace getvariable "btGameTimeScale";
    _btPlayerMovementSpeedMultiplier = missionNamespace getvariable "btPlayerMovementSpeedMultiplier";
    _btTransitionDuration = missionNamespace getvariable "btTransitionDuration";
    _btChromAbberationStrength = missionNamespace getvariable "btChromAbberationStrength";

    if (missionNamespace getvariable ["tracerVision", true]) then 
    { 
        nul = call compile preprocessFileLineNumbers "bulletTime\apply_tracer.sqf"; 
    };

    sleep 0.1;
    damagePlyr = getDammage player;
    playSound3D ["bulletTime\sounds\powerdown.wav", player, false, getPosASL player, 5, 1, 0]; 
    hint "BULLET-TIME!!!";

    player setDammage 0; 
    missionNamespace setvariable ["btPassedDammage", damagePlyr];

    chromAb =  ["ChromAberration", 1000, [0.03, 0.02, true]] call compile preprocessFileLineNumbers "bulletTime\chromAb.sqf";
    chromAb ppEffectCommit 10;

    // Smoothly transition the game time scale and player movement speed.
    // In step size, use transition duration 
    for "_i" from 0 to _btTransitionDuration step 0.1 do
    {
        // Set the game time scale by percent _i / _btTransitionDuration  -- (_i / _btTransitionDuration is the lerp percentage)
        _accelTimeStepwise = 1 + (_btGameTimeScale - 1) * _i / _btTransitionDuration; 
        // hint format ["_accelTimeStepwise: %1", _accelTimeStepwise];
        setAccTime _accelTimeStepwise; 

        // Set player anim speed by percent _i / _btTransitionDuration.
        player setAnimSpeedCoef 1 + (_btPlayerMovementSpeedMultiplier - 1) * _i / _btTransitionDuration;

        // Strengthen the pp effect by percent _i / _btTransitionDuration
        _lerpPercent = _i / _btTransitionDuration;
        chromAb ppEffectAdjust 
        [
            _lerpPercent * _btChromAbberationStrength, 
            _lerpPercent * _btChromAbberationStrength, 
            true
        ];

        sleep 0.2;
    };
}