/*
    Author: SpecOp0

    Description:
    Ammunition Parachute Box.
    Spawns a Ammunition Box in the air and adds a parachute.
    The Ammunition Box will land safely if it is stuck in a tree.
    Furthermore a enemy unit is spawned as a drawback.
    
    For use in a addAction entry, most parameter are hardcoded.
    
    
    Parameter(s):
    0: -
    1: OBJECT - player who wants to spawn the object (i.e. a player who chooses the menu entry)

    Returns:
    true
*/

private _script = _this spawn {

private _ammoBoxType = "B_supplyCrate_F";
private _parachuteType = "B_Parachute_02_F";

private _enemyPatLeaderType = "rhs_g_Soldier_TL_F";
private _enemyPatSoldierAtype = "rhs_g_Soldier_F";
private _enemyPatSoldierBtype = "rhs_g_Soldier_AR_F";
private _enemyPatSide = RESISTANCE;
private _enemyPatCycleRadius = 125 + random 100;
private _spawnedAmmoBoxHeight = 500;
private _enemyPatSpawnDistance = 500;

private _hintAmmoBoxSpawned = "Die Versorgungskiste wurde ueber Ihnen abgeworfen.\nPassen Sie auf, dass der Feind diese nicht entdeckt!";
private _hintAmmoBoxAbovePlayer = "Eine Versorgungskiste ist bereits auf dem Weg. Gucken Sie nach oben in die Luft oder warten Sie ein Augenblick und rufen sie eine Weitere.";

private _parameterCorrect = params ["",["_caller",objNull]];

if(_parameterCorrect) then {
    comment "check if ammo box already spawned";
    private _spawnPosition = getPosATL _caller;
    private _spawnPositionHeight = (_spawnPosition select 2) + _spawnedAmmoBoxHeight;
    _spawnPosition set [2, _spawnPositionHeight];
    
    private _nearestAmmobox = nearestObjects [_spawnPosition,[_ammoBoxType],30];
    if(count _nearestAmmobox > 0) then {
        hint _hintAmmoBoxAbovePlayer;
    } else {
    
        comment "spawn ammo box with parachute at player position";
        private _spawnedAmmoBox = createVehicle [_ammoBoxType,_spawnPosition, [],0,""];
        private _parachute =  createVehicle [_parachuteType,_spawnPosition, [], 0, "NONE"];
        _spawnedAmmoBox attachTo [_parachute, [0,0,1]];
        
        comment "spawn enemy patrol near player";
        private _patGroup = createGroup _enemyPatSide;
        private _angle = (random 360);

        private _enemySpawnPos = _caller modelToWorld [sin(_angle)*_enemyPatSpawnDistance,cos(_angle)*_enemyPatSpawnDistance,0];
        private _enemySpawnMarker = createMarkerLocal ["AmmoBoxSpawnerMarker#", [_enemySpawnPos select 0, _enemySpawnPos select 1]];
        _enemySpawnMarker = "AmmoBoxSpawnerMarker#";
        _enemySpawnMarker setMarkerPos [_enemySpawnPos select 0, _enemySpawnPos select 1];

        private _enemyPatLeader = _patGroup createUnit [_enemyPatLeaderType, getMarkerPos _enemySpawnMarker, [], 25, "FORM"];
        [_enemyPatLeader] join _patGroup;
        private _enemyPatSoldierA = _patGroup createUnit [_enemyPatSoldierAtype, getMarkerPos _enemySpawnMarker, [], 25, "FORM"];
        [_enemyPatSoldierA] join _patGroup;
        private _enemyPatSoldierB = _patGroup createUnit [_enemyPatSoldierBtype, getMarkerPos _enemySpawnMarker, [], 25, "FORM"];
        [_enemyPatSoldierB] join _patGroup;

        private _wp0 = _patGroup addWaypoint [_pos,5];
        _wp0 setWaypointType "MOVE";
        _wp0 setWaypointSpeed "FULL";

        private _tempAngle = 41 + random 10;
        private _wp1 = _patGroup addWaypoint [_caller modelToWorld [sin(_tempAngle)*_enemyPatCycleRadius,cos(_tempAngle)*_enemyPatCycleRadius,0],5];
        _wp1 setWaypointSpeed "NORMAL";
        _tempAngle = 131 + random 10;
        private _wp2 = _patGroup addWaypoint [_caller modelToWorld [sin(_tempAngle)*_enemyPatCycleRadius,cos(_tempAngle)*_enemyPatCycleRadius,0],5];
        _tempAngle = 221 + random 10;
        private _wp3 = _patGroup addWaypoint [_caller modelToWorld [sin(_tempAngle)*_enemyPatCycleRadius,cos(_tempAngle)*_enemyPatCycleRadius,0],5];
        _tempAngle = 311 + random 10;
        private _wp4 = _patGroup addWaypoint [_caller modelToWorld [sin(_tempAngle)*_enemyPatCycleRadius,cos(_tempAngle)*_enemyPatCycleRadius,0],5];
        _tempAngle = 45;
        private _wp5 = _patGroup addWaypoint [_caller modelToWorld [sin(_tempAngle)*_enemyPatCycleRadius,cos(_tempAngle)*_enemyPatCycleRadius,0],5];
        _wp5 setWaypointType "CYCLE";
        
        comment "set ammo content here";
        clearWeaponCargoGlobal _spawnedAmmoBox;
        clearMagazineCargoGlobal _spawnedAmmoBox;
        clearItemCargoGlobal _spawnedAmmoBox;
        clearBackpackCargoGlobal _spawnedAmmoBox;

        _spawnedAmmoBox addMagazineCargoGlobal ["30Rnd_556x45_Stanag",26];
        _spawnedAmmoBox addMagazineCargoGlobal ["rhsusf_20Rnd_762x51_m118_special_Mag",5];
        _spawnedAmmoBox addMagazineCargoGlobal ["BWA3_120Rnd_762x51",3];
        _spawnedAmmoBox addMagazineCargoGlobal ["BWA3_200Rnd_556x45",4];

        _spawnedAmmoBox addItemCargoGlobal ["ACE_fieldDressing",55];
        _spawnedAmmoBox addItemCargoGlobal ["ACE_bloodIV_500",10];
        _spawnedAmmoBox addItemCargoGlobal ["ACE_bloodIV",4];
        _spawnedAmmoBox addItemCargoGlobal ["ACE_epinephrine",8];
        _spawnedAmmoBox addItemCargoGlobal ["ACE_morphine",8];
        
        _spawnedAmmoBox addItemCargoGlobal ["SmokeShell", 24];
        _spawnedAmmoBox addItemCargoGlobal ["SmokeShellRed", 24];
        _spawnedAmmoBox addItemCargoGlobal ["SmokeShellGreen", 24];
        _spawnedAmmoBox addItemCargoGlobal ["SmokeShellPurple", 12];

        _spawnedAmmoBox addItemCargoGlobal ["DemoCharge_Remote_Mag",2];
        _spawnedAmmoBox addWeaponCargoGlobal ["BWA3_PzF3_Tandem_Loaded",1];
        
        comment "end of ammo content";
        hint _hintAmmoBoxSpawned;
        
        comment "land ammo box safely (if stuck in tree)";
        private  _spawnedAmmoBoxOldPos = getPosATL _spawnedAmmoBox;
        sleep 60;
        private  _spawnedAmmoBoxCurPos = getPosATL _spawnedAmmoBox;
        waitUntil{
            _spawnedAmmoBoxCurPos = getPosATL _spawnedAmmoBox;
            sleep 5;
            if (isNull _parachute) then {
                true
            } else {
                if (_spawnedAmmoBoxOldPos distance _spawnedAmmoBoxCurPos < 2) then {
                    _spawnedAmmoBoxCurPos set [2,0];
                    detach _spawnedAmmoBox;
                    deleteVehicle _parachute;
                    _spawnedAmmoBox setPosATL _spawnedAmmoBoxCurPos;
                    true
                } else {
                    _spawnedAmmoBoxOldPos = _spawnedAmmoBoxCurPos;
                    false
                };
            };
        };
    };
} else {
    hint "Script Error: Calling player is Null";
};

};
true
