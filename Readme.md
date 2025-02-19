# Metadata

Repository to capture all schemas for metadata representation.

## Tools to be installed

```
mkdocs
```

## Steps to install mkdocs
```
pip3 install -r requirements.txt
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

## Steps for updating skos 

- All skos changes should be done manually in the turtle skos files with suffix `_amgext.ttl`
- Once the changes are done use `riot` cli to create the xml serialization of the skos. E.g. `riot --out=RDF/xml ./skos/ebu_ParentalGuidanceCodeCS_amgext.ttl > ./skos/ebu_ParentalGuidanceCodeCS_amgext.rdf`
- Generate the csv files using the python script `genre_skos_to_json_csv.py` and `ratings_skos_tojson_csv.py` in the tools folder. E.g. `python genre_skos_to_json_csv.py csv`
- All above changes should be committed and reviewed before merging to main branch.


## List omissions in amgrss_master.xml

```
$ cd .../metadata
$ ./scripts/report_masterxml_omissions.sh -h
$ ./scripts/report_masterxml_omissions.sh
```


## References:

1. [Jena CLI tools](https://jena.apache.org/documentation/tools/index.html)
