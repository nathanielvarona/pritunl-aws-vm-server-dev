## Provision Initial VM using Terraform

### Prepare the Environment

Create a copy and fill in the required environment variables fields

```bash
cp ./.envrc.dist ./.envrc
```

Load the environment variables in your current working shell

```bash
set -a && source ./.envrc && set +a
```

### Install Terraspace *(a Terraform Framework)* Requirements

Create a Ruby Environment (Gemset)

```bash
rbenv gemset create 3.1.2 pritunl-aws-vm-single-server
```

Install the required Gemset for Terraspace Framework

```bash
bundle install
```

Install Terraform Vendor Modules from Terraform Registry

```bash
terraspace bundle
```

### Provision the VM

Plan and Provision a VM

```bash
terraspace all plan
terraspace all up
```

Monitor the Operations by outputting the logs

```bash
terraspace logs -f
```


## Provision Existing VM using Ansible

### Ansible Provisioning Requirements

Prepare the Environment
```bash
cd ./provisioning
python -m venv ./.venv
source ./.venv/bin/activate
```

Ansible Base (Core Distribution)
```bash
pip install -r requirements.txt
```


AWS Plugin
```bash
ansible-galaxy collection install amazon.aws
```

### AWS Compute Resource Inventory Checks

Show AWS EC2 Resource
```
ansible-inventory -i aws_ec2.yml --graph
```

```bash
ansible tag_Name_pritunl_vm -i aws_ec2.yml -m ping
```

### Basic Usage

Check for Possible Changes _(Dry Run)_
```bash
ansible-playbook -i aws_ec2.yml main.yml --check
```

Install the Updates _(Approve for any changes)_
```bash
ansible-playbook -i aws_ec2.yml main.yml
```

### Advance Usage

Only for APT Check/Changes
```bash
ansible-playbook -i aws_ec2.yml main.yml --tags "apt" --check
```

Only for SystemD Check/Changes
```bash
ansible-playbook -i aws_ec2.yml main.yml --tags "systemd" --check
```

## TODO

* Create a Packer Images for Initial VM Provisioning
 