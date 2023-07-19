#!/bin/sh
#
# Run ssh-agent and export the SSH_AUTH_SOCK env var
#

# We'll use a fixed socket path
SSH_AUTH_SOCK="${XDG_RUNTIME_DIR}/ssh-agent.sock"

# Using daemon supervisor to stop ssh-agent upon last logout
daemon -rBP ~/.run -n ssh-agent -- ssh-agent -Da "$SSH_AUTH_SOCK" && \
    # Export the env var if the above command succeeded
    export SSH_AUTH_SOCK
