
Overview
========

This is a (cookiecutter) template to generate a new Ansible role including a working test environment using Molecule

When invoked, cookiecutter will prompt for some variables like names, generate an Ansible role, and initialize a local git repository for it.

Purpose
----

Starting all new roles from a centrally managed template facilitates standaardisation of Ansible roles. The structure of all new roles is similar, which easfies maintenance and makes them more readable.
The generated role has a working test environment, which can (and should) be extended to test more complex scenarios in multiple Linux flavors, and possibly Windows versions as well. By starting to test the roles from day one, the purpose is to improve quality and prevent bugs.

When encountering a bug in a role, ideally fix process should start by adding a test that fails initially. This should prevent the bug from ever re-appearing in the future.

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
- generate_git_repository: create a local git repository after the role has been created


Testing
-------
The generated Ansible role has the molecule testing framework built in! This will test the role using dockers in different Linux
flavors. To make this work:
- install Python3 on your local machine
- install Docker Desktop on your local machine
- install Molecule on your local machine (`brew install molecule` on a Mac)
- install the Molecule docker driver (`pip3 install 'molecule-plugins[docker]'`)
- when it is not working, you might have to downgrade the Python requests library (`pip3 install requests==2.28.1`)

to start a full test run, execute `molecule test` from a directory within the role.

Example
----

command:
```
cookiecutter https://gitlab.itcreation.nl/it-creation/ansible/ansible-role-template.git
```
output:
```

  [1/5] rolename (My Ansible Role):
  [2/5] rolename_slug (my_ansible_role):
  [3/5] author (John Doe):
  [4/5] email (john.doe@itcreation.nl):
  [5/5] Select generate_git_repository
    1 - yes
    2 - no
    Choose from [1/2] (1):
Initialized empty Git repository in /Users/reinoudvanleeuwen/blah/cookiecuttertest/my_ansible_role/.git/
[main (root-commit) 1637aa1] Initial commit
 19 files changed, 284 insertions(+)
 create mode 100644 README.md
 create mode 100644 defaults/main.yml
 create mode 100644 handlers/main.yml
 create mode 100644 meta/main.yml
 create mode 100644 molecule/default/converge.yml
 create mode 100644 molecule/default/create.yml
 create mode 100644 molecule/default/destroy.yml
 create mode 100644 molecule/default/molecule.yml
 create mode 100644 molecule/default/verify.yml
 create mode 100644 molecule/default/verify_vars/debian.yml
 create mode 100644 molecule/default/verify_vars/redhat.yml
 create mode 100644 tasks/configure_packages.yml
 create mode 100644 tasks/configure_services.yml
 create mode 100644 tasks/install_packages.yml
 create mode 100644 tasks/main.yml
 create mode 100644 tasks/preflight.yml
 create mode 100644 vars/debian.yml
 create mode 100644 vars/main.yml
 create mode 100644 vars/redhat.yml
initialized git repo
```