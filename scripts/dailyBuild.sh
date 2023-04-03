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

export RUNTIMEURL="\nliberty {\n    install {\n        runtimeUrl='https://public.dhe.ibm.com/ibmdl/export/pub/software/openliberty/runtime/nightly/$DATE/$DRIVER'\n    }\n}"

#echo -e "$RUNTIMEURL" >> module-jwt/build.gradle
sed -i "s;clean.dependsOn;$RUNTIMEURL\nclean.dependsOn;g" module-jwt/build.gradle module-getting-started/build.gradle system/build.gradle module-config/build.gradle module-securing/build.gradle module-openapi/build.gradle
cat module-jwt/build.gradle

#echo -e "$RUNTIMEURL" >> module-getting-started/build.gradle
cat module-getting-started/build.gradle

#echo -e "$RUNTIMEURL" >> system/build.gradle
cat system/build.gradle

#echo -e "$RUNTIMEURL" >> module-config/build.gradle
cat module-config/build.gradle

#echo -e "$RUNTIMEURL" >> module-securing/build.gradle
cat module-securing/build.gradle

#echo -e "$RUNTIMEURL" >> module-openapi/build.gradle
cat module-openapi/build.gradle

sed -i "s;FROM icr.io/appcafe/open-liberty:full-java11-openj9-ubi;FROM $DOCKER_USERNAME/olguides:$BUILD;g" module-kubernetes/Containerfile
cat module-kubernetes/Containerfile

sed -i "s;95;999;g" module-health-checks/src/main/java/io/openliberty/deepdive/rest/health/StartupCheck.java
cat module-health-checks/src/main/java/io/openliberty/deepdive/rest/health/StartupCheck.java

sudo -u runner ../scripts/testApp.sh
