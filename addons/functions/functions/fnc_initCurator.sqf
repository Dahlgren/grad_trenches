#include "script_component.hpp"
/*
 * Author: chris579
 * Initializes curator logics with Event Handlers.
 *
 * Arguments:
 * 0: Curator logic <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [Logic] call grad_trenches_functions_fnc_initCurator
 *
 * Public: No
 */

params [
    ["_logic", objnull, [objNull]]
];

_logic addEventHandler ["CuratorObjectEdited", {
    params ["", "_object"];

    if (isClass (configFile >> "CfgVehicles" >> typeOf _object >> "CamouflagePositions1")) then {
        _object setObjectTextureGlobal [0, surfaceTexture (getPos _object)];
    };
}];

_logic addEventHandler ["CuratorObjectPlaced", {
	params ["", "_object"];

    systemChat str _object;

    if (isClass (configFile >> "CfgVehicles" >> typeOf _object >> "CamouflagePositions1")) then {
        _object setObjectTextureGlobal [0, surfaceTexture (getPos _object)];
    };
}];
