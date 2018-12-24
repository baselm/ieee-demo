FROM numenta/nupic

MAINTAINER Basel Magableh

RUN apt-get update
RUN apt-get install nano 
RUN apt-get install docker.io -y 


RUN pip install --upgrade pip
RUN pip install --upgrade numpy
RUN pip install --upgrade flask


COPY requirements.txt /tmp/
RUN pip install --requirement /tmp/requirements.txt
 

COPY /model-api /model-api
ENV TERM xterm
ENV NTA_CONF_PROP_nupic_cluster_database_passwd nupic
ENV NTA_CONF_PROP_nupic_cluster_database_host db
COPY nupic-default.xml /usr/local/src/nupic/src/nupic/support/nupic-default.xml

WORKDIR /model-api
CMD python nupic-api.py


