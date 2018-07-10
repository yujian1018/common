
make:
	./rebar co


def:
	rm -rf ebin
	rm -rf src/auto/def
	escript ../parse_tool/t_def priv/def src/auto/def