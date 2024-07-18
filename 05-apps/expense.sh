#!/bin/bash

## user data automatically have the sudo access

dnf install ansible -y
cd /temp
git clone https://github.com/LingannaJ/re-expense-ansible-roles.git
cd re-expense-ansible-roles
ansible-playbook main.yaml -e component=backend -e login_password=ExpenseApp1
ansible-playbook main.yaml -e component=frontend