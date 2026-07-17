# Incident runbook: INC-2026-0717-042

## Situation

- Severity: SEV-2
- Service: checkout-api
- Region: eu-west
- Started: 2026-07-17T09:12:00Z
- Customer impact: Some customers cannot complete checkout.

## Evidence

- checkout_5xx_rate is 18.4% (threshold: 5%).
- p95_latency is 2.8s (threshold: 900ms).
- payments_gateway_timeout_rate is 14.1% (threshold: 2%).

## Immediate response

1. Page Commerce Platform through PagerDuty service `commerce-platform-primary`.
2. Freeze checkout-api deployments.
3. Compare payments-gateway timeouts between eu-west and us-east.
4. If payments-gateway timeouts remain above 2% for 10 minutes, shift payment traffic from eu-west to us-east.

## Recovery checks

- Confirm checkout_5xx_rate is below 5% for 15 continuous minutes.
- Confirm p95_latency is below 900ms for 15 continuous minutes.
- Confirm payments_gateway_timeout_rate is below 2% for 15 continuous minutes.

## Communications

- Post an update in #inc-checkout every 15 minutes.

