
## Naming Conventions

- ebu_[A-Za-z0-9]*CS.rdf: RDF/XML serialization of EBU published Concept Scheme
- amagi_ebu_[A-Za-z0-9]*CS.rdf: RDF/XML serialization of Amagi defined Concept Schemes using ebucore rdfs
- ebu_[A-Za-z0-9]*CS_amgext.rdf: RDF/XML serialization of EBU published Concept Scheme, that has been extended by adding more skos triples.


## Files in folder

- **ebu_ContentGenreCS.rdf**: Source -> http://www.ebu.ch/metadata/ontologies/skos/ebu_ContentGenreCS.rdf
- **ebu_RoleCodeCS.rdf**: Source -> http://www.ebu.ch/metadata/ontologies/skos/ebu_RoleCodeCS.rdf
- **ebu_Iso3166_CountryCodeCS.rdf**  : Source -> https://www.ebu.ch/metadata/ontologies/skos/ebu_Iso3166_CountryCodeCS.rdf


## RDF compare

**rdfdiff**: Jena cli tool. [Install instructions](https://jena.apache.org/documentation/tools/index.html)

```bash
rdfdiff ebu_ContentGenreCS_amgext.rdf ebu_ContentGenreCS.rdf rdf/xml rdf/xml | sort
```

