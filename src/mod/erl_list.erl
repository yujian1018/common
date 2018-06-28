%%%-------------------------------------------------------------------
%%% @author yujian
%%% @doc
%%%
%%% Created : 16. 四月 2016 上午11:05
%%%-------------------------------------------------------------------
-module(erl_list).

-include("erl_pub.hrl").

-export([
    lists_spawn/2,
    diff/3,
    diff_kv/3,
    foldl/4,
    map/3, map_break/2,
    set_element/2,
    keyfind_jiffy/2
]).


lists_spawn(Fun, Lists) ->
    Ref = erlang:make_ref(),
    Pid = self(),
    [
        receive
            {Ref, Res} -> Res;
            _ -> ok
        end || _ <-
        [spawn(
            fun() ->
                Res =
                    try
                        Fun(I)
                    catch
                        _Exit:_WHY ->
                            ?ERROR("err:~p~n", [[_Exit, _WHY]]),
                            {nomatch, {_Exit, _WHY}}
                    end,
                Pid ! {Ref, Res}
            end) || I <- Lists]
    ].


diff([], _Ids, DelAcc) -> DelAcc;
diff([OldId | OldIds], Ids, DelAcc) ->
    case lists:member(OldId, Ids) of
        true ->
            diff(OldIds, Ids, DelAcc);
        false ->
            diff(OldIds, Ids, [OldId | DelAcc])
    end.


diff_kv([], _Channels, Acc) -> Acc;
diff_kv([K | OldChannels], Channels, Acc) ->
    case lists:keymember(K, 2, Channels) of
        true ->
            diff_kv(OldChannels, Channels, Acc);
        false ->
            diff_kv(OldChannels, Channels, [K | Acc])
    end.


foldl(_Fun, [], _List2, Acc) -> lists:reverse(Acc);
foldl(Fun, [H1 | List1], [H2 | List2], Acc) -> foldl(Fun, List1, List2, Fun(H1, H2, Acc)).


map(Fun, List1, List2) -> map(Fun, List1, List2, []).

map(_Fun, [], _List2, Acc) -> lists:reverse(Acc);
map(Fun, [H1 | List1], [H2 | List2], Acc) -> map(Fun, List1, List2, [Fun(H1, H2) | Acc]).


map_break(_Fun, []) -> false;
map_break(Fun, [H | R]) ->
    case Fun(H) of
        false -> map_break(Fun, R);
        Ret -> Ret
    end.


set_element(Fun, Lists) -> set_element(Fun, Lists, []).

set_element(_Fun, [], ListsAcc) -> lists:reverse(ListsAcc);
set_element(Fun, [H | R], ListsAcc) -> set_element(Fun, R, [Fun(H) | ListsAcc]).



keyfind_jiffy([H], List) ->
    case lists:keyfind(H, 1, List) of
        false -> false;
        {_, Val} -> Val
    end;

keyfind_jiffy([H | R], List) ->
    case lists:keyfind(H, 1, List) of
        false -> false;
        {_, {Val}} -> keyfind_jiffy(R, Val)
    end.