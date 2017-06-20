# bird-formula

This formula creates and manages BGP routes for VPC <-> VPC IPSEC tunnels created by the `strongswan-formula`.

Example pillar data:

```
bird:
  routes:
    route_1:
      neighbor_ip: 192.168.1.69
      remote_as: 12345
    route_2:
      neighbor_ip: 192.168.5.55
      remote_as: 54321
```

Official package repo:
https://launchpad.net/~cz.nic-labs/+archive/ubuntu/bird
