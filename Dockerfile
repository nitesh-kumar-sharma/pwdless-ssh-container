FROM alpine:latest
EXPOSE 22
USER root
#******************** Install packages ***************************	
RUN apk add --no-cache \
			  bash \
			  openssh \
			  wget \
			  openjdk8-jre \
			  procps
			  
ENV JAVA_HOME=/usr/lib/jvm/java-1.8-openjdk \
	PATH=$PATH:${JAVA_HOME}/bin

#******************** configure passwordless SSH *****************
RUN /usr/bin/ssh-keygen -A
RUN ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa \
	&& cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys \
	&& chmod 0600 ~/.ssh/authorized_keys \
	&& sed -i s/#PermitRootLogin.*/PermitRootLogin\ yes/ /etc/ssh/sshd_config \
	&& sed -i s/#Port.*/Port\ 22/ /etc/ssh/sshd_config

RUN echo "root:latest" | chpasswd
ADD ssh_config /etc/ssh/
CMD ["/usr/sbin/sshd","-D"]
#COPY ./config/ /etc/ssh/
#RUN chmod 777 /usr/sbin/sshd
#ENTRYPOINT ["bash","-C","/usr/sbin/sshd"]