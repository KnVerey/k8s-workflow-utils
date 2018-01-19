# Creates aliases named after your kube contexts that switch to the context in question
# The alias for minikube is 'minik' to avoid conflict with the minikube binary
# WARNING: Think about what your context names might conflict with before using this!
#
# Example: Given a kubeconfig containing context "fave", this plugin will alias "fave" to 'kubectl config use-context fave'"

# You can override this in your ~/.zshrc
MASTER_PROD_KUBECONFIG="${MASTER_PROD_KUBECONFIG:-$HOME/.kube/config}"

function _build_kube_context_aliases() {
  if which minikube > /dev/null; then
    alias minik="chctx minikube"
  fi

  if which kubectl > /dev/null; then
    contexts=($(kubectl config get-contexts -o name --kubeconfig=$MASTER_PROD_KUBECONFIG))
    for context in $contexts; do
      alias $context="kubectl config use-context $context"
    done
  else
    echo "kubectl binary not found"
    return 1
  fi
}

_build_kube_context_aliases
