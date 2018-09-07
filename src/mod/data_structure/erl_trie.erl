%%%-------------------------------------------------------------------
%%% @author yj
%%% @doc  优化方案：ets
%%%
%%% Created : 03. 九月 2018 上午10:33
%%%-------------------------------------------------------------------
-module(erl_trie).

-include("erl_pub.hrl").

-export([
    init/2,
    search/3
]).

%% 初始化
init(Trie, Data) ->
    lists:foldl(
        fun({Item, Markup}, TrieAcc) ->
            if
                Item =:= [] -> TrieAcc;
                true -> add(TrieAcc, Item, Markup)
            end
        end, Trie, Data).


%% 1.计算分支中老的节点更新
%% 2.计算分支中新的节点
add(Tree, Keys, Markup) ->
%%    ?INFO("aaa:~tp", [[Tree, Keys, Markup]]),
    case add(Tree, Keys, Markup, []) of
        {nothing, _Tree, _KeysH} ->
            Tree;
        {new_branch, NewBranch, []} ->
            NewBranch;
        {new_branch, NewBranch, KeysH} ->
%%            ?INFO("aaa:~tp", [[NewBranch, KeysH]]),
            FunKVs =
                fun(Key, {TreeAcc, KVsAcc}) ->
                    #{Key := TreeV} = TreeAcc,
                    {TreeV, [TreeV | KVsAcc]}
                end,
            {_, KVs} = lists:foldl(FunKVs, {Tree, []}, KeysH),
            FunTree =
                fun(KV, {TreeAcc, [K | KList]}) ->
%%                    ?INFO("bbb:~tp", [[TreeAcc, K, KV]]),
                    NewTreeAcc =
                        if
                            length([K | KList]) =:= length(KeysH) ->
                                #{K => NewBranch};
                            true ->
                                #{K => maps:merge(KV, TreeAcc)}
                        end,
%%                    ?INFO("ccc:~tp", [NewTreeAcc]),
                    {NewTreeAcc, KList}
                end,
            {NewTree, _} = lists:foldl(FunTree, {#{}, lists:reverse(KeysH)}, KVs),
            maps:merge(Tree, NewTree);

        {reset, NewBranch, []} ->
            maps:merge(Tree, NewBranch);
        {reset, NewBranch, KeysH} ->
%%            ?INFO("bbb:~tp", [[NewBranch, KeysH]]),
            FunKVs =
                fun(Key, {TreeAcc, KVsAcc}) ->
                    #{Key := TreeV} = TreeAcc,
                    {TreeV, [TreeV | KVsAcc]}
                end,
            {_, KVs} = lists:foldl(FunKVs, {Tree, []}, KeysH),

            FunTree =
                fun(KV, {TreeAcc, [K | KList]}) ->
                    NewTreeAcc =
                        if
                            length([K | KList]) =:= length(KeysH) ->
                                #{K => NewBranch};
                            true ->
                                #{K => maps:merge(KV, TreeAcc)}
                        end,
                    {NewTreeAcc, KList}
                end,
            {NewTree, _} = lists:foldl(FunTree, {#{}, lists:reverse(KeysH)}, KVs),
            maps:merge(Tree, NewTree)
    end.


add(Trees, [Key | KList], Markup, KeysH) ->
    case maps:find(Key, Trees) of
        {ok, TrieChild} ->
            if
                KList =:= [] ->
                    case maps:find(markup, TrieChild) of
                        error ->
                            {reset, Trees#{Key => TrieChild#{markup => [Markup]}}, KeysH};
                        {ok, OldMarkup} ->
                            case lists:member(Markup, OldMarkup) of
                                true ->
                                    {nothing, Trees, KeysH};
                                false ->
                                    {reset, Trees#{Key => TrieChild#{markup => [Markup | OldMarkup]}}, KeysH}
                            end
                    end;
                true -> add(TrieChild, KList, Markup, KeysH ++ [Key])
            end;
        error ->
            BranchMaps =
                if
                    KList =:= [] ->
                        #{markup => [Markup]};
                    true -> new_branch(lists:reverse(KList), Markup)
                end,
            {new_branch, Trees#{Key => BranchMaps}, KeysH}
    end.


new_branch([Char], Markup) -> #{Char => #{markup => [Markup]}};
new_branch([Char | R], Markup) -> new_acc(R, #{Char => #{markup => [Markup]}}).

new_acc([Char], BranchAcc) -> #{Char => BranchAcc};
new_acc([Char | R], BranchAcc) -> new_acc(R, #{Char => BranchAcc}).


search(_Trie, [], Acc) -> lists:reverse(Acc);
search(Trie, [H | Lists], Acc) ->
    case search(Trie, [H | Lists], [], []) of
        [] ->
            search(Trie, Lists, [{skip, H} | Acc]);
        {RLists, Words, Markup} ->
            search(Trie, RLists, [{match, Words, Markup} | Acc])
    end.


%% @doc 一次匹配中匹配出的所有情况
search(_Trie, [], _Words, Acc) -> Acc;
search(Trie, [H | Lists], Words, Acc) ->
    case maps:find(H, Trie) of
        error ->
            if
                Acc == [] -> Acc;
                true -> Acc
            end;
        {ok, TreeChild} ->
            case maps:find(markup, TreeChild) of
                error ->
                    search(TreeChild, Lists, Words ++ [H], Acc);
                {ok, Markup} ->
                    search(TreeChild, Lists, Words ++ [H], {Lists, Words ++ [H], Markup})
            end
    end.
