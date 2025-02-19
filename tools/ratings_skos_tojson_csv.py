
import os
import rdflib
from rdflib import URIRef
from country_codes import country_codes
from dataclasses import dataclass, asdict
from itertools import zip_longest
import csv
import json


ratings_ttl = os.path.dirname(os.path.realpath(__file__)) + "/../skos/ebu_ParentalGuidanceCodeCS_amgext.ttl"

@dataclass
class RatingInstance:
    id: str
    label: str
    definition: str

@dataclass
class Criteria:
    id: str
    label: str
    definition: str

@dataclass
class Rating:
    id: str
    country: str 
    country_code: str
    rating_body: str 
    rating: list[RatingInstance]
    criteria: list[Criteria]

def get_rating_parent(g, rating_root):
    qres = g.query(
        f"""
        SELECT ?id ?label
        WHERE {{
            ?id a <http://www.ebu.ch/metadata/ontologies/ebucore/ebucore#TargetAudience> .
            ?id skos:prefLabel "Rating"@en .
            ?id skos:broader <{rating_root}> .
        }}
        """
    )
    if len(qres) == 0:
        return URIRef(rating_root)
    for q in qres:
        return q.id

def get_criteria_parent(g, id):
    qres = g.query(
        f"""
        SELECT ?id ?label
        WHERE {{
            ?id a <http://www.ebu.ch/metadata/ontologies/ebucore/ebucore#TargetAudience> .
            ?id skos:prefLabel "Criteria"@en .
            ?id skos:broader <{id}> .
        }}
        """
    )
    if len(qres) == 0:
        return None
    for q in qres:
        return q.id

def get_all_children(g, id):
    qres = g.query(
        f"""
        SELECT ?id 
        WHERE {{
            ?id a <http://www.ebu.ch/metadata/ontologies/ebucore/ebucore#TargetAudience> .
            ?id skos:broader <{id}> .
        }}
        """
    )
    return qres

def get_all_rating_bodies():
    g = rdflib.Graph()
    g.parse(ratings_ttl, format="turtle")
    qres = g.query(
        """
        SELECT ?id ?country ?label
        WHERE {
            ?id a <http://www.ebu.ch/metadata/ontologies/ebucore/ebucore#TargetAudience> .
            ?id skos:prefLabel ?label .
            ?id skos:scopeNote ?country .
            FILTER (regex(?country, "^Region") && langMatches(lang(?label), "en"))
        }
        """
    )
    ratings = []
    for row in qres:
        country = row.country.split(":")[-1]
        ratings.append(Rating(id=row.id, country=country, country_code=row.country, rating_body=row.label, rating=[], criteria=[]))
        print(row.id, row.label, country)

    for r in ratings:
        rating_root = get_rating_parent(g, str(r.id))
        loc_ratings = get_all_children(g, str(rating_root))
        for lr in loc_ratings:
            labels = []
            definitions = []
            for _, p, o in g.triples((lr.id, None, None)):
                if p == URIRef("http://www.w3.org/2004/02/skos/core#prefLabel"):
                    labels.append(o + f"@{o.language}")
                if p == URIRef("http://www.w3.org/2004/02/skos/core#definition"):
                    definitions.append(o + f"@{o.language}")
            f_label = "</br></br>".join(labels)
            f_definition = "</br></br>".join(definitions)
            #print(r.id, f_label)
            r.rating.append(RatingInstance(id=lr.id, label=f_label, definition=f_definition))

        criteria_root = get_criteria_parent(g, str(r.id))
        if criteria_root:
            criteria = get_all_children(g, criteria_root)
            for lc in criteria:
                labels = []
                definitions = []
                for _, p, o in g.triples((lc.id, None, None)):
                    if p == URIRef("http://www.w3.org/2004/02/skos/core#prefLabel"):
                        labels.append(o + f"@{o.language}")
                    if p == URIRef("http://www.w3.org/2004/02/skos/core#definition"):
                        definitions.append(o + f"@{o.language}")
                f_label = "</br></br>".join(labels)
                f_definition = "</br></br>".join(definitions)
                r.criteria.append(Criteria(id=lc.id, label=f_label, definition=f_definition))

    return ratings


def write_json(ratings):
    with open("ratings.json", "w") as f:
        f.write(json.dumps([asdict(r) for r in ratings], indent=4))

def write_csv(ratings):
    with open("ratings.csv", "w") as f:
        writer = csv.writer(f)
        writer.writerow(["country", "country_code", "rating_body", "rating_id", "rating_label", "rating_definition", "criteria_id", "criteria_label", "criteria_definition"])
        for r in ratings:
            country_code = country_codes.get(r.country)
            zip_rc = zip_longest(r.rating, r.criteria, fillvalue=None)
            for rc in zip_rc:
                rating_id, rating_label, rating_defintion = (rc[0].id.split("#_")[-1], rc[0].label, rc[0].definition) if rc[0] else (None, None, None)
                criteria_id, criteria_label, criteria_definition = (rc[1].id.split("#_")[-1], rc[1].label, rc[1].definition) if rc[1] else (None, None, None)
                writer.writerow([r.country, country_code, r.rating_body, rating_id, rating_label, rating_defintion, criteria_id, criteria_label, criteria_definition])

if __name__ == "__main__":
    import sys
    ratings = get_all_rating_bodies()
    if sys.argv[1] == "json":
        write_json(ratings)
    elif sys.argv[1] == "csv":
        write_csv(ratings)