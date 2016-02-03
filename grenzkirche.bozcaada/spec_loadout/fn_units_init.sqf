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

comment "Initialize global class variables";
[] call Spec_fnc_initClassVariables;

if(isServer) then {
	{
		if(side _x == east) then {
			comment "assign loadout to AI only (excellent for testing purposes)";
			[_x] call Spec_fnc_loadout_rus_flora_alt;
			_x addEventHandler ["Respawn", Spec_fnc_loadout_rus_flora_alt];
		} else {
			_x removeMagazines "1Rnd_HE_Grenade_shell";
		};
	} foreach  allUnits - allPlayers;
};
if(hasInterface) then {
	[player] call Spec_fnc_loadout_rus_flora_alt;
	player addEventHandler ["Respawn", {(_this select 0) call Spec_fnc_loadout;}];
};
true