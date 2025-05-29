#!/bin/bash

echo "Starting dockerized Velocity (unofficial image)"
echo "by Florke64 | https://github.com/Florke64/velocity-docker"
echo "Running in directory: $(pwd)"
echo "Current user: $(whoami)"
echo "Current date and time: $(date)"
echo "Current environment variables:"
echo $(env)

java ${JVM_OPTIONS} -jar /velocity.jar
