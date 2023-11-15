aws rds create-db-instance \
  --db-instance-identifier dbmidawmiles \
  --db-instance-class db.t3.micro \
  --engine MySQL \
  --master-username rootm \
  --master-user-password 4t58D+yG*B4r \
  --allocated-storage 20


aws rds authorize-db-security-group-ingress \
  --db-security-group-name default \
  --ec2-security-group-name gs_mimysql \
  --ec2-security-group-owner-id 167722586127

aws rds wait db-instance-available --db-instance-identifier dbmidawmiles

aws rds describe-db-instances --db-instance-identifier dbmidawmiles
