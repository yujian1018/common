%%%-------------------------------------------------------------------
%%% @author yujian
%%% @doc
%%%
%%% Created : 26. 四月 2016 下午4:55
%%%-------------------------------------------------------------------

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
-define(INFO(MSG),          io:format("[INFO] ~p [~s:~b ~w]~n"  MSG"~n", [calendar:local_time(), ?FILE, ?LINE, self()])).
-define(INFO(FMT, ARGS),    io:format("[INFO] ~p [~s:~b ~w]~n"  FMT"~n", [calendar:local_time(), ?FILE, ?LINE, self() | ARGS])).
-define(WARN(MSG),          io:format("[WARN] ~p [~s:~b ~w]~n"  MSG"~n", [calendar:local_time(), ?FILE, ?LINE, self()])).
-define(WARN(FMT, ARGS),    io:format("[WARN] ~p [~s:~b ~w]~n"  FMT"~n", [calendar:local_time(), ?FILE, ?LINE, self() | ARGS])).
-define(ERROR(MSG),         io:format("[ERROR] ~p [~s:~b ~w]~n"  MSG"~n", [calendar:local_time(), ?FILE, ?LINE, self()])).
-define(ERROR(FMT, ARGS),   io:format("[ERROR] ~p [~s:~b ~w]~n" FMT"~n", [calendar:local_time(), ?FILE, ?LINE, self() | ARGS])).
-define(LOG(MSG),           io:format("[LOG] ~p [~s:~b ~w]~n"  MSG"~n", [calendar:local_time(), ?FILE, ?LINE, self()])).
-define(LOG(FMT, ARGS),     io:format("[LOG] ~p [~s:~b ~w]~n"  FMT"~n", [calendar:local_time(), ?FILE, ?LINE, self() | ARGS])).
-define(DEBUG(MSG),         io:format("[DEBUG] ~p [~s:~b ~w]~n"  MSG"~n", [calendar:local_time(), ?FILE, ?LINE, self()])).
-define(DEBUG(FMT, ARGS),   io:format("[DEBUG] ~p [~s:~b ~w]~n"  FMT"~n", [calendar:local_time(), ?FILE, ?LINE, self() | ARGS])).
-define(PRINT(MSG),         io:format("[PRINT] ~p [~s:~b ~w]~n"  MSG"~n", [calendar:local_time(), ?FILE, ?LINE, self()])).
-define(PRINT(FMT, ARGS),   io:format("[PRINT] ~p [~s:~b ~w]~n"  FMT"~n", [calendar:local_time(), ?FILE, ?LINE, self() | ARGS])).

-else.

%%-ifdef(linux).
-define(LAGER_START,        lager:start()).
-define(INFO(MSG),          lager:info("[INFO] ~p [~s:~b ~w]~n"  MSG, [calendar:local_time(), ?FILE, ?LINE, self()])).
-define(INFO(FMT, ARGS),    lager:info("[INFO] ~p [~s:~b ~w]~n"  FMT, [calendar:local_time(), ?FILE, ?LINE, self() | ARGS])).
-define(WARN(MSG),          lager:warning("[WARN] ~p [~s:~b ~w]~n"  MSG"~n", [calendar:local_time(), ?FILE, ?LINE, self()])).
-define(WARN(FMT, ARGS),    lager:warning("[WARN] ~p [~s:~b ~w]~n"  FMT"~n", [calendar:local_time(), ?FILE, ?LINE, self() | ARGS])).
-define(ERROR(MSG),         lager:error("[ERROR] ~p [~s:~b ~w]~n"  MSG"~n", [calendar:local_time(), ?FILE, ?LINE, self()])).
-define(ERROR(FMT, ARGS),   lager:error("[ERROR] ~p [~s:~b ~w]~n"  FMT"~n", [calendar:local_time(), ?FILE, ?LINE, self() | ARGS])).
-define(LOG(MSG),           lager:notice("[LOG] ~p [~s:~b ~w]~n"  MSG"~n", [calendar:local_time(), ?FILE, ?LINE, self()])).
-define(LOG(FMT, ARGS),     lager:notice("[LOG] ~p [~s:~b ~w]~n"  FMT"~n", [calendar:local_time(), ?FILE, ?LINE, self() | ARGS])).
-define(DEBUG(MSG),         lager:debug("[DEBUG] ~p [~s:~b ~w]~n"  MSG"~n", [calendar:local_time(), ?FILE, ?LINE, self()])).
-define(DEBUG(FMT, ARGS),   lager:debug("[DEBUG] ~p [~s:~b ~w]~n"  FMT"~n", [calendar:local_time(), ?FILE, ?LINE, self() | ARGS])).
-define(PRINT(MSG),         lager:notice("[PRINT] ~p [~s:~b ~w]~n"  MSG"~n", [calendar:local_time(), ?FILE, ?LINE, self()])).
-define(PRINT(FMT, ARGS),   lager:notice("[PRINT] ~p [~s:~b ~w]~n"  FMT"~n", [calendar:local_time(), ?FILE, ?LINE, self() | ARGS])).

-endif.

