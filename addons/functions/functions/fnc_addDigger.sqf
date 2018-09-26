/*
    @Authors
        Marc 'Salbei' Heinze
    @Arguments
        - _unit, is the unit that helps digging
		- _trench, the trench that is beeing dug
    @Return Value
        None
*/

#include "script_component.hpp"

params ["_trench", "_unit"];

if ((_trench getVariable [QGVAR(diggerCount), 0]) < 1) exitWith {[_trench, _unit] call FUNC(continueDiggingTrench);};
_trench setVariable [QGVAR(diggerCount), ((_trench getVariable QGVAR(diggerCount))+1), true];
if (_trench getVariable [QGVAR(diggerCount), 0] == 1) then {_trench setVariable [QGVAR(nextDigger), player, true]};

private _handle = [{
   params ["_args", "_handle"];
    _args params ["_trench", "_unit"];

    if ((_trench getVariable [QGVAR(nextDigger), player]) == player && ((_trench getVariable [QGVAR(diggerCount), 1]) <= 1 || _trench getVariable ["ace_trenches_digging", false])) exitWith {
      [_handle] call CBA_fnc_removePerFrameHandler;
      [_trench, _unit] call FUNC(continueDiggingTrench);
   };
},1,_this] call CBA_fnc_addPerFrameHandler;

private _type = switch (_trench getVariable [QGVAR(diggingType), nil]) do {
   case "UP" : {true};
   case "Down" : {false};
};

// Create progress bar
private _fnc_onFinish = {
    (_this select 0) params ["_unit", "_trench", "_handle"];
    [_handle] call CBA_fnc_removePerFrameHandler;
    _trench setVariable [QGVAR(diggerCount), 0,true];

    // Reset animation
    [_unit, "", 1] call ace_common_fnc_doAnimation;
};

private _fnc_onFailure = {
    (_this select 0) params ["_unit", "_trench", "_handle"];

    [_handle] call CBA_fnc_removePerFrameHandler;
    private _count = (_trench getVariable QGVAR(diggerCount));
    _trench setVariable [QGVAR(diggerCount), (_count-1),true];

    // Reset animation
    [_unit, "", 1] call ace_common_fnc_doAnimation;
};
private _fnc_condition = {
   (_this select 0) params ["_unit", "_trench", "", "_handle"];

   if (_trench getVariable [QGVAR(diggerCount), 0] <= 0) exitWith {false};
   if (isNil "_handle") exitWith {false};
   if (GVAR(stopBuildingAtFatigueMax) && (ace_advanced_fatigue_anReserve <= 0))  exitWith {false};
   true
};

[[_unit, _trench, _type, _handle], _fnc_onFinish, _fnc_onFailure, localize "STR_ace_trenches_DiggingTrench", _fnc_condition] call FUNC(progressBar);

[_unit, "AinvPknlMstpSnonWnonDnon_medic4"] call ace_common_fnc_doAnimation;
