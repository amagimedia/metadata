# Metadata

Repository to capture all schemas for metadata representation.

## Tools to be installed

```
xmlstarlet
mkdocs
rapper can be installed using `brew install raptor`
```

## GithubIO deploy

```
mkdocs gh-deploy
```

## Conversion from ttl to XML/RDF

To convert run the following command

```
rapper -i turtle -o rdfxml amagi_ebucoreExtension.ttl > amagi_ebucoreExtension.rdf
```

The same can be achieved through `riot` (**a jena cli**) as follows:

```
riot --out=RDF/XML amagi_ebucoreExtension.ttl > amagi_ebucoreExtension.rdf
```

## List omissions in amgrss_master.xml

```
$ cd .../metadata
$ ./scripts/report_masterxml_omissions.sh -h
$ ./scripts/report_masterxml_omissions.sh
```

## References:

1. [Jena CLI tools](https://jena.apache.org/documentation/tools/index.html)
