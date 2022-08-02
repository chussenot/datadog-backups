Datadog Backup Tooling
----------------

This repository contains a set of tools to provide backups. 

Usage
---------------------------
1. Ensure you have a suitable Ruby > 2.3.x+ version available
2. Clone the repository 
3. Bundle install 
4. Setup the configuration file YAML (See structure below)
    4.1 Copy the sample file and add your DD keys
5. Execute the tools
    5.1 Example in the Makefile

- This tool uses the old Datadog Ruby SDK and the Datadog APIs, you can read more about them below;
    - [Datadog Ruby SDK](https://github.com/DataDog/dogapi-rb)
    - [Datadog API](https://docs.datadoghq.com/api/)

Debug
---------------------------

```
# Add some breakpoint on the ruby line you want with pry `binding.pry`
# Build your Docker image `docker build . -t ddb  && docker run -it ddb`
```