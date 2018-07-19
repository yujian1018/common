%%%-------------------------------------------------------------------
%%% @author yujian
%%% @doc
%%% Created : 03. 三月 2016 下午2:12
%%%-------------------------------------------------------------------
-module(erl_cowboy_handler).

-export([init/3]).
-export([handle/2]).
-export([terminate/3]).

%%{"aya":"66666666","keyword":"范冰冰","offset":"-1","direction":"1","reqlen":"10"}

init({_, http}, Req, []) ->
    {ok, Req, undefined}.


handle(Req, State) ->
    Req3 = case cowboy_req:method(Req) of
               {<<"POST">>, Req1} ->
                   {ok, PostData, Req2} = cowboy_req:body_qs(Req1),
%%                   io:format("post data:~p~nOpts:~p~n", [PostData, Opts]),
                   case PostData of
                       [{<<"url">>, Url},
                           {<<"method">>, <<"POST">>},
                           {<<"count">>, Count},
                           {<<"process">>, Process},
                           {<<"args">>, Args}] ->
                           Time = inets_httpc:test(unicode:characters_to_list(Url), binary_to_integer(Count), binary_to_integer(Process), Args),
                           cowboy_req:reply(200, [], integer_to_list(Time), Req2);
                       _ ->
                           io:format("post date:~p~n", [PostData]),
                           cowboy_req:reply(200, [], "error", Req2)
                   end;
               {<<"GET">>, Req1} ->
                   {Path, _R1} = cowboy_req:path(Req1),
                   {Qs, _R2} = cowboy_req:qs(_R1),
                   {Header, _R3} = cowboy_req:headers(_R2),
                   io:format("get date:~p~n", [[Path, Qs, Header]]),
                   cowboy_req:reply(200, [], "true", _R2)
           end,
    {ok, Req3, State}.

terminate(_Reason, _Req, _State) ->
    ok.