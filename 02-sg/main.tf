module "db" {
  source = "../../re-terraform-aws-security-group"
  project_name = var.project_name
  environment = var.environment
  sg_description = "SG for DB Mysql instance"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  sg_name = "db"
  common_tags = var.common_tags

}

module "backend" {
  source = "../../re-terraform-aws-security-group"
  project_name = var.project_name
  environment = var.environment
  sg_description = "SG for backend instance"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  sg_name = "backend"
  common_tags = var.common_tags

}

module "frontend" {
  source = "../../re-terraform-aws-security-group"
  project_name = var.project_name
  environment = var.environment
  sg_description = "SG for frotnend instance"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  sg_name = "frontend"
  common_tags = var.common_tags
}

module "bastion" {
  source = "../../re-terraform-aws-security-group"
  project_name = var.project_name
  environment = var.environment
  sg_description = "SG for bastion instance"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  sg_name = "bastion"
  common_tags = var.common_tags
}

module "ansible" {
  source = "../../re-terraform-aws-security-group"
  project_name = var.project_name
  environment = var.environment
  sg_description = "SG for ansible instance"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  sg_name = "ansible"
  common_tags = var.common_tags
}

## DB is accepting connection from backend

resource "aws_security_group_rule" "db_backend" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  source_security_group_id = module.backend.sg_id ## source means where your getting traffic from
  security_group_id = module.db.sg_id
}

resource "aws_security_group_rule" "db_bastion" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id ## source means where your getting traffic from
  security_group_id = module.db.sg_id
}

resource "aws_security_group_rule" "backend_frontend" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.frontend.sg_id ## source means where your getting traffic from
  security_group_id = module.backend.sg_id
}


resource "aws_security_group_rule" "backend_bastion" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id ## source means where your getting traffic from
  security_group_id = module.backend.sg_id
}

resource "aws_security_group_rule" "backend_ansible" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.ansible.sg_id ## source means where your getting traffic from
  security_group_id = module.backend.sg_id
}


resource "aws_security_group_rule" "frontend_public" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
 cidr_blocks   =   ["0.0.0.0/0"]
  security_group_id = module.frontend.sg_id
}

resource "aws_security_group_rule" "frontend_bastion" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id ## source means where your getting traffic from
  security_group_id = module.frontend.sg_id
}

resource "aws_security_group_rule" "frontend_ansible" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.ansible.sg_id ## source means where your getting traffic from
  security_group_id = module.frontend.sg_id
}

resource "aws_security_group_rule" "bastion_public" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
 cidr_blocks   =   ["0.0.0.0/0"]
  security_group_id = module.bastion.sg_id
}


resource "aws_security_group_rule" "ansible_public" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
 cidr_blocks   =   ["0.0.0.0/0"]
  security_group_id = module.ansible.sg_id
}


