NDEx_ Package Bundler
============================

This repo contains scripts and files needed to build the NDEx_
distribution (similar to this ftp://ftp.ndexbio.org/NDEx-v2.3.1/) for external groups
running NDEx_.

This repo includes a Vagrant_ configuration that creates a VirtualBox_
`Virtual Machine <https://en.wikipedia.org/wiki/Virtual_machine>`_
running `Centos 7.2 <https://www.centos.org/>`_ to provide a consistent build
environment regardless of host OS and configuration.

Building via Vagrant_
~~~~~~~~~~~~~~~~~~~~~~~~~~

Requirements for building via Vagrant_
--------------------------------------------

-  Vagrant_

-  VirtualBox_

**NOTE:** Vagrant_ has a bug where it does not recognize 6.1 of VirtualBox.
`Click here for fix <https://github.com/oracle/vagrant-boxes/issues/178#issue-536720633>`_

Commands to run building via Vagrant_
------------------------------------------

.. code:: bash

   git clone https://github.com/idekerlab/ndexpackagebundler.git
   cd ndexpackagebundler
   vagrant up
   vagrant ssh
   cd /vagrant
   make dist

To exit the Vagrant_ VM_ just type ``exit``

**WARNING:** Once done building it is a good idea to destroy the VM_ created with ``vagrant up``. This can
be done with a call to ``vagrant destroy`` from the same directory ``vagrant up`` was typed.

**NOTE:** The ``/vagrant`` directory is mounted from host computer so when exiting the VM_ the results will still be visible

Results
----------

After running ``make dist`` above a folder should reside under ``dist/NDEx-<VERSION>``
will contain `PDF <https://en.wikipedia.org/wiki/PDF>`_ instructions as well as the NDEx_ distribution `gzipped <https://www.gzip.org/>`_
`tarfile <https://www.gnu.org/software/tar/>`_.

Changing versions of what to build
-------------------------------------

The file ``versions.config`` dictates what tagged versions of the NDEx_ codebase as
well as what versions of Solr_ and Tomcat_ to bundle in.


Advanced instructions for building directly on a machine
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The instructions below provide requirements and instructions
to build the NDEx_ distribution directly on a Linux or Mac
box.

Requirements for direct build
----------------------------------

**NOTE:** These requirements apply only if one intends to **NOT** use the Vagrant_ approach
above.

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

.. _NDEx: https://ndexbio.org
.. _Solr: https://lucene.apache.org/solr/
.. _Tomcat: http://tomcat.apache.org/
.. _Vagrant: https://www.vagrantup.com/
.. _VirtualBox: https://www.virtualbox.org/
.. _VM: https://en.wikipedia.org/wiki/Virtual_machine

Results
---------

The results will be in same ``dist/NDEx-<VERSION>`` location as noted in Vagrant_ build instructions