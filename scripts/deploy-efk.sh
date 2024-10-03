#!/bin/bash

# Aplicar la configuración de Elasticsearch
kubectl apply -f elasticsearch.yaml

# Aplicar la configuración de Fluentd
kubectl apply -f fluentd-configmap.yaml
kubectl apply -f fluentd-rbac.yaml
kubectl apply -f fluentd-daemonset.yaml

# Aplicar la configuración de Kibana
kubectl apply -f kibana.yaml

# Esperar a que los pods estén listos
kubectl wait --for=condition=ready pod -l app=elasticsearch --timeout=300s
kubectl wait --for=condition=ready pod -l app=fluentd --timeout=300s
kubectl wait --for=condition=ready pod -l app=kibana --timeout=300s

# Verificar que todos los pods estén en estado Running
kubectl get pods

# Verificar los logs de Fluentd
kubectl logs -n kube-system -l app=fluentd

# Verificar la conectividad entre Fluentd y Elasticsearch
FLUENTD_POD=$(kubectl get pods -n kube-system -l app=fluentd -o jsonpath='{.items[0].metadata.name}')
if [ -n "$FLUENTD_POD" ]; then
  kubectl exec -it $FLUENTD_POD -n kube-system -- curl elasticsearch:9200
else
  echo "No Fluentd pod found"
fi

# Verificar los índices en Elasticsearch
ES_POD=$(kubectl get pods -l app=elasticsearch -o jsonpath='{.items[0].metadata.name}')
if [ -n "$ES_POD" ]; then
  kubectl exec -it $ES_POD -- curl localhost:9200/_cat/indices
else
  echo "No Elasticsearch pod found"
fi