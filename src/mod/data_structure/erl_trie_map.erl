%%%-------------------------------------------------------------------
%%% @author yj
%%% @doc  存储格式map  #{<<"怎"/utf8>> => #{}, tag => [{<<"F">>, 1070010001}, {<<"E">>, 1070010001}]}
%%%
%%% Created : 03. 九月 2018 上午10:33
%%%-------------------------------------------------------------------
-module(erl_trie_map).

-include("erl_pub.hrl").

%%-compile(export_all).

-export([
    new/2,
    search/2, search_max/3, search_max/2
]).

%% 初始化
%%-spec new(#{}, [{{<<"F">>, 1070010001}, [<<"我们都有一个家"/utf8>>]}]) -> #{}.
new(Trie, Data) ->
    lists:foldl(
        fun({Tag, Items}, TrieAcc) ->
            if
                Items =:= [] -> TrieAcc;
                true -> add_items(TrieAcc, Items, Tag)
            end
        end, Trie, Data).


%% 1.计算分支中老的节点更新
%% 2.计算分支中新的节点
add_items(Map, Items, Tag) ->
    lists:foldl(
        fun(Item, MapAcc) ->
            set_branch(MapAcc, erl_utf8:to_list(Item), Tag)
        end,
        Map,
        Items).


new_branch([Char], Tag) -> #{Char => null, tag => Tag};
new_branch([Char | R], Tag) -> new_acc(R, #{Char => null, tag => Tag}).

new_acc([], MapAcc) -> MapAcc;
new_acc([Char | R], MapAcc) -> new_acc(R, #{Char => MapAcc}).


set_branch(Map, Words, Tag) ->
    set_branch(Map, Words, Tag, []).


set_branch(_Map, [], _Tag, TreeMaps) ->
    lists:foldl(
        fun({Key, KeyMaps}, MapsAcc) ->
            MapsAcc#{Key => KeyMaps}
        end,
        #{},
        TreeMaps);


set_branch(Map, [Char1, Char2 | RWords], Tag, TreeMaps) ->
    case maps:get(Char1, Map, null) of
        null ->
            set_branch(Map, [], Tag, [{Char1, #{Char1 => new_branch([Char2 | RWords], Tag)}} | TreeMaps]);
        Val ->
            if
                RWords == [] ->
                    set_branch(Map, [], Tag, [{Char1, #{Char1 => new_branch([Char2 | RWords], Tag)}} | TreeMaps]);
                true ->
                    set_branch(Val, [Char2 | RWords], Tag, [{Char1, Val} | TreeMaps])
            end
    end.


search(Dict, Input) -> search(Dict, Input, []).

search(_Dict, [], Acc) -> lists:reverse(Acc);
search(Dict, [H | Lists], Acc) ->
    case search(Dict, [H | Lists], [], []) of
        [] -> search(Dict, Lists, [{skip, H} | Acc]);
        MatchWords -> [search(Dict, RLists, [{match, Words, Markup} | Acc]) || {RLists, Words, Markup} <- MatchWords]
    end.


%% @doc 一次匹配中匹配出的所有情况
search(_Dict, [], _Words, Acc) -> Acc;
search(Dict, [H | Lists], Words, Acc) ->
    case dict:find(H, Dict) of
        error ->
            if
                Acc == [] -> Acc;
                true -> Acc
            end;
        {ok, DictChild} ->
            case dict:find(mark, DictChild) of
                error ->
                    search(DictChild, Lists, Words ++ [H], Acc);
                {ok, Markup} ->
                    search(DictChild, Lists, Words ++ [H], [{Lists, Words ++ [H], Markup} | Acc])
            end
    end.


search_max(Dict, Input) -> search_max(Dict, Input, []).

search_max(_Dict, [], Acc) -> lists:reverse(Acc);
search_max(Dict, Lists, Acc) ->
    case search_max(Dict, Lists, <<>>, []) of
        error ->
            [H | R] = Lists,
            search_max(Dict, R, [{skip, H} | Acc]);
        {RLists, Words, Markup} ->
            search_max(Dict, RLists, [{match, Words, Markup} | Acc])
    end.


search_max(_Tree, [], Words, Acc) -> {[], Words, Acc};
search_max(Tree, [Char | R], Words, Acc) ->
    case maps:find(Char, Tree) of
        error ->
            if
                Acc == [] -> error;
                true -> {[Char | R], Words, Acc}
            end;
        {ok, TreeChild} ->
            case maps:find(mark, TreeChild) of
                error -> search_max(TreeChild, R, Words ++ [Char], Acc);
                {ok, Markup} -> search_max(TreeChild, R, Words ++ [Char], Markup)
            end
    end.
