# Setting up your Docker environment for ODK use

One of the most frequent problems with running the ODK for the first time is failure because of lack of memory. This can look like a Java OutOfMemory exception, 
but more often than not it will appear as something like an `Error 137`. There are two places you need to consider to set your memory:

1. Your src/ontology/run.sh (or run.bat) file. You can set the memory in there by adding 
`robot_java_args: '-Xmx8G'` to your src/ontology/hp-odk.yaml file, see for example [here](https://github.com/INCATools/ontology-development-kit/blob/0e0aef2b26b8db05f5e78b7c38f807d04312d06a/configs/uberon-odk.yaml#L36).
2. Set your docker memory. By default, it should be about 10-20% more than your `robot_java_args` variable. You can manage your memory settings
by right-clicking on the docker whale in your system bar-->Preferences-->Resources-->Advanced, see picture below.

![dockermemory](https://github.com/INCATools/ontology-development-kit/raw/master/docs/img/docker_memory.png)


