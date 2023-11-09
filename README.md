Role Name
=========

This is a proof of concept to demonstrate the molecule testing framwork. The Ansible role is tested on two different OSses (Debian and Ubuntu), which are running in Docker containers

Requirements
------------

Install Python, molecule, docker, ansible locally (my Python needed a downgrade of the python requests module to get it working; this might be solved at the time you are reading this)

Overview
--------

Molecule can run multiple test scenarios. In this POC, only one is implemented (under `molecule/default`). A scenario is composed of several steps:

### Setup
Molecule creates a virtual environment for testing. This can be a Docker container, a virtual machine, or even a cloud instance. The environment is defined in the molecule.yml configuration file.

This is configured in `molecule/<scenario>/create.yml`

### Converge
Molecule runs the Ansible role on the virtual environment. This applies the tasks defined in the role to the environment.

This is configured in `molecule/<scenario>/converge.yml`

### Verify
Molecule runs a set of tests against the virtual environment to verify that the role has had the expected effect. These tests are typically written using a framework like Testinfra or Goss, and are defined in a verify.yml playbook or a test_*.py file.

This is configured in `molecule/<scenario>/verify.yml`

### Teardown
After the tests have been run, Molecule destroys the virtual environment. This ensures that each test run starts with a clean environment.

This is configured in `molecule/<scenario>/destroy.yml`

Configuration
-------------
The configuration per scenario is defined in `molecule/<scenario>/molecule.yml`

Running
------------

`molecule test` will do all the stages of the test:

  - set up two hosts (running in dockers)
  - run the playbook that calles the ansible role
  - verify that the desired state has actually been reached
  - tear down the testing environment (i.e. stopping the docker containers)

```bash
$ molecule test

WARNING  Driver docker does not provide a schema.
INFO     default scenario test matrix: dependency, cleanup, destroy, syntax, create, prepare, converge, idempotence, side_effect, verify, cleanup, destroy
INFO     Performing prerun with role_name_check=0...
INFO     Using /Users/reinoudvanleeuwen/.ansible/roles/itc.myrole symlink to current repository in order to enable Ansible to find the role using its expected full name.
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

PLAY RECAP *********************************************************************
localhost                  : ok=1    changed=0    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Running default > syntax

playbook: /Users/reinoudvanleeuwen/blah/molecule/myrole/molecule/default/converge.yml
INFO     Running default > create

PLAY [Create] ******************************************************************

TASK [Create a container] ******************************************************
ok: [localhost] => (item={'image': 'mipguerrero26/ubuntu-python3', 'name': 'instance-ubuntu', 'pre_build_image': True})
ok: [localhost] => (item={'image': 'python:3.12.0-bookworm', 'name': 'instance-debian', 'pre_build_image': True})

TASK [Add container to molecule_inventory] *************************************
ok: [localhost] => (item=instance-ubuntu)
ok: [localhost] => (item=instance-debian)

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

PLAY RECAP *********************************************************************
instance-debian            : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
instance-ubuntu            : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
localhost                  : ok=4    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Running default > prepare
WARNING  Skipping, prepare playbook not configured.
INFO     Running default > converge

PLAY [Converge] ****************************************************************

TASK [Gathering Facts] *********************************************************
ok: [instance-debian]
ok: [instance-ubuntu]

TASK [Test myrole] *************************************************************

TASK [myrole : Install package nginx] ******************************************
ok: [instance-debian]
ok: [instance-ubuntu]

PLAY RECAP *********************************************************************
instance-debian            : ok=2    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
instance-ubuntu            : ok=2    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Running default > idempotence

PLAY [Converge] ****************************************************************

TASK [Gathering Facts] *********************************************************
ok: [instance-debian]
ok: [instance-ubuntu]

TASK [Test myrole] *************************************************************

TASK [myrole : Install package nginx] ******************************************
ok: [instance-debian]
ok: [instance-ubuntu]

PLAY RECAP *********************************************************************
instance-debian            : ok=2    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
instance-ubuntu            : ok=2    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Idempotence completed successfully.
INFO     Running default > side_effect
WARNING  Skipping, side effect playbook not configured.
INFO     Running default > verify
INFO     Running Ansible Verifier

PLAY [Check if nginx is installed and running] *********************************

TASK [Check if nginx is installed] *********************************************
changed: [instance-debian]
changed: [instance-ubuntu]

PLAY RECAP *********************************************************************
instance-debian            : ok=1    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
instance-ubuntu            : ok=1    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Verifier completed successfully.
INFO     Running default > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running default > destroy

PLAY [Destroy] *****************************************************************

TASK [Populate instance config] ************************************************
ok: [localhost]

TASK [Dump instance config] ****************************************************
skipping: [localhost]

PLAY RECAP *********************************************************************
localhost                  : ok=1    changed=0    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Pruning extra files from scenario ephemeral directory
```