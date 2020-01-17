.. _NDEx: https://ndexbio.org
.. _Solr: https://lucene.apache.org/solr/
.. _Tomcat: http://tomcat.apache.org/
.. _Vagrant: https://www.vagrantup.com/
.. _VirtualBox: https://www.virtualbox.org/
.. _VM: https://en.wikipedia.org/wiki/Virtual_machine

Building NDEx_ package directly
================================

The instructions below provide requirements and instructions
to build the NDEx_ distribution directly on a Linux or Mac
box.

Requirements for direct build
----------------------------------

**NOTE:** These requirements apply only if one intends to **NOT** use the Vagrant_ described
in :doc:`README.rst`

-  Linux or Mac (for other OS a Vagrant configuration is included)

-  `Make <https://www.gnu.org/software/make/manual/make.html>`_

-  `Bash shell <https://en.wikipedia.org/wiki/Bash_(Unix_shell)>`_

-  `Java 11 jdk <https://openjdk.java.net/projects/jdk/11/>`_

-  `Maven 3.6+ <https://maven.apache.org/>`_

-  `Python 3 <https://www.python.org/downloads/>`_

-  `wget <https://www.gnu.org/software/wget/manual/wget.html>`_

-  `rst2pdf <https://pypi.org/project/rst2pdf/>`_

Commands to run for direct build
---------------------------------------

To do this all requirements above must be satisfied. If this is tricky use the Vagrant_ approach
above.

.. code:: bash

   git clone https://github.com/idekerlab/ndexpackagebundler.git
   cd ndexpackagebundler
   make dist

Results
---------

The results will be in same ``dist/NDEx-<VERSION>`` location as noted in Vagrant_ build instructions
in ``README.rst``