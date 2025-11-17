# Databricks-workspace-environments-setup-Unity-Catalog-Integrated


### Purpose

#### This repo contains (azure-cli and databricks-cli) scripts to create one (unity catalog) metastore and: create one development (dev), one test (test) and one production (prod) databricks workpace, with associated catalogs to be integrated into it (the unity catalog metastore), all within one azure subscription.  This repo assumes that this user has an azure subscription and a linux environment (linux machine, mac machine, or Windows Susbsytem for Linux (WSL)) that uses a bash shell.

#### I created this repo so that I could quickly setup and teardown unity catalog integrated databricks workspaces, so that I could reduce cost while using premium databricks workspaces for training purposes.  I started with wanting to deploy code to simulate Software Development Lifecycle (SDLC) Continuous Integration and Continuous Deployment (CI/CD); this repo does not mimic SDLC CI/CD.  It is conceivable that this repo could be morphed to satisfy enterprise-level purposes.

#### One way to validate that these scripts have worked, is try to create a table from a *.csv file into a catalog.schema
#### If you are in any of the newly-created workspaces, you can maneuver into the databricks account (accounts.azuredatabricks.net), by clicking the search workspaces drop-down at the top-right in Catalog Explorer (next to your account profile), and you can click "Manage Account".  There you can maneuver into Catalog, and you can see a list of metastores.  If you drill into one of them (there should only be one from this repo), you can see in the "Configuration" and "Workspaces" tabs, that the metastore has been created and the workspace(s) has/(have) been integrated into Unity Catalog

### Lessons learned

1. Trial versions, standard versions, and Community Editions do not support integration into unity catalog metastores
2. "unity catalog" is a "logical" concept, "catalogs" and "metastores" are "physical" concepts (in my honest opinion). "catalogs" are "baskets" (figurative term, not a technical term), where permissions and pointers to "things" (figurative term) reside.
3. 
    a. you can only have one metastore per region. each workspace is enabled for unity catalog when it is created, but it is not integrated with a (unity catalog) metastore. the newly-created workspace provides this enabling by nature of creating a storage account and a unity catalog databricks access connector within its managed resource group.  

    b. each workspace has its own resource group. this makes it difficult, but not impossible, to integrate all databricks workspaces, within the same region, to the same one unity catalog metastore. I chose to create a custom storage account and a unique custom databricks access connector (and permission it to the storage account), and binding a (custom-created) unity catalog metastore to it.  There might be ways to associate all databricks workspaces to the same managed resource group.  I would imagine that this strategy would make vnet-injection difficult, but quite frankly, I would not know, because I have not tried it.
4. You can still create MANAGED catalogs along an external file location. the scripts will do this.  anyone can prove/disprove this assertion by typing "show catalog <<catalog_name>> extended" in any %sql notebook command cell and executing it.
5. All (workspace) catalogs that are integrated into unity catalog, by default, will be visible in all workspaces that are integrated into unity catalog.
6. Clusters must be all-purpose or job clusters with the correct policy setting enabled (Advanced tab), or they will not be able to be integrated with unity catalog. Access mode (Advanced dropdown, towards the bottom of Compute configuration), must be Manual, and either:

    a. Standard (formerly: Shared) -- for All-purpose clusters
       --- or ---
    b. Dedicated (formerly: Single User) -- for job clusters

### setup instructions

#### 1. Ensure that you have the following installed and configured:
#### a. Python installed on your machine. Must be compatable with the version of Databricks Runtime that you will be using; see Databricks release notes: (https://learn.microsoft.com/en-us/azure/databricks/release-notes/runtime/) . This repo will be creating clusters for Databricks Runtime 15.4. Python 3.11 is compatible with Databricks Runtime 15.4 .
#### b. Git installed and configured on your machine (https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) .
#### c. Visual Studio Code installed on your machine (https://code.visualstudio.com/docs/setup/setup-overview). Once in VS Code, must have the Python marketplace extension from Microsoft.
#### d. Perform a git clone ... from this repo. 
#### Note: For steps 2-5 below, you do only need to perform those steps if you are loading the files into a standalone git clone and associated Python environment.  For the more noviced users, it is recommended that you do clone this repo into a local standalone repo and python environment (and perform steps 2-5 as a results).
#### 2. python3 -m venv .venv
#### 3. source .venv/bin/activate
#### 4. Open the Command Pallete (Cntrl+Shift+P), select "Python: Select interpreter", and set the .venv as your interpreter
#### 5. pip3 install -r requirements.txt
#### 6. chmod +x -R ./setup_teardown
#### 7. cd setup_teardown/ # this will be your working directory for all script runs. ENSURE that you cd into this directory EVERY TIME you start a NEW BASH session
#### 8. run az login. pick the subscription for creating your metastore and workspaces.
#### 9. configure and run your scripts of choice, as conveyed below:


#### The ./setup_teardown directory contains several azure-cli and databricks-cli bash scripts to:

#### a. setup and permission the (unity catalog) metastore to accommodate several workspaces and catalogs
#### b. create a workspace for each environment (dev, test and prod), and integrate them into the one unity catalog
#### c. create a MANAGED catalog for each workspace (residing within an external file locates), and integrate them into the (unity catalog) metastore
#### d. create a small All-purpose cluster for each workspace

#### The ./setup_teardown/teardown directories can scripts to destroy assets.


#### At the time of this writing, there is no setting of export variables st s high-lrvrl, that cascade their way into child scripts .  Unfortunately, the user will need to drill into the child scripts and set the appropriate values for export variables, such as:

##### WORKSPACE_NAME="databricks-dev"
##### RESOURCE_GROUP="rg-databricks-dev"
##### MANAGED_RESOURCE_GROUP="rg-databricks-dev-managed"
##### LOCATION="southcentralus"
##### DEFAULT_CATALOG_NAME="catalog-dev"
##### CATALOG_NAME="catalog-dev"

##### CREDENTIAL_NAME="databricks-access-connector-credential"
##### EXTERNAL_LOCATION_NAME="databricks-access-connector-location"

#### Perhaps at some future version of this repo, the existing scripts will be better abstracted such that there will be one-and-only-one place to update export variable values.


#### Here are the parent-level directories and scripts:

#### 01_create-databricks-dev-assets.sh   --# creates all dev environment assets to include creating the unity catalog metastore,creating and integrating a dev workspace with a cluster and an externally-located MANAGED database
#### 02_create-databricks-test-assets.sh  --# creates all test environment assets by creating and integrating a test workspace with a cluster and an externally-located MANAGED database
#### 03_create-databricks-prod-assets.sh  --# creates all test environment assets by creating and integrating a test workspace with a cluster and an externally-located MANAGED database

#### ./teardown # is a directory of teardown scripts for all of the above

#### 00_delete-all.sh
#### 01a_delete-metastore-and-resource-group.sh
#### 01b_delete-databricks-dev.sh
#### 02_delete-databricks-test.sh
#### 03_delete-databricks-prod.sh

#### The following are the nested child directories reference by the above (parent(s)).  they also have teardown directories within them. the child directories create/destroy assets for dev, test and prod environments. can be run individually if needed.

#### 01_metastore_storage --# creates and permissions the storage for the metastore. is designed to accommodate integration of more than on workspace.
#### 02_workspaces --# creates and permissions the workspaces, and builds the .databrickscfg profiles for the workspaces by logging in with azure-cli (az login)
#### 03_metastore --# creates the metastore associates the dev workspace to it, and creates one storage credential and one external location to be used by managed databases in any workspace associated with unity catalog
#### 04_metastore_catalogs --# creates catalogs for the workspaces for the environments  
#### 05_clusters --# creates small default All-Purpose clusters for the workspaces

#### ./01_metastore_storage:

#### storage-account.sh --# creates the and permissions the unity catalog metastore storage account using a databricks access connector to be used by the workspace for each environment (dev, test and prod). integration into the unity catalog metastore will occur after the first databricks workspace (dev) is created.

#### ./01_metastore_storage/teardown:

#### delete-metastore-and-resource-group.sh --# destroys the metastore, databricks access connector and storage account by destroying the resource groups.


#### ./02_workspaces:

#### 01_databricks-dev.sh --# creates the dev workspace and associates an az login profile for it (DEFAULT)
#### 02_databricks-test.sh --# creates the test workspace and associates an az login profile for it (test)
#### 03_databricks-prod.sh --# creates the prod workspace and associates an az login profile for it (prod)


#### ./02_workspaces/teardown:

#### delete-databricks-dev.sh --# destroys the dev workspace by destroying its resource group
#### delete-databricks-prod.sh --# destroys the prod workspace by destroying its resource group
#### delete-databricks-test.sh --# destroys the test workspace by destroying its resource group

#### ./03_metastore:

#### create-metastore.sh --# creates the (unity catalog) metastore, associates the dev workspace to it, and creates a file credential and external location to be shared later my MANAGED catalogs for the workspace for each environment. 

#### ./03_metastore/teardown:

#### delete-metatore.sh --# deletes the metastore

#### ./04_metastore_catalogs:

#### 01_catalog-dev.sh --# creates a dev catalog for the metastore
#### 02_catalog-test.sh --# creates a test catalog for the metastore
#### 03_catalog-prod.sh --# creates a prod catalog for the metastore

#### ./04_metastore_catalogs/teardown:

#### delete-catalog-dev.sh --# forces a delete for the dev catalog
#### delete-catalog-prod.sh --# forces a delete for the prod catalog
#### delete-catalog-test.sh --# forces a delete for the test catalog


#### ./05_clusters:

#### 01_create-cluster-dev.sh --# creates a small, All-purpose cluster for dev 
#### 02_create-cluster-test.sh --# creates a small, All-purpose cluster for test 
#### 03_create-cluster-prod.sh --# creates a small, All-purpose cluster for prod 
#### my_cluster.json  --# serves as the cluster configuration for a small General Purpose cluster of Databricks Runtime 15.4

#### Note: there is no teardown directory for clusters.  Clusters will be destroyed (not just terminated), when the workspaces are 

### Lessons to learn
1. make the scripts more abstract and dynamic by configuring the variables only once at the top level. this will likely entail joining os.path's and catching variable values via sys.argv[] ...