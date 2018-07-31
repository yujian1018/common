%%%-------------------------------------------------------------------
%%% @author yujian
%%% @doc
%%%
%%% Created : 27. 四月 2016 下午2:05
%%%-------------------------------------------------------------------

-include("erl_keywords.hrl").
-include("erl_lager_log.hrl").
-include("erl_verify.hrl").
-include("erl_node.hrl").
-include("erl_db.hrl").
-include("../src/_auto/def/def.hrl").


-define(put_new(K, V), erlang:put(K, V)). %初始化进程字典，和erlang:put/2区分 开
-define(put(K, V), erlang:put(K, V)).
-define(get(K), erlang:get(K)).


-ifdef(linux).

-define(encode(JiffyData), jiffy:encode(JiffyData)).
-define(decode(JiffyData),
    case jiffy:decode(JiffyData) of
        {JiffyDecode} -> JiffyDecode;
        JiffyDecode -> JiffyDecode
    end).

-else.

-define(encode(Rfc4627Data), list_to_binary(jsx:encode(Rfc4627Data))).
-define(decode(Rfc4627Data),
    case jsx:decode(Rfc4627Data) of
        {ok, {obj, Rfc4627Obj}, []} ->
            Rfc4627Obj;
        {ok, Rfc4627Obj, []} ->
            Rfc4627Obj
    end).

-endif.

