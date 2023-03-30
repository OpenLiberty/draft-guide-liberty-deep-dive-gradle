#!/bin/bash
while getopts t:d:b:u: flag; do
    case "${flag}" in
    t) DATE="${OPTARG}" ;;
    d) DRIVER="${OPTARG}" ;;
    b) BUILD="${OPTARG}";;
    u) DOCKER_USERNAME="${OPTARG}";;
    *) echo "Invalid option" ;;
    esac
done

echo "Testing daily build image"

echo "apply plugin: 'liberty'\nliberty {\n    install {\n        runtimeUrl='https://public.dhe.ibm.com/ibmdl/export/pub/software/openliberty/runtime/nightly/$DATE/$DRIVER'\n    }\n}" >> module-jwt/build.gradle
cat module-jwt/build.gradle

echo "apply plugin: 'liberty'\nliberty {\n    install {\n        runtimeUrl='https://public.dhe.ibm.com/ibmdl/export/pub/software/openliberty/runtime/nightly/$DATE/$DRIVER'\n    }\n}" >> module-getting-started/build.gradle
cat module-getting-started/build.gradle

echo "apply plugin: 'liberty'\nliberty {\n    install {\n        runtimeUrl='https://public.dhe.ibm.com/ibmdl/export/pub/software/openliberty/runtime/nightly/$DATE/$DRIVER'\n    }\n}" >> system/build.gradle
cat system/build.gradle

echo "apply plugin: 'liberty'\nliberty {\n    install {\n        runtimeUrl='https://public.dhe.ibm.com/ibmdl/export/pub/software/openliberty/runtime/nightly/$DATE/$DRIVER'\n    }\n}" >> module-config/build.gradle
cat module-config/build.gradle

echo "apply plugin: 'liberty'\nliberty {\n    install {\n        runtimeUrl='https://public.dhe.ibm.com/ibmdl/export/pub/software/openliberty/runtime/nightly/$DATE/$DRIVER'\n    }\n}" >> module-securing/build.gradle
cat module-securing/build.gradle

echo "apply plugin: 'liberty'\nliberty {\n    install {\n        runtimeUrl='https://public.dhe.ibm.com/ibmdl/export/pub/software/openliberty/runtime/nightly/$DATE/$DRIVER'\n    }\n}" >> module-openapi/build.gradle
cat module-openapi/build.gradle

sed -i "s;FROM icr.io/appcafe/open-liberty:full-java11-openj9-ubi;FROM $DOCKER_USERNAME/olguides:$BUILD;g" module-kubernetes/Containerfile
cat module-kubernetes/Containerfile

../scripts/testApp.sh
