.PHONY: list setup test api-check local oz-create oz-run

list:
	./scripts/playground list

setup:
	./scripts/setup.sh

test:
	./scripts/playground check

api-check:
	./scripts/check-warp-api.sh

local:
	@test -n "$(PLAYGROUND)" || (echo "usage: make local PLAYGROUND=<name>" >&2; exit 2)
	./scripts/playground local "$(PLAYGROUND)"

oz-create:
	./scripts/playground oz-create $(if $(OZ_REPO),--repo "$(OZ_REPO)",)

oz-run:
	@test -n "$(PLAYGROUND)" || (echo "usage: make oz-run PLAYGROUND=<name> OZ_ENVIRONMENT_ID=<id>" >&2; exit 2)
	./scripts/playground oz "$(PLAYGROUND)"
