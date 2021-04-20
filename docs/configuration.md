# Configuration

This module tries as much as possible to minimise the amount of configuration
required. For local installations where there is no requirement to synchronise
data with remote installations, no configuration is necessary. In cases where
remote synchronisation is required, it utilises the same technology and
configuration used by LIMS. When triggered to start remote synchronisation
operations, the module will attempt to find a configuration file in various
LIMS installation directories. Thus in an environment where LIMS is/was
functional, this module will require zero configuration. It will use the
existing LIMS' configuration file. The search for a configuration file goes
as follows:

    1. ~/apps/nlims_controller/config/couchdb.yml
    2. /var/www/nlims_controller/config/couchdb.yml
    3. ../nlims_controller/config/couchdb.yml
    4. config/lims-couch.yml
  
First the module looks for a LIMS' CouchDB configuration in the apps
directory that's located in the current user's home directory (ie
user the app runs as). If not found then it goes to `/var/www` and
looks for a LIMS installation, and so on. The last place it looks for
a configuration is the HIS-EMR-API config's directory. It looks for
a file named lims-couch.yml which is just a copy of the LIM's couchdb.yml.

## Structure of the configuration file

The CouchDB configuration file for LIMS comes as a [YAML](https://yaml.org)
file of the following structure (NOTE: the indentation matters):

  ```yaml
  development: &development
    protocol: 'http'
    host: localhost
    port: 5984
    prefix: nlims
    suffix: repo
    username: user
    password: password
  test:
    <<: *development
    suffix: test
  production:
    <<: *development
    protocol: 'http'
  ```

The file has three sections, development, test, and production. These
correspond to various deployment environments. The parameters that fall
under production apply to the production environment, similarly test
and development's parameters apply to the test and development environments.
Sections can inherit parameters from other sections by using the special <<:
parameter, for example, in the configuration above: test and production
inherit from the development environment.

The configuration parameters are the same across alls sections, thus the
following will describe the parameters that are appearing in the development
section of the example configuration above.

1. `protocol`

   This is the protocol the CouchDB server is running on: Valid values are
   http and https

2. `host`

   This is the ip address of the machine the target CouchDB instance is running
   on

3. `port`

   Normally CouchDB runs on port 5984, but if that port was changed to something
   else then this must be updated to that

4. `prefix`

   LIMS's database names are structured as prefix_order_suffix. This parameter
   just specifies the prefix of the database name

5. `suffix`

   See `prefix` above, this is the suffix of the target database name

6. `username`
   
   This is the CouchDB user username

7. `password`

   Accompanies the username above
