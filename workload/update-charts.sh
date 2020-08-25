

set -eux

echo "Update all helm charts."

find . -maxdepth 3 -perm 0755 -type f -name "generate-manifests.sh" -exec '{}' ';'
