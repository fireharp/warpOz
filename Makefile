.PHONY: list runs show setup test api-check local oz-create oz-run

list:
	./scripts/playground list

runs:
	./scripts/playground runs

show:
	@test -n "$(RUN_ID)" || (echo "usage: make show RUN_ID=<id-or-prefix>" >&2; exit 2)
	./scripts/playground show "$(RUN_ID)"

setup:
	./scripts/setup.sh

test:
	./scripts/playground check
	PYTHONDONTWRITEBYTECODE=1 python3 -m unittest discover -s tests -p 'test_*.py'

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
