{%- if pillar.pgbouncer is defined %}
include:
{%- if pillar.pgbouncer.server is defined %}
- pgbouncer.server
{%- endif %}
{%- endif %}
