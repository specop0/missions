comment "Edit these Entries";

comment "Type of Vehicle";
private _vehicleType = "B_G_Offroad_01_F";

comment "Direction of Vehicle";
private _vehicleSpawnerDirection = 187;

comment "Name of Marker for Vehicle Spawn";
private _markerVehicleSpawn = "marker_spawner";

comment "Hints displayed for Caller";
private _hintSpawnSucessfull = "Fahrzeug gespawned.";
private _hintSpawnPosBlocked = "Ein Fahrzeug steht dort bereits.";


comment "Script start";
params ["",["_caller",objNull]];
private _spawnPos = getMarkerPos _markerVehicleSpawn;

if(isNull _caller) then {
    hint "Script Error: Unit which called for Vehicle is null/has no Position attached";
} else {
    if( (_spawnPos select 0 == 0 && _spawnPos select 1 == 0 && _spawnPos select 2 == 0)) then {
        hint format ["Script Error: Marker '%1' not found",_markerVehicleSpawn];
    } else {    
        private _nearestObject = nearestObjects [_spawnPos,[_vehicleType],10];

        if(count _nearestObject > 0) then {
            hint _hintSpawnPosBlocked;
        } else {
            private _vehicle = _vehicleType createVehicle _spawnPos;
            _vehicle setDir _vehicleSpawnerDirection;
            clearItemCargoGlobal _vehicle;
            _vehicle addItemCargo ["ItemGPS",1];
            hint _hintSpawnSucessfull; 
        };
    };
};
