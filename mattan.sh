#!/bin/bash

cd helm-chart
helm dep update
cd ..
helm upgrade rozner helm-chart --recreate-pods --namespace rozner
watch kubectl get pods --namespace rozner