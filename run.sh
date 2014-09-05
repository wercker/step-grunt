#!/bin/sh

# return true if local npm package is installed at ./node_modules, else false
# example
# echo "gruntacular : $(npm_package_is_installed gruntacular)"
function npm_package_is_installed {
  # set to true initially
  local return_=true
  # set to false if not found
  ls node_modules | grep $1 >/dev/null 2>&1 || { local return_=false; }
  # return value
  echo "$return_"
}

# First make sure grunt is installed
if ! type grunt &> /dev/null ; then
    # Check if it is in repo
    if ! $(npm_package_is_installed grunt-cli) ; then
        info "grunt-cli not installed, trying to install it through npm"

        if ! type npm &> /dev/null ; then
            fail "npm not found, make sure you have npm or grunt-cli installed"
        else
            info "npm is available"
            debug "npm version: $(npm --version)"

            info "installing grunt-cli"
            npm config set ca "" --silent
            sudo npm install npm -g --silent
            sudo npm install -g --silent grunt-cli
            grunt_command="grunt"
        fi
    else
        info "grunt is available locally"
        debug "grunt version: $(./node_modules/grunt-cli/bin/grunt --version)"
        grunt_command="./node_modules/grunt-cli/bin/grunt"
    fi
else
    info "grunt is available"
    debug "grunt version: $(grunt --version)"
    grunt_command="grunt"
fi

grunt_working_path=""

# Parse some variable arguments
if [ "$WERCKER_GRUNT_DEBUG" = "true" ] ; then
    grunt_command="$grunt_command --debug"
fi

if [ "$WERCKER_GRUNT_VERBOSE" = "true" ] ; then
    grunt_command="$grunt_command --verbose"
fi

if [ "$WERCKER_GRUNT_STACK" = "true" ] ; then
    grunt_command="$grunt_command --stack"
fi

if [ -n "$WERCKER_GRUNT_GRUNTFILE" ] ; then
    grunt_command="$grunt_command --gruntfile $WERCKER_GRUNT_GRUNTFILE"
fi

if [ -n "$WERCKER_GRUNT_TASKS" ] ; then
    grunt_command="$grunt_command $WERCKER_GRUNT_TASKS"
fi

debug "$grunt_command"

set +e
$grunt_command
result="$?"
set -e

# Fail if it is not a success or warning
if [[ result -ne 0 ]]
then
    warn "$result"
    fail "grunt command failed"
else
    success "finished $grunt_command"
fi
