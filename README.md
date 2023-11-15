
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

Limitations
-----
As a result of the architecture of Docker, `systemd` is not available in containers that mimic a full VM. This means that the Ansible role cannot enable and start a real service.
To be able to work around this limitation, the scenario is called with the variable `in_molecule_test_run` (with correct prefix), so the code can check this:

```
- name: Make sure service is enabled and starts at boot
  ansible.builtin.systemd:
    name: "{{ '{{' }} {{ cookiecutter.rolename_slug}}_servicename {{ '}}' }}"
    enabled: yes
    state: started
  when: "not {{ cookiecutter.rolename_slug}}_in_molecule_test_run"
```

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

All instances of double curly braces (`{{` and `}}` ) need to be escaped by putting them inside double curly brances themself. Note that you should use the other type of quotes than the surrounding string uses:

| template | generated Ansible code |
|--------------|----------|
| `"{{ '{{' }} ansible_os_family {{ '}}' }}-specific variables"` | `"{{ ansible_os_family }}-specific variables"` |

### Yaml compliance

Since the names of variables should start with the name of the role, and this is templated. the template files themselve might not be valid yaml. This example shows the naming convention for variables in the role:

| template (not valid yaml) | generated Ansible code (valid yaml) |
|--------------|----------|
| `{{ cookiecutter.rolename_slug}}_packagename: 'apache2'` | `my_ansible_role_packagename: 'apache2'` |


Testing the generated role
-------
The generated Ansible role has the molecule testing framework built in! This will test the role using dockers in different Linux
flavors. To make this work:
- install Python3 on your local machine
- install Docker Desktop on your local machine
- install Molecule on your local machine (`brew install molecule` on a Mac)
- install the Molecule docker driver (`pip3 install 'molecule-plugins[docker]'`)
- when it is not working, you might have to downgrade the Python requests library (`pip3 install requests==2.28.1`)

to start a full test run, execute `molecule test` from a directory within the role. The generated role should have a working test setup right after it is generated. This code is checked in in the locally initialised git repository, so you have a working setup to go back to if you break something during development.

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

Example of running the test
------

This output shows running the tests with a freshly generated Ansible role. The role installs the Apache webserver on 3 Linux flavors (Debian, Ubuntu, Oracle Linux). The test only checks if the binary is present. More thorough testing is advised for real-world roles.

Command:
```
molecule test
```

Output
```
WARNING  Driver docker does not provide a schema.
INFO     default scenario test matrix: dependency, cleanup, destroy, syntax, create, prepare, converge, idempotence, side_effect, verify, cleanup, destroy
INFO     Performing prerun with role_name_check=0...
INFO     Using /Users/reinoudvanleeuwen/.ansible/roles/itc.my_ansible_role symlink to current repository in order to enable Ansible to find the role using its expected full name.
INFO     Running default > dependency
WARNING  Skipping, missing the requirements file.
WARNING  Skipping, missing the requirements file.
INFO     Running default > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running default > destroy
INFO     Sanity checks: 'docker'

PLAY [Destroy] *****************************************************************

TASK [Populate instance config] ************************************************
ok: [localhost]

TASK [Dump instance config] ****************************************************
skipping: [localhost]

TASK [Stop containers] *********************************************************
ok: [localhost] => (item={'image': 'mipguerrero26/ubuntu-python3', 'name': 'instance-ubuntu', 'pre_build_image': True})
ok: [localhost] => (item={'image': 'python:3.12.0-bookworm', 'name': 'instance-debian', 'pre_build_image': True})
ok: [localhost] => (item={'image': 'aptplatforms/oraclelinux-python', 'name': 'instance-oracle', 'pre_build_image': True})

TASK [Remove containers] *******************************************************
ok: [localhost] => (item={'image': 'mipguerrero26/ubuntu-python3', 'name': 'instance-ubuntu', 'pre_build_image': True})
ok: [localhost] => (item={'image': 'python:3.12.0-bookworm', 'name': 'instance-debian', 'pre_build_image': True})
ok: [localhost] => (item={'image': 'aptplatforms/oraclelinux-python', 'name': 'instance-oracle', 'pre_build_image': True})

PLAY RECAP *********************************************************************
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Running default > syntax

playbook: /Users/reinoudvanleeuwen/blah/cookiecuttertest/my_ansible_role/molecule/default/converge.yml
INFO     Running default > create

PLAY [Create] ******************************************************************

TASK [Create a container] ******************************************************
changed: [localhost] => (item={'image': 'mipguerrero26/ubuntu-python3', 'name': 'instance-ubuntu', 'pre_build_image': True})
changed: [localhost] => (item={'image': 'python:3.12.0-bookworm', 'name': 'instance-debian', 'pre_build_image': True})
changed: [localhost] => (item={'image': 'aptplatforms/oraclelinux-python', 'name': 'instance-oracle', 'pre_build_image': True})

TASK [Add container to molecule_inventory] *************************************
ok: [localhost] => (item=instance-ubuntu)
ok: [localhost] => (item=instance-debian)
ok: [localhost] => (item=instance-oracle)

TASK [Dump molecule_inventory] *************************************************
changed: [localhost]

TASK [Force inventory refresh] *************************************************

TASK [Fail if molecule group is missing] ***************************************
ok: [localhost] => {
    "changed": false,
    "msg": "All assertions passed"
}

PLAY [Validate that inventory was refreshed] ***********************************

TASK [Check uname] *************************************************************
ok: [instance-debian]
ok: [instance-ubuntu]
ok: [instance-oracle]

PLAY RECAP *********************************************************************
instance-debian            : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
instance-oracle            : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
instance-ubuntu            : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
localhost                  : ok=4    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Running default > prepare
WARNING  Skipping, prepare playbook not configured.
INFO     Running default > converge

PLAY [Converge] ****************************************************************

TASK [Gathering Facts] *********************************************************
ok: [instance-debian]
ok: [instance-ubuntu]
ok: [instance-oracle]

TASK [Test My Ansible Role] ****************************************************

TASK [my_ansible_role : Set Debian-specific variables] *************************
ok: [instance-debian]
ok: [instance-oracle]
ok: [instance-ubuntu]

TASK [my_ansible_role : Pre-flight checks] *************************************
included: /Users/reinoudvanleeuwen/blah/cookiecuttertest/my_ansible_role/tasks/preflight.yml for instance-debian, instance-oracle, instance-ubuntu

TASK [my_ansible_role : Check OS family] ***************************************
ok: [instance-debian] => {
    "changed": false,
    "msg": "All assertions passed"
}
ok: [instance-oracle] => {
    "changed": false,
    "msg": "All assertions passed"
}
ok: [instance-ubuntu] => {
    "changed": false,
    "msg": "All assertions passed"
}

TASK [my_ansible_role : Install needed packages] *******************************
included: /Users/reinoudvanleeuwen/blah/cookiecuttertest/my_ansible_role/tasks/install_packages.yml for instance-debian, instance-oracle, instance-ubuntu

TASK [my_ansible_role : Install example package] *******************************
ok: [instance-oracle]
ok: [instance-debian]
ok: [instance-ubuntu]

TASK [my_ansible_role : Configure package] *************************************

TASK [my_ansible_role : Configure services] ************************************
included: /Users/reinoudvanleeuwen/blah/cookiecuttertest/my_ansible_role/tasks/configure_services.yml for instance-debian, instance-oracle, instance-ubuntu

TASK [my_ansible_role : Make sure service is enabled and starts at boot] *******
skipping: [instance-debian]
skipping: [instance-oracle]
skipping: [instance-ubuntu]

PLAY RECAP *********************************************************************
instance-debian            : ok=7    changed=0    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0
instance-oracle            : ok=7    changed=0    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0
instance-ubuntu            : ok=7    changed=0    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Running default > idempotence

PLAY [Converge] ****************************************************************

TASK [Gathering Facts] *********************************************************
ok: [instance-debian]
ok: [instance-ubuntu]
ok: [instance-oracle]

TASK [Test My Ansible Role] ****************************************************

TASK [my_ansible_role : Set Debian-specific variables] *************************
ok: [instance-debian]
ok: [instance-oracle]
ok: [instance-ubuntu]

TASK [my_ansible_role : Pre-flight checks] *************************************
included: /Users/reinoudvanleeuwen/blah/cookiecuttertest/my_ansible_role/tasks/preflight.yml for instance-debian, instance-oracle, instance-ubuntu

TASK [my_ansible_role : Check OS family] ***************************************
ok: [instance-debian] => {
    "changed": false,
    "msg": "All assertions passed"
}
ok: [instance-oracle] => {
    "changed": false,
    "msg": "All assertions passed"
}
ok: [instance-ubuntu] => {
    "changed": false,
    "msg": "All assertions passed"
}

TASK [my_ansible_role : Install needed packages] *******************************
included: /Users/reinoudvanleeuwen/blah/cookiecuttertest/my_ansible_role/tasks/install_packages.yml for instance-debian, instance-oracle, instance-ubuntu

TASK [my_ansible_role : Install example package] *******************************
ok: [instance-oracle]
ok: [instance-debian]
ok: [instance-ubuntu]

TASK [my_ansible_role : Configure package] *************************************

TASK [my_ansible_role : Configure services] ************************************
included: /Users/reinoudvanleeuwen/blah/cookiecuttertest/my_ansible_role/tasks/configure_services.yml for instance-debian, instance-oracle, instance-ubuntu

TASK [my_ansible_role : Make sure service is enabled and starts at boot] *******
skipping: [instance-debian]
skipping: [instance-oracle]
skipping: [instance-ubuntu]

PLAY RECAP *********************************************************************
instance-debian            : ok=7    changed=0    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0
instance-oracle            : ok=7    changed=0    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0
instance-ubuntu            : ok=7    changed=0    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Idempotence completed successfully.
INFO     Running default > side_effect
WARNING  Skipping, side effect playbook not configured.
INFO     Running default > verify
INFO     Running Ansible Verifier

PLAY [Check if apache is installed and running] ********************************

TASK [Gathering Facts] *********************************************************
ok: [instance-debian]
ok: [instance-ubuntu]
ok: [instance-oracle]

TASK [Include vars for linux family] *******************************************
ok: [instance-debian]
ok: [instance-oracle]
ok: [instance-ubuntu]

TASK [Check if apache is installed] ********************************************
changed: [instance-debian]
changed: [instance-ubuntu]
changed: [instance-oracle]

PLAY RECAP *********************************************************************
instance-debian            : ok=3    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
instance-oracle            : ok=3    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
instance-ubuntu            : ok=3    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Verifier completed successfully.
INFO     Running default > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running default > destroy

PLAY [Destroy] *****************************************************************

TASK [Populate instance config] ************************************************
ok: [localhost]

TASK [Dump instance config] ****************************************************
skipping: [localhost]

TASK [Stop containers] *********************************************************
changed: [localhost] => (item={'image': 'mipguerrero26/ubuntu-python3', 'name': 'instance-ubuntu', 'pre_build_image': True})
changed: [localhost] => (item={'image': 'python:3.12.0-bookworm', 'name': 'instance-debian', 'pre_build_image': True})
changed: [localhost] => (item={'image': 'aptplatforms/oraclelinux-python', 'name': 'instance-oracle', 'pre_build_image': True})

TASK [Remove containers] *******************************************************
ok: [localhost] => (item={'image': 'mipguerrero26/ubuntu-python3', 'name': 'instance-ubuntu', 'pre_build_image': True})
ok: [localhost] => (item={'image': 'python:3.12.0-bookworm', 'name': 'instance-debian', 'pre_build_image': True})
ok: [localhost] => (item={'image': 'aptplatforms/oraclelinux-python', 'name': 'instance-oracle', 'pre_build_image': True})

PLAY RECAP *********************************************************************
localhost                  : ok=3    changed=1    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Pruning extra files from scenario ephemeral directory
```