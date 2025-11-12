# Databricks-workspace-environments-setup-Unity-Catalog-Integrated


### Purpose

### Lessons learned

### setup instructions

1. python3 -m venv .venv
2. source .venv/bin/activate
3. open the Command Pallete, select Python: Select interpreter, and set the .venv as your interpreter
4. pip3 install -r requirements.txt

The following assumes that you already have a metastore established. it is assumed that you only have one metastore created, and it is true that you can only have one metastore per region

several  *.sh scripts will be run to create your azure environments and the resources within them.  you may need to chmod +x for several of them, to be able to run them.

5. run az login

6. for each of of the databricks-<<envrionment>>.sh scripts that will establish your databricks workspaces, will assign them to a metastore, and will create a cluster, alter the variables on lines 4-12, but let SKU remain set to SKU="premium".

7. run each of the databricks-<<envrionment>>.sh for which you want to create databricks workspaces