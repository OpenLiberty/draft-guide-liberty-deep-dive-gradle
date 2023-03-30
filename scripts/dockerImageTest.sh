#!/bin/bash
while getopts t:d:b:u: flag;
do
    case "${flag}" in
        t) DATE="${OPTARG}";;
        d) DRIVER="${OPTARG}";;
        *) echo "Invalid option";;
    esac
done

echo "Testing daily Docker image"


export RUNTIMEURL="apply plugin: 'liberty'\nliberty {\n    install {\n        runtimeUrl='https://public.dhe.ibm.com/ibmdl/export/pub/software/openliberty/runtime/nightly/$DATE/$DRIVER'\n    }\n}"

echo "$RUNTIMEURL" >> module-jwt/build.gradle
cat module-jwt/build.gradle

echo "$RUNTIMEURL" >> module-getting-started/build.gradle
cat module-getting-started/build.gradle

echo "$RUNTIMEURL" >> system/build.gradle
cat system/build.gradle

echo "$RUNTIMEURL" >> module-config/build.gradle
cat module-config/build.gradle

echo "$RUNTIMEURL" >> module-securing/build.gradle
cat module-securing/build.gradle

echo  "$RUNTIMEURL" >> module-openapi/build.gradle
cat module-openapi/build.gradle

sed -i "s;FROM icr.io/appcafe/open-liberty:full-java11-openj9-ubi;FROM openliberty/daily:latest;g" module-kubernetes/Containerfile
cat module-kubernetes/Containerfile

podman pull "openliberty/daily:latest"

../scripts/testApp.sh
