/*
    Author: SpecOp0

    Description:
    Assigns the standard equipment to a given unit.
    For example map, radio, grenades and medic stuff.
    Furthermore role specific stuff like explosives or 40mm HE grenades.

    Can be used as an addAction entry as well.

    Parameter(s):
    0: OBJECT - unit to assign loadout to
    1: STRING - classname which represents loadout type

    Returns:
    true
*/
#include "addItemToContainer.hpp"
#include "classVariables.hpp"

private _parameterCorrect = params [ ["_unit",objNull,[objNull]], ["_type","",[""]] ];

if (_parameterCorrect) then {

    if (_type in [CLASS_OPL, CLASS_SQL, CLASS_FTL]) then {
        _unit addWeapon "ACE_Vector";
    } else {
        if (_type in [CLASS_GL]) then{
            _unit addWeapon "ACE_Yardage450";
        } else {
            _unit addWeapon "Binocular";
        };
    };

    _unit linkItem "ItemMap";
    _unit linkItem "ItemCompass";
    _unit linkItem "ItemWatch";
    _unit linkItem "ItemRadio";

    // lead equipment (tablet, etc)
    if (_type in [CLASS_OPL, CLASS_SQL, CLASS_FTL, CLASS_DRIVER, CLASS_PILOT, CLASS_LOGISTIC]) then {
        [_unit,"ACE_microDAGR",ADD_TO_UNIFORM] call Spec_loadout_fnc_addItemToContainer;
        if (_type in [CLASS_OPL]) then {
            [_unit,"ItemcTab",ADD_TO_BACKPACK] call Spec_loadout_fnc_addItemToContainer;
        } else {
            [_unit,"ItemAndroid",ADD_TO_BACKPACK] call Spec_loadout_fnc_addItemToContainer;
        };
    };

    [_unit,"ACE_CableTie",ADD_TO_VEST, 2] call Spec_loadout_fnc_addItemToContainer;

    // standard equipment (ear plugs, grenades)
    [_unit,"ACE_MapTools",ADD_TO_UNIFORM] call Spec_loadout_fnc_addItemToContainer;
    [_unit,"ACE_IR_Strobe_Item",ADD_TO_UNIFORM,2] call Spec_loadout_fnc_addItemToContainer;

    [_unit,"SmokeShell",ADD_ANYWHERE,5] call Spec_loadout_fnc_addItemToContainer;
    [_unit,"SmokeShellGreen",ADD_ANYWHERE,2] call Spec_loadout_fnc_addItemToContainer;
    [_unit,"SmokeShellPurple",ADD_ANYWHERE,2] call Spec_loadout_fnc_addItemToContainer;
    [_unit,"HandGrenade",ADD_TO_VEST, 2] call Spec_loadout_fnc_addItemToContainer;

    // night equipment
    [_unit,"ACE_Flashlight_MX991",ADD_ANYWHERE] call Spec_loadout_fnc_addItemToContainer;
    [_unit,"ACE_NVG_Wide",ADD_TO_VEST] call Spec_loadout_fnc_addItemToContainer;

    // medic equipment
    switch _type do {
        case CLASS_MEDIC : {
            [_unit,"ACE_fieldDressing",ADD_TO_BACKPACK, 15] call Spec_loadout_fnc_addItemToContainer;
            [_unit,"ACE_elasticBandage",ADD_TO_BACKPACK, 10] call Spec_loadout_fnc_addItemToContainer;
            [_unit,"ACE_quikclot",ADD_TO_BACKPACK, 15] call Spec_loadout_fnc_addItemToContainer;
            [_unit,"ACE_packingBandage",ADD_TO_BACKPACK, 10] call Spec_loadout_fnc_addItemToContainer;
            [_unit,"ACE_tourniquet",ADD_TO_BACKPACK, 3] call Spec_loadout_fnc_addItemToContainer;
            [_unit,"ACE_salineIV_500",ADD_TO_BACKPACK, 4] call Spec_loadout_fnc_addItemToContainer;
            [_unit,"ACE_atropine",ADD_TO_BACKPACK, 5] call Spec_loadout_fnc_addItemToContainer;
            [_unit,"ACE_epinephrine",ADD_TO_BACKPACK, 8] call Spec_loadout_fnc_addItemToContainer;
            [_unit,"ACE_morphine",ADD_TO_BACKPACK, 8] call Spec_loadout_fnc_addItemToContainer;
            [_unit,"ACE_surgicalKit",ADD_TO_BACKPACK, 3] call Spec_loadout_fnc_addItemToContainer;
            _unit setVariable ["ace_medical_medicClass", 1, true];
        };
        case CLASS_MEDEVAC : {
            [_unit,"ACE_fieldDressing",ADD_TO_BACKPACK, 15] call Spec_loadout_fnc_addItemToContainer;
            [_unit,"ACE_elasticBandage",ADD_TO_BACKPACK, 10] call Spec_loadout_fnc_addItemToContainer;
            [_unit,"ACE_quikclot",ADD_TO_BACKPACK, 15] call Spec_loadout_fnc_addItemToContainer;
            [_unit,"ACE_packingBandage",ADD_TO_BACKPACK, 10] call Spec_loadout_fnc_addItemToContainer;
            [_unit,"ACE_tourniquet",ADD_TO_BACKPACK, 2] call Spec_loadout_fnc_addItemToContainer;
            [_unit,"ACE_salineIV",ADD_TO_BACKPACK, 6] call Spec_loadout_fnc_addItemToContainer;
            [_unit,"ACE_atropine",ADD_TO_BACKPACK, 8] call Spec_loadout_fnc_addItemToContainer;
            [_unit,"ACE_epinephrine",ADD_TO_BACKPACK, 12] call Spec_loadout_fnc_addItemToContainer;
            [_unit,"ACE_morphine",ADD_TO_BACKPACK, 12] call Spec_loadout_fnc_addItemToContainer;
            [_unit,"ACE_surgicalKit",ADD_TO_BACKPACK, 5] call Spec_loadout_fnc_addItemToContainer;
            [_unit,"ACE_personalAidKit",ADD_TO_BACKPACK, 3] call Spec_loadout_fnc_addItemToContainer;
            _unit setVariable ["ace_medical_medicClass", 2, true];
        };
        default {
            [_unit,"ACE_fieldDressing",ADD_TO_BACKPACK, 18] call Spec_loadout_fnc_addItemToContainer;
            [_unit,"ACE_packingBandage",ADD_TO_BACKPACK, 6] call Spec_loadout_fnc_addItemToContainer;
            [_unit,"ACE_tourniquet",ADD_TO_BACKPACK, 2] call Spec_loadout_fnc_addItemToContainer;
        };
    };

   // role specific special equipment
    switch _type do {
        case CLASS_SQL : {
            [_unit,"1Rnd_Smoke_Grenade_shell",ADD_TO_BACKPACK, 6] call Spec_loadout_fnc_addItemToContainer;
            [_unit,"1Rnd_SmokeRed_Grenade_shell",ADD_TO_BACKPACK, 6] call Spec_loadout_fnc_addItemToContainer;
            [_unit,"1Rnd_SmokeRed_Grenade_shell",ADD_TO_BACKPACK, 4] call Spec_loadout_fnc_addItemToContainer;
        };
        case CLASS_GL : {
            [_unit,"1Rnd_HE_Grenade_shell",ADD_TO_BACKPACK, 12] call Spec_loadout_fnc_addItemToContainer;
        };
        case CLASS_EOD : {
            [_unit,"ACE_VMH3",ADD_TO_BACKPACK] call Spec_loadout_fnc_addItemToContainer;
            [_unit,"DemoCharge_Remote_Mag",ADD_TO_BACKPACK, 3] call Spec_loadout_fnc_addItemToContainer;
            [_unit,"ACE_M26_Clacker",ADD_ANYWHERE_REVERSE] call Spec_loadout_fnc_addItemToContainer;
            [_unit,"ACE_DefusalKit",ADD_ANYWHERE_REVERSE] call Spec_loadout_fnc_addItemToContainer;
            _unit setVariable ["ACE_IsEngineer", true, true];
            _unit setVariable ["ACE_isEOD", true, true];
        };
        case CLASS_LOGISTIC : {
            [_unit,"ToolKit",ADD_TO_BACKPACK] call Spec_loadout_fnc_addItemToContainer;
            _unit setVariable ["ACE_IsEngineer", true, true];
        };
    };
};
true
