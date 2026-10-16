# kube.nu — kubectl wrappers (edit with `hxk`).
# Namespace lives on the current context. Set it once with `kns`, which defaults
# to $env.KUBE_NS, and every command below inherits it without a per-command -n.

def kns [ns?: string] {
  let ns = ($ns | default $env.KUBE_NS)
  kubectl config set-context --current $"--namespace=($ns)"
}

# Completion helper: current pod names.
def kube-pods [] {
  kgp | get name
}

def kgp [...rest: string@kube-pods] {
  let pods = (kubectl get pods ...$rest -o json | from json)
  if $pods.kind == "List" { $pods.items } else { [$pods] }
  | select metadata.name status.phase
  | rename name phase
}
def kd  [...rest: string@kube-pods] { kubectl delete pods ...$rest }
def kdp [...rest: string@kube-pods] { kubectl describe pods ...$rest }
def ka  [...rest: string@kube-pods] { kubectl attach ...$rest }

def ki [prefix: string@kube-pods] {
  kgp "--sort-by=.metadata.creationTimestamp" | where name starts-with $prefix
}
def kv [prefix?: string@kube-pods] { ki ($prefix | default $env.NET_ID) }

# Watching variants.
def mki [prefix: string@kube-pods] {
  m $"ki ($prefix | to nuon)"
}
alias mkv = m kv
alias mkc = m 'kv | group-by phase --to-table | update items { length } | rename phase count | sort-by phase'

def klg [pod: string@kube-pods] { kubectl exec -it $pod -- /bin/bash }
def ke  [pod: string@kube-pods] { kubectl logs $pod | grep -i -A 200 Traceback | less }
def kl  [pod: string@kube-pods] { kubectl logs $pod | less +G }

def ktb [pod: string@kube-pods] { kubectl port-forward $pod 8080:6006 }

# Delete + recreate from a manifest.
def kc  [file: path] { kubectl delete -f $file; kubectl create -f $file }
