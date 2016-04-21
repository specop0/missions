/*
	Author: SpecOp0

	Description:
	Enforces usage of TFAR by setting TFAR module.
	If client hasInterface (is a player) the TFAR frequencies are initialized (see fn_TFAR_initGroups)
	and a EventHandler is added if a new radio is received to set frequencies accordingly (see fn_setTFAR.sqf)
	
	Parameter(s):
	-

	Returns:
	true
*/

// TFAR mod configuration
#include "\task_force_radio\functions\common.sqf";

TF_give_personal_radio_to_regular_soldier = true; //inverted module setting
tf_no_auto_long_range_radio = true; //inverted module setting
TF_terrain_interception_coefficient = 0;
tf_radio_channel_name = "LaufendeMission";
tf_radio_channel_password = "130";
if(isServer) then {
	tf_same_sw_frequencies_for_side = true;
	tf_same_lr_frequencies_for_side = true;
};

if(hasInterface) then {
	player call Spec_fnc_TFAR_initGroups;
	["Spec_setTFAR", "OnRadiosReceived", Spec_fnc_setTFAR, player] call TFAR_fnc_addEventHandler;
};
true