%%%-------------------------------------------------------------------
%%% @author yujian
%%% @doc
%%%
%%% Created : 10. 二月 2017 上午11:15
%%%-------------------------------------------------------------------


-define(return_err(ErrCode), erlang:throw({throw, ErrCode, <<>>})).
-define(return_err(ErrCode, Msg), erlang:throw({throw, ErrCode, Msg})).
-define(throw(ErrCode), {throw, ErrCode, <<>>}).
-define(throw(ErrCode, Msg), {throw, ErrCode, Msg}).

-define(assertEqual(Expect, Err), if (Expect) =:= true -> ok;true -> erlang:throw({throw, Err}) end).

-define(check(Fun, Msg), ?check(Fun, Msg, [])).
-define(check(Fun, Msg, Arg),
    case (Fun) of
        true -> true;
        false ->
            io:format(Msg, Arg),
            erlang:throw({throw, {Msg, Arg}})
    end).