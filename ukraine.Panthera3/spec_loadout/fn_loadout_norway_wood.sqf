/*
    Author: SpecOp0

    Description:
    Assigns a loadout to a given unit.
    The type of loadout is determined with the classname.

    Can be used as an addAction entry as well.

    Parameter(s):
    0: OBJECT - unit to assign loadout to
    1 (Optional) : STRING - classname which represents loadout type (default: classname of unit)

    Alternativ Usage:
    0: -
    1: OBJECT - unit which choose addAction entry
    2: -
    3 (Optional): STRING - classname which represents loadout type (default: classname of unit)

    Returns:
    true
*/
#include "addItemToContainer.hpp"
#include "classVariables.hpp"

waitUntil {!isNull player || isServer};
private _unit = objNull;
private _type = "";
private _parameterCorrect = false;
// test if addAction was used (caller _this select 3 is present)
if(_this isEqualType [] && {count _this > 3}) then {
    _parameterCorrect = params [ "", ["_caller", objNull,[objNull]] ];
    _unit = _caller;
    _type = typeOf _unit;
    // test if addAction arguments were used
    if (count _this > 3 && {(_this select 3) isEqualTypeAny ["",[]]}) then {
        private _addActionParameterCorrect = (_this select 3) params [ ["_typeAddActionArg","",["STRING"]] ];
        if(_addActionParameterCorrect) then {
            _type = _typeAddActionArg;
        };
    };
} else {
    // normal call
    _parameterCorrect = params [["_unitArg",objNull,[objNull]]];
    _unit = _unitArg;
    _type = typeOf _unit;
    // test if type argument present (_this select 1)
    if(_this isEqualType [] && {count _this > 1}) then {
        private _typeParameterCorrect = params ["", ["_typeArg","",[""]] ];
        if(_typeArg != "") then {
            _type = _typeArg;
        };
    };
};

private _uniform = "MNP_CombatUniform_NOR_A";
private _vest = selectRandom ["MNP_Vest_NOR_2", "MNP_Vest_NOR_1"];

private _backpack = "B_AssaultPack_rgr";
private _backpackKitBag = "B_Kitbag_rgr";
private _backpackBig = "B_Carryall_khk";
private _backpackLR = "TTT_Backpack_Operator_Radio_BW_Flecktarn";

private _headgear = "MNP_Boonie_NOR";
private _headgearPilot = "H_PilotHelmetHeli_B";
private _headgearPilotJet = "H_PilotHelmetFighter_B";
private _goggles = "G_Lowprofile";

private _standardWeapon = "rhs_weap_hk416d145";
private _standardAmmo = "30Rnd_556x45_Stanag";
private _standardAccessory = ["optic_Hamr","rhsusf_acc_anpeq15_bk"];
private _standardAccessoryExtra = ["rhsusf_acc_compm4"];

private _secondaryWeapon = "rhsusf_weap_m9";
private _secondaryAmmo = "rhsusf_mag_15Rnd_9x19_JHP";
private _secondaryAccessory = [];

comment "Weapon with Underslung Grenade Launcher";
private _grenadeLauncherWeapon = "rhs_weap_hk416d145_m320";
private _grenadeLauncherAmmo = _standardAmmo;
private _grenadeLauncherAccessory = _standardAccessory;
private _grenadeLauncherAccessoryExtra = _standardAccessoryExtra;

comment "Machine Gunner";
private _mgWeapon = "rhs_weap_m240B";
private _mgAmmo = "rhsusf_100Rnd_762x51_m62_tracer";
private _mgAccessory = ["optic_Hamr"];
private _mgAccessoryExtra = _standardAccessoryExtra;

comment "Light Machine Gunner";
private _lmgWeapon = "CUP_lmg_minimi_railed";
private _lmgAmmo = "CUP_200Rnd_TE4_Red_Tracer_556x45_M249";
private _lmgAccessory = _standardAccessory;
private _lmgAccessoryExtra = _standardAccessoryExtra;

comment "Rifleman (AT)";
private _atWeapon = "rhs_weap_fgm148";
private _atAmmo = "rhs_fgm148_magazine_AT";
private _atAccessory = [];

if(_parameterCorrect) then {
    removeAllWeapons _unit;
    removeAllItems _unit;
    removeAllAssignedItems _unit;
    removeUniform _unit;
    removeVest _unit;
    removeBackpack _unit;
    removeHeadgear _unit;
    removeGoggles _unit;

    comment "Vest, Uniform, Backpack, Headgear (, Googgles)";
    if(_type == CLASS_PILOT_JET) then {
        [_unit, "U_I_pilotCoveralls"] call Spec_fnc_addContainer;
    } else {
        [_unit, _uniform] call Spec_fnc_addContainer;
    };
    [_unit, _vest] call Spec_fnc_addContainer;
    if(_type in [CLASS_OPL, CLASS_FUNKER_BLUE, CLASS_LOGISTIC, CLASS_PILOT, CLASS_PILOT_JET]) then {
        [_unit, _backpackLR] call Spec_fnc_addContainer;
        clearItemCargoGlobal (unitBackpack _unit);
        clearMagazineCargoGlobal (unitBackpack _unit);
        if(backpack _unit == "") then {
            [_unit, _backpack] call Spec_fnc_addContainer;
        };
    } else {
        if(_type in [CLASS_MEDEVAC, CLASS_AT_ASSI_BLUE]) then {
            [_unit, _backpackBig] call Spec_fnc_addContainer;
        } else {
            if(_type in [CLASS_PIO_BLUE]) then {
                [_unit, _backpackKitBag] call Spec_fnc_addContainer;
            } else {
                [_unit, _backpack] call Spec_fnc_addContainer;
            };
        };
    };
    
    switch _type do {
        case CLASS_PILOT : {
            _unit addHeadgear _headgearPilot;
        };
        case CLASS_PILOT_JET : {
            _unit addHeadgear _headgearPilotJet;
        };
        default {
            _unit addHeadgear _headgear;
        }
    };
    _unit addGoggles _goggles;

    comment "===========================================";
    comment "standard equipment (Map, Grenades, Medic Stuff, Explosives)";
    [_unit, _type] call Spec_fnc_loadoutStandardEquipment;
    comment "===========================================";

    if(_type == CLASS_MG) then {
        [_unit,_mgAmmo,ADD_TO_VEST, 2] call Spec_fnc_addItemToContainer;
        [_unit,_mgAmmo,ADD_TO_BACKPACK] call Spec_fnc_addItemToContainer;
        _unit addWeapon _mgWeapon;
        {
            _unit addPrimaryWeaponItem _x;
        } forEach _mgAccessory;
        {
            [_unit,_x,ADD_ANYWHERE] call Spec_fnc_addItemToContainer;
        } forEach _mgAccessoryExtra;
    } else {
        if(_type == CLASS_LMG_BLUE) then {
            [_unit,_lmgAmmo,ADD_TO_VEST] call Spec_fnc_addItemToContainer;
            _unit addWeapon _lmgWeapon;
            [_unit,_lmgAmmo,ADD_TO_VEST] call Spec_fnc_addItemToContainer;
            [_unit,_lmgAmmo,ADD_TO_BACKPACK, 2] call Spec_fnc_addItemToContainer;
            _unit addWeapon _lmgWeapon;
            {
                _unit addPrimaryWeaponItem _x;
            } forEach _lmgAccessory;
            {
                [_unit,_x,ADD_ANYWHERE] call Spec_fnc_addItemToContainer;
            } forEach _lmgAccessoryExtra;
        } else {
            comment "Grenade launcher";
            if(_type in [CLASS_TF_BLUE, CLASS_GL, CLASS_FUNKER_BLUE]) then {
                [_unit,_grenadeLauncherAmmo,ADD_TO_VEST, 6] call Spec_fnc_addItemToContainer;

                _unit addWeapon _grenadeLauncherWeapon;
                {
                    _unit addPrimaryWeaponItem _x;
                } forEach _grenadeLauncherAccessory;
                {
                    [_unit,_x,ADD_ANYWHERE] call Spec_fnc_addItemToContainer;
                } forEach _grenadeLauncherAccessoryExtra;
            } else {
                comment "AT launcher";
                if(_type == CLASS_AT_BLUE) then {
                    _unit addWeapon _atWeapon;
                    {
                        _unit addSecondaryWeaponItem _x;
                    } forEach _atAccessory;
                };
                comment "MG Ammunition for MG Assistant";
                if(_type == CLASS_AT_ASSI_BLUE) then {
                    [_unit,_atAmmo,ADD_TO_BACKPACK, 2] call Spec_fnc_addItemToContainer;
                };
                comment "Standard Weapon";
                [_unit,_standardAmmo,ADD_TO_VEST, 6] call Spec_fnc_addItemToContainer;

                _unit addWeapon _standardWeapon;
                {
                    _unit addPrimaryWeaponItem _x;
                } forEach _standardAccessory;
                {
                    [_unit,_x,ADD_ANYWHERE] call Spec_fnc_addItemToContainer;
                } forEach _standardAccessoryExtra;
            };
        };
    };
    comment "Secondary Weapon";
    [_unit,_secondaryAmmo,ADD_TO_VEST, 3] call Spec_fnc_addItemToContainer;
    _unit addWeapon _secondaryWeapon;
    {
        _unit addSecondaryWeaponItem _x;
    } forEach _secondaryAccessory;
};
true
