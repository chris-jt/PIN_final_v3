# Proyecto de Despliegue en AWS EKS

Este proyecto implementa un pipeline de CI/CD para desplegar una instancia EC2 en AWS, crear un cluster EKS, y desplegar una aplicación Nginx junto con herramientas de monitoreo (EFK stack y Prometheus/Grafana).

## Estructura del Proyecto

├── .github
│   └── workflows
│       └── main.yaml
├── cloudformation
│   └── ec2-stack.yaml
├── kubernetes
│   ├── nginx-index-html-configmap.yaml
│   ├── nginx-deployment.yaml
│   ├── nginx-service.yaml
│   ├── efk-stack.yaml
│   └── prometheus-grafana.yaml
├── ec2_user_data.sh
└── README.md

## Funcionamiento

1. El workflow de GitHub Actions se activa manualmente.
2. Se crea una instancia EC2 utilizando CloudFormation.
3. Se configura la instancia EC2 con las herramientas necesarias (Docker, kubectl, eksctl, etc.).
4. Se crea un cluster EKS en AWS.
5. Se despliega un pod de Nginx con una página personalizada.
6. Se despliega el stack EFK (Elasticsearch, Fluentd, Kibana) para monitoreo de logs.
7. Se despliega Prometheus y Grafana para métricas y visualización.

## Acceso a la Instancia EC2

Para acceder a la instancia EC2 desde una PC remota:

1. Descarga la clave SSH `jenkins.pem` del artefacto generado por el workflow.
2. Abre una terminal y navega hasta el directorio donde guardaste la clave.
3. Cambia los permisos de la clave:

        chmod 400 jenkins.pem

4. Conéctate a la instancia EC2 usando el comando:

        ssh -i jenkins.pem ubuntu@`<EC2_PUBLIC_IP>

    Reemplaza `<EC2_PUBLIC_IP>` con la IP pública de la instancia EC2 que encontrarás en el archivo `connection_info.txt`.

## Conexión al Cluster EKS

Para conectarte al cluster EKS desde la instancia EC2:

1. Una vez conectado a la instancia EC2, el archivo kubeconfig ya debería estar configurado.
2. Puedes verificar la conexión con:

        kubectl get nodes


## Integración con Lens

Para integrar el cluster con Lens desde tu PC remota:

1. Instala Lens en tu PC si aún no lo tienes.
2. En la instancia EC2, copia el contenido del archivo kubeconfig:

        cat ~/.kube/config

3. En tu PC local, crea un nuevo archivo kubeconfig y pega el contenido copiado.
4. En Lens, añade un nuevo cluster usando este archivo kubeconfig.

## Acceso a Kibana y Grafana

Las URLs para acceder a Kibana y Grafana se encuentran en el archivo `connection_info.txt`. Estas interfaces son accesibles desde fuera del cloud para monitorear los logs y métricas de la aplicación.

