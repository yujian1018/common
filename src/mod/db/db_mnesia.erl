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
    foldl_record/3
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


foldl_record(Fun, Tab, Index) ->
    case mnesia:dirty_slot(Tab, Index) of
        '$end_of_table' ->
            ok;
        L ->
            lists:foreach(fun(I) -> Fun(I) end, L),
            foldl_record(Fun, Tab, Index + 1)
    end.