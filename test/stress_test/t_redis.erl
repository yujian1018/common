%%%-------------------------------------------------------------------
%%% @author yujian
%%% @doc
%%%
%%% Created : 15. 二月 2017 下午1:40
%%%-------------------------------------------------------------------
-module(t_redis).

-define(SEQ, 1000).

-export([t/0]).

t() ->
    Seq = lists:seq(1, ?SEQ),
    T1 = os:timestamp(),
    redis_r(0, Seq),
    io:format("time cost:~p~n", [timer:now_diff(os:timestamp(), T1)]).

redis_r(100, _Seq) -> ok;
redis_r(Int, Seq) ->
    Fun = fun(_I) ->
        Uid = integer_to_binary(Int * ?SEQ + _I),
%%        DanLv = erl_random:random(52),
%%        set_hash(Uid, DanLv)
        get_hash(Uid)
          end,
    erl_list:lists_spawn(Fun, Seq),
    redis_r(Int + 1, Seq).


set_hash(Uid, DanLv) ->
    qp([
        [<<"ZADD">>, <<"rank:dan_lv_1">>, DanLv, Uid],
        [<<"SET">>, Uid, Uid],
        [<<"HSET">>, <<"set:", Uid/binary>>, <<"uid">>, Uid]
    ]).

get_hash(_Uid) ->
%%    q([<<"GET">>, Uid]).
%%    q([<<"HGET">>, <<"set:", Uid/binary>>, <<"uid">>]).
%%    q([<<"ZREVRANK">>, <<"rank:dan_lv_1">>, Uid]).
    q([<<"ZREVRANGE">>, <<"rank:dan_lv_1">>, 0, 40]).
%%qp([
%%    [<<"ZREVRANK">>, <<"rank:dan_lv_1">>, Uid],
%%    [<<"ZREVRANGE">>, <<"rank:dan_lv_1">>, 0, 40],
%%    [<<"GET">>, Uid],
%%    [<<"HGET">>, <<"set:", Uid/binary>>, <<"uid">>]
%%]).

q(Command) ->
    {ok, Node} = application:get_env(login, db_node),
    rpc:call(Node, db_redis, q, [Command]).

qp(Command) ->
    {ok, Node} = application:get_env(login, db_node),
    rpc:call(Node, db_redis, qp, [Command]).