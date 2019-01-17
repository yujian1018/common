%%%-------------------------------------------------------------------
%%% @author yj
%%% @doc
%%%
%%% Created : 17. 一月 2019 下午3:25
%%%-------------------------------------------------------------------
-module(t_zlib).

-include("erl_pub.hrl").

-export([
    t/0
]).


t() ->
    t(1).

t(1000) -> ok;
t(Index) ->
    IndexStr = integer_to_list(Index),
    case storage_1:read("/media/yj/DOC/project/baike", "https://baike.baidu.com/view/" ++ IndexStr ++ ".htm") of
        {ok, Bin} ->
%%            ?INFO("size:", [byte_size(Bin)]),

%%            Z = zlib:open(),
%%            ok = zlib:deflateInit(Z, best_compression),
%%            Last = zlib:deflate(Z, Bin, finish),
%%            ok = zlib:deflateEnd(Z),
%%            zlib:close(Z),
%%            list_to_binary(Last);
%%            zlib:compress(Bin);

            zlib:zip(Bin);
        _Err ->
            ok
    end,
    t(Index + 1).