#!/bin/bash

# Variables de configuración
DB_INSTANCE_IDENTIFIER="midawdbmiles"
DB_INSTANCE_CLASS="db.t2.micro"
DB_ENGINE="mysql"
DB_MASTER_USERNAME="rootm"
DB_MASTER_PASSWORD="4t58D+yG*B4r"
DB_ALLOCATED_STORAGE=20
EC2_SECURITY_GROUP_NAME="gs_mimysql"
EC2_SECURITY_GROUP_OWNER_ID="167722586127"

# Crear la instancia de base de datos MySQL
aws rds create-db-instance \
  --db-instance-identifier $DB_INSTANCE_IDENTIFIER \
  --db-instance-class $DB_INSTANCE_CLASS \
  --engine $DB_ENGINE \
  --master-username $DB_MASTER_USERNAME \
  --master-user-password $DB_MASTER_PASSWORD \
  --allocated-storage $DB_ALLOCATED_STORAGE

# Esperar a que la instancia esté disponible
aws rds wait db-instance-available --db-instance-identifier $DB_INSTANCE_IDENTIFIER

# Obtener información de conexión
db_info=$(aws rds describe-db-instances --db-instance-identifier $DB_INSTANCE_IDENTIFIER)
db_endpoint=$(echo $db_info | jq -r '.DBInstances[0].Endpoint.Address')

# Modificar el grupo de seguridad para permitir conexiones remotas
aws rds authorize-db-security-group-ingress \
  --db-security-group-name default \
  --ec2-security-group-name $EC2_SECURITY_GROUP_NAME \
  --ec2-security-group-owner-id $EC2_SECURITY_GROUP_OWNER_ID

# Esperar a que se apliquen los cambios en el grupo de seguridad
aws rds wait db-instance-available --db-instance-identifier $DB_INSTANCE_IDENTIFIER

# Imprimir la información de conexión
echo "La instancia de base de datos ha sido creada con éxito."
echo "Endpoint: $db_endpoint"

