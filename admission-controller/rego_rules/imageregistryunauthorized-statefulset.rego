# PolicyName: PSS - Baseline - StatefulSet with containers that using images from unauthorized registries
# Description: This policy identifies StatefulSets with containers using images from unauthorized registries

# In the below set, add allowed registry sources as needed
allowed_sources := {"registry.example.com"}

match[{"msg": msg}] {
    input.request.operation == "CREATE"
    input.request.kind.kind == "StatefulSet"
    image := input.request.object.spec.template.spec.containers[_].image
    images := {i | i := split(image, "/")[0]}
    compliant_images := images - allowed_sources
    count(compliant_images) != 0
    name := input.request.object.metadata.name
    msg := sprintf("StatefulSet with container using images from unauthorized registry found in:: %v", [name])
    
}