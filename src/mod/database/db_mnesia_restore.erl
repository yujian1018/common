%%%-------------------------------------------------------------------
%%% @author yujian
%%% @doc
%%%
%%% Created : 16. 五月 2016 下午5:23
%%%-------------------------------------------------------------------
-module(db_mnesia_restore).

-include("erl_pub.hrl").


-export([
    load_textfile/1
]).

load_textfile(File) ->
    db_mnesia:ensure_started(),
    {ok, S} = file:open(File, [read]),
    {ok, {tables, _Tabs}} = io:read(S, ''),
    next(S).


next(S) ->
    case io:read(S, '') of
        {ok, Record} ->
            mnesia:dirty_write(Record),
            next(S);
        _Err -> ?ERROR("ERR io:read", [_Err])
    end.

