NDEx Package Bundler
====================

This repo contains scripts and files needed to build the NDEx
distribution tar for external groups running NDEx. This tool is driven
by a ``Makefile``

Requirements
------------

-  Linux or Mac (for other OS a Vagrant configuration is included)

-  make

-  bash shell

-  Java 11

-  maven 3.6.3

-  Python 3

-  wget

-  rst2pdf

For other operating systems
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Vagrant requires the following

-  Vagrant

-  VirtualBox

NOTE: If installing VirtualBox 6.1 Vagrant has a bug where it does not
recognize 6.1 of virtualbox. This can be fixed with the solution
documented here:
https://github.com/oracle/vagrant-boxes/issues/178#issue-536720633

Building directly on machine
==============================

.. code:: bash

   git clone https://github.com/idekerlab/ndexpackagebundler.git
   cd ndexpackagebundler
   make dist

Building via Vagrant
==========================

.. code:: bash

   git clone https://github.com/idekerlab/ndexpackagebundler.git
   cd ndexpackagebundler
   vagrant up
   vagrant ssh
   cd /vagrant
   make dist
