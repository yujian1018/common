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


-ifdef(windows).

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
-define(ALERT(MSG),         io:format("[ALERT] ~p [~s:~b ~w]~n"  MSG"~n", [calendar:local_time(), ?FILE, ?LINE, self()])).
-define(ALERT(FMT, ARGS),   io:format("[ALERT] ~p [~s:~b ~w]~n"  FMT"~n", [calendar:local_time(), ?FILE, ?LINE, self() | ARGS])).

-else.

%%-ifdef(linux).
-define(LAGER_START,        lager:start()).
-define(DEBUG(MSG),         lager:debug("[DEBUG] ~p [~s:~b ~w]~n"  MSG"~n", [calendar:local_time(), ?FILE, ?LINE, self()])).
-define(DEBUG(FMT, ARGS),   lager:debug("[DEBUG] ~p [~s:~b ~w]~n"  FMT"~n", [calendar:local_time(), ?FILE, ?LINE, self() | ARGS])).
-define(INFO(MSG),          lager:info("[INFO] ~p [~s:~b ~w]~n"  MSG, [calendar:local_time(), ?FILE, ?LINE, self()])).
-define(INFO(FMT, ARGS),    lager:info("[INFO] ~p [~s:~b ~w]~n"  FMT, [calendar:local_time(), ?FILE, ?LINE, self() | ARGS])).
-define(NOTICE(MSG),        lager:notice("[NOTICE] ~p [~s:~b ~w]~n"  MSG"~n", [calendar:local_time(), ?FILE, ?LINE, self()])).
-define(NOTICE(FMT, ARGS),  lager:notice("[NOTICE] ~p [~s:~b ~w]~n"  FMT"~n", [calendar:local_time(), ?FILE, ?LINE, self() | ARGS])).
-define(WARN(MSG),          lager:warning("[WARN] ~p [~s:~b ~w]~n"  MSG"~n", [calendar:local_time(), ?FILE, ?LINE, self()])).
-define(WARN(FMT, ARGS),    lager:warning("[WARN] ~p [~s:~b ~w]~n"  FMT"~n", [calendar:local_time(), ?FILE, ?LINE, self() | ARGS])).
-define(ERROR(MSG),         lager:error("[ERROR] ~p [~s:~b ~w]~n"  MSG"~n", [calendar:local_time(), ?FILE, ?LINE, self()])).
-define(ERROR(FMT, ARGS),   lager:error("[ERROR] ~p [~s:~b ~w]~n"  FMT"~n", [calendar:local_time(), ?FILE, ?LINE, self() | ARGS])).
-define(ALERT(MSG),         lager:notice("[ALERT] ~p [~s:~b ~w]~n"  MSG"~n", [calendar:local_time(), ?FILE, ?LINE, self()])).
-define(ALERT(FMT, ARGS),   lager:notice("[ALERT] ~p [~s:~b ~w]~n"  FMT"~n", [calendar:local_time(), ?FILE, ?LINE, self() | ARGS])).

-endif.

