private _serverNumber = 2;	
uiNamespace setVariable ["serverNumber", _serverNumber];

[] spawn {
    while {isNil "stopCuratorLoop"} do {
      { _x addCuratorEditableObjects [vehicles + allUnits]} forEach allCurators;
      uisleep 10;
    };
};

private _query = format ["SELECT user_id FROM curators WHERE server_number = %1", _serverNumber];
private _queryResult = [_query, 2, true] call para_s_fnc_db_query;

private _result = [];
{
	private _uid = _x select 0;
	_result pushBack _uid;
} forEach _queryResult;

diag_log format["[+] Curator UIDs: %1", _result];
missionNamespace setVariable ["curatorUIDs", _result];
publicVariable "curatorUIDs";
