%%%-------------------------------------------------------------------
%%% @author yj
%%% @doc
%%%
%%% Created : 13. 七月 2018 下午3:54
%%%-------------------------------------------------------------------
-module(erl_maps).

-export([
    find/2
]).

find([], V) -> V;
find([H | R], Maps) ->
    K = binary_to_atom(H, 'utf8'),
    case maps:find(K, Maps) of
        {ok, V} -> find(R, V);
        _ -> <<>>
    end.
