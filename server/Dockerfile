FROM ubuntu:14.04

RUN dpkg-divert --local --rename --add /sbin/initctl
RUN ln -nfs /bin/true /sbin/initctl

RUN apt-get -y update \
    && apt-get -y upgrade

# install mysql
RUN echo "mysql-server-5.6 mysql-server/root_password password root" | debconf-set-selections
RUN echo "mysql-server-5.6 mysql-server/root_password_again password root" | debconf-set-selections
RUN apt-get -y install mysql-server-5.6

# config mysql to have mysqld bind to available networks, not just localhost
RUN sed -i -e"s/^bind-address\s*=\s*127.0.0.1/bind-address = 0.0.0.0/" /etc/mysql/my.cnf

# copy over db files
#COPY ./dev-env /usr/local/share/dev-env

ADD ./startup.sh /opt/startup.sh
	
RUN apt-get install -y python-software-properties \
    && apt-get install -y software-properties-common \
    && apt-get -y install python-pip \
    && apt-get -y install python-dev

RUN apt-get -y install git \
    && apt-get -y install make \
    && apt-get -y install cmake

RUN apt-get install -y wget

# install the MITIE library
RUN apt-get install -y libjpeg-dev
RUN sudo apt-get install -y libopenblas-dev liblapack-dev
RUN mkdir /usr/lib/mitie \
    && cd /usr/lib/mitie \
    && git clone https://github.com/mitll/MITIE.git \
    && cd MITIE \
    && make MITIE-models \
    && cd tools/ner_stream \
    && mkdir build \
    && cd build \
    && cmake .. \
    && cmake --build . --config Release \
    && cd ../../../mitielib \
    && make
ENV MITIE_HOME /usr/lib/mitie/MITIE


# misc python libs

RUN pip install happybase
RUN pip install httplib2
RUN pip install tldextract



# install mysql client
RUN wget http://dev.mysql.com/get/Downloads/Connector-Python/mysql-connector-python-1.2.3.tar.gz \
    && tar xf mysql-connector-python-1.2.3.tar.gz \
    && cd mysql-connector-python-1.2.3/ \
    && python setup.py install


# install igraph

RUN add-apt-repository -y ppa:igraph/ppa \
    && apt-get update \
    && apt-get install -y python-igraph


# install pyodc

RUN apt-get -y install aptitude \
    && aptitude -y install g++ \
    && apt-get -y install unixodbc-dev \
    && pip install --allow-external pyodbc --allow-unverified pyodbc pyodbc


# install beatiful soup
RUN apt-get install -y python-bs4

# install tangelo
RUN pip install tangelo


# copy over the web apps and conf
COPY datawake /usr/local/share/tangelo/web/datawake
COPY forensic /usr/local/share/tangelo/web/forensic
ENV PYTHONPATH /usr/local/share/tangelo/web:$PYTHONPATH



# setup tangelo conf and entry point for container
# set the default container command to run startup script (tangelo, mysql)
RUN adduser  --no-create-home --disabled-password --disabled-login --gecos "" tangelo
COPY tangelo.conf /etc/tangelo.conf
EXPOSE 80
ADD ./startup.sh /opt/startup.sh
CMD ["/bin/bash", "/opt/startup.sh"]


# Install elastic search for the domain dive feature
RUN pip install elasticsearch

