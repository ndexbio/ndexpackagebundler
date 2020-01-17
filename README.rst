.. _NDEx: https://ndexbio.org
.. _Solr: https://lucene.apache.org/solr/
.. _Tomcat: http://tomcat.apache.org/
.. _Vagrant: https://www.vagrantup.com/
.. _VirtualBox: https://www.virtualbox.org/
.. _VM: https://en.wikipedia.org/wiki/Virtual_machine

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

**NOTE:** For information on building the NDEx distribution without Vagrant_ see ``Advanced.rst`` file in this repo.