private _id = addMissionEventHandler ["HandleDisconnect",{
    params ["_unit"];
    if((getPosASL _unit) distance (getMarkerPos "respawn") < 1000) then {
        deleteVehicle _unit;
    };
}];
[] call Spec_fnc_units_init;