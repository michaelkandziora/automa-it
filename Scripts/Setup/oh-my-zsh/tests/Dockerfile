FROM ubuntu

RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y git curl zsh vim python3-pip

COPY .p10k.zsh /root/.p10k.zsh
COPY utils.sh /root/utils.sh
COPY install_omz.sh /root/install_omz.sh
COPY customize_omz.sh /root/customize_omz.sh
COPY config.toml /root/config.toml
COPY config.toml /root/config.toml.bak
COPY run_unittest.sh /root/run_unittest.sh


RUN bash /root/install_omz.sh --silent

CMD ["sleep", "infinity"]

