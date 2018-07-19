%%%-------------------------------------------------------------------
%%% @author yj
%%% @doc
%%%
%%% Created : 13. 七月 2018 下午3:21
%%%-------------------------------------------------------------------
-module(t_uuid).

-include("erl_pub.hrl").

-export([
    test/0
]).


test() ->
    test(1, maps:new()).


test(1000000, Maps) -> maps:size(Maps);
test(N, Maps) ->
    Key = erl_uuid:uuid(),
    test(N + 1, maps:put(Key, 1, Maps)).
