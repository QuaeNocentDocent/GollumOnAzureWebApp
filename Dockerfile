FROM ruby

LABEL MAINTAINER daniele.grandni@live.it
ENV PORT=80
ENV SHARE="azurefsshare"
ENV SHAREPWD="azurefssharekey"
ENV GOLLUMCONF=""

RUN apt-get -y update && apt-get -y install libicu-dev cmake && rm -rf /var/lib/apt/lists/*
RUN gem install github-linguist
RUN gem install gollum
RUN gem install org-ruby  # optional

#here we must use a file share
RUN mkdir /wiki
RUN git init /wiki

#WORKDIR /wiki

# ------------------------
# SSH Server support
# ------------------------
RUN apt-get update \ 
  && apt-get install -y --no-install-recommends openssh-server \
  && echo "root:Docker!" | chpasswd

COPY sshd_config /etc/ssh/
COPY init_container.sh /bin/

RUN chmod 755 /bin/init_container.sh 
EXPOSE 2222 $PORT

CMD ["/bin/init_container.sh"]




#CMD ["gollum", "--port", "80"]

# Install dependencies
#RUN apt-get update
#RUN apt-get install -y -q build-essential ruby1.9.3 python python-docutils ruby-bundler libicu-dev libreadline-dev libssl-dev zlib1g-dev git-core
#RUN apt-get clean
#RUN rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/*

# Install gollum
#RUN gem install gollum redcarpet github-markdown

# Initialize wiki data
#RUN mkdir /root/wikidata
#RUN git init /root/wikidata

# Expose default gollum port 4567
#EXPOSE 4567

#ENTRYPOINT ["/usr/local/bin/gollum", "/root/wikidata"]
