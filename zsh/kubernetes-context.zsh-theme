# A two-line prompt with git status and kubernetes context info
#
# KnVerey at Katrina's Mac in ~/workflow-utils on ±master ✗
# ༶                                                                                        ⎈  minikube/test-namespace

# kubernetes-current-context-info: Prints "context/namespace"
function kubernetes-current-context-info() {
  if which kubectl > /dev/null; then
    cname=`kubectl config current-context`
    args="--output=jsonpath={.contexts[?(@.name == \"${cname}\")].context.namespace}"
    namespace=$(kubectl config view "${args}")
    if [ -z $namespace ]; then
      namespace="default"
    fi
    echo "${cname}/${namespace}"
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
RPROMPT='%{$fg[yellow]%}⎈ %{$reset_color%}%{$fg[cyan]%} $(kubernetes-current-context-info)%{$reset_color%}'
