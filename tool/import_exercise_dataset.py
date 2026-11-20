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


def convert(record: dict[str, object]) -> dict[str, object]:
    name = record.get("name_es")
    body_part = record.get("body_part")
    equipment = record.get("equipment")
    instructions = record.get("instructions")
    spanish = instructions.get("es") if isinstance(instructions, dict) else None
    if not all(isinstance(value, str) and value for value in (name, body_part, equipment, spanish)):
        raise ValueError(f"Incomplete Spanish record: {record.get('id')}")

    equipment_label = EQUIPMENT.get(equipment.lower(), equipment.title())
    return {
        "id": record["id"],
        "name": name,
        "muscleGroup": BODY_PARTS.get(body_part.lower(), body_part.title()),
        "equipment": equipment_label,
        "instructions": split_instructions(spanish),
        "alternativeIds": [],
    }


def main() -> None:
    source = (
        Path(sys.argv[1])
        if len(sys.argv) > 1
        else ROOT / "assets" / "data" / "exercises_source.json"
    )
    records = json.loads(source.read_text(encoding="utf-8-sig"))
    if not isinstance(records, list):
        raise ValueError("The source dataset must be a JSON array.")

    exercises = [convert(record) for record in records]
    OUTPUT.parent.mkdir(parents=True, exist_ok=True)
    OUTPUT.write_text(
        json.dumps(exercises, ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
    )
    print(f"Wrote {len(exercises)} Spanish exercises to {OUTPUT.relative_to(ROOT)}")


if __name__ == "__main__":
    main()
