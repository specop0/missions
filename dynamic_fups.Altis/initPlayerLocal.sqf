[teleporter] call FETT_fnc_W_addTeleport;
[laptop] call Spec_dynamic_fnc_addControlActions;
// respawn medevac and logistic helicopter
laptop addAction [
    "Neuer MedEvac",
    {[true] remoteExec ["Spec_fnc_respawn_heli",2];},
    [],
    1.5,
    false,
    true,
    "",
    "_this distance _target <3"
];
laptop addAction [
    "Neue Banane",
    {
        [_this select 1,"ACE_Banana",3] call Spec_fnc_addItemToContainer;
        [false] remoteExec ["Spec_fnc_respawn_heli",2];
    },
    [],
    1.5,
    false,
    true,
    "",
    "_this distance _target <3"
];
player addEventHandler ["Respawn",{
    params ["","_corpse"];
    if((getPosASL player) distance (getMarkerPos "respawn") < 1000) then {
        deleteVehicle _corpse;
    };
}];
// call medevac and logistic helicopter
private _oplClass = "B_officer_F";
private _medicClass = "B_medic_F";
if(typeOf player in [_oplClass,_medicClass]) then {
    private _actionMedevac = ["Spec_action_callMedevac", "Rufe Weiss", "", {_this remoteExec ["Spec_fnc_heli_medevac",2]}, {true}] call ace_interact_menu_fnc_createAction;
    [player,1, ["ACE_SelfActions"], _actionMedevac] call ace_interact_menu_fnc_addActionToObject;
    if(typeOf player == _oplClass) then {
        [] call Spec_fnc_moveMarkerLZ;
        private _actionBussard = ["Spec_action_callBussard", "Rufe Bussard", "", {_this remoteExec ["Spec_fnc_heli_taxi",2]}, {true}] call ace_interact_menu_fnc_createAction;
        [player,1, ["ACE_SelfActions"], _actionBussard] call ace_interact_menu_fnc_addActionToObject;
        private _actionAmmoBox = ["Spec_action_spawnAmmoBox", "Nachschubkiste", "", {_this remoteExec ["Spec_crates_fnc_spawnAmmoBox",2]}, {true}] call ace_interact_menu_fnc_createAction;
        [player,1, ["ACE_SelfActions"], _actionAmmoBox] call ace_interact_menu_fnc_addActionToObject;
    };
};
// briefing
[player] call compile preprocessFileLineNumbers "briefing.sqf";