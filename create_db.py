import json
import os
import sys
import logging.config
import traceback

import psycopg2
from psycopg2 import pool

abspath = os.path.abspath(os.path.dirname(__file__))
util = abspath + '/util'
sys.path.append(abspath)

log_conf = abspath + '/logging-conf.json'
with open(log_conf, 'r') as logging_configuration_file:
    config_dict = json.load(logging_configuration_file)

logging.config.dictConfig(config_dict)

# Log that the logger was configured
logger = logging.getLogger(__name__)
logger.info('Completed configuring logger()!')

import util.config_reader

cadre_meta_connection_pool = pool.SimpleConnectionPool(1,
                                                20,
                                                host=util.config_reader.get_cadre_db_hostname(),
                                                database=util.config_reader.get_cadre_db_name(),
                                                user=util.config_reader.get_cadre_db_username(),
                                                password=util.config_reader.get_cadre_db_pwd(),
                                                port=util.config_reader.get_cadre_db_port())

if cadre_meta_connection_pool:
    logger.info("Connection pool for cadre meta database created successfully")

if __name__ == '__main__':
    try:
        connection = cadre_meta_connection_pool.getconn()
        with connection.cursor() as cursor:
            cursor.execute(open("cadre-metadatabase.sql", "r").read())
        connection.commit()
    except (Exception, psycopg2.Error) as error:
        traceback.print_tb(error.__traceback__)
        logger.error('Error while connecting to cadre meta database. Error is ' + str(error))
    finally:
        # Closing database connection.
        cursor.close()
        # Use this method to release the connection object and send back ti connection pool
        cadre_meta_connection_pool.putconn(connection)
        print("PostgreSQL connection pool is closed")
