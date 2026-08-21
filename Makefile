.PHONY: all clean test default dotbot install check pc

default: check

dotbot:
	dotbot -c install.conf.yaml

check: pc
pc:
	prek run -a

update:
	prek update
	pinact run --update
