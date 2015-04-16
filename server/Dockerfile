FROM ubuntu:14.04

RUN apt-get -y update \
    && apt-get -y upgrade

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

# Install elastic search for the domain dive feature
RUN pip install elasticsearch

# copy over the tangelo web apps 
COPY datawake /usr/local/share/tangelo/web/datawake
COPY forensic /usr/local/share/tangelo/web/forensic

# setup tangelo user account and configuration, expose port 80 for tangelo
RUN adduser  --no-create-home --disabled-password --disabled-login --gecos "" tangelo
COPY tangelo.conf /etc/tangelo.conf
EXPOSE 80

# copy over the Datawake Environment Variable file and startup script
COPY opt /opt
RUN chmod 777 /opt/dockerstartup.sh
RUN chmod 666 /opt/DWenvVar.txt

# set the default container command to run the startup script each time
CMD ["/opt/dockerstartup.sh"]

# All environmental variables should be loaded from the DWenvVar.txt file above
## ENV MITIE_HOME /usr/lib/mitie/MITIE
## ENV PYTHONPATH /usr/local/share/tangelo/web:$PYTHONPATH