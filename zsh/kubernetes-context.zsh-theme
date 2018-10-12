# A two-line prompt with git status and kubernetes context info
#
# KnVerey at Katrina's Mac in ~/workflow-utils on ±master ✗
# ༶                                                                                        ⎈  minikube/test-namespace

# kubernetes-current-context-info: Prints "context/namespace"
function _load_current_context_info() {
  if which kubectl > /dev/null; then
    K8S_ZSH_THEME_CURRENT_CONTEXT=$(kubectl config current-context)
    if [[ -z "${K8S_ZSH_THEME_CURRENT_CONTEXT}" ]]; then
      echo "kubectl context is not set"
      return 1
    fi

    K8S_ZSH_THEME_CURRENT_NAMESPACE=$(kubectl config view --minify --output=jsonpath='{..namespace}')
    K8S_ZSH_THEME_CURRENT_NAMESPACE="${K8S_ZSH_THEME_CURRENT_NAMESPACE:-default}"
    local local_contexts=(minikube docker-for-desktop dind)
    if [[ "${local_contexts[@]}" =~ "${K8S_ZSH_THEME_CURRENT_CONTEXT}" ]]; then
      iconColor=$fg[cyan]
    else
      iconColor=$fg[yellow]
    fi
    K8S_ZSH_THEME_KUBE_ICON="%{$iconColor%}⎈ %{$reset_color%}"
    echo "${K8S_ZSH_THEME_KUBE_ICON} %{$fg[cyan]%}${K8S_ZSH_THEME_CURRENT_CONTEXT}/${K8S_ZSH_THEME_CURRENT_NAMESPACE}%{$reset_color%}"
  else
    echo "kubectl binary not found"
    return 1
  fi
}

ZSH_THEME_GIT_PROMPT_PREFIX="on %{$fg[yellow]%}±"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[red]%}✗%{$fg[yellow]%}%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN=" %{$fg[green]%}✓%{$fg[yellow]%}%{$reset_color%}"

# Left prompt with user device and github info on top line
# And either a symbol or a red interrobang on the cursor line, depending on last exit code
PROMPT='
%{$fg_bold[blue]%}%n%{$reset_color%} at %{$fg_bold[blue]%}%m%{$reset_color%} in %{$fg_bold[cyan]%}%~%{$reset_color%} $(git_prompt_info)
%(?.༶.%{$fg_bold[red]%}‽%{$reset_color%}) '

# Right prompt with :boom: when last command failed and kube info
RPROMPT='$(_load_current_context_info)'
