# Generate key
openssl rand -base64 32

# Create Kubernetes secret
kubectl create secret generic consul-gossip-encryption-key \
  --namespace consul \
  --from-literal=key="<generated-key>"
