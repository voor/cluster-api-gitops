

FOLDERS=$(find . -maxdepth 2 -type d -name "manifests" -print)

set -eux

echo "Packages all container images in preparation for transport."

mkdir -p ./images

for appFolder in $FOLDERS; do
    app=${appFolder%"/manifests"}
    ytt --ignore-unknown-comments -f $appFolder | kbld -f - --lock-output ./images/${app}.lock
    echo "$app"
done

for appFolder in $FOLDERS; do
    app=${appFolder%"/manifests"}
    kbld package -f ./images/${app}.lock -o ./images/${app}.tar
    echo "$app"
done