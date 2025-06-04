#!/bin/sh
# Wrapper script for docker.
#
# This is used primarily for wrapping the GNU Make workflow.
# Instead of typing "make TARGET", type "./run.sh make TARGET".
# This will run the make workflow within a docker container.
#
# The assumption is that you are working in the src/ontology folder;
# we therefore map the whole repo (../..) to a docker volume.
#
# To use singularity instead of docker, please issue
# export USE_SINGULARITY=<any-value>
# before running this script.
#
# See README-editors.md for more details.

case "$@" in
*update_repo*)
    # Execute a copy of this script so that it can be overwritten
    # during the update process
    mkdir -p tmp
    sed -n '/^set -e/,$p' $0 > tmp/$0
    exec /bin/sh tmp/$0 "$@"
    ;;
esac

set -e

# Check for spaces in the current directory path
for item in $PWD ; do
    if [ "$item" != "$PWD" ]; then
        echo "${0##*/}: error: repository path must not contain whitespace characters" >&2
        exit 1
    fi
done

if [ -f run.sh.conf ]; then
    . ./run.sh.conf
fi

# Look for a GitHub token
if [ -n "$GH_TOKEN" ]; then
    :
elif [ -f ../../.github/token.txt ]; then
    GH_TOKEN=$(cat ../../.github/token.txt)
elif [ -f $XDG_CONFIG_HOME/ontology-development-kit/github/token ]; then
    GH_TOKEN=$(cat $XDG_CONFIG_HOME/ontology-development-kit/github/token)
elif [ -f "$HOME/Library/Application Support/ontology-development-kit/github/token" ]; then
    GH_TOKEN=$(cat "$HOME/Library/Application Support/ontology-development-kit/github/token")
fi

# SSH agent socket
# On macOS, we cannot use $SSH_AUTH_SOCK directly,
# we need to use a "magic" socket instead.
case "$(uname)" in
Darwin)
    ODK_SSH_AUTH_SOCKET=/run/host-services/ssh-auth.sock
    ;;
*)
    ODK_SSH_AUTH_SOCKET=$SSH_AUTH_SOCK
    ;;
esac
ODK_SSH_BIND=
if [ -n "$ODK_SSH_AUTH_SOCKET" ]; then
    ODK_SSH_BIND=",$ODK_SSH_AUTH_SOCKET:/run/host-services/ssh-auth.sock"
fi

ODK_IMAGE=${ODK_IMAGE:-odkfull}
TAG_IN_IMAGE=$(echo $ODK_IMAGE | awk -F':' '{ print $2 }')
if [ -n "$TAG_IN_IMAGE" ]; then
  # Override ODK_TAG env var if IMAGE already includes a tag
  ODK_TAG=$TAG_IN_IMAGE
  ODK_IMAGE=$(echo $ODK_IMAGE | awk -F':' '{ print $1 }')
fi
ODK_TAG=${ODK_TAG:-latest}

ODK_JAVA_OPTS=${ODK_JAVA_OPTS:--Xmx8G}

ODK_DEBUG=${ODK_DEBUG:-no}

ODK_USER_ID=${ODK_USER_ID:-$(id -u)}
ODK_GROUP_ID=${ODK_GROUP_ID:-$(id -g)}

# Convert OWLAPI_* environment variables to the OWLAPI as Java options
# See http://owlcs.github.io/owlapi/apidocs_4/org/semanticweb/owlapi/model/parameters/ConfigurationOptions.html
# for a list of allowed options
OWLAPI_OPTIONS_NAMESPACE=org.semanticweb.owlapi.model.parameters.ConfigurationOptions
for owlapi_var in $(env | sed -n s/^OWLAPI_//p) ; do
    ODK_JAVA_OPTS="$ODK_JAVA_OPTS -D$OWLAPI_OPTIONS_NAMESPACE.${owlapi_var%=*}=${owlapi_var#*=}"
done

# Proxy settings for Java applications
[ -z "$HTTP_PROXY" ] && [ -n "$http_proxy" ] && HTTP_PROXY=$http_proxy
if [ -n "$HTTP_PROXY" ]; then
    proxy_host=$(echo $HTTP_PROXY | sed -E 's,^https?://,,; s,:[0-9]+$,,')
    proxy_port=$(echo $HTTP_PROXY | sed -E 's,^.*:([0-9]+)$,\1,')
    ODK_JAVA_OPTS="$ODK_JAVA_OPTS -Dhttp.proxyHost=$proxy_host"
    [ "$proxy_port" != "$proxy_host" ] && ODK_JAVA_OPTS="$ODK_JAVA_OPTS -Dhttp.proxyPort=$proxy_port"
fi
[ -z "$HTTPS_PROXY" ] && [ -n "$https_proxy" ] && HTTPS_PROXY=$https_proxy
if [ -n "$HTTPS_PROXY" ]; then
    proxy_host=$(echo $HTTPS_PROXY | sed -E 's,^https?://,,; s,:[0-9]+$,,')
    proxy_port=$(echo $HTTPS_PROXY | sed -E 's,^.*:([0-9]+)$,\1,')
    ODK_JAVA_OPTS="$ODK_JAVA_OPTS -Dhttps.proxyHost=$proxy_host"
    [ "$proxy_port" != "$proxy_host" ] && ODK_JAVA_OPTS="$ODK_JAVA_OPTS -Dhttps.proxyPort=$proxy_port"
fi
[ -z "$NO_PROXY" ] && [ -n "$no_proxy" ] && NO_PROXY=$no_proxy
if [ -n "$NO_PROXY" ] ; then
    no_proxy_hosts=$(echo $NO_PROXY | tr ',' '|')
    ODK_JAVA_OPTS="$ODK_JAVA_OPTS -Dhttp.nonProxyHosts=$no_proxy_hosts"
fi

TIMECMD=
if [ x$ODK_DEBUG = xyes ]; then
    # If you wish to change the format string, take care of using
    # non-breaking spaces (U+00A0) instead of normal spaces, to
    # prevent the shell from tokenizing the format string.
    echo "Running obolibrary/${ODK_IMAGE}:${ODK_TAG} with '${ODK_JAVA_OPTS}' as options for ROBOT and other Java-based pipeline steps."
    TIMECMD="/usr/bin/time -f ### DEBUG STATS ###\nElapsed time: %E\nPeak memory: %M kb"
fi
rm -f tmp/debug.log

VOLUME_BIND=$PWD/../../:/work$ODK_SSH_BIND
WORK_DIR=/work/src/ontology

# Support for OAK cache sharing
if [ -n "$ODK_SHARE_OAK_CACHE" ]; then
    case "$ODK_SHARE_OAK_CACHE" in
    user)
        # We assume the cache is in its default location; if it is not,
        # ODK_SHARE_OAK_CACHE must point to the actual location.
        ODK_SHARE_OAK_CACHE="$HOME/.data/oaklib"
        ;;
    repo)
        ODK_SHARE_OAK_CACHE="$PWD/tmp/oaklib"
        ;;
    esac
    [ $ODK_USER_ID -eq 0 ] && OAK_DEST=/root/.data/oaklib || OAK_DEST=/home/odkuser/.data/oaklib
    VOLUME_BIND="$VOLUME_BIND,$ODK_SHARE_OAK_CACHE:$OAK_DEST"
fi

if [ -n "$ODK_BINDS" ]; then
    VOLUME_BIND="$VOLUME_BIND,$ODK_BINDS"
fi

if [ -n "$USE_SINGULARITY" ]; then
    
    singularity exec --cleanenv $ODK_SINGULARITY_OPTIONS \
        --env "ROBOT_JAVA_ARGS=$ODK_JAVA_OPTS,JAVA_OPTS=$ODK_JAVA_OPTS,SSH_AUTH_SOCK=/run/host-services/ssh-auth.sock,ODK_USER_ID=$ODK_USER_ID,ODK_GROUP_ID=$ODK_GROUP_ID,ODK_DEBUG=$ODK_DEBUG" \
        --bind $VOLUME_BIND \
        -W $WORK_DIR \
        docker://obolibrary/$ODK_IMAGE:$ODK_TAG $TIMECMD "$@"
else
    BIND_OPTIONS="-v $(echo $VOLUME_BIND | sed 's/,/ -v /g')"
    docker run $ODK_DOCKER_OPTIONS $BIND_OPTIONS -w $WORK_DIR \
        -e ROBOT_JAVA_ARGS="$ODK_JAVA_OPTS" -e JAVA_OPTS="$ODK_JAVA_OPTS" -e SSH_AUTH_SOCK=/run/host-services/ssh-auth.sock -e ODK_USER_ID=$ODK_USER_ID -e ODK_GROUP_ID=$ODK_GROUP_ID -e ODK_DEBUG=$ODK_DEBUG \
        --rm -ti obolibrary/$ODK_IMAGE:$ODK_TAG $TIMECMD "$@"
fi

case "$@" in
*update_repo*|*release*)
    echo "Please remember to update your ODK image from time to time: https://oboacademy.github.io/obook/howto/odk-update/."
    ;;
esac