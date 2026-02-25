# Kubectl wrappers

function kgp
    kubectl get pods -n $KUBE_NS $argv
end

function kd
    kubectl delete pods -n $KUBE_NS $argv
end

function kdp
    kubectl describe pods -n $KUBE_NS $argv
end

function ka
    kubectl attach -n $KUBE_NS $argv
end

function wkv
    wki $UIC_NAME $argv
end

function kv
    ki $UIC_NAME $argv
end

function ki
    # Initialize as empty list (no arguments)
    set suffix

    if test (count $argv) -ge 2; and test "$argv[2]" = w
        set suffix "--output=wide"
    end

    # Fish will simply expand $suffix to nothing if it's an empty list
    kubectl get pod -n $KUBE_NS --sort-by='{metadata.creationTimestamp}' $suffix | grep $argv[1]
end

function wki
    set suffix

    if test (count $argv) -ge 2; and test "$argv[2]" = w
        set suffix "--output=wide"
    end

    # Watch is tricky with quotes. We construct the command string first.
    # Note: We escape the pipe \| so it's part of the watch string, not interpreted by Fish now.
    set cmd "kubectl get pod -n $KUBE_NS --sort-by='{metadata.creationTimestamp}' $suffix | grep $argv[1]"

    watch "fish -c '$cmd'"
end

function klg
    kubectl exec -n $KUBE_NS -it $argv[1] -- /bin/bash
end

function ke
    kubectl logs -n $KUBE_NS $argv[1] | grep -i -A 200 Traceback | less
end

function kl
    kubectl logs -n $KUBE_NS $argv[1] | less +G
end

function wkl
    set lines 20
    if set -q argv[2]
        set lines $argv[2]
    end
    watch "fish -c 'kubectl logs -n $KUBE_NS $argv[1] --tail=$lines'"
end

function w
    # Generic watch wrapper - doesn't need namespace unless user types it
    watch "fish -c '$argv'"
end

function ktb
    kubectl port-forward -n $KUBE_NS $argv[1] 8080:6006
end

function kc
    set job_file $argv[1]
    # Delete and Create take files (-f), but usually respect the namespace in the YAML.
    # If your YAMLs don't have namespaces, we force it here.
    kubectl delete -n $KUBE_NS -f $job_file
    kubectl create -n $KUBE_NS -f $job_file
end

function kcp
    set pod_file $argv[1]
    kubectl delete -n $KUBE_NS -f $pod_file
    kubectl create -n $KUBE_NS -f $pod_file
end

# --- Completions ---
set pod_function_names ki wki klg ke kl wkl kdp kd ka kgp

for func in $pod_function_names
    complete -c $func -f -a '(kubectl get pods --no-headers -o custom-columns=":metadata.name" 2>/dev/null)'
end

set yml_function_names kc kcp
for func in $yml_function_names
    complete -c $func -a "(__fish_complete_suffix .yml)"
end
