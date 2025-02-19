import sys
import rdflib 
import os 
from dataclasses import dataclass, asdict
import csv
import json

genre_ttl = os.path.dirname(os.path.realpath(__file__)) + "/../skos/ebu_ContentGenreCS_amgext.ttl"

ignore_genre_prefixes = ["3.7"]

profiles = {
    "generic": ["3.1", "3.4", "3.5", "3.8"],
    "music": ["3.6"],
    "sports": ["3.2"],
}

@dataclass
class Genre:
    serial_number: int
    id: str
    pref_label: str
    parent_id: str
    parent_label: str

def get_all_genres(profile):
    g = rdflib.Graph()
    g.parse(genre_ttl, format="turtle")
    qres = g.query(
        """
        SELECT ?id ?pref_label ?parent_id ?parent_label
        WHERE {
            ?id a <http://www.ebu.ch/metadata/ontologies/ebucore/ebucore#Genre> .
            ?id skos:prefLabel ?pref_label .
            OPTIONAL { ?id skos:broader ?parent_id . ?parent_id skos:prefLabel ?parent_label }
        }
        """
    )
    profile_prefixes = profiles[profile]
    genres = []
    serial_number = 1
    for row in qres:
        id = row.id.split("#_")[-1]
        parent_id = row.parent_id.split("#_")[-1] if row.parent_id else None
        if not any(id.startswith(prefix) for prefix in profile_prefixes):
            continue
        genres.append(Genre(serial_number, id, row.pref_label, parent_id, row.parent_label))
        serial_number += 1
    return genres


def duplicate_relabel(genres):
    pref_label_dict = {}
    for g in genres:
        if g.pref_label in pref_label_dict:
            pref_label_dict[g.pref_label].append(g)
        else:
            pref_label_dict[g.pref_label] = [g]

    for _, gs in pref_label_dict.items():
        if len(gs) > 1:
            for i in range(len(gs)):
                gs[i].pref_label = f"{gs[i].parent_label} > {gs[i].pref_label}"
                print("Duplicate label found: ", gs[i].id, gs[i].pref_label)

    return genres


def write_json(genres, output_file):
    with open(output_file, "w") as f:
        f.write(json.dumps([asdict(g) for g in genres], indent=4))

def write_csv(genres, output_file):
    with open(output_file, "w") as f:
        writer = csv.writer(f)
        writer.writerow(["serial_number", "genre_id", "genre_label"])
        for g in genres:
            writer.writerow([g.serial_number, g.id, g.pref_label])

if __name__ == "__main__":
    genres = get_all_genres("generic")
    genres = duplicate_relabel(genres)
    if sys.argv[1] == "json":
        write_json(genres, "generic_genres.json")
    elif sys.argv[1] == "csv":
        write_csv(genres, "generic_genres.csv")

    genres = get_all_genres("music")
    genres = duplicate_relabel(genres)
    if sys.argv[1] == "json":
        write_json(genres, "music_genres.json")
    elif sys.argv[1] == "csv":
        write_csv(genres, "music_genres.csv")

    genres = get_all_genres("sports")
    genres = duplicate_relabel(genres)
    if sys.argv[1] == "json":
        write_json(genres, "sports_genres.json")
    elif sys.argv[1] == "csv":
        write_csv(genres, "sports_genres.csv")