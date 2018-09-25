### pi-like container image
### runme:
### cd reporoot
### docker build --tag pi-app .
### docker run --rm -it -p 80:80 pi-app
### (on host machine) ==> curl localhost/v1 ==> "hello, api"

FROM debian:stretch

# === start setup user
ENV USER pi
ENV HOME /home/$USER

# install sudo as root
RUN apt-get update && \
        apt-get install -y sudo

# setup the $user
#   -m ==> create home directory
#   -U ==> create group with same name
RUN useradd -mU $USER

# add new user to sudoers
RUN adduser $USER sudo

# allow no password sudo execution
RUN echo "$USER ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER $USER
WORKDIR $HOME

# /=== end setup user

# from this point run as $USER, and . is /home/$USER
# COPY --chown does not expand env vars, so we fallback to calling chown manually
COPY . .
RUN sudo chown -R $USER:$USER .

RUN ./setup.sh

ENTRYPOINT for ser in nginx rsyslog supervisor ; do sudo service $ser start ; done; sh