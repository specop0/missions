#include "classVariables.hpp"

private _loadoutFactionList = [];
_loadoutFactionList pushBack "NATO";
_loadoutFactionList pushBack "AAF";
_loadoutFactionList pushBack "CSAT";
// CUP
_loadoutFactionList pushBack "CUP_USSOCOM";
_loadoutFactionList pushBack "KOREA";
// RHS
_loadoutFactionList pushBack "USARMY";
_loadoutFactionList pushBack "USMC";
_loadoutFactionList pushBack "USSOCOM";
_loadoutFactionList pushBack "RUS";
_loadoutFactionList pushBack "RUS_ALT";
//3CB
_loadoutFactionList pushBack "UK";
//BW
_loadoutFactionList pushBack "BW_TROPEN";
_loadoutFactionList pushBack "BW_FLECK";
Spec_var_loadoutFactionList = _loadoutFactionList;

private _loadoutClassList = [];
_loadoutClassList pushBack ["AT-Schuetze",CLASS_AT];
_loadoutClassList pushBack ["Feldarzt",CLASS_MEDEVAC];
_loadoutClassList pushBack ["Funker",CLASS_FUNKER];
_loadoutClassList pushBack ["Gefechtssanitaeter",CLASS_MEDIC];
_loadoutClassList pushBack ["Grenadier",CLASS_GL];
_loadoutClassList pushBack ["LMG-Schuetze",CLASS_LMG];
_loadoutClassList pushBack ["Logistik",CLASS_LOGISTIC];
_loadoutClassList pushBack ["MG-Assistent",CLASS_MG_ASSI];
_loadoutClassList pushBack ["MG-Schuetze",CLASS_MG];
_loadoutClassList pushBack ["OPL",CLASS_OPL];
_loadoutClassList pushBack ["Pilot",CLASS_PILOT];
_loadoutClassList pushBack ["Pionier",CLASS_PIO];
_loadoutClassList pushBack ["Truppfuehrer",CLASS_TF];
Spec_var_loadoutClassList = _loadoutClassList;
