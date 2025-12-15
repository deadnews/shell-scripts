.PHONY: all clean test default dotbot install check pc

default: dotbot

dotbot:
	dotbot -c install.conf.yaml

update:
	prek auto-update

check: pc
pc:
	prek run -a
