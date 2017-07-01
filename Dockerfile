FROM ruby

LABEL MAINTAINER daniele.grandni@live.it
ENV PORT=80

# Accessing Azure File Share is not yet supported as any other external storage commenting out the relevant code
#ENV SHARE="azurefsshare"
#ENV SHAREPWD="azurefssharekey"
#ENV SHAREACCT="azurestorageaccountname"

ENV AZURE_STORAGE_KEY=""
ENV AZURE_STORAGE_URL=""
ENV GOLLUMCONF=""
ENV GOLLUMCONF_KEY=""


#Gollum prereq layer
RUN apt-get -qq update \
  && apt-get -y --fix-missing install libicu-dev cmake build-essential make ruby-dev libicu-dev zlib1g-dev \
  && rm -rf /var/lib/apt/lists/* \
  && gem install bundler 

#Gollum binaries from branch 5.x
RUN git clone https://github.com/gollum/gollum /gollum
WORKDIR /gollum
RUN git checkout -b 5.x origin/5.x \
  && bundle install

#RUN gem install github-linguist
#RUN gem install gollum
#RUN gem install org-ruby  # optional

#here we must use a file share
#RUN apt-get -qq update \ 
  #&& apt-get -y install cifs-utils \
  #&& mkdir /wiki \
  #&& git init /wiki

#WORKDIR /wiki

# ------------------------
# Azure cli2 support
# ------------------------

RUN  apt-get update -qq && apt-get install -y apt-transport-https \
  && echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ wheezy main" | tee /etc/apt/sources.list.d/azure-cli.list \
  && apt-key adv --keyserver packages.microsoft.com --recv-keys 417A0893 \
  && apt-get update -qq && apt-get install -y azure-cli

# ------------------------
# SSH Server support
# ------------------------
RUN apt-get -qq update \ 
  && apt-get install -y --no-install-recommends openssh-server \
  && echo "root:Docker!" | chpasswd

COPY sshd_config /etc/ssh/

# ------------------------
# CRON support
# ------------------------
RUN apt-get update -qq && apt-get -y install cron
COPY save_wiki.py /usr/bin/
ADD save_wiki.cron /etc/cron.daily/save_wiki
RUN chmod 0644 /etc/cron.daily/save_wiki

# ------------------------
# Init container
# ------------------------
COPY init_container.sh /usr/bin/
COPY init_container.py /usr/bin/

RUN chmod 755 /usr/bin/init_container.sh 
EXPOSE 2222 $PORT

CMD ["/usr/bin/python /usr/bin/init_container.py"]


