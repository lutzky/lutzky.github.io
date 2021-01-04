FROM gitpod/workspace-full

RUN sudo apt-get update \
 && sudo apt-get install -y ruby-full build-essential zlib1g-dev