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
    add_words/2,
    search/2
]).

%% 初始化
%%-spec new(#{}, [{{<<"F">>, 1070010001}, [[<<"我">>, <<"们">>, <<"都">>, <<"有">>, <<"一">>, <<"个">>, <<"家"/utf8>>]}]) -> #{}.
add_words(Trie, Data) ->
    lists:foldl(
        fun({Tag, Items}, TrieAcc) ->
            if
                Items =:= [] -> TrieAcc;
                true -> add_words(TrieAcc, Items, Tag)
            end
        end, Trie, Data).


%% 1.计算分支中老的节点更新
%% 2.计算分支中新的节点
add_words(Map, Items, Tag) ->
    lists:foldl(
        fun(Item, MapAcc) ->
%%            ?INFO("aaa:~tp", [[Item, Tag]]),
            MapAccRet = set_branch(MapAcc, Item, Tag),
            maps:merge(MapAcc, MapAccRet)
        end,
        Map,
        Items).


new_branch([], Tag) -> #{tag => [Tag]};
new_branch([Char], Tag) -> #{Char => #{tag => [Tag]}};
new_branch(Words, Tag) ->
    [Char | R] = lists:reverse(Words),
    new_acc(R, #{Char => #{tag => [Tag]}}).

new_acc([], MapAcc) -> MapAcc;
new_acc([Char | R], MapAcc) -> new_acc(R, #{Char => MapAcc}).


set_branch(Map, Words, Tag) ->
    set_branch(Map, Words, Tag, []).


set_branch(_Map, [], _Tag, TreeMaps) ->
%%    ?INFO("TreeMaps 111：~tp", [TreeMaps]),
    RMap = lists:foldl(
        fun({Key, Val}, MapsAcc) ->
%%            ?INFO("TreeMaps 222：~tp", [[{Key, Val}, MapsAcc]]),
            #{Key => maps:merge(Val, MapsAcc)}
        end,
        #{},
        TreeMaps),
%%    ?INFO("TreeMaps 333：~tp", [[RMap]]),
    RMap;

set_branch(Map, [Char], Tag, TreeMaps) ->
    case maps:get(Char, Map, null) of
        null ->
            set_branch(#{}, [], Tag, [{Char, new_branch([], Tag)} | TreeMaps]);
        Val ->
            TreeMap = set_tag(Tag, Char, Val),
            set_branch(Val, [], Tag, [TreeMap | TreeMaps])
    end;

set_branch(Map, [Char | RWords], Tag, TreeMaps) ->
    case maps:get(Char, Map, null) of
        null ->
            TreeMap = {Char, new_branch(RWords, Tag)},
            set_branch(#{}, [], Tag, [TreeMap | TreeMaps]);
        Val ->
%%            ?INFO("ccc:~ts", [[Map, [Char | RWords], TreeMaps]]),
            set_branch(Val, RWords, Tag, [{Char, Val} | TreeMaps])
    end.

set_tag(Tag, Key, Val) ->
    case maps:get(tag, Val, null) of
        null -> {Key, Val#{tag => [Tag]}};
        TagOld ->
            case lists:member(Tag, TagOld) of
                true -> {Key, Val#{tag => TagOld}};
                false -> {Key, Val#{tag => [Tag | TagOld]}}
            end
    end.

search(TrieMap, Words) -> [I || {I} <- lists:flatten(search(TrieMap, Words, []))].

search(_TrieMap, [], Acc) -> {lists:reverse(Acc)};
search(TrieMap, [H | Lists], Acc) ->
    case words_tag(TrieMap, [H | Lists], [], []) of
        [] ->
            search(TrieMap, Lists, [{skip, H} | Acc]);
        MatchWords ->
%%            ?INFO("aaa:~tp", [MatchWords]),
            [search(TrieMap, RLists, [{match, Words, Tags} | Acc]) || {RLists, Words, Tags} <- MatchWords]
    end.


%% @doc 一次匹配中匹配出的所有情况
words_tag(_Trie, [], _MatchWords, Acc) ->
%%    ?INFO("bbb:~tp", [[_MatchWords, Acc]]),
    Acc;
words_tag(Trie, [Char | RWords], MatchWords, Acc) ->
%%    ?INFO("ccc:~tp", [Acc]),
    case maps:get(Char, Trie, null) of
        null ->
            Acc;
        TrieChild ->
            case maps:get(tag, TrieChild, null) of
                null ->
                    words_tag(TrieChild, RWords, MatchWords ++ [Char], Acc);
                Tags ->
                    words_tag(TrieChild, RWords, MatchWords ++ [Char], [{RWords, MatchWords ++ [Char], Tags} | Acc])
            end
    end.
