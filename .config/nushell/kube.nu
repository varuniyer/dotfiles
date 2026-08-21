# kube.nu — kubectl wrappers (edit with `hxk`).
# Namespace lives on the current context. Set it once with `kns`, which defaults
# to $env.KUBE_NS, and every command below inherits it without a per-command -n.

def kns [ns?: string] {
  let ns = ($ns | default $env.KUBE_NS)
  kubectl config set-context --current $"--namespace=($ns)"
}

# Completion helper: current pod names.
def kube-pods [] {
  kubectl get pods --no-headers -o custom-columns=":metadata.name" | lines
}

def kgp [...rest: string@kube-pods] { kubectl get pods ...$rest }
def kd  [...rest: string@kube-pods] { kubectl delete pods ...$rest }
def kdp [...rest: string@kube-pods] { kubectl describe pods ...$rest }
def ka  [...rest: string@kube-pods] { kubectl attach ...$rest }

# Sorted pod list filtered by a name pattern. Pass `w` as the 2nd arg for wide output.
def ki [pattern: string@kube-pods, wide?: string] {
  let flags = (if $wide == "w" { ["--output=wide"] } else { [] })
  kubectl get pod "--sort-by={metadata.creationTimestamp}" ...$flags | grep $pattern
}
def kv [wide?: string] { if $wide == null { ki $env.NET_ID } else { ki $env.NET_ID $wide } }

# Watching variants.
def wki [pattern: string@kube-pods, wide?: string] {
  let flags = (if $wide == "w" { "--output=wide" } else { "" })
  ^watch $"kubectl get pod --sort-by='{metadata.creationTimestamp}' ($flags) | grep ($pattern)"
}
def wkv [wide?: string] { if $wide == null { wki $env.NET_ID } else { wki $env.NET_ID $wide } }

def klg [pod: string@kube-pods] { kubectl exec -it $pod -- /bin/bash }
def ke  [pod: string@kube-pods] { kubectl logs $pod | grep -i -A 200 Traceback | less }
def kl  [pod: string@kube-pods] { kubectl logs $pod | less +G }
def wkl [pod: string@kube-pods, lines: int = 20] {
  ^watch $"kubectl logs ($pod) --tail=($lines)"
}

# Generic watch wrapper: `w kubectl get pods` etc.
def w [...cmd: string] { ^watch ($cmd | str join ' ') }

def ktb [pod: string@kube-pods] { kubectl port-forward $pod 8080:6006 }

# Delete + recreate from a manifest.
def kc  [file: path] { kubectl delete -f $file; kubectl create -f $file }
def kcp [file: path] { kubectl delete -f $file; kubectl create -f $file }
