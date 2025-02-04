locals {
  name        = "eks-lab"
  domain      = "lab.qaisnavaei.com"
  region      = "eu-west-2" # London region
  my_role_arn = "arn:aws:iam::009160072276:user/qaisb"


  tags = {
    Enviroment = "sandbox"
    Project    = "EKS Advanced Lab"
    Owner      = "Qais"
  }

}