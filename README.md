## **Multi-Server Installation Guide**

---

### *Prerequisites*

For a Windows system, Windows Subsystem for Linux must be installed, preferably with Ubuntu.

However, MacOS Homebrew, apt, yum, and snap are all supported package managers.


> [!IMPORTANT]
> The following packages must be installed on the system:

- ansible
- jq

The provided script: `kasm_dependencies.sh` will verify the required packages and attempt to install using supported package managers.

Modify permissions to set the `kasm_dependencies.sh` to be executable.

```sh
chmod +x kasm_dependencies && ./kasm_dependencies.sh
```

The Kasm installer needs to be downloaded and placed in the right location.

- Navigate to [https://www.kasmweb.com/downloads.html](https://www.kasmweb.com/downloads.html) and download the latest version as a `tar.gz`
  - Make sure the name has no additions to it by the operating system.
- Place the `tar.gz` file in the directory `roles/install_common/files/kasm_release_{version}.tar.gz`.


### *Requirement - Deploying with a remote database*

In order to deploy using this playbook a dedicated external database must already exist.

To properly init the database you will need to supply endpoint, superuser credentials, along with the credentials the application will use to access it within the `inventory`

Set the relevant credentials and endpoints:

```
    ## PostgreSQL settings ##
    ##############################################
    # PostgreSQL remote DB connection parameters #
    ##############################################
    # The following parameters need to be set only once on database initialization
    init_remote_db: true #verify set to false post installation
    database_master_user: postgres
    database_master_password: PASSWORD
    database_hostname: DATABASE_HOSTNAME
    # The remaining variables can be modified to suite your needs or left as is in a normal deployment
    database_user: kasmapp
    database_name: kasm
    database_port: 5432
    database_ssl: true
    ## redis settings ##
    # redis connection parameters if hostname is set the web role will use a remote redis server
    redis_hostname: REDIS_HOSTNAME
```

---


<details><summary>
1. Launching Dashboard</summary>

</details>

The script is now ready to run. You may run the command `chmod +x *.sh` in the root directory of the project and then run `main.sh`, or you may run the following command (preferred):

```sh
chmod +x main.sh && ./main.sh
```

The script will first check for the prerequisite dependencies, and will then initialize the dashboard, which will give the menu options:

```
Menu
1. Install Kasm
2. Start Kasm
3. Stop Kasm
4. Restart Kasm
5. Update Kasm
6. Uninstall Kasm
7. Exit
```

These menu options will be discussed as the guide continues. For now, note that only the number should be put in the input field (no extra spaces behind or ahead), and #7 is to exit.

***


<details><summary>1. Installation of Kasm</summary>
test
</details>

***



```
Note: During the installation, `.txt` files will appear. It is recommended that they stay on the system, as some parts of the system may use them even after installation.
```


2. Option 1 - Install Kasm:

Option 1 on the Menu or `ansible-playbook -i inventory install_kasm.yml`


**Post deployment if the `install_kasm.yml` needs to be run again to make scaling changes it is important to set `init_remote_db: false` this should happen automatically but best to check**

### Deploying a Dedicated Kasm Proxy

1. Before deployment or while scaling open `inventory` and uncomment/add the relevant lines for :

```
        # Optional Web Proxy server
        #zone1_proxy:
          #hosts:
            #zone1_proxy_1:
              #ansible_host: zone1_proxy_hostname
              #ansible_port: 22
              #ansible_ssh_user: ubuntu
              #ansible_ssh_private_key_file: ~/.ssh/id_rsa
```

2. Post deployment follow the instructions [here](https://www.kasmweb.com/docs/latest/install/multi_server_install/multi_installation_proxy.html#post-install-configuration) to configure the proxy for use.

**It is important to use a DNS endpoint for the `web` and `proxy` role as during deployment the CORS settings will be linked to that domain**

## 3. Option 2 - Start Kasm

If the Kasm network was stopped before, or is inactive, you may start it with option 2.

For more specific start commands:

Start Kasm Workspaces (start_kasm.yml)- This will start all hosts defined in inventory or optionally be limited to a zone, group or single server passing the `--limit` flag. Example Usage `ansible-playbook -i inventory --limit zone1_agent_1 start_kasm.yml`

## 4. Option 3 -  Stop Kasm

To stop the Kasm network, and take it offline, you may do so with option 3.

For more specific stop commands:

Stop Kasm Workspaces (stop_kasm.yml)- This will stop all hosts defined in inventory or optionally be limited to a zone, group or single server passing the `--limit` flag. Example Usage `ansible-playbook -i inventory --limit zone1_agent_1 stop_kasm.yml`

## 5. Option 4 - Restart Kasm

To stop and restart the Kasm network, you may do so with option 4.

For more specific restart commands:

Restart Kasm Workspaces (restart_kasm.yml)- This will restart all hosts defined in inventory or optionally be limited to a zone, group or single server passing the `--limit` flag. Example Usage `ansible-playbook -i inventory --limit zone1_agent_1 restart_kasm.yml`

## 6. Option 5 - Update Kasm

This will update the Kasm framework on the hosts using the install feature.

## 7. Option 6 - Uninstall Kasm

Uninstalls the Kasm workspace off of the images, but leaves the images intact.

## EXTRA Commands/All Helper Playbooks

* Uninstall Kasm Workspaces (uninstall_kasm.yml)- This will completely purge your Kasm Workspaces installation on all hosts, if using a remote database that data will stay intact no remote queries will be executed. Example Usage: `ansible-playbook -i inventory uninstall_kasm.yml`
* Stop Kasm Workspaces (stop_kasm.yml)- This will stop all hosts defined in inventory or optionally be limited to a zone, group or single server passing the `--limit` flag. Example Usage `ansible-playbook -i inventory --limit zone1_agent_1 stop_kasm.yml`
* Start Kasm Workspaces (start_kasm.yml)- This will start all hosts defined in inventory or optionally be limited to a zone, group or single server passing the `--limit` flag. Example Usage `ansible-playbook -i inventory --limit zone1_agent_1 start_kasm.yml`
* Restart Kasm Workspaces (restart_kasm.yml)- This will restart all hosts defined in inventory or optionally be limited to a zone, group or single server passing the `--limit` flag. Example Usage `ansible-playbook -i inventory --limit zone1_agent_1 restart_kasm.yml`
* OS Patching (patch_os.yml)- This will update system packages and reboot on all hosts defined in inventory or optionally be limited to a zone, group or single server passing the `--limit` flag. Example Usage `ansible-playbook -i inventory --limit zone1_agent_1 patch_os.yml`

#### Recover Credentials

If for any reason you have misplaced your inventory file post installation credentials for the installation can be recovered using:

- Existing Database password can be obtained by logging into a web app host and running the following command:

```
sudo grep " password" /opt/kasm/current/conf/app/api.app.config.yaml
```

- Existing Redis password can be obtained by logging into a web app host and running the following command:

```
sudo grep "redis_password" /opt/kasm/current/conf/app/api.app.config.yaml
```

- Existing Manager token can be obtained by logging into an agent host and running the following command:

```
sudo grep "token" /opt/kasm/current/conf/app/agent.app.config.yaml
```

### Scaling the deployment

The installation can be "scaled up" after being installed by adding any additional hosts including entire new zones. Make any necessary changes to `inventory` and run:

Option 1 on the Menu or `ansible-playbook -i inventory install_kasm.yml`

Before running the installation against a modified inventory file please ensure the credentials lines in your inventory were set and uncommented properly by the initial deployment IE. If installed through the menu, they should already be replaced.

```
    ## Credentials ##
    # If left commented secure passwords will be generated during the installation and substituted in upon completion
    user_password: PASSWORD
    admin_password: PASSWORD
    database_password: PASSWORD
    redis_password: PASSWORD
    manager_token: PASSWORD
    registration_token: PASSWORD
```

#### Scaling examples

Example of adding more Docker Agents:

```
        zone1_agent:
          hosts:
            zone1_agent_1:
              ansible_host: zone1_agent_hostname
              ansible_port: 22
              ansible_ssh_user: ubuntu
              ansible_ssh_private_key_file: ~/.ssh/id_rsa
            zone1_agent_2:
              ansible_host: zone1_agent2_hostname
              ansible_port: 22
              ansible_ssh_user: ubuntu
              ansible_ssh_private_key_file: ~/.ssh/id_rsa
```

If you would like to scale up web/agent/guac/proxy servers as a group where the agent/guac/proxy server talk exclusively to that web server set `default_web: false` in your inventory file. This requires entries with a matching integer for all hosts IE:

```
        zone1_web:
          hosts:
            zone1_web_1:
              ansible_host: zone1_web_hostname
              ansible_port: 22
              ansible_ssh_user: ubuntu
              ansible_ssh_private_key_file: ~/.ssh/id_rsa
            zone1_web_2:
              ansible_host: zone1_web2_hostname
              ansible_port: 22
              ansible_ssh_user: ubuntu
              ansible_ssh_private_key_file: ~/.ssh/id_rsa
        zone1_agent:
          hosts:
            zone1_agent_1:
              ansible_host: zone1_agent_hostname
              ansible_port: 22
              ansible_ssh_user: ubuntu
              ansible_ssh_private_key_file: ~/.ssh/id_rsa
            zone1_agent_2:
              ansible_host: zone1_agent2_hostname
              ansible_port: 22
              ansible_ssh_user: ubuntu
              ansible_ssh_private_key_file: ~/.ssh/id_rsa
        zone1_guac:
          hosts:
            zone1_guac_1:
              ansible_host: zone1_guac_hostname
              ansible_port: 22
              ansible_ssh_user: ubuntu
              ansible_ssh_private_key_file: ~/.ssh/id_rsa
          hosts:
            zone1_guac_2:
              ansible_host: zone1_guac2_hostname
              ansible_port: 22
              ansible_ssh_user: ubuntu
              ansible_ssh_private_key_file: ~/.ssh/id_rsa
```

Included in inventory is a commented section laying out a second zone. The names zone1 and zone2 were chosen arbitrarily and can be modified to suite your needs, but all items need to follow that naming pattern IE:

```
    # Second zone
    # Optionally modify names to reference zone location IE west
    west:
      children:
        west_web:
          hosts:
            west_web_1:
              ansible_host: HOST_OR_IP
              ansible_port: 22
              ansible_ssh_user: ubuntu
              ansible_ssh_private_key_file: ~/.ssh/id_rsa
        west_agent:
          hosts:
            west_agent_1:
              ansible_host: HOST_OR_IP
              ansible_port: 22
              ansible_ssh_user: ubuntu
              ansible_ssh_private_key_file: ~/.ssh/id_rsa
        west_guac:
          hosts:
            west_guac_1:
              ansible_host: HOST_OR_IP
              ansible_port: 22
              ansible_ssh_user: ubuntu
              ansible_ssh_private_key_file: ~/.ssh/id_rsa

  vars:
    zones:
      - zone1
      - west
```