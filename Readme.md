
# Metadata

Repository to capture all schemas for metadata representation.

## GithubIO deploy

```
mkdocs gh-deploy
```

## Conversion from ttl to XMD/RDF

rapper can be installed using `brew install raptor`

To convert run the following command

```
rapper -i turtle -o rdfxml amagi_ebucoreExtension.ttl > amagi_ebucoreExtension.rdf
```