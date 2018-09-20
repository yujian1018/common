%%%-------------------------------------------------------------------
%%% @author yujian
%%% @doc
%%%
%%% Created : 15. 二月 2017 下午1:40
%%%-------------------------------------------------------------------
-module(t_mysql).

-export([
    t/0,
    mysql_r/2, mysql_w/2
]).

-define(SEQ, 1000).

call_ea(App, Sql) ->
    {ok, Node} = application:get_env(App, db_node),
    rpc:call(Node, db_mysql, ea, [Sql]).

t() ->
    Seq = lists:seq(1, ?SEQ),
    T1 = os:timestamp(),
    mysql_rw(0, Seq),
    io:format("time cost:~p~n", [timer:now_diff(os:timestamp(), T1)]).


mysql_r(50, _Seq) -> ok;
mysql_r(Int, Seq) ->
    Fun = fun(_I) ->
        Uin = integer_to_binary(Int * ?SEQ + _I),
        call_ea(login, <<"select uin, pwd from account where account='", Uin/binary, "' AND channel_id = '-1'  limit 0, 1;">>)
          end,
    erl_list:lists_spawn(Fun, Seq),
    mysql_r(Int + 1, Seq).

mysql_w(10, _Seq) -> ok;
mysql_w(Int, Seq) ->
    Fun = fun(_I) ->
        Uin = integer_to_binary(Int * ?SEQ + _I + 70000),
        call_ea(login, [<<"INSERT INTO account (account, pwd, c_times, sdk_platform, packet_id, channel_id) VALUES
                                                               ('", Uin/binary, "','222','333', '444', '555','666');
        insert into token(uin, token, c_times) values (", Uin/binary, ", '", Uin/binary, "', 333) ON DUPLICATE KEY UPDATE token = '", Uin/binary, "', c_times = 333;">>])
          end,
    erl_list:lists_spawn(Fun, Seq),
    mysql_w(Int + 1, Seq).

mysql_rw(10, _Seq) -> ok;
mysql_rw(Int, Seq) ->
    Fun = fun(_I) ->
        Uin = integer_to_binary(Int * ?SEQ + _I + 10000),
        call_ea(login, [<<"
        select uin, pwd from account where account='", Uin/binary, "' AND channel_id = '-1'  limit 0, 1;
        SELECT token FROM token WHERE uin = ", Uin/binary, ";
        insert into token(uin, token, c_times) values (", Uin/binary, ", '", Uin/binary, "', 333) ON DUPLICATE KEY UPDATE token = '", Uin/binary, "', c_times = 333;">>])
          end,
    erl_list:lists_spawn(Fun, Seq),
    mysql_rw(Int + 1, Seq).