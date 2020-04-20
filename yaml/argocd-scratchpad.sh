kubectl apply --validate --dry-run -n argocd -f argocd-install.yaml

kubectl apply -n argocd -f argocd-install.yaml

argocd app create guestbook --repo https://github.com/argoproj/argocd-example-apps.git --path guestbook --dest-server https://kubernetes.default.svc --dest-namespace default


argocd-server-5c7bc9f58b-9jrrz