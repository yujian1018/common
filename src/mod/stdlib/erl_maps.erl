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
    K =
        if
            is_binary(H) -> binary_to_atom(H, 'utf8');
            true -> H
        end,
    case maps:find(K, Maps) of
        {ok, V} -> find(R, V);
        _ -> <<>>
    end.
