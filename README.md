
Overview
========

This is a (cookiecutter) template to generate a new Ansible role including a working test environment using Molecule

When invoked, cookiecutter will prompt for some variables like names, generate an Ansible role, and initialize a local git repository for it.

Usage
-----
- Install cookiecutter: `pip install cookiecutter`
- Generate the Ansible role from the template: `cookiecutter <path-to-template>`
- Follow the prompts to customize the generated role.

Template Variables
------
- role_name: The name of the Ansible role.
- description: A brief description of the role.
- author_name: The name of the author.
- author_email: The email address of the author.


Example
----
    cookiecutter ansible-role-template
