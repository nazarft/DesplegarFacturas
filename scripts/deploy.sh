#!/bin/bash

# Paso 1: Cargar las variables de entorno
source ":/entornos/$1"

# Paso 2: Cambiar a la rama correspondiente y actualizar el código
git checkout $RAMA_GIT
git pull origin $RAMA_GIT

# Paso 3: Construir con maven
mvn clean install

# Paso 4: Copiar la aplicación al servidor destino
scp /Users/pro/Desktop/build.jar ${USER_NAME}@$IP_SERVER:/home/nazar

# Paso 5: Generar el par de claves SSH en local
 ssh-keygen -f $HOME/.ssh/id_rsa -t rsa -b 4096 -C "juan@alumno.fpmislata.com" -q -N ""

# Paso 6: Copiar la clave pública al servidor remoto
ssh-copy-id -i $HOME/.ssh/id_rsa.pub ${USER_NAME_DEPLOY_SERVER}@${IP_DEPLOY_SERVER}

# Paso 7: Despliegue remoto y configuración del JDK y firewall
ssh -i $HOME/.ssh/id_rsa "${USER_NAME_DEPLOY_SERVER}@${IP_DEPLOY_SERVER}" <<EOF
  # Crear un directorio para el JDK
  mkdir -p /home/nazar/jdk
  
  # Descargar los trozos del JDK
  curl -L https://github.com/nazarft/DesplegarFacturas/raw/main/JDK/jdk_part_aa.tar.gz -o /home/nazar/jdk/jdk_part_aa.tar.gz
  curl -L https://github.com/nazarft/DesplegarFacturas/raw/main/JDK/jdk_part_ab.tar.gz -o /home/nazar/jdk/jdk_part_ab.tar.gz
  curl -L https://github.com/nazarft/DesplegarFacturas/raw/main/JDK/jdk_part_ac.tar.gz -o /home/nazar/jdk/jdk_part_ac.tar.gz
  curl -L https://github.com/nazarft/DesplegarFacturas/raw/main/JDK/jdk_part_ad.tar.gz -o /home/nazar/jdk/jdk_part_ad.tar.gz
  curl -L https://github.com/nazarft/DesplegarFacturas/raw/main/JDK/jdk_part_ae.tar.gz -o /home/nazar/jdk/jdk_part_ae.tar.gz
  curl -L https://github.com/nazarft/DesplegarFacturas/raw/main/JDK/jdk_part_af.tar.gz -o /home/nazar/jdk/jdk_part_af.tar.gz
  curl -L https://github.com/nazarft/DesplegarFacturas/raw/main/JDK/jdk_part_ag.tar.gz -o /home/nazar/jdk/jdk_part_ag.tar.gz
  curl -L https://github.com/nazarft/DesplegarFacturas/raw/main/JDK/jdk_part_ah.tar.gz -o /home/nazar/jdk/jdk_part_ah.tar.gz
  
  cat /home/nazar/jdk/jdk.part*.tar.gz > /home/nazar/jdk/jdk.tar.gz
  tar -xzf /home/nazar/jdk/jdk.tar.gz -C /home/nazar/jdk --strip-components=1

  /home/nazar/jdk/bin/java -jar /home/nazar/build.jar

  sudo ufw allow $PUERTO_APP
EOF

echo "Despliegue completado con éxito."
