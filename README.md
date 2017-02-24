# k8s-workflow-utils

See individual files for more detailed descriptions.

## chns (change namespace)

`Usage: chns NAMESPACE`
NAMESPACE can be the shortest substring that uniquely identifies the namespace within the current context.
Zsh completions available.

## chctx (change context)

`Usage: chctx CONTEXT [NAMESPACE]`
CONTEXT can be the shortest substring that uniquely identifies the context.
Zsh completions available. NAMESPACE feature uses chns.

## exec-pod

`Usage: exec-pod POD_TYPE [CONTAINER]`

Chooses a pod whose name starts with POD_TYPE and executes `kubectl exec -ti "$POD" -c=$CONTAINER -- sh`.
E.g. `exec-pod web` to enter a pod in the "web" deployment
