%%%-------------------------------------------------------------------
%%% @author yujian
%%% @doc
%%%
%%% Created : 26. 四月 2016 下午4:55
%%%-------------------------------------------------------------------

-compile({parse_transform, lager_transform}).

%% R16 suport color term
-define(color_none, "\e[m").
-define(color_red, "\e[1m\e[31m").
-define(color_yellow, "\e[1m\e[33m").
-define(color_green, "\e[0m\e[32m").
-define(color_black, "\e[0;30m").
-define(color_blue, "\e[0;34m").
-define(color_purple, "\e[0;35m").
-define(color_cyan, "\e[0;36m").
-define(color_white, "\e[0;37m").


%% background hilight
-define(bak_blk, "\e[40m").   %% Black - Background
-define(bak_red, "\e[41m").   %% Red
-define(bak_grn, "\e[42m").   %% Green
-define(bak_ylw, "\e[43m").   %% Yellow
-define(bak_blu, "\e[44m").   %% Blue
-define(bak_pur, "\e[45m").   %% Purple
-define(bak_cyn, "\e[46m").   %% Cyan
-define(bak_wht, "\e[47m").   %% White

-ifdef(linux).
    -define(LAGER_START,        lager:start()).
-ifdef(prod).
    -define(DEBUG(MSG),         ok).
    -define(DEBUG(FMT, ARGS),   ok).
    -define(INFO(MSG),          ok).
    -define(INFO(FMT, ARGS),    ok).
    -define(NOTICE(MSG),        ok).
    -define(NOTICE(FMT, ARGS),  ok).
-else.
    -define(DEBUG(MSG),         io:format("\e[0;35m[DEBUG] ~p [~s:~b ~w]~n"  MSG"~n\e[m\n", [calendar:local_time(), ?FILE, ?LINE, self()])).
    -define(DEBUG(FMT, ARGS),   io:format("\e[0;35m[DEBUG] ~p [~s:~b ~w]~n"  FMT"~n\e[m\n", [calendar:local_time(), ?FILE, ?LINE, self() | ARGS])).
    -define(INFO(MSG),          io:format("\e[0m\e[32m[INFO] ~p [~s:~b ~w]~n"  MSG"~n\e[m\n", [calendar:local_time(), ?FILE, ?LINE, self()])).
    -define(INFO(FMT, ARGS),    io:format("\e[0m\e[32m[INFO] ~p [~s:~b ~w]~n"  FMT"~n\e[m\n", [calendar:local_time(), ?FILE, ?LINE, self() | ARGS])).
    -define(NOTICE(MSG),        io:format("\e[1m\e[34m[NOTICE] ~p [~s:~b ~w]~n"  MSG"~n\e[m\n", [calendar:local_time(), ?FILE, ?LINE, self()])).
    -define(NOTICE(FMT, ARGS),  io:format("\e[1m\e[34m[NOTICE] ~p [~s:~b ~w]~n"  FMT"~n\e[m\n", [calendar:local_time(), ?FILE, ?LINE, self() | ARGS])).
-endif.
    %%-define(DEBUG(MSG),         lager:debug(MSG)).
    %%-define(DEBUG(FMT, ARGS),   lager:debug(FMT, ARGS)).
    %%-define(INFO(MSG),          lager:info(MSG)).
    %%-define(INFO(FMT, ARGS),    lager:info(FMT, ARGS)).
    %%-define(NOTICE(MSG),        lager:notice(MSG)).
    %%-define(NOTICE(FMT, ARGS),  lager:notice(FMT, ARGS)).
    -define(WARN(MSG),          lager:warning(MSG)).
    -define(WARN(FMT, ARGS),    lager:warning(FMT, ARGS)).
    -define(ERROR(MSG),         lager:error(MSG)).
    -define(ERROR(FMT, ARGS),   lager:error(FMT, ARGS)).

-else.

    -define(LAGER_START, error).
    -define(DEBUG(MSG),         io:format("[DEBUG] ~p [~s:~b ~w]~n"  MSG"~n", [calendar:local_time(), ?FILE, ?LINE, self()])).
    -define(DEBUG(FMT, ARGS),   io:format("[DEBUG] ~p [~s:~b ~w]~n"  FMT"~n", [calendar:local_time(), ?FILE, ?LINE, self() | ARGS])).
    -define(INFO(MSG),          io:format("[INFO] ~p [~s:~b ~w]~n"  MSG"~n", [calendar:local_time(), ?FILE, ?LINE, self()])).
    -define(INFO(FMT, ARGS),    io:format("[INFO] ~p [~s:~b ~w]~n"  FMT"~n", [calendar:local_time(), ?FILE, ?LINE, self() | ARGS])).
    -define(NOTICE(MSG),        io:format("[NOTICE] ~p [~s:~b ~w]~n"  MSG"~n", [calendar:local_time(), ?FILE, ?LINE, self()])).
    -define(NOTICE(FMT, ARGS),  io:format("[NOTICE] ~p [~s:~b ~w]~n"  FMT"~n", [calendar:local_time(), ?FILE, ?LINE, self() | ARGS])).
    -define(WARN(MSG),          io:format("[WARN] ~p [~s:~b ~w]~n"  MSG"~n", [calendar:local_time(), ?FILE, ?LINE, self()])).
    -define(WARN(FMT, ARGS),    io:format("[WARN] ~p [~s:~b ~w]~n"  FMT"~n", [calendar:local_time(), ?FILE, ?LINE, self() | ARGS])).
    -define(ERROR(MSG),         io:format("[ERROR] ~p [~s:~b ~w]~n"  MSG"~n", [calendar:local_time(), ?FILE, ?LINE, self()])).
    -define(ERROR(FMT, ARGS),   io:format("[ERROR] ~p [~s:~b ~w]~n" FMT"~n", [calendar:local_time(), ?FILE, ?LINE, self() | ARGS])).

-endif.
