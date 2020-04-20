export GHUSER="jai"
fluxctl install \
--git-user=${GHUSER} \
--git-email=${GHUSER}@users.noreply.github.com \
--git-url=git@github.com:Honestbank/demo-flux-state \
--git-path=namespaces,workloads \
--namespace=flux | kubectl apply -f -

git@github.com:Honestbank/demo-flux-state.git

export GHUSER="YOURUSER"
fluxctl install \
--git-user=${GHUSER} \
--git-email=${GHUSER}@users.noreply.github.com \
--git-url=git@github.com:Honestbank/flux-get-started \
--git-path=namespaces,workloads \
--namespace=flux | kubectl apply -f -