# checkout-api approved incident procedures

- Owning team: Commerce Platform
- Paging route: PagerDuty service `commerce-platform-primary`
- Freeze checkout-api deployments before mitigation.
- Compare payments-gateway timeouts between eu-west and us-east.
- If payments-gateway timeouts remain above threshold for 10 minutes, shift
  payment traffic from eu-west to us-east.
- Recovery requires all three observed signals below their thresholds for 15
  continuous minutes.
- Post an update in the coordination channel every 15 minutes.

