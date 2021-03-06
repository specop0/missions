#include "const.hpp"

private _scriptHandle = _this spawn {
    params ["_target","_caller"];
    (_this select 3) params [ ["_index",-1,[0]], ["_markerName","",[""]] ];
    if(_index > -1) then {
        if !(_markerName isEqualTo "") then {
            missionNamespace setVariable [format [MARKER_CLEANUP_AVAILABLE, _markerName], false, true];
            _markerName setMarkerColor LOCATION_COLOR_DONE;
        };
        private _objects = SPAWNED_OBJECTS_ARRAY select _index;
        {
            if (!isNull _x) then {
                deleteVehicle _x;
                sleep SLEEP_TIME;
            };
        } forEach _objects;
        SPAWNED_OBJECTS_ARRAY set [_index, [] ];
    } else {
        ["Script Error: CleanUp started, but wrong index. %1", str _this] call BIS_fnc_error;
    };
};
true
