%%%-------------------------------------------------------------------
%%% @author yujian
%%% @doc
%%%
%%% Created : 11. 五月 2016 下午12:56
%%%-------------------------------------------------------------------
-module(erl_string).

-export([
    uuid_int/0, uuid_bin/0, order_id/0,
    sql/1, illegal_character/1
]).

-export([re_url/1]).

-export([
    all_to_binary/1,    %转译 mysql关键字' 单引号
    binary_to_all/1,
    
    term_to_bin/1
]).

%%| 41 bits: Timestamp | 3 bits: 区域 | 10 bits: 机器编号 | 10 bits: 序列号 |
uuid_int() ->
    {MegaSecs, Secs, MicroSecs} = os:timestamp(),
    Timers = MegaSecs * 1000000000000 + Secs * 1000000 + MicroSecs,
    erlang:md5(term_to_binary({self(), erlang:make_ref(), Timers, node()})).

uuid_bin() ->
    {MegaSecs, Secs, MicroSecs} = os:timestamp(),
    Timers = MegaSecs * 1000000000000 + Secs * 1000000 + MicroSecs,
    erl_hash:md5_to_bin(term_to_binary({self(), erlang:make_ref(), Timers, node()})).

%% 32字节的订单号（理论值不能重复）
order_id() ->
    {{Y, Mo, D}, {H, Mi, S}} = erlang:localtime(),
    {_, _, Ms} = os:timestamp(),
    FunTime =
        fun(Int) ->
            if
                Int < 10 -> <<"0", (integer_to_binary(Int))/binary>>;
                true -> integer_to_binary(Int)
            end
        end,
    NewMs =
        if
            Ms < 10 -> <<"00000", (integer_to_binary(Ms))/binary>>;
            Ms < 100 -> <<"0000", (integer_to_binary(Ms))/binary>>;
            Ms < 1000 -> <<"000", (integer_to_binary(Ms))/binary>>;
            Ms < 10000 -> <<"00", (integer_to_binary(Ms))/binary>>;
            Ms < 100000 -> <<"0", (integer_to_binary(Ms))/binary>>;
            true -> integer_to_binary(Ms)
        end,
    crypto:rand_seed(),
    Rand = integer_to_binary(erl_random:random(100000, 999999)),
    Rand2 = integer_to_binary(erl_random:random(100000, 999999)),
    <<(FunTime(Y))/binary, (FunTime(Mo))/binary, (FunTime(D))/binary, (FunTime(H))/binary, (FunTime(Mi))/binary, (FunTime(S))/binary,
        NewMs/binary, Rand/binary, Rand2/binary>>.

re_url(Binary) ->
    B1 = binary:replace(Binary, <<" ">>, <<"">>, [global]),
    [B2, _] = cpn_mask_word:checkRes(B1, <<"www\.[a-zA-Z0-9\-_]+\."/utf8>>),
    hd(cpn_mask_word:checkRes(B2, <<"\.[a-zA-Z0-9\-_]+\.(com|cn|net|xin|ltd|store|vip|cc|game|mom|lol|work|pub|club|club|xyz|top|ren|bid|loan|red|biz|mobi|me|win|link|wang|date|party|site|online|tech|website|space|live|studio|press|news|video|click|trade|science|wiki|design|pics|photo|help|gitf|rocks|org|band|market|sotfware|social|lawyer|engineer|gov.cn|name|info|tv|asia|co|so|中国|公司|网络)"/utf8>>)).


all_to_binary(Msg) ->
    binary:replace(term_to_binary(Msg), <<"'">>, <<"\\'">>, [global]).

binary_to_all(Bin) ->
    binary_to_term(binary:replace(Bin, <<"\'">>, <<"'">>, [global])).

sql(Values) ->
    FunFoldl = fun(Value, Acc) ->
        NewValue =
            if
                is_integer(Value) -> integer_to_binary(Value);
                Value =:= undefined -> <<>>;
                true -> Value
            end,
        if
            Acc =:= <<>> -> <<"'", NewValue/binary, "'">>;
            true -> <<Acc/binary, ",'", NewValue/binary, "'">>
        end
               end,
    Sql = lists:foldl(FunFoldl, <<>>, Values),
    <<"(", Sql/binary, ")">>.

-define(ILLEGAL_CHARACTER, [<<"'">>, <<"`">>, <<";">>, <<"/*">>, <<"#">>, <<"--">>]).
illegal_character(K) -> illegal_character(K, ?ILLEGAL_CHARACTER).

illegal_character(_K, []) -> true;
illegal_character(K, [Char | Chars]) ->
    case binary:match(K, Char) of
        nomatch -> illegal_character(K, Chars);
        _ -> false
    end.

term_to_bin(Args) when is_list(Args) ->
    FunFoldl =
        fun(Arg, Acc) ->
            NewArg = term_to_bin(Arg),
            if
                Acc =:= <<>> -> NewArg;
                true -> <<Acc/binary, ",", NewArg/binary>>
            end
        end,
    NewArg = lists:foldl(FunFoldl, <<>>, Args),
    <<"[", NewArg/binary, "]">>;

term_to_bin(Args) when is_tuple(Args) ->
    FunFoldl =
        fun(Arg, Acc) ->
            NewArg = term_to_bin(Arg),
            if
                Acc =:= <<>> -> NewArg;
                true -> <<Acc/binary, ",", NewArg/binary>>
            end
        end,
    NewArg = lists:foldl(FunFoldl, <<>>, tuple_to_list(Args)),
    <<"{", NewArg/binary, "}">>;

term_to_bin(undefined) -> <<>>;
term_to_bin(Arg) when is_atom(Arg) -> atom_to_binary(Arg, utf8);
term_to_bin(Arg) when is_integer(Arg) -> integer_to_binary(Arg);
term_to_bin(Arg) when is_binary(Arg) -> Arg.
