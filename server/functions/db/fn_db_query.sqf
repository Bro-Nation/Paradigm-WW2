/*
    File: fn_db_query.sqf
    Author: Cerebral
    Date: 2022-07-15
    Last Update: 2022-07-15
    Public: No
    
    Description:
        Queries a mysql/mariadb with a given statement.
    
    Parameter(s):
		_statement  - Statement to be executed. [STRING]
        _mode       - [INTEGER]
                      1: DELETE, SELECT
                      2: UPDATE, INSERT
        _returnType - [BOOL]
                      true:  Single array
                      false: Multiple arrays
    
    Returns:
		STRING or ARRAY
    
    Example(s):
		[_query, 2, true] call para_s_fnc_db_query;
*/

params ["_statement","_mode","_returnType"];
private _key = "extDB3" callExtension format ["%1:%2:%3", _mode, call mf_sql_id, _statement];

if (_mode isEqualTo 1) exitWith {true};

_key = call compile format ["%1",_key];
_key = (_key select 1);

private _result = "extDB3" callExtension format ["4:%1", _key];
switch (_result) do 
{
    case "[3]": {
        while {true} do 
        {
            if !(_result == "[3]") exitWith {};

            _result = "extDB3" callExtension format ["4:%1", _key];
        };
    };

    case "[5]": {
        private _loop = true;
        while {_loop} do 
        {
            _result = "";
            while {true} do
            {
                _buffer = "extDB3" callExtension format ["5:%1", _key];
                if (_buffer isEqualTo "") exitWith {_loop = false};
                _result = _result + _buffer;
            };
        };
    };
};

_result = call compile _result;
if ((_result select 0) isEqualTo 0) exitWith {
    diag_log format ["Paradigm: DB Error: %1", _result]; 
    []
};

_return = (_result select 1);
if (!_returnType && count _return > 0) then {
    _return = (_return select 0);
};

_return;