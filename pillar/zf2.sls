zf2:
  configfiles:
    {% if 'vagrant' in grains["id"] %}
    mode: 777
    {% else %}
    mode: 644
    {% endif %}
