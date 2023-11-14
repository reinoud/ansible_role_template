#!/bin/bash
if [ "{{ cookiecutter.generate_git_repository }}" == "yes" ];
then
    # Initialize git repository
    git init -b main
    # Add all files and directories
    git  add .
    # Commit changes
    git commit -m "Initial commit"

    echo "initialized git repo"
fi