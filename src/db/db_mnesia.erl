%%%-------------------------------------------------------------------
%%% @author yujian
%%% @doc
%%%
%%% Created : 16. 五月 2016 下午5:23
%%%-------------------------------------------------------------------
-module(db_mnesia).

-include("erl_pub.hrl").


-export([
    write/1,
    read/2
]).


write(VO) ->
    mnesia:dirty_write(VO).


read(TabName, Key) ->
    mnesia:dirty_read(TabName, Key).