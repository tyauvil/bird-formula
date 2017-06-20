{%- from 'bird/settings.sls' import bird with context %}

cz_nic_labs_repo:
  pkgrepo.managed:
    - humanname: CZ.nic PPA
    - name: deb http://ppa.launchpad.net/cz.nic-labs/bird/ubuntu {{ grains['oscodename'] }} main
    - dist: {{ grains['oscodename'] }}
    - file: /etc/apt/sources.list.d/cz_nic_labs.list
    - keyid: F9C59A45
    - keyserver: keyserver.ubuntu.com
    - require_in:
      - pkg: bird

bird:
  pkg.installed:
    - version: {{ bird.version }}
  service.running:
    - enable: True

bird6:
  service.dead:
    - enable: False

/etc/bird/bird.conf:
  file.managed:
    - user: bird
    - group: bird
    - source: salt://bird/templates/bird.conf.jinja
    - template: jinja
    - require:
      - pkg: bird
    - listen_in:
      - service: bird

/etc/bird/config.d:
  file.directory:
    - user: bird
    - group: bird
    - makedirs: True
    - require:
      - pkg: bird

/etc/bird/config.d/static_bgp.conf:
  file.managed:
    - user: bird
    - group: bird
    - source: salt://bird/files/static_bgp.conf
    - require:
      - pkg: bird
    - listen_in:
      - service: bird

{% for route, value in salt['pillar.get']('bird:routes', {}).iteritems() -%}
/etc/bird/config.d/{{ route }}.conf:
  file.managed:
    - user: bird
    - group: bird
    - source: salt://bird/templates/bgp.conf.jinja
    - template: jinja
    - context:
        route: {{ route }}
        neighbor_ip: {{ value['neighbor_ip'] }}
        remote_as: {{ value['remote_as'] }}
    - require:
      - pkg: bird
    - listen_in:
      - service: bird

{% endfor %}

net.ipv4.ip_forward:
  sysctl.present:
    - value: 1

net.ipv4.conf.all.accept_redirects:
  sysctl.present:
    - value: 0

net.ipv4.conf.all.send_redirects:
  sysctl.present:
    - value: 0

net.ipv4.conf.all.arp_filter:
  sysctl.present:
    - value: 1

net.ipv4.conf.all.rp_filter:
  sysctl.present:
    - value: 0

net.ipv4.conf.eth0.arp_filter:
  sysctl.present:
    - value: 1

net.ipv4.conf.eth0.accept_redirects:
  sysctl.present:
    - value: 0

net.ipv4.conf.eth0.send_redirects:
  sysctl.present:
    - value: 0

net.ipv4.conf.eth0.rp_filter:
  sysctl.present:
    - value: 0
