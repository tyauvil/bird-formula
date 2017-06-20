{% set p    = pillar.get('bird', {}) %}
{% set pc   = p.get('config', {}) %}
{% set g    = grains.get('bird', {}) %}
{% set gc   = g.get('config', {}) %}

{%- set bird = {} %}
{%- do bird.update({
  'version'                       : p.get('version', '1.6.3-1+xenial+1')
  }) %}