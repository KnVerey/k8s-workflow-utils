#!/bin/zsh

# Creates aliases named after your kube contexts that switch to the context in question
# Requires chctx to be on your path
# The alias for minikube is 'minik' to avoid conflict with the minikube binary
# WARNING: Think about what your context names might conflict with before using this!
#
# Example: Given a kubeconfig containing context "fave", this plugin will alias "fave" to 'kubectl config use-context fave'"

function _build_kube_context_aliases() {
  local kubeconfig="${KUBECONFIG:-$HOME/.kube/config}"
  if which kubectl > /dev/null; then
    local contexts=($(kubectl config get-contexts -o name --kubeconfig="${kubeconfig}"))
    for context in $contexts; do
      if [[ $context == "minikube" ]]; then
        alias minik="chctx minikube"
      else
        alias $context="chctx $context"
      fi
    done
  else
    echo "kubectl binary not found"
    return 1
  fi
}

_build_kube_context_aliases
