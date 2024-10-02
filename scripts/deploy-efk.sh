#!/bin/bash

# Aplicar la configuración de Elasticsearch
kubectl apply -f kubernetes/elasticsearch.yaml

# Aplicar la configuración de Fluentd
kubectl apply -f kubernetes/fluentd-configmap.yaml
kubectl apply -f kubernetes/fluentd-rbac.yaml
kubectl apply -f kubernetes/fluentd-daemonset.yaml

# Aplicar la configuración de Kibana
kubectl apply -f kubernetes/kibana.yaml

# Verificar que todos los pods estén en estado Running
kubectl get pods

# Verificar los logs de Fluentd
kubectl logs -n kube-system -l app=fluentd

# Verificar la conectividad entre Fluentd y Elasticsearch
kubectl exec -it $(kubectl get pods -l app=fluentd -n kube-system -o jsonpath='{.items[0].metadata.name}') -n kube-system -- curl elasticsearch:9200

# Verificar los índices en Elasticsearch
kubectl exec -it $(kubectl get pods -l app=elasticsearch -o jsonpath='{.items[0].metadata.name}') -- curl localhost:9200/_cat/indices