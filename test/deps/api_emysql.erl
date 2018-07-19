%%%-------------------------------------------------------------------
%%% @author yujian
%%% @doc
%%%-------------------------------------------------------------------
-module(api_emysql).

-export([start/0, execute/1]).
-export([select/3, update/3, insert/3, delete/2]).


start() ->
    crypto:start(),
    emysql:start(),
    {ok, Size} = application:get_env(emysql, size),
    {ok, User} = application:get_env(emysql, user),
    {ok, Password} = application:get_env(emysql, password),
    {ok, Host} = application:get_env(emysql, host),
    io:format("mysql start:~p~n", [[User, Host, "ping"]]),
    emysql:add_pool(ping_pool, [{size, Size},
        {user, User},
        {password, Password},
        {host, Host},
        {database, "ping"},
        {encoding, utf8}]).


execute(SQL) ->
    Sql = iolist_to_binary(SQL),
    io:format("SQL:~ts~n", [Sql]),
    try emysql:execute(ping_pool, Sql, 10000) of
        {result_packet, _, _, Data, _} ->
            Data;
        {ok_packet, _, _, Data, _, _, _} ->
            Data;
        [{result_packet, _, _, Data, _}, _] ->
            Data;
        [{ok_packet, _, _, _, __, _, _} | _] ->
            ok;
        _Error ->
            io:format("emysql:execute error:~p~n SQL:~ts~n", [_Error, Sql]),
            {error, 1}
    catch
        _E1:_E2 ->
            io:format("emysql:execute crash:catch:~p~nwhy:~p~nSQL:~p~n", [_E1, _E2, Sql]),
            {error, 1}
    end.


%SELECT team_id FROM team_account WHERE account_id = '18721112975'LIMIT 0,1;
%%select(Tab, Select, Condition) ->
%%    execute(["SELECT ", Select, " FROM ", Tab, " WHERE ", Condition, ";"]).

select(Tab, Select, Condition0) ->
    Arg = string:join(Select, ", "),
    Condition1 = string:join([[K, "='", V, "'"] || {K, V} <- Condition0], " AND "),
    execute(["SELECT ", Arg, " FROM ", Tab, " WHERE ", Condition1, ";"]).



%UPDATE `ping`.`account_tab` SET `user_name` = '用户名称' WHERE `account_id` = '18721112975';
update(Tab, Update, Condition) ->
    execute(["UPDATE ", Tab, " SET ", Update, " WHERE ", Condition, ";"]).


%INSERT INTO `ping`.`task_submit` (team_id,create_times,task_content,task_work_state, task_work_innovate) VALUES (1,1446715643,'工作任务内容', '1', '1');
insert(Tab, Insert, Value) ->
    execute(["INSERT INTO ", Tab, Insert, " VALUES ", Value, ";"]).

%DELETE FROM team_account WHERE account_id = '111'
delete(Tab, Condition) ->
    execute(["DELETE FROM ", Tab, " WHERE ", Condition]).

%mnesia:dump_to_textfile( "./mnesia.dump.tab" ).
%mnesia:load_textfile( "./mnesia.dump.tab" ).