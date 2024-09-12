# Metadata

Repository to capture all schemas for metadata representation.

## Tools to be installed

```
mkdocs
```

## GithubIO deploy

```
mkdocs gh-deploy
```

## Protege View Ontology

- Open Protege
- File -> Open .../ebucore/amagi_ebucoreExtension.ttl

## Conversion from ttl to XML/RDF

To convert run the following command

```
riot --out=RDF/XML amagi_ebucoreExtension.ttl > amagi_ebucoreExtension.rdf
```

**Note**:- `riot` is a command line tool that comes with Jena. You can download Jena from [here](https://jena.apache.org/download/)

## Generation of CSV from skos 

```bash
cd tools
python genre_skos_to_json_csv.py csv
python ratings_skos_tojson_csv.py csv

# Copy the generated csv files to docs folder
```


## List omissions in amgrss_master.xml

```
$ cd .../metadata
$ ./scripts/report_masterxml_omissions.sh -h
$ ./scripts/report_masterxml_omissions.sh
```


## References:

1. [Jena CLI tools](https://jena.apache.org/documentation/tools/index.html)
