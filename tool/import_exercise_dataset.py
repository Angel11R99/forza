"""Convert the pinned bilingual exercise dataset into FORZA's media-free asset."""

from __future__ import annotations

import json
import re
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
OUTPUT = ROOT / "assets" / "data" / "exercises.json"

BODY_PARTS = {
    "back": "Espalda",
    "cardio": "Cardio",
    "chest": "Pecho",
    "lower arms": "Brazos",
    "lower legs": "Piernas",
    "neck": "Cuello",
    "shoulders": "Hombros",
    "upper arms": "Brazos",
    "upper legs": "Piernas",
    "waist": "Core",
}

EQUIPMENT = {
    "assisted": "Asistido",
    "band": "Banda elástica",
    "barbell": "Barra",
    "body weight": "Peso corporal",
    "bosu ball": "Balón BOSU",
    "cable": "Polea",
    "dumbbell": "Mancuernas",
    "elliptical machine": "Elíptica",
    "ez barbell": "Barra EZ",
    "hammer": "Martillo",
    "kettlebell": "Pesa rusa",
    "leverage machine": "Máquina de palanca",
    "medicine ball": "Balón medicinal",
    "olympic barbell": "Barra olímpica",
    "resistance band": "Banda elástica",
    "roller": "Rodillo",
    "rope": "Cuerda",
    "sled machine": "Trineo",
    "skierg machine": "Máquina SkiErg",
    "smith machine": "Máquina Smith",
    "stability ball": "Balón de estabilidad",
    "stationary bike": "Bicicleta estática",
    "stepmill machine": "Escaladora",
    "tire": "Neumático",
    "trap bar": "Barra hexagonal",
    "upper body ergometer": "Ergómetro de tren superior",
    "weighted": "Carga adicional",
    "wheel roller": "Rueda abdominal",
}


def split_instructions(text: str) -> list[str]:
    sentences = re.split(r"(?<=[.!?])\s+(?=[A-ZÁÉÍÓÚÜÑ¿¡])", text.strip())
    return [sentence.strip() for sentence in sentences if sentence.strip()]


def convert(
    record: dict[str, object], english_record: dict[str, object] | None = None
) -> dict[str, object]:
    name = record.get("name_es")
    body_part = record.get("body_part")
    equipment = record.get("equipment")
    instructions = record.get("instructions")
    spanish = instructions.get("es") if isinstance(instructions, dict) else None
    if not all(isinstance(value, str) and value for value in (name, body_part, equipment, spanish)):
        raise ValueError(f"Incomplete Spanish record: {record.get('id')}")

    equipment_label = EQUIPMENT.get(equipment.lower(), equipment.title())
    converted = {
        "id": record["id"],
        "name": name,
        "muscleGroup": BODY_PARTS.get(body_part.lower(), body_part.title()),
        "equipment": equipment_label,
        "instructions": split_instructions(spanish),
        "alternativeIds": [],
    }
    if english_record is not None:
        english_name = english_record.get("name")
        english_steps_by_language = english_record.get("instruction_steps")
        english_steps = (
            english_steps_by_language.get("en")
            if isinstance(english_steps_by_language, dict)
            else None
        )
        if not isinstance(english_name, str) or not english_name:
            raise ValueError(f"Missing English name: {record.get('id')}")
        if not isinstance(english_steps, list) or not all(
            isinstance(step, str) and step for step in english_steps
        ):
            raise ValueError(f"Missing English instructions: {record.get('id')}")
        converted["englishName"] = english_name
        converted["englishInstructions"] = english_steps
    return converted


def main() -> None:
    source = (
        Path(sys.argv[1])
        if len(sys.argv) > 1
        else ROOT / "assets" / "data" / "exercises_source.json"
    )
    records = json.loads(source.read_text(encoding="utf-8-sig"))
    if not isinstance(records, list):
        raise ValueError("The source dataset must be a JSON array.")

    english_by_id: dict[str, dict[str, object]] = {}
    if len(sys.argv) > 2:
        english_source = Path(sys.argv[2])
        english_records = json.loads(english_source.read_text(encoding="utf-8-sig"))
        if not isinstance(english_records, list):
            raise ValueError("The English source dataset must be a JSON array.")
        english_by_id = {str(record["id"]): record for record in english_records}
        spanish_ids = {str(record["id"]) for record in records}
        if spanish_ids != set(english_by_id):
            raise ValueError("Spanish and English datasets must contain the same IDs.")

    exercises = [
        convert(record, english_by_id.get(str(record["id"])))
        for record in records
    ]
    OUTPUT.parent.mkdir(parents=True, exist_ok=True)
    OUTPUT.write_text(
        json.dumps(exercises, ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
    )
    language_label = "Spanish and English" if english_by_id else "Spanish"
    print(
        f"Wrote {len(exercises)} {language_label} exercises "
        f"to {OUTPUT.relative_to(ROOT)}"
    )


if __name__ == "__main__":
    main()
