duffle install tanzu-build-service \
    -c credentials.yaml \
    --set kubernetes_env=another \
    --set docker_registry=gcr.io \
    --set docker_repository=gcr.io/pa-rvanvoorhees/build-service \
    --set registry_username=_json_key \
    --set registry_password="$(cat gcr.io.creds.json)" \
    --set custom_builder_image="gcr.io/pa-rvanvoorhees/build-service/default-builder" \
    -f build-service-0.1.0.tgz \
    -m relocated.json