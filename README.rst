Kira
####

Kira (bash-kira): a small bash script for killing programs which run too long.

The first time you run Kira, it begins watching the pids of a program.

The next time you run Kira, it will kill pids if they are still running.


usage
=====

Kira expects two arguments, the `process-regex` and the human readable `program-name`.

.. code-block:: bash

    ./kira.sh <process-regex> <program-name>

For example:

.. code-block:: bash

    ./kira.sh /usr/bin/uri2png uri2png

cron
====

This example kills a program if it has been running for 1-2 minutes.

.. code-block:: bash

 * * * * * /usr/bin/kira.sh /usr/bin/uri2png uri2png

Note: Cron does not support sub minute scheduling, but Kira should.

files
=====

Kira manages two files:

/tmp/kira-$PROGRAM_NAME.log:
 Kira tracks when/what is killed here.

/tmp/kira-$PROGRAM_NAME.pids:
 Kira stores pids currently being monitored here.
