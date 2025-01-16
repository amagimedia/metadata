
## Naming Conventions

- ebu_[A-Za-z0-9]*CS.rdf: RDF/XML serialization of EBU published Concept Scheme
- amagi_ebu_[A-Za-z0-9]*CS.rdf: RDF/XML serialization of Amagi defined Concept Schemes using ebucore rdfs
- ebu_[A-Za-z0-9]*CS_amgext.rdf: RDF/XML serialization of EBU published Concept Scheme, that has been extended by adding more skos triples.


## Files in folder

- **ebu_ContentGenreCS.rdf**: Source -> http://www.ebu.ch/metadata/ontologies/skos/ebu_ContentGenreCS.rdf
- **ebu_RoleCodeCS.rdf**: Source -> http://www.ebu.ch/metadata/ontologies/skos/ebu_RoleCodeCS.rdf
- **ebu_Iso3166_CountryCodeCS.rdf**  : Source -> https://www.ebu.ch/metadata/ontologies/skos/ebu_Iso3166_CountryCodeCS.rdf


## Json representations

- **json/role_skos.json**: Command to generate `amgrss-tool ebucs-rdf-2-json -i /Users/shashidhar/sb_work/sb_github/metadata/skos/ebu_RoleCodeCS_amgext.rdf -p all -n 5,17,20,25,28 -o role.json`
- **json/asset_type_skos.json**: Command to generate `amgrss-tool ebucs-rdf-2-json -i /Users/shashidhar/sb_work/sb_github/metadata/skos/amagi_ebu_AssetTypeCS.rdf -o asset_type.json`
- **json/genre_skos.json**: Json representation of ebu_ContentGenreCS_amgext.rdf
- **json/parental_guidance_skos.json**: Json representation of ebu_ParentalGuidanceCodeCS_amgext.rdf 

## RDF compare

**rdfdiff**: Jena cli tool. [Install instructions](https://jena.apache.org/documentation/tools/index.html)

```bash
rdfdiff ebu_ContentGenreCS_amgext.rdf ebu_ContentGenreCS.rdf rdf/xml rdf/xml | sort
```
<!-- test spellchecker -->
