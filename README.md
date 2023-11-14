
Overview
========

This is a (cookiecutter) template to generate a new Ansible role including a working test environment using Molecule

When invoked, cookiecutter will prompt for some variables like names, generate an Ansible role, and initialize a local git repository for it.

Usage
-----
- Install cookiecutter: `pip install cookiecutter`
- Generate the Ansible role from the template: `cookiecutter https://gitlab.itcreation.nl/it-creation/ansible/ansible-role-template.git`
- Follow the prompts to customize the generated role.
- search for TODO in the generated role to change it in something useable

Template Variables
------
- rolename: The long name of the Ansible role including spaces.
- rolename_slug: the valid name as used in Ansible and on the filesystem
- name: The name of the author.
- email: The email address of the author.


Testing
-------
The generated Ansible role has the molecule testing framework built in! This will test the role using dockers in different Linux
flavors. To make this work:
- install Python3 on your local machine
- install Docker Desktop on your local machine
- install Molecule on your local machine (`brew install molecule` on a Mac)
- install the Molecule docker driver (`pip3 install 'molecule-plugins[docker]'`)
- when it is not working, you might have to downgrade the Python requests library (`pip3 install requests==2.28.1`)

to start a full test run, execute `molecule test` from within the role.

Example
----

    cookiecutter https://gitlab.itcreation.nl/it-creation/ansible/ansible-role-template.git
