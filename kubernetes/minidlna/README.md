### Deploying Kubernetes Resources
To deploy launch depoy.sh script.

It will use "envtmp" (https://pypi.org/project/envtpl/) to render jinja2 templates on the command line with shell environment variables.

Those variables will be used to create Kubernees resources, update them accordingly to node configuration

(e.g. EXT_HD_PATH contains the HD mount point of node, etc.). 