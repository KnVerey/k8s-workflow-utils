# Makes session-specific copies your kubeconfig(s) and creates aliases that manipulate $KUBECONFIG to switch between them:
# - kprod: switches to the session-specific copy of $MASTER_PROD_KUBECONFIG ($HOME/.kube/config by default)
# - kloc: switches to the session-specific copy of $MASTER_LOCAL_KUBECONFIG ($HOME/.kube/localConfig by default)
# - kmaster: switches to your master kubeconfig(s)
#
# Your sessions will start with the session-specific copy of the config of type $DEFAULT_KUBECONFIG_TYPE (prod by default)


# You can override these in your ~/.zshrc
MASTER_PROD_KUBECONFIG="${MASTER_PROD_KUBECONFIG:-$HOME/.kube/config}"
MASTER_LOCAL_KUBECONFIG="${MASTER_LOCAL_KUBECONFIG:-$HOME/.kube/localConfig}"
DEFAULT_KUBECONFIG_TYPE="${DEFAULT_KUBECONFIG_TYPE:-prod}"

function _build_temp_kubeconfigs() {
  session_id=$(echo $TERM_SESSION_ID | sed 's/://g')
  mkdir -p "$TMPDIR$session_id/.kube"

  if [[ -s $MASTER_PROD_KUBECONFIG ]]; then
    export PROD_KUBECONFIG="$TMPDIR$session_id/.kube/prodKubeConfig"
    cp $MASTER_PROD_KUBECONFIG $PROD_KUBECONFIG
    alias kprod="export KUBECONFIG=$PROD_KUBECONFIG"
  fi

  if [[ -s $MASTER_LOCAL_KUBECONFIG ]]; then
    export LOCAL_KUBECONFIG="$TMPDIR$session_id/.kube/localConfig"
    cp $MASTER_LOCAL_KUBECONFIG $LOCAL_KUBECONFIG
    alias kloc="export KUBECONFIG=$LOCAL_KUBECONFIG"
  fi
}

function _set_default_kubeconfig() {
  if [[ $DEFAULT_KUBECONFIG_TYPE == "local" ]]; then
    if [[ ! -s $LOCAL_KUBECONFIG ]]; then
      echo "Local kubeconfig specified as default but does not exist"
      return 1
    fi

    export KUBECONFIG=$LOCAL_KUBECONFIG
    if [[ -s $PROD_KUBECONFIG ]]; then
      alias kmaster="export KUBECONFIG=$MASTER_LOCAL_KUBECONFIG:$MASTER_PROD_KUBECONFIG"
    else
      alias kmaster="export KUBECONFIG=$MASTER_LOCAL_KUBECONFIG"
    fi

  elif [[ $DEFAULT_KUBECONFIG_TYPE == "prod" ]]; then
    if [[ ! -s $PROD_KUBECONFIG ]]; then
      echo "Prod kubeconfig specified as default but does not exist"
      return 1
    fi

    export KUBECONFIG=$PROD_KUBECONFIG
    if [[ -s $LOCAL_KUBECONFIG ]]; then
      alias kmaster="export KUBECONFIG=$MASTER_PROD_KUBECONFIG:$MASTER_LOCAL_KUBECONFIG"
    else
      alias kmaster="export KUBECONFIG=$MASTER_PROD_KUBECONFIG"
    fi
  else
    echo "DEFAULT_KUBECONFIG_TYPE ($DEFAULT_KUBECONFIG_TYPE) is invalid"
  fi
}

_build_temp_kubeconfigs
_set_default_kubeconfig
