# Warp API reachability

Run the safe, read-only probe:

```sh
make api-check
```

Authentication resolution is:

1. `WARP_API_KEY`, for CI or a headless machine.
2. `~/.onecli/env.sh`, for a OneCLI-managed Warp connection. The script does
   not set an authorization header in this mode; the gateway injects it.

The probe calls the current plural endpoint:

```text
GET https://app.warp.dev/api/v1/agent/runs?limit=1
```

It requires HTTP 200 plus the documented `runs` and `page_info` fields, then
prints only the number of returned entries. It never prints credentials or run
content. On a gateway error it surfaces only recovery fields such as
`connect_url`, `blocked_by_policy`, or `retry_after_secs`.

See Warp's [API quickstart](https://docs.warp.dev/reference/api-and-sdk/quickstart)
and [API reference](https://docs.warp.dev/reference/api-and-sdk/).
