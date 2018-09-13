%%%-------------------------------------------------------------------
%%% @author yj
%%% @doc
%%%
%%% Created : 13. 九月 2018 下午5:37
%%%-------------------------------------------------------------------
-module(erl_func).

-compile(no_native).

-on_load(init/0).

-export([
    edit_distance/2
]).




init() ->
    Path = case code:lib_dir(common, priv) of
               {error, _} -> "./priv/erl_func";
               Str -> Str ++ "/erl_func"
           end,
    erlang:load_nif(Path, 0).


-spec edit_distance(binary(), binary()) -> integer().

edit_distance(_Src, _Dest) ->
    erlang:nif_error(nif_not_loaded).


%%%===================================================================
%%% Unit tests
%%%===================================================================

-ifdef(TEST).
-include_lib("eunit/include/eunit.hrl").
-endif.

-ifdef(TEST).
load_nif_test() ->
    ?assertEqual(ok, load_nif(filename:join(["..", "priv", "lib"]))).

dis_1_test() ->
    ?assertEqual(
        1,
        erl_func:edit_distance(<<"utf-8">>, <<"koi8-r">>)).
-endif.
