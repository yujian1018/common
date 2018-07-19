%%%-------------------------------------------------------------------
%%% @author yujian
%%% @doc
%%%
%%% Created : 23. 十一月 2017 下午4:31
%%%-------------------------------------------------------------------
-module(erl_erlydtl).

-export([
    load/1
]).

load(Path) ->
    {ok, Files} = file:list_dir(Path),
    Fun = fun(FileName) ->
        case lists:suffix(".tpl", FileName) of
            true ->
                [Tpl | _] = string:tokens(FileName, "."),
                erlydtl:compile(Path ++ "/" ++ FileName, Tpl, [{out_dir, "ebin"}]);
            false ->
                error
        end
          end,
    lists:foreach(Fun, Files).
