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

private _uniform = "MNP_CombatUniform_USMC_arctic";
private _vest = "V_PlateCarrier2_blk";

private _backpack = "MNP_B_WB_KB";

private _headgear = "MNP_Helmet_USMC_arctic";
private _googles = "G_Balaclava_combat";

private _standardWeapon = "rhs_weap_m4_grip";
private _standardAmmo = "30Rnd_556x45_Stanag";
private _standardAccessory = ["rhsusf_acc_nt4_black","acc_pointer_IR","rhsusf_acc_ACOG"];
private _standardAccessoryExtra = ["rhsusf_acc_eotech_552"];

private _grenadeLauncherWeapon = "rhs_weap_m4_m320";
private _grenadeLauncherAmmo = _standardAmmo;
private _grenadeLauncherAccessory = _standardAccessory;
private _grenadeLauncherAccessoryExtra = _standardAccessoryExtra;

private _secondaryWeapon = "rhsusf_weap_m1911a1";
private _secondaryAmmo = "rhsusf_mag_7x45acp_MHP";
private _secondaryAccessory = [];

comment "Team Leader";
private _tfClass = "B_Soldier_TL_F";
comment "Grenadier";
private _glClass = "B_Soldier_GL_F";
comment "Combat Life Saver";
private _medicClass = "B_medic_F";

comment "Autorifleman";
private _mgClass = "B_soldier_AR_F";
private _mgWeapon = "BWA3_MG5";
private _mgAmmo = "BWA3_120Rnd_762x51";
private _mgAccessory = ["BWA3_muzzle_snds_Rotex_IIA","acc_pointer_IR","optic_MRCO"];
private _mgAccessoryExtra = ["BWA3_optic_EOTech"];
comment "Ammo Bearer";
private _mgAssiClass = "B_Soldier_A_F";

comment "Helicopter Crew";
private _lmgClass = "B_Soldier_lite_F";
private _lmgWeapon = "BWA3_MG4";
private _lmgAmmo = "BWA3_200Rnd_556x45_Tracer";
private _lmgAccessory = ["BWA3_muzzle_snds_Rotex_IIIC","acc_pointer_IR","optic_MRCO"];
private _lmgAccessoryExtra = ["BWA3_optic_EOTech"];

comment "Rifleman (AT)";
private _atClass = "B_soldier_LAT_F";
private _atWeapon = "BWA3_PzF3_Tandem_Loaded";

comment "Engineer";
private _pioClass = "B_engineer_F";

private _sniperClass = "B_Soldier_F";
private _sniperWeapon = "rhs_weap_sr25";
private _sniperAmmo = "rhsusf_20Rnd_762x51_m118_special_Mag";
private _sniperAccessory = ["rhsusf_acc_SR25S","acc_pointer_IR","optic_LRPS","rhsusf_acc_harris_bipod"];
private _sniperAccessoryExtra = ["rhsusf_acc_eotech_552"];
private _sniperHelpClass = "B_Helipilot_F";

if(_parameterCorrect) then {
    removeAllWeapons _unit;
    removeAllItems _unit;
    removeAllAssignedItems _unit;
    removeUniform _unit;
    removeVest _unit;
    removeBackpackGlobal _unit;
    removeHeadgear _unit;
    removeGoggles _unit;
    
    comment "Vest, Uniform, Backpack, Headgear (, Googgles)";
    _unit forceAddUniform _uniform;
    _unit addVest _vest;
    if(_type in [_pioClass, _mgAssiClass]) then {
        _unit addBackpack _backpack;
    };
    
    _unit addHeadgear _headgear;
    _unit addGoggles _googles;
    
    comment "Loadout based on TTT-Mod (weapons near end of file)";
    if(_type == _tfClass) then {
        _unit addWeapon "ACE_Vector";
    } else {
        if(_type in [_atClass, _mgAssiClass, _glClass, _sniperHelpClass]) then{
            _unit addWeapon "ACE_Yardage450";
        } else {
            _unit addWeapon "Binocular";
        };
    };
    
    _unit linkItem "ItemMap";
    _unit linkItem "ItemCompass";
    _unit linkItem "ItemWatch";
    _unit linkItem "ItemRadio";
    
    comment "lead equipment (tablet, etc)";
    if(_type == _tfClass) then {
        /*
        [_unit,"ItemcTab",ADD_ANYWHERE] call Spec_fnc_addItemToContainer;
        [_unit,"ACE_CableTie",ADD_TO_VEST, 3] call Spec_fnc_addItemToContainer;
        */        
        Spec_fnc_ammoBox = compile preprocessFileLineNumbers "scripts\ammoBox.sqf";
        //_unit addAction ["Fordere Nachschub an", Spec_fnc_ammoBox, [], -100, false, true, "", "_target == _this"];
        [_unit,1,["ACE_SelfActions","Spec_action_ammoBox"]] call ace_interact_menu_fnc_removeActionFromObject;
        _action = ["Spec_action_ammoBox", "Fordere Nachschub an", "", Spec_fnc_ammoBox, {true}] call ace_interact_menu_fnc_createAction;
        [_unit,1, ["ACE_SelfActions"], _action] call ace_interact_menu_fnc_addActionToObject;
    };
    
    comment "standard equipment (ear plugs, grenades)";
    [_unit,"ACE_EarPlugs",ADD_TO_UNIFORM] call Spec_fnc_addItemToContainer;
    [_unit,"ACE_MapTools",ADD_TO_UNIFORM] call Spec_fnc_addItemToContainer;
    
    [_unit,"ACE_IR_Strobe_Item",ADD_TO_UNIFORM,2] call Spec_fnc_addItemToContainer;
    [_unit,"ACE_HandFlare_Green",ADD_TO_UNIFORM,2] call Spec_fnc_addItemToContainer;

    [_unit,"SmokeShell",ADD_TO_UNIFORM,2] call Spec_fnc_addItemToContainer;
    [_unit,"SmokeShellGreen",ADD_TO_UNIFORM, 2] call Spec_fnc_addItemToContainer;
    [_unit,"SmokeShellPurple",ADD_TO_UNIFORM] call Spec_fnc_addItemToContainer;
    
    comment "night equipment";
    [_unit,"ACE_Flashlight_MX991",ADD_TO_UNIFORM] call Spec_fnc_addItemToContainer;
    [_unit,"ACE_NVG_Wide",ADD_TO_UNIFORM] call Spec_fnc_addItemToContainer;
    
    [_unit,"ACE_M84",ADD_TO_VEST, 2] call Spec_fnc_addItemToContainer;

    comment "medic equipment";
    switch _type do {
        case _medicClass : {
            [_unit,"ACE_fieldDressing",ADD_TO_VEST, 20] call Spec_fnc_addItemToContainer;
            [_unit,"ACE_bloodIV_500",ADD_TO_VEST, 6] call Spec_fnc_addItemToContainer;
            [_unit,"ACE_bloodIV",ADD_TO_VEST, 2] call Spec_fnc_addItemToContainer;
            [_unit,"ACE_epinephrine",ADD_TO_VEST, 4] call Spec_fnc_addItemToContainer;
            [_unit,"ACE_morphine",ADD_TO_VEST, 4] call Spec_fnc_addItemToContainer;
            
            _unit setVariable ["ace_medical_medicClass", 2, true];
        };
        default {
            [_unit,"ACE_fieldDressing",ADD_TO_VEST, 7] call Spec_fnc_addItemToContainer;
            [_unit,"ACE_morphine",ADD_TO_VEST, 1] call Spec_fnc_addItemToContainer;;
        };
    };
    
    comment "role specific special equipment";
    switch _type do {
        case _tfClass : {
            [_unit,"1Rnd_Smoke_Grenade_shell",ADD_TO_VEST, 6] call Spec_fnc_addItemToContainer;
            [_unit,"1Rnd_SmokeRed_Grenade_shell",ADD_TO_VEST, 6] call Spec_fnc_addItemToContainer;
        };
        case _glClass : {
            [_unit,"1Rnd_HE_Grenade_shell",ADD_TO_VEST, 12] call Spec_fnc_addItemToContainer;
        };
        case _pioClass : {
            [_unit,"DemoCharge_Remote_Mag",ADD_TO_BACKPACK, 5] call Spec_fnc_addItemToContainer;
            [_unit,"ACE_Clacker",ADD_ANYWHERE] call Spec_fnc_addItemToContainer;
            [_unit,"ACE_DefusalKit",ADD_ANYWHERE] call Spec_fnc_addItemToContainer;
            _unit setVariable ["ACE_isEOD", true, true];
        };
        case _mgAssiClass : {
            [_unit,_mgAmmo,ADD_TO_BACKPACK, 2] call Spec_fnc_addItemToContainer;
        };
        case _sniperHelpClass : {
            [_unit,_sniperAmmo,ADD_TO_VEST, 4] call Spec_fnc_addItemToContainer;
        };
    };
    
    comment "===========================================";
    comment "==============  Weapons  ==================";
    comment "===========================================";
    
    if(_type == _mgClass) then {
        [_unit,_mgAmmo,ADD_TO_VEST, 2] call Spec_fnc_addItemToContainer;
        _unit addWeapon _mgWeapon;
        {
            _unit addPrimaryWeaponItem _x;
        } forEach _mgAccessory;
        {
            [_unit,_x,ADD_ANYWHERE] call Spec_fnc_addItemToContainer;
        } forEach _mgAccessoryExtra;    
        [_unit,_mgAmmo,ADD_TO_VEST] call Spec_fnc_addItemToContainer;
    } else {
        if(_type == _lmgClass) then {
            [_unit,_lmgAmmo,ADD_TO_VEST, 2] call Spec_fnc_addItemToContainer;
            _unit addWeapon _lmgWeapon;
            {
                _unit addPrimaryWeaponItem _x;
            } forEach _lmgAccessory;
            {
                [_unit,_x,ADD_ANYWHERE] call Spec_fnc_addItemToContainer;
            } forEach _lmgAccessoryExtra;
            [_unit,_lmgAmmo,ADD_TO_VEST, 1] call Spec_fnc_addItemToContainer;
        } else {
            if(_type == _sniperClass) then {
                [_unit,_sniperAmmo,ADD_TO_VEST, 7] call Spec_fnc_addItemToContainer;
                _unit addWeapon _sniperWeapon;
                {
                    _unit addPrimaryWeaponItem _x;
                } forEach _sniperAccessory;
                {
                    [_unit,_x,ADD_ANYWHERE] call Spec_fnc_addItemToContainer;
                } forEach _sniperAccessoryExtra;
            } else {
                comment "grenade launcher";
                if(_type in [_tfClass, _glClass]) then {
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
                    if(_type == _atClass) then {
                        _unit addWeapon _atWeapon;
                    };
                    comment "standard weapon";
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
    };
    comment "secondary weapon";
    [_unit,_secondaryAmmo,ADD_ANYWHERE, 1] call Spec_fnc_addItemToContainer;
    _unit addWeapon _secondaryWeapon;
    {
        _unit addSecondaryWeaponItem _x;
    } forEach _secondaryAccessory;
};
