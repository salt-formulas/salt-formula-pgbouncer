
=========
pgbouncer
=========

Service pgbouncer description

Sample pillars
==============

Single pgbouncer service

.. code-block:: yaml

    pgbouncer:
      server:
        enabled: true
        bind:
          address: 0.0.0.0
        user:
          admin:
            username: admin
            password: password
        host:
          localhost:
          another_host:
            address: 10.8.0.100

Read more
=========

* links
