# Cert manager IRSA (IAM roles for service accounts)
module "cert_manager_irsa_role" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  role_name                     = "cert-manager"
  version                       = "5.2.0"
  attach_cert_manager_policy    = true
  cert_manager_hosted_zone_arns = ["arn:aws:route53:::hostedzone/Z06789328PXZNV3WOVWM"]

  oidc_providers = {
    eks = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["cert-manager:cert-manager"]
    }
  }

  tags = local.tags
}

resource "aws_iam_policy" "cert_manager_policy" {
  name        = "cert-manager-policy"
  description = "Policy allowing Cert-Manager to manage DNS challenges"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "route53:ListHostedZones",
          "route53:ListResourceRecordSets",
          "route53:GetChange"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "route53:ChangeResourceRecordSets",
          "route53:GetHostedZone"
        ]
        Resource = "arn:aws:route53:::hostedzone/Z06789328PXZNV3WOVWM"
      }
    ]
  })
}

# Attach Cert-Manager Policy to the Role
resource "aws_iam_role_policy_attachment" "cert_manager_policy_attachment" {
  policy_arn = aws_iam_policy.cert_manager_policy.arn
  role       = module.cert_manager_irsa_role.iam_role_name
}

## External DNS IRSA
module "external_dns_irsa_role" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version                       = "5.2.0"
  role_name                     = "external-dns"
  attach_external_dns_policy    = true
  external_dns_hosted_zone_arns = ["arn:aws:route53:::hostedzone/Z06789328PXZNV3WOVWM"]

  oidc_providers = {
    eks = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["external-dns:external-dns"]
    }
  }
  tags = local.tags
}

resource "aws_iam_policy" "external_dns_policy" {
  name        = "external-dns-policy"
  description = "Policy allowing ExternalDNS to manage Route53 records"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "route53:ListHostedZones",
          "route53:ListResourceRecordSets",
          "route53:GetChange"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "route53:ChangeResourceRecordSets",
          "route53:GetHostedZone"
        ]
        Resource = "arn:aws:route53:::hostedzone/Z06789328PXZNV3WOVWM"
      }
    ]
  })
}

# Attach ExternalDNS Policy to the Role
resource "aws_iam_role_policy_attachment" "external_dns_policy_attachment" {
  policy_arn = aws_iam_policy.external_dns_policy.arn
  role       = module.external_dns_irsa_role.iam_role_name
}


