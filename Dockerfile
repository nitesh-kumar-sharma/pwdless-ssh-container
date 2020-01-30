FROM alpine:latest
EXPOSE 22
USER root
#******************** Install packages ***************************	
RUN apk add --no-cache \
			  bash \
			  openssh \
			  wget \
			  openjdk8-jre

#******************** configure passwordless SSH *****************
RUN /usr/bin/ssh-keygen -A
RUN ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa \
	&& cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys \
	&& chmod 0600 ~/.ssh/authorized_keys \
	&& sed -i s/#PermitRootLogin.*/PermitRootLogin\ yes/ /etc/ssh/sshd_config \
	&& sed -i s/#Port.*/Port\ 22/ /etc/ssh/sshd_config

RUN echo "root:latest" | chpasswd
COPY ./config/ /etc/ssh/
ENTRYPOINT ["bash","-C","/usr/sbin/sshd"]