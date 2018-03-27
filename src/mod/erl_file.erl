%%%-------------------------------------------------------------------
%%% @author yujian
%%% @doc
%%%
%%% Created : 29. 十二月 2016 上午11:39
%%%-------------------------------------------------------------------
-module(erl_file).

-export([
    get_mods/2,
    is_behaviour/2,
    read_file/2
]).


get_mods(AppName, Behaviour) ->
    Pwd = code:lib_dir(AppName, ebin),
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
        FileNames).


is_behaviour(Mod, Behaviour) ->
    lists:member({behaviour, [Behaviour]}, Mod:module_info(attributes)).


read_file(AppName, File) ->
    Pwd = code:lib_dir(AppName),
    {ok, Bin} = file:read_file(Pwd ++ File),
    Bin.