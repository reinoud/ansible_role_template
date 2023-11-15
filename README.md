
Overview
========

This is a ([cookiecutter](https://cookiecutter.readthedocs.io/en/stable/)) template to generate a new Ansible role including a working test environment using the [Molecule](https://ansible.readthedocs.io/projects/molecule/) test environment.

When invoked, cookiecutter will prompt for some variables like names, generate an Ansible role, and initialize a local git repository for it.

Purpose
----

Starting all new roles from a centrally managed template facilitates standaardisation of Ansible roles. The structure of all new roles is similar, which easfies maintenance and makes them more readable.
The generated role has a working test environment, which can (and should) be extended to test more complex scenarios in multiple Linux flavors, and possibly Windows versions as well. By starting to test the roles from day one, the purpose is to improve quality and prevent bugs.

When encountering a bug in a role, ideally fix process should start by adding a test that fails initially. This should prevent the bug from ever re-appearing in the future.

General usage overview
-----
- make sure Python3 is installed
- Install cookiecutter: `pip install cookiecutter`
- Generate the Ansible role from the template: `cookiecutter https://gitlab.itcreation.nl/it-creation/ansible/ansible-role-template.git`
- Follow the prompts to customize the generated role.
- search for TODO in the generated role to change example code in something useable

Cookiecutter Template Variables
------
Cookiecutter has some variables (defined in `cookiecutter.json`), that are used in the template. The values are asked (with some sane generated defaults) when the template is called with the `cookiecutter` command:

- `rolename`: The long name of the Ansible role including spaces.
- `rolename_slug`: the valid name as used in Ansible and on the filesystem
- `name`: The name of the author.
- `email`: The email address of the author.
- `generate_git_repository`: create a local git repository after the role has been created

In the template they are used in their namespace: `{{ cookiecutter.rolename_slug }}`

Maintenance of the template
-------
This template uses Jinja2 templating to generate Ansible code that might contain Jinja2 templates itself. This has several consequences:

### Escaping

All instances of double curly braces (`{{` and `}}` ) need to be escaped by putting them inside double curly brances themself:

| Ansible code | Template |
|--------------|----------|
| `"{{ ansible_os_family }}-specific variables"` | `{{ '{{' }} ansible_os_family {{ '}}' }}-specific variables"` |

### Yaml compliance

Since the names of variables should start with the name of the role, and this is templated. the template files themselve might not be valid yaml. This example shows the naming convention for variables in the role:

| Ansible code | Template |
|--------------|----------|
| `my_ansile_role_packagename: 'apache2'` |`{{ cookiecutter.rolename_slug}}_packagename: 'apache2'`|


Testing the generated role
-------
The generated Ansible role has the molecule testing framework built in! This will test the role using dockers in different Linux
flavors. To make this work:
- install Python3 on your local machine
- install Docker Desktop on your local machine
- install Molecule on your local machine (`brew install molecule` on a Mac)
- install the Molecule docker driver (`pip3 install 'molecule-plugins[docker]'`)
- when it is not working, you might have to downgrade the Python requests library (`pip3 install requests==2.28.1`)

to start a full test run, execute `molecule test` from a directory within the role.

Example usage of the template
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
Initialized empty Git repository in /Users/reinoudvanleeuwen/git/ansible/my_ansible_role/.git/
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