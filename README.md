<h1>cardinal-docker</h1>

<h3>Summary</h3>

cardinal-docker is the official implementation of Cardinal inside a containerized environment. cardinal-docker 
leverages `docker-compose` in order to create a pod-like deployment of Cardinal. NGINX/uWSGI/Cardinal services operate
in one container, while MariaDB operates in another.

<h3>How Cardinal is Built</h3>

The `Dockerfile` provided will build Cardinal using the latest source code from the Cardinal repo. Cardinal
is configured to run inside an Ubuntu 20.04 environment. Many aspects of the Cardinal environment can be 
customized by updating the `docker-compose.yml` file. By default, the Cardinal environment is ephemeral. There
are no volume bindings that allow MariaDB to save outside the environment. If you wish to persist the configuration of Cardinal,
please look into volume bindings with `docker-compose`. You can reference this [link](https://docs.docker.com/storage/volumes/) for more
information.

<h3>Running Cardinal with Docker</h3>

Before running Cardinal, please make sure Docker and `docker-compose` are installed on the host system. For more information on installing Docker, 
please reference this [link](https://docs.docker.com/install/).

Once you have `docker-compose` installed, running Cardinal is as simple as running the following from the root directory:

~~~
docker-compose build
docker-compose up
~~~

By default, the Cardinal UI is served on HTTP (i.e. `80/tcp`) and bound to port 1000 on the host. You can change which port Cardinal binds
to on the host by updating `docker-compose.yml`.

If you have any difficulties during the build process or need further clarification, please open an issue report in the cardinal-docker GitHub
repository.