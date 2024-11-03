ARG DEVBOX_ROOT=""
ARG DEBIAN_FRONTEND=noninteractive
ARG DEVBOX_BASE_IMAGE=debian:latest

# Proxy
ARG http_proxy
ARG https_proxy
ARG no_proxy

FROM $DEVBOX_BASE_IMAGE

# Install frequently used tools
RUN apt-get update && \
    apt-get install -yq --no-install-recommends \
      nvtop \
      htop \
      speedometer \
      && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get clean

# Install & configure zsh
RUN apt-get update && \
    apt-get install -yq --no-install-recommends zsh && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get clean
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
RUN git clone https://github.com/zplug/zplug.git $HOME/.zplug && \
    chown -R tiger:tiger $HOME/.zplug
RUN sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME=""/' $HOME/.zshrc && \
    echo '\n\
# >>> zplug section >>>\n\
source ~/.zplug/init.zsh\n\n\
zplug "mafredri/zsh-async", from:github\n\
zplug "sindresorhus/pure", use:pure.zsh, from:github, as:theme\n\
# zplug "romkatv/powerlevel10k", as:theme, depth:1\n\n\
zplug "zsh-users/zsh-autosuggestions", as:plugin, defer:2\n\
zplug "zdharma/fast-syntax-highlighting", as:plugin, defer:2\n\
zplug "conda-incubator/conda-zsh-completion", as:plugin, defer:2\n\n\
if ! zplug check --verbose; then\n\
    zplug install\n\
fi\n\n\
zplug load\n\
# <<< zplug section <<<\n\
' >> $HOME/.zshrc

# autojump
RUN apt-get update && \
    apt-get install -yq --no-install-recommends \
      autojump \
      && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get clean
RUN echo '\n\
. /usr/share/autojump/autojump.sh\n\
' >> $HOME/.zshrc

# Install snipkit
RUN echo 'deb [trusted=yes] https://apt.fury.io/lemoony/ /' | tee /etc/apt/sources.list.d/snipkit.list && \
    apt-get update && \
    apt-get install -yq --no-install-recommends \
      snipkit \
      && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get clean

# Install & configure devbox
RUN echo '\n\
# >>> devbox section >>>\n\
export DEVBOX_ROOT=${DEVBOX_ROOT:-$HOME/.devbox}\n\
[[ -d $DEVBOX_ROOT/devbox ]] && export PATH="$DEVBOX_ROOT/devbox:$PATH"\n\
eval "$(devbox init -)"\n\
# <<< devbox section <<<\n\
' >> $HOME/.zshrc