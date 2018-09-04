%%%-------------------------------------------------------------------
%%% @author yujian
%%% @doc
%%%
%%% Created : 29. 十二月 2016 上午11:39
%%%-------------------------------------------------------------------
-module(erl_file).

-include("erl_pub.hrl").

-export([
    get_mods/2,
    is_behaviour/2,
    read_file/2,
    dirs/1
]).


get_mods(AppName, Behaviour) ->
    case code:lib_dir(AppName, ebin) of
        {error, _Err} -> ?ERROR("no app:~p~n", [AppName]),[];
        Pwd ->
            {ok, FileNames} = file:list_dir(Pwd),
            lists:foldl(
                fun(FileName, ModAcc) ->
                    case lists:reverse(FileName) of
                        "maeb." ++ R ->
                            Mod = list_to_atom(lists:reverse(R)),
                            case is_behaviour(Mod, Behaviour) of
                                true -> [Mod | ModAcc];
                                false -> ModAcc
                            end;
                        _R -> ModAcc
                    end
                end,
                [],
                FileNames)
    end.


is_behaviour(Mod, Behaviour) ->
    lists:member({behaviour, [Behaviour]}, Mod:module_info(attributes)).


read_file(AppName, File) ->
    Pwd = code:lib_dir(AppName),
    {ok, Bin} = file:read_file(Pwd ++ File),
    Bin.


dirs(Dir) -> dirs1(filename:split(Dir), "", []).
dirs1([], _, Acc) -> lists:reverse(Acc);
dirs1([H | T], "", []) -> dirs1(T, H, [H]);
dirs1([H | T], Last, Acc) ->
    Dir = filename:join(Last, H),
    dirs1(T, Dir, [Dir | Acc]).