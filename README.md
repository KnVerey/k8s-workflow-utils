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

## kgoom (kubectl get oom)

`Usage: kgoom [ARGS]`

Returns information about any pods that have containers that have been OOMKilled.
Any args passed to the script (e.g. namespace, context flags) will be passed to the kubectl command.

Example:

```
NAMESPACE  /  NAME  /  CONTAINERS  /  LAST TERMINATION REASON  /  LAST TERMINATION TIME
my-app        web      nginx          OOMKilled                   2017-11-24T09:12:38Z
```

## kubernetes-context zsh theme

Looks like this:

![screenshot](https://screenshot.click/2017-08-15--154209_kt05f-ceby8.png)

Or in a git repo:

![screenshot](https://screenshot.click/2017-08-15--154332_c3axe-kbjv0.png)

Or if the last command failed:

![screenshot](https://screenshot.click/2017-08-15--154115_3h9bc-vcnsp.png)

## kube_context_aliases zsh plugin

Creates aliases named after your kube contexts that switch to the context in question. The alias for minikube is `minik` to avoid conflict with the minikube binary.

> WARNING: Think about what your context names might conflict with before using this!

Example: Given a kubeconfig containing context "fave", this plugin will alias `fave` to `kubectl config use-context fave`.

## session_kubeconfigs zsh plugin

Makes session-specific copies your kubeconfig(s) and creates aliases that manipulate `$KUBECONFIG` to switch between them:
- `kprod`: switches to the session-specific copy of `$MASTER_PROD_KUBECONFIG` (`$HOME/.kube/config` by default)
- `kloc`: switches to the session-specific copy of `$MASTER_LOCAL_KUBECONFIG` (`$HOME/.kube/localConfig` by default)
- `kmaster`: switches to your master kubeconfig(s)

This way, if you switch contexts in one window, your zsh prompt in another window won't by lying about its current context. In other words, it makes the "where am I" aspect of the zsh theme more dependable.

Your sessions will start with the session-specific copy of the config of type `$DEFAULT_KUBECONFIG_TYPE` (`prod` by default)
