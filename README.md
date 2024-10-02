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
2. Usa el archivo kubeconfig descargado del artefacto de GitHub Actions.
3. En Lens, añade un nuevo cluster usando este archivo kubeconfig.

## Acceso a Kibana y Grafana

Las URLs para acceder a Kibana y Grafana se encuentran en el archivo `connection_info.txt`. Estas interfaces son accesibles desde fuera del cloud para monitorear los logs y métricas de la aplicación.

## Conexión al Pod de Nginx desde una PC Remota

Para conectarte directamente al pod de Nginx desde tu PC remota:

1. Descarga el archivo kubeconfig del artefacto generado por el workflow de GitHub Actions.
2. Guarda el archivo kubeconfig en tu PC local, por ejemplo, en `~/eks-kubeconfig`.
3. Instala kubectl en tu PC local si aún no lo tienes instalado.
4. Configura la variable de entorno KUBECONFIG para usar el archivo descargado:

        export KUBECONFIG=~/eks-kubeconfig

5. Verifica que puedes conectarte al cluster:

        kubectl get nodes

6. Obtén el nombre del pod de Nginx:

        kubectl get pods -l app=nginx

7. Para conectarte directamente al pod de Nginx, usa el siguiente comando:

        kubectl exec -it `<nombre-del-pod-nginx>` -- /bin/bash

    Reemplaza `<nombre-del-pod-nginx>` con el nombre real del pod que obtuviste en el paso anterior.

8. Para ver los logs del pod de Nginx:

        kubectl logs `<nombre-del-pod-nginx>`

9. Para acceder a la aplicación Nginx desde tu navegador local, necesitarás configurar port-forwarding:

        kubectl port-forward service/nginx-service 8080:80

    hora puedes acceder a la aplicación Nginx en `http://localhost:8080` desde tu navegador local.

    Nota: Asegúrate de tener las credenciales de AWS configuradas correctamente en tu PC local para poder acceder al cluster EKS.