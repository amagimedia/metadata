
# Metadata

Repository to capture all schemas for metadata representation.

## GithubIO deploy

```
mkdocs gh-deploy
```

## Conversion from ttl to XML/RDF

rapper can be installed using `brew install raptor`

To convert run the following command

```
rapper -i turtle -o rdfxml amagi_ebucoreExtension.ttl > amagi_ebucoreExtension.rdf
```

**riot: a jena cli**

```
riot --out=RDF/XML amagi_ebucoreExtension.ttl > amagi_ebucoreExtension.rd
```

## Python virtual env.

### creating 

```
$ cd .../metadata
$ python3 -m venv venv
```

### entering 

```
$ cd .../metadata
$ . ./venv/bin/activate
```

### exitting
```
$ cd .../metadata
$ deactivate
```

## References:

1. [Jena CLI tools](https://jena.apache.org/documentation/tools/index.html)
