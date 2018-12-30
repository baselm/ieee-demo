Please see the original post and work in this github page 
https://github.com/stefanprodan/swarmprom
This repo is an experiment for research work in Self Adapting µServices Architecture
# Thanks to Stefan Prodan
 

# swarmprom

Swarmprom is a starter kit for Docker Swarm monitoring with [Prometheus](https://prometheus.io/), 
[Grafana](http://grafana.org/), 
[cAdvisor](https://github.com/google/cadvisor), 
[Node Exporter](https://github.com/prometheus/node_exporter), 
[Alert Manager](https://github.com/prometheus/alertmanager)
and [Unsee](https://github.com/cloudflare/unsee).

## Install

Clone this repository and run the monitoring and adaptation stack:

```bash
$ git clone https://github.com/baselm/ieee-demo.git
$ cd ieee-demo
ADMIN_USER=admin \
ADMIN_PASSWORD=admin \
docker stack deploy -c basic-docker-compose.yml mon3
```
## Run 
The DQN_aftersubmission.ipynb contains the MDP Agent and the DQN algorithm. Running this notebook will enable the DQN to initiat the swarm and load all the services below. The agent will be able to create/remove nodes based on the current state. 

Prerequisites:

* Docker CE 17.09.0-ce or Docker EE 17.06.2-ee-3
* Swarm cluster with one manager and a worker node
* Docker engine experimental enabled and metrics address set to `0.0.0.0:9323`
* Tensorflow 
* Keras API installed 
* Keras-rl https://github.com/keras-rl/keras-rl

Services:

* prometheus (metrics database) `http://<swarm-ip>:9090`
* grafana (visualize metrics) `http://<swarm-ip>:3000`
* node-exporter (host metrics collector)
* cadvisor (containers metrics collector)
* dockerd-exporter (Docker daemon metrics collector, requires Docker experimental metrics-addr to be enabled)
* alertmanager (alerts dispatcher) `http://<swarm-ip>:9093`
* unsee (alert manager dashboard) `http://<swarm-ip>:9094`
* caddy (reverse proxy and basic auth provider for prometheus, alertmanager and unsee)
* NUPIC API for collecting Observation
* Swarm-API for traning NUPIC Anomaly Detection Service 
* MDP Agent Implemented in Open gym


## Setup Grafana

Navigate to `http://<swarm-ip>:3000` and login with user ***admin*** password ***admin***. 
You can change the credentials in the compose file or 
by supplying the `ADMIN_USER` and `ADMIN_PASSWORD` environment variables at stack deploy.

Swarmprom Grafana is preconfigured with two dashboards and Prometheus as the default data source:

* Name: Prometheus
* Type: Prometheus
* Url: http://prometheus:9090
* Access: proxy

After you login, click on the home drop down, in the left upper corner and you'll see the dashboards there.

***Docker Swarm Nodes Dashboard***

![Nodes](https://snapshot.raintank.io/dashboard/snapshot/SyKQ96o2JWfuVyc43hcGgAI9YLcjk3mW?orgId=2)

URL: `http://<swarm-ip>:3000/dashboard/db/docker-swarm-nodes`

This dashboard shows key metrics for monitoring the resource usage of your Swarm nodes and can be filtered by node ID:

* Cluster up-time, number of nodes, number of CPUs, CPU idle gauge
* System load average graph, CPU usage graph by node
* Total memory, available memory gouge, total disk space and available storage gouge
* Memory usage graph by node (used and cached)
* I/O usage graph (read and write Bps)
* IOPS usage (read and write operation per second) and CPU IOWait
* Running containers graph by Swarm service and node
* Network usage graph (inbound Bps, outbound Bps)
* Nodes list (instance, node ID, node name)

***Docker Swarm Services Dashboard***

![Nodes](https://snapshot.raintank.io/dashboard/snapshot/SyKQ96o2JWfuVyc43hcGgAI9YLcjk3mW?orgId=2)

URL: `http://<swarm-ip>:3000/dashboard/db/docker-swarm-services`

This dashboard shows key metrics for monitoring the resource usage of your Swarm stacks and services, can be filtered by node ID:

* Number of nodes, stacks, services and running container
* Swarm tasks graph by service name
* Health check graph (total health checks and failed checks)
* CPU usage graph by service and by container (top 10)
* Memory usage graph by service and by container (top 10)
* Network usage graph by service (received and transmitted)
* Cluster network traffic and IOPS graphs
* Docker engine container and network actions by node
* Docker engine list (version, node id, OS, kernel, graph driver)

***Prometheus Stats Dashboard***

![Nodes](https://raw.githubusercontent.com/stefanprodan/swarmprom/master/grafana/screens/swarmprom-prometheus-dash-v3.png)

URL: `http://<swarm-ip>:3000/dashboard/db/prometheus`

* Uptime, local storage memory chunks and series
* CPU usage graph
* Memory usage graph
* Chunks to persist and persistence urgency graphs
* Chunks ops and checkpoint duration graphs
* Target scrapes, rule evaluation duration, samples ingested rate and scrape duration graphs
 
## Monitoring production systems

The swarmprom project is meant as a starting point in developing your own monitoring solution. Before running this 
in production you should consider building and publishing your own Prometheus, node exporter and alert manager 
images. Docker Swarm doesn't play well with locally built images, the first step would be to setup a secure Docker 
registry that your Swarm has access to and push the images there. Your CI system should assign version tags to each 
image. Don't rely on the latest tag for continuous deployments, Prometheus will soon reach v2 and the data store 
will not be backwards compatible with v1.x.    

Another thing you should consider is having redundancy for Prometheus and alert manager. 
You could run them as a service with two replicas pinned on different nodes, or even better, 
use a service like Weave Cloud Cortex to ship your metrics outside of your current setup. 
You can use Weave Cloud not only as a backup of your 
metrics database but you can also define alerts and use it as a data source for your Grafana dashboards. 
Having the alerting and monitoring system hosted on a different platform other than your production 
is good practice that will allow you to react quickly and efficiently when a major disaster strikes. 

Swarmprom comes with built-in [Weave Cloud](https://www.weave.works/product/cloud/) integration, 
what you need to do is run the weave-compose stack with your Weave service token:

```bash
TOKEN=<WEAVE-TOKEN> \
ADMIN_USER=admin \
ADMIN_PASSWORD=admin \
docker stack deploy -c weave-compose.yml mon
```

This will deploy Weave Scope and Prometheus with Weave Cortex as remote write. 
The local retention is set to 24h so even if your internet connection drops you'll not lose data 
as Prometheus will retry pushing data to Weave Cloud when the connection is up again.

You can define alerts and notifications routes in Weave Cloud in the same way you would do with alert manager.

To use Grafana with Weave Cloud you have to reconfigure the Prometheus data source like this:

* Name: Prometheus
* Type: Prometheus
* Url: https://cloud.weave.works/api/prom
* Access: proxy
* Basic auth: use your service token as password, the user value is ignored

Weave Scope automatically generates a map of your application, enabling you to intuitively understand, 
monitor, and control your microservices based application. 
You can view metrics, tags and metadata of the running processes, containers and hosts. 
Scope offers remote access to the Swarm’s nods and containers, making it easy to diagnose issues in real-time.

![Scope](https://raw.githubusercontent.com/stefanprodan/swarmprom/master/grafana/screens/weave-scope.png)

![Scope Hosts](https://raw.githubusercontent.com/stefanprodan/swarmprom/master/grafana/screens/weave-scope-hosts-v2.png)


# ieee-demo
