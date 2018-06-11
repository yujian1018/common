
make:
	./rebar co


all:
	rm -rf ebin
	rm -rf src/auto/def
	escript ../parse_tool/t_def priv/def src/auto/def
	./rebar co