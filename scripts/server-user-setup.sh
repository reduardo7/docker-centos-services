#!/usr/bin/env bash

# Usage:
# script.sh deployer sysadmin 'ssh-rsa AAAA...zA3gF0pnPgy4rEsJQZ deployer@localhost'

set -e

##########
# Config #
##########

# Required
USER_NAME="$1"

# Optional
GROUP_ADMIN_NAME="$2"

# Optional
SSH_PUB="$3"


ssh_dir="/home/${USER_NAME}/.ssh"

#########
# Utils #
#########

@log() {
  echo "# $*"
}


#################
# User creation #
#################

if [ -d /home/${USER_NAME} ]; then
  @log User ${USER_NAME} already exists
else
  @log Create user ${USER_NAME}
  useradd --create-home -s /bin/bash ${USER_NAME}
fi


#######
# SSH #
#######

if [ ! -z "${SSH_PUB}" ]; then
  @log Setup SSH...
  authorized_keys_path="${ssh_dir}/authorized_keys"

  [ ! -d ${ssh_dir} ] && mkdir ${ssh_dir}

  if [ -f ${authorized_keys_path} ]; then
    echo >> ${authorized_keys_path}
  else
    touch ${authorized_keys_path}
  fi

  if grep -q "${SSH_PUB}" "${authorized_keys_path}"
    then
      @log "SSH Key already configured at ${authorized_keys_path}"
    else
      echo "${SSH_PUB}" >> ${authorized_keys_path}
    fi

  chown -R ${USER_NAME}:${USER_NAME} ${ssh_dir}
  chmod 700 ${ssh_dir}
  chmod 640 ${authorized_keys_path}
fi


###############
# Admin Group #
###############

if [ ! -z "${GROUP_ADMIN_NAME}" ]; then
  @log Create ${GROUP_ADMIN_NAME} group...

  SUDO_LINE_KEY="%${GROUP_ADMIN_NAME}"
  SUDO_LINE="${SUDO_LINE_KEY}        ALL=(ALL:ALL)       NOPASSWD: ALL"
  SUDO_FILE="/etc/sudoers.d/${GROUP_ADMIN_NAME}"

  if grep -q -E "^${GROUP_ADMIN_NAME}:" /etc/group
    then
      @log Group ${GROUP_ADMIN_NAME} already exists
    else
      groupadd ${GROUP_ADMIN_NAME}
    fi

  @log Add ${USER_NAME} to group ${GROUP_ADMIN_NAME}...
  usermod -aG ${GROUP_ADMIN_NAME} ${USER_NAME}

  touch ${SUDO_FILE}

  if grep -q "${SUDO_LINE_KEY}" ${SUDO_FILE}
    then
      @log ${SUDO_FILE} already configured
    else
      @log Add line "'${SUDO_LINE}'" to ${SUDO_FILE}
      echo "${SUDO_LINE}" >> ${SUDO_FILE}
    fi
fi

@log Finish with ${USER_NAME}
