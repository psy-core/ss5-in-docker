FROM centos:7.6.1810
ADD ss5-3.8.9-8.tar.gz /opt

RUN yum -y install gcc gcc-c++ automake make pam-devel openssl-devel openldap-devel cyrus-sasl-devel \
    && cd /opt/ss5-3.8.9 \
    && ./configure \
    && make \
    && make install \
    && sed -i "/#auth/a\auth 0.0.0.0\/0 - -" /etc/opt/ss5/ss5.conf \
    && sed -i "/#permit/a\permit - 0.0.0.0\/0 - 0.0.0.0\/0 - - - - -" /etc/opt/ss5/ss5.conf 

COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 1080

CMD ["tail", "-f", "/var/log/ss5/ss5.log"]

