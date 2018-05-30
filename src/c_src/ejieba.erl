%%%-------------------------------------------------------------------
%%% @author yujian
%%% @doc
%%% Created : 30. 一月 2016 下午2:11
%%%-------------------------------------------------------------------
-module(ejieba).

-on_load(init/0).

-export([cut/2, target/1, keyword/1]).

init() ->
    Path = case code:lib_dir(common, priv) of
               {error, _} -> "./priv/ejieba";
               Str -> Str ++ "/ejieba"
           end,
    erlang:load_nif(Path, 0).


-spec cut(_Bin :: binary, _Type :: 1|2|3|4|5) -> list().
% 1 -> METHOD_MP   最大概率法
% 2 -> METHOD_HMM  隐式马尔科夫模型
% 3 -> METHOD_MIX  混合模型
% 4 -> METHOD_FULL 全模式
% 5 -> METHOD_QUERY 索引模型

cut(_Bin, _Type) ->
    erlang:error({"NIF not implemented in ejieba at line", ?LINE}).

%% 词性标注
target(_Bin) ->
    erlang:error({"NIF not implemented in ejieba at line", ?LINE}).

%% 关键词抽取
keyword(_Bin) ->
    erlang:error({"NIF not implemented in ejieba at line", ?LINE}).