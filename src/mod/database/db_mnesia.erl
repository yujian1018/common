%%%-------------------------------------------------------------------
%%% @author yujian
%%% @doc
%%%
%%% Created : 16. 五月 2016 下午5:23
%%%-------------------------------------------------------------------
-module(db_mnesia).

-include("erl_pub.hrl").


-export([
    write/1,
    read/2,
    do/1, transaction/1,
    foldl/3
]).


write(VO) ->
    mnesia:dirty_write(VO).


read(TabName, Key) ->
    mnesia:dirty_read(TabName, Key).


do(Q) ->
    F = fun() -> qlc:e(Q) end,
    {atomic, Val} = mnesia:transaction(F),
    Val.

%%  @doc    事务
transaction(F) ->
    case mnesia:transaction(F) of
        {atomic, Val} ->
            Val;
        Other ->
            ?ERROR("transaction error:~p~n", [Other]),
            {error, Other}
    end.



foldl(Fun, DataInit, TabName) -> foldl(Fun, DataInit, TabName, 0).

foldl(Fun, Data, Tab, Index) ->
    case mnesia:dirty_slot(Tab, Index) of
        '$end_of_table' -> Data;
        DataQuery -> foldl(Fun, lists:foldl(Fun, Data, DataQuery), Tab, Index + 1)
    end.