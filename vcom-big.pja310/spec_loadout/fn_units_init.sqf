/*
    Author: SpecOp0

    Description:
    Assigns a loadout to every unit.

    On the server every AI unit on the west side will be given the loadout (Spec_fnc_loadout).
    For every client (hasInterface) the loadout will be given - inclusive a respawn EventHandler.

    Parameter(s):
    -

    Returns:
    true
*/
#define LOADOUT_FUNC Spec_fnc_loadout_czech
if(isServer) then {
    {
        if(side _x == west) then {
            comment "assign loadout to AI only (excellent for testing purposes)";
            [_x] call LOADOUT_FUNC;
            _x addEventHandler ["Respawn", {(_this select 0) call LOADOUT_FUNC;}];
        } else {
            _x removeMagazines "1Rnd_HE_Grenade_shell";
        };
    } foreach  allUnits - allPlayers;  
};
if(hasInterface) then {
    [player] call LOADOUT_FUNC;
    player addEventHandler ["Respawn", {(_this select 0) call LOADOUT_FUNC;}];
};
true
