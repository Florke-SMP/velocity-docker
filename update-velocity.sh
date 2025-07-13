#!/bin/bash

# Client information
USER_AGENT="velocity-docker/1.0.0 (@florke64@mastodon.social)"

# This scipt fetches the latest stable build of Velocity from the PaperMC API v3
LATEST_VERSION=$(curl -s -H "User-Agent: $USER_AGENT" https://fill.papermc.io/v3/projects/velocity | \
    jq -r '.versions | to_entries[0] | .value[0]')

LATEST_BUILD=$(curl -s -H "User-Agent: $USER_AGENT" https://fill.papermc.io/v3/projects/velocity/versions/${LATEST_VERSION}/builds | \
    jq -r 'map(select(.channel == "STABLE")) | .[0] | .id')

if [ "$LATEST_BUILD" != "null" ]; then
    echo "Found build $LATEST_BUILD for $LATEST_VERSION"
else
    echo "An unexpected error has occured. Please check the logs."
fi

VELOCITY_URL=$(curl -s -H "User-Agent: $USER_AGENT" https://fill.papermc.io/v3/projects/velocity/versions/${LATEST_VERSION}/builds | \
    jq -r 'first(.[] | select(.channel == "STABLE") | .downloads."server:default".url) // "null"')

SHA256=$(curl -s "$VELOCITY_URL" | sha256sum | cut -d' ' -f1)

# Output information
echo "Velocity SHA256: $SHA256"
echo "Velocity URL: $VELOCITY_URL"

# Save to .buildargs for use in dockerfile
echo "LATEST_VERSION=$LATEST_VERSION" > .buildargs
echo "VELOCITY_URL=$VELOCITY_URL" >> .buildargs
echo "SHA256=$SHA256" >> .buildargs