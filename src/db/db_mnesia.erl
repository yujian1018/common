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
    do/1, transaction/1
]).


write(VO) ->
    mnesia:dirty_write(VO).


read(TabName, Key) ->
    mnesia:dirty_read(TabName, Key).


do(Q) ->
    F = fun() -> qlc:e(Q) end,
    transaction(F).

%%  @doc    事务
transaction(F) ->
    case mnesia:transaction(F) of
        {atomic, Val} ->
            Val;
        Other ->
            ?ERROR("transaction error:~p~n", [Other]),
            {error, Other}
    end.