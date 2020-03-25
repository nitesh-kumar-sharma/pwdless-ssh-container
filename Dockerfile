FROM nikush001/base-alpine-java8:latest
LABEL MAINTAINER="Nitesh K. Sharma <sharma.nitesh590@gmail.com>"
EXPOSE 22
USER root
#******************** Install packages ***************************	
RUN apk add openssh

#******************** configure passwordless SSH *****************
RUN /usr/bin/ssh-keygen -A
RUN ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa \
	&& cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys \
	&& chmod 0600 ~/.ssh/authorized_keys \
	&& sed -i s/#PermitRootLogin.*/PermitRootLogin\ yes/ /etc/ssh/sshd_config \
	&& sed -i s/#Port.*/Port\ 22/ /etc/ssh/sshd_config
	
RUN ssh-keyscan -H "$HOSTNAME" >> ~/.ssh/known_hosts && \
	echo "root:latest" | chpasswd
ADD ssh_config /etc/ssh/
CMD ["/usr/sbin/sshd","-D"]