# Airflow on Clever Cloud

# Setup

## Add-ons

On Clever Cloud, go to Create -> an add-on -> PostgreSQL -> DEV. Enter a name and you are ready for the database.

Then create a Redis add-on, go to Create -> an add-on -> Redis -> S. Enter a name and your Redis is going to be ready in a few seconds.

Finally, in order to ease the configuration management, go to Create -> an add-on -> Configuration Management -> Standard. Enter a name and your Configuration is going to be ready in a few seconds.

Once these 3 addons are ready, go to the configuration management add-on, and add the 2 following lines:

```
AIRFLOW_EXECUTOR=CeleryExecutor
# BROKER_URL is the URL of your Redis + /0 at the end.
BROKER_URL=redis://:lorem@ipsum-redis.services.clever-cloud.com:3780/0
CC_PYTHON_VERSION=3.9
CC_POST_BUILD_HOOK=npm run build
```

## Webserver and DB Migration

Go to Create -> an application -> select your GitHub repo -> NodeJS -> Select the instance size (XS is ok) -> enter the name and the description and click on create. Click on I don't need any addons. Then you can define your environment variables.

You need to add the following environment variable:

```
CC_RUN_COMMAND="npm run webserver"
```

Then you need to link the 3 previous services:
* PostgreSQL
* Redis
* Configuration management

Then you want to copy all environment variables from the webserver locally.
You can use the CLI for this : `clever env --add-export > .env`

Once it's done, we want to prepare the database. Run the following command on your host:

```
export .env && bash run.sh db upgrade
```

When it's done, relaunch the deployment of the web server, and it should work!

## Admin user

Now you have your Airflow Webserver ready, but you want to have access to it. Very simple:

```
bash run.sh users create \
--username admin \
--firstname Peter \
--lastname Parker \
--role Admin \
--email spiderman@superhero.org
```

## Scheduler

Once the webserver is up, we want to deploy the scheduler. As the scheduler does not have a web interface, we are going to cheat: we are going to launch a dummy python on port 8080 and launch the scheduler as a CC_WORKER.

Go to Create -> an application -> select your GitHub repo -> NodeJS -> Select the instance size (XS is ok) -> enter the name and the description and click on create. Click on I don't need any addons. Then you can define your environment variables.

You need to add the following environment variable:

```
CC_RUN_COMMAND="npm run http"
CC_WORKER_COMMAND="npm run scheduler"
```

Then you need to link the 4 previous services:
* PostgreSQL
* Redis
* Configuration management
* ElasticSearch

## Worker

Once the webserver is up, we want to deploy the scheduler. As the scheduler does not have a web interface, we are going to cheat: we are going to launch a dummy python on port 8080 and launch the scheduler as a CC_WORKER.

Go to Create -> an application -> select your GitHub repo -> NodeJS -> Select the instance size (S is ok) -> enter the name and the description and click on create. Click on I don't need any addons. Then you can define your environment variables.

You need to add the following environment variable:

```
CC_RUN_COMMAND="npm run http"
CC_WORKER_COMMAND="npm run worker"
```

Then you need to link the 4 previous services:
* PostgreSQL
* Redis
* Configuration management
* ElasticSearch
