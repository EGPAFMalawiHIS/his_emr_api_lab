# Configuration

This module tries as much as possible to minimise the amount of configuration
required. For local installations where there is no requirement to synchronise
data with remote installations, no configuration is necessary. In cases where
remote synchronisation is required, there are two ways to go about it:

   1. Configure the application to use LIMS' API and optionally use LIMS' results
      update channel for realtime results updates
   2. Configure the application to attach to LIMS' message queue (ie CouchDB)

## 1. LIMS API integration

This makes use of EMR-API's `config/application.yml` and it's the recommended setup.
The Lab module extends the configuration file with a few parameters of its own.
Below is a list of the parameters added and what they do:

<table>
   <thead>
      <th>Field</th>
      <th>Description</th>
   </thead>
   <tbody>
      <tr>
         <td>lims_protocol</td>
         <td>
            The <a href="https://en.wikipedia.org/wiki/OSI_model#Layer_7:_Application_Layer">
            layer 7 protocol</a> the LIMS API is using. Valid values are <em>http</em>
            and <em>https</em>
         </td>
      </tr>
      <tr>
         <td>lims_host</td>
         <td>IP address or domain of the machine hosting the LIMS API server</td>
      </tr>
      <tr>
         <td>lims_port</td>
         <td>Port on the host machine the LIMS API server is exposed on</td>
      </tr>
      <tr>
         <td>lims_username</td>
         <td>Username used by this application to authenticate with LIMS</td>
      </tr>
      <tr>
         <td>lims_password</td>
         <td>Password used by this application to authenticate with LIMS</td>
      </tr>
      <tr>
         <td>lims_prefix</td>
         <td>LIMS API version, setting it to <em>api/v1</em> should be fine</td>
      </tr>
      <tr>
         <td>lims_realtime_updates_url</td>
         <td>
            An optional field that when specified enables receipt of results from LIMS
            in realtime. The value of this is a URL to a web socket exposed by LIMS
            for updates.
         </td>
      </tr>
   </tbody>
</table>

The following is an example configuration:

```YAML
# LIMS Configuration
lims_protocol: http
lims_host: lims.hismalawi.org
lims_port: 80
lims_prefix: api/v1
lims_username: emr_api
lims_password: caput-draconis
lims_realtime_updates: lims.hismalawi.org:8000
```

## 2. LIMS's Message Queue

This was the original implementation, it's no longer recommended. In setups
where the EMR API application is installed on the same machine as the local
LIMS proxy, no configuration is required. LIMS' configurations will be read
and used. The following is the search path for a configuration file:

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

### Structure of the configuration file

The CouchDB configuration file for LIMS comes as a [YAML](https://yaml.org)
file of the following structure (NOTE: the indentation matters):

  ```yaml
  development: &development
    protocol: 'http'
    host: localhost
    port: 5984
    prefix: nlims
    suffix: repo
    username: admin
    password: caput-draconis
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

<table>
   <thead>
      <th>Field</th>
      <th>Description</th>
   </thead>
   <tbody>
      <tr>
         <td>protocol</td>
         <td>
            This is the protocol the CouchDB server is running on: Valid values
            are http and https
         </td>
      </tr>
      <tr>
         <td>host</td>
         <td>
            This is the ip address of the machine the target CouchDB instance is running on
         </td>
      </tr>
      <tr>
         <td>port</td>
         <td>
            Normally CouchDB runs on port 5984, but if that port was changed to something
            else then this must be updated to that
         </td>
      </tr>
      <tr>
         <td>prefix</td>
         <td>
            LIMS's database names are structured as prefix_order_suffix. This parameter
            just specifies the prefix of the database name
         </td>
      </tr>
      <tr>
         <td>suffix</td>
         <td>See prefix above, this is the suffix of the target database name</td>
      </tr>
      <tr>
         <td>username</td>
         <td>This is the CouchDB user username</td> 
      </tr>
      <tr>
         <td>password</td>
         <td>Accompanies the username above</td>
      </tr>
   </tbody>
</table>
