/*
    Author: SpecOp0

    Description:
    Initializes for a unit variables needed for setting TFAR frequencies
    and set names for BFT system.
    Variables are chosen based on variable "Spec_var_TFARgroup".
    
    Example in init-field add: this setVariable ["Spec_var_TFARgroup",0];
    
    Parameter(s):
    0: OBJECT - unit/player which variables need to be initialized

    Returns:
    true
*/
private _parameterCorrect = params [["_unitName",objNull,[objNull]]];

if(_parameterCorrect) then {
    private _groupID = _unitName getVariable ["Spec_var_TFARgroup", 0];
    private ["_swFreq", "_lrFreq", "_callsign", "_BFTicon", "_BFTremarks"];
    _BFTicon = "b_inf";
    _BFTremarks = name _unitName;
    
    switch _groupID do {
        case 0 : {
            _swFreq = ["100"];
            _lrFreq = ["30","31","32","40"];
            _callsign = "Herkules";
        };
        case 1 : {
            _swFreq = ["100"];
            _lrFreq = ["30","31","32","40"];
            _callsign = "Lektor";
        };
        case 2 : {
            _swFreq = ["111","110","112","113","114"];
            _lrFreq = ["31","30"];
            _callsign = "Anton 1";
        };
        case 3 : {
            _swFreq = ["112","110","111","113","114"];
            _lrFreq = ["31","30"];
            _callsign = "Anton 2";
        };
        case 4 : {
            _swFreq = ["113","110","111","112","114"];
            _lrFreq = ["31","30"];
            _callsign = "Anton 3";
        };
        case 5 : {
            _swFreq = ["114","110","111","112","113"];
            _lrFreq = ["31","30"];
            _callsign = "Anton 4";
        };
        case 6 : {
            _swFreq = ["121","120","122","123","124"];
            _lrFreq = ["32","30"];
            _callsign = "Berta 1";
        };
        case 7 : {
            _swFreq = ["122","120","121","123","124"];
            _lrFreq = ["32","30"];
            _callsign = "Berta 2";
        };
        case 8 : {
            _swFreq = ["123","120","121","122","124"];
            _lrFreq = ["32","30"];
            _callsign = "Berta 3";
        };
        case 9 : {
            _swFreq = ["124""120","121","122","123"];
            _lrFreq = ["32","30"];
            _callsign = "Berta 4";
        };
        case 10 : {
            _swFreq = ["140"];
            _lrFreq = ["40"];
            _callsign = "Steinlaus";
        };
        default {
            _swFreq = ["100"];
            _lrFreq = ["30"];
            _callsign = "Default";
        };
    };
    // set frequency variables
    _unitName setVariable ["Spec_var_swFreq", _swFreq];
    _unitName setVariable ["Spec_var_lrFreq", _lrFreq];

    // BFT Settings
    (group _unitName) setGroupIdGlobal [_callsign];
    _unitName setVariable ["BG_BFT_groupId", _callsign, true];
    _unitName setVariable ["BG_BFT_icon", _BFTicon, true]; 
    _unitName setVariable ["BG_BFT_remarks", _BFTremarks, true];
    if(count _swFreq > 0) then {
        _unitName setVariable ["BG_BFT_radioSR", (_swFreq select 0), true];
    };
    if(count _lrFreq > 0) then {
        _unitName setVariable ["BG_BFT_radioLR", (_lrFreq select 0), true];
    };
    
};
true
