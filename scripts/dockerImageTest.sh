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

sed -i "\#<artifactId>liberty-maven-plugin</artifactId>#a<configuration><install><runtimeUrl>https://public.dhe.ibm.com/ibmdl/export/pub/software/openliberty/runtime/nightly/$DATE/$DRIVER</runtimeUrl></install></configuration>" module-jwt/build.gradle
cat module-jwt/build.gradle

sed -i "s;FROM icr.io/appcafe/open-liberty:full-java11-openj9-ubi;FROM openliberty/daily:latest;g" module-kubernetes/Containerfile
cat module-kubernetes/Containerfile

podman pull "openliberty/daily:latest"

../scripts/testApp.sh
