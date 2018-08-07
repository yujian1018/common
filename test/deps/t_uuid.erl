%%%-------------------------------------------------------------------
%%% @author yj
%%% @doc
%%%
%%% Created : 13. 七月 2018 下午3:21
%%%-------------------------------------------------------------------
-module(t_uuid).

-include("erl_pub.hrl").

-export([
    repeat/0, repeat/2,
    eff/0, eff/2
]).

-define(SEQ, 1000).
-define(PAGE, 1000).
-define(MAX, 1000000).


repeat() ->
    Tc = timer:tc(t_uuid, repeat, [1, maps:new()]),
    io:format("time cost:~p~n", [Tc]).

eff() ->
    Seq = lists:seq(1, ?SEQ),
    Tc = timer:tc(t_uuid, eff, [0, Seq]),
    io:format("time cost:~p~n", [Tc]).


repeat(?MAX, Maps) -> maps:size(Maps);
repeat(N, Maps) ->
    Key = erl_uuid:uuid(),
    repeat(N + 1, maps:put(Key, 1, Maps)).


eff(?PAGE, _Seq) -> ok;
eff(Int, Seq) ->
    Fun = fun(_I) -> erl_uuid:uuid() end,
    erl_list:lists_spawn(Fun, Seq),
    eff(Int + 1, Seq).
