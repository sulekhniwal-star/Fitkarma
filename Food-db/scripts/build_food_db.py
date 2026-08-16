"""
Food-db/scripts/build_food_db.py
ETL script — reads all Indian food CSVs, normalises, deduplicates, and
outputs:
  Food-db/output/food_references_seed.json   (full dataset for D1 seed script)
  Food-db/output/food_seed_5000.json          (top-5000 trimmed, for APK bundle)
  Food-db/output/food_references_seed.sql    (raw INSERT SQL as fallback)
"""

import csv
import json
import os
import re
import unicodedata
from pathlib import Path

BASE = Path(__file__).parent.parent  # Food-db/
OUT = BASE / "output"
OUT.mkdir(exist_ok=True)

def safe_float(val, default=0.0):
    try:
        return round(float(str(val).strip().replace(",", ".")), 2)
    except Exception:
        return default

PRIORITY = {
    "indian_nutrition_cal": 0,
    "processed_indian": 1,
    "nutrition_cf": 2,
    "recipe_ingredients": 3,
    "global_nutrition": 4,
}

rows = []

# ── Source 1: Indian_Food_Nutrition_Processed.csv ─────────────────────────────
src1 = BASE / "archive2_extract" / "Indian_Food_Nutrition_Processed.csv"
if src1.exists():
    batch = []
    with open(src1, encoding="utf-8-sig", errors="replace") as f:
        reader = csv.DictReader(f)
        for r in reader:
            name = str(r.get("Dish Name", "")).strip()
            if not name:
                continue
            batch.append({
                "foodName": name,
                "calories": safe_float(r.get("Calories (kcal)", r.get("Calories(kcal)", 0))),
                "proteinG": safe_float(r.get("Protein (g)", r.get("Protein(g)", 0))),
                "carbsG": safe_float(r.get("Carbohydrates (g)", r.get("Carbohydrates(g)", 0))),
                "fatG": safe_float(r.get("Fats (g)", r.get("Fats(g)", 0))),
                "fiberG": safe_float(r.get("Fibre (g)", r.get("Fibre(g)", 0))),
                "category": "Indian", "region": "", "servingGrams": 100.0,
                "glycemicIndex": 50, "satietyIndex": 60,
                "sourceTag": "processed_indian", "defaultServing": "100g",
            })
    rows.extend(batch)
    print(f"[src1] {len(batch)} rows from Indian_Food_Nutrition_Processed")

# ── Source 2: Indian_Food_Ingredients_Nutrition_CookingMethods.csv ─────────────
src2 = BASE / "archive3_extract" / "Indian_Food_Ingredients_Nutrition_CookingMethods.csv"
if src2.exists():
    batch = []
    with open(src2, encoding="utf-8-sig", errors="replace") as f:
        reader = csv.DictReader(f)
        for r in reader:
            name = str(r.get("final_food_name", "")).strip() or str(r.get("recipe_original", "")).strip()
            if not name:
                continue
            cuisine = str(r.get("Cuisine", "")).strip()
            batch.append({
                "foodName": name,
                "calories": safe_float(r.get("Calories (kcal)", r.get("Calories(kcal)", 0))),
                "proteinG": safe_float(r.get("Protein (g)", r.get("Protein(g)", 0))),
                "carbsG": safe_float(r.get("Carbohydrates (g)", r.get("Carbohydrates(g)", 0))),
                "fatG": safe_float(r.get("Fats (g)", r.get("Fats(g)", 0))),
                "fiberG": safe_float(r.get("Fibre (g)", r.get("Fibre(g)", 0))),
                "category": cuisine or "Indian", "region": "", "servingGrams": 100.0,
                "glycemicIndex": 50, "satietyIndex": 60,
                "sourceTag": "recipe_ingredients", "defaultServing": "100g",
            })
    rows.extend(batch)
    print(f"[src2] {len(batch)} rows from Indian_Food_Ingredients_Nutrition_CookingMethods")

# ── Source 3: indian_food_nutrition_calories - Sheet1.csv ─────────────────────
src3_dir = BASE / "archive1_extract"
if src3_dir.exists():
    csvs = [f for f in src3_dir.iterdir() if f.suffix == ".csv"]
    for src3 in csvs:
        batch = []
        with open(src3, encoding="utf-8-sig", errors="replace") as f:
            reader = csv.DictReader(f)
            for r in reader:
                name = str(r.get("Food_Item", "")).strip()
                if not name:
                    continue
                batch.append({
                    "foodName": name,
                    "calories": safe_float(r.get("Calories_per_100g", 0)),
                    "proteinG": safe_float(r.get("Protein_g", 0)),
                    "carbsG": safe_float(r.get("Carbs_g", 0)),
                    "fatG": safe_float(r.get("Fat_g", 0)),
                    "fiberG": safe_float(r.get("Fiber_g", 0)),
                    "category": str(r.get("Category", "Indian")).strip(),
                    "region": str(r.get("Region", "")).strip(),
                    "servingGrams": 100.0, "glycemicIndex": 50, "satietyIndex": 60,
                    "sourceTag": "indian_nutrition_cal", "defaultServing": "100g",
                })
        rows.extend(batch)
        print(f"[src3] {len(batch)} rows from {src3.name}")

# ── Source 4: nutrition_cf - Sheet5.csv ───────────────────────────────────────
src4 = BASE / "nutrition_cf - Sheet5.csv"
if src4.exists():
    batch = []
    with open(src4, encoding="utf-8-sig", errors="replace") as f:
        reader = csv.DictReader(f)
        for r in reader:
            name = str(r.get("Food", "")).strip()
            if not name:
                continue
            weight = safe_float(r.get("Total Weight (gms)", "100"), 100.0)
            factor = 100.0 / weight if weight > 0 else 1.0
            batch.append({
                "foodName": name,
                "calories": round(safe_float(r.get("Energy(kcal)", 0)) * factor, 2),
                "proteinG": round(safe_float(r.get("Proteins", 0)) * factor, 2),
                "carbsG": round(safe_float(r.get("Carbohydrates", 0)) * factor, 2),
                "fatG": round(safe_float(r.get("Fats", 0)) * factor, 2),
                "fiberG": round(safe_float(r.get("Fiber", 0)) * factor, 2),
                "category": str(r.get("Category", r.get("Type", "Indian"))).strip() or "Indian",
                "region": str(r.get("Region", "")).strip(),
                "servingGrams": weight,
                "glycemicIndex": 50, "satietyIndex": 60,
                "sourceTag": "nutrition_cf",
                "defaultServing": str(r.get("Serving", "100g")).strip(),
            })
    rows.extend(batch)
    print(f"[src4] {len(batch)} rows from nutrition_cf - Sheet5.csv")

# ── Source 5: Food_Nutrition_Dataset.csv (global, lower priority) ─────────────
src5 = BASE / "Food_Nutrition_Dataset.csv"
if src5.exists():
    batch = []
    with open(src5, encoding="utf-8-sig", errors="replace") as f:
        reader = csv.DictReader(f)
        for r in reader:
            name = str(r.get("food_name", "")).strip()
            if not name:
                continue
            batch.append({
                "foodName": name,
                "calories": safe_float(r.get("calories", 0)),
                "proteinG": safe_float(r.get("protein", 0)),
                "carbsG": safe_float(r.get("carbs", 0)),
                "fatG": safe_float(r.get("fat", 0)),
                "fiberG": 0.0,
                "category": str(r.get("category", "General")).strip(),
                "region": "", "servingGrams": 100.0,
                "glycemicIndex": 50, "satietyIndex": 60,
                "sourceTag": "global_nutrition", "defaultServing": "100g",
            })
    rows.extend(batch)
    print(f"[src5] {len(batch)} rows from Food_Nutrition_Dataset.csv")

print(f"\nTotal before dedup: {len(rows)}")

# ── Deduplication ──────────────────────────────────────────────────────────────
seen = {}
for row in rows:
    norm = re.sub(r"\s*\(.*?\)", "", row["foodName"].lower().strip())
    norm = re.sub(r"\s+", " ", norm).strip()
    existing = seen.get(norm)
    if existing is None:
        seen[norm] = row
    else:
        if PRIORITY.get(row["sourceTag"], 99) < PRIORITY.get(existing["sourceTag"], 99):
            seen[norm] = row

deduped = list(seen.values())
print(f"Total after dedup:  {len(deduped)}")

# ── Assign stable IDs ──────────────────────────────────────────────────────────
final = []
for i, row in enumerate(deduped, start=1):
    final.append({
        "foodId": f"ind_{i:05d}",
        "foodName": row["foodName"],
        "defaultServing": row["defaultServing"],
        "calories": row["calories"],
        "proteinG": row["proteinG"],
        "carbsG": row["carbsG"],
        "fatG": row["fatG"],
        "fiberG": row["fiberG"],
        "glycemicIndex": row["glycemicIndex"],
        "satietyIndex": row["satietyIndex"],
        "category": row["category"],
        "region": row.get("region", ""),
        "servingGrams": row["servingGrams"],
        "sourceTag": row["sourceTag"],
    })

# ── Full JSON ──────────────────────────────────────────────────────────────────
full_json = OUT / "food_references_seed.json"
with open(full_json, "w", encoding="utf-8") as f:
    json.dump(final, f, ensure_ascii=False, indent=2)
print(f"\nWritten: {full_json}  ({full_json.stat().st_size // 1024} KB)")

# ── Trimmed 5000-item JSON for APK bundle ─────────────────────────────────────
priority_order = sorted(final, key=lambda x: PRIORITY.get(x["sourceTag"], 99))
trimmed = priority_order[:5000]
trimmed_json = OUT / "food_seed_5000.json"
with open(trimmed_json, "w", encoding="utf-8") as f:
    json.dump(trimmed, f, ensure_ascii=False, separators=(",", ":"))
print(f"Written: {trimmed_json}  ({trimmed_json.stat().st_size // 1024} KB)")

# ── SQL inserts ────────────────────────────────────────────────────────────────
BATCH_SIZE = 200
def esc(s): return str(s).replace("'", "''")

sql_out = OUT / "food_references_seed.sql"
with open(sql_out, "w", encoding="utf-8") as f:
    f.write("-- Food references seed generated by build_food_db.py\n")
    f.write("DELETE FROM food_references;\n\n")
    for i in range(0, len(final), BATCH_SIZE):
        batch = final[i:i + BATCH_SIZE]
        vals = []
        for item in batch:
            vals.append(
                f"('{esc(item['foodId'])}','{esc(item['foodName'])}','{esc(item['defaultServing'])}',"
                f"{item['calories']},{item['proteinG']},{item['carbsG']},{item['fatG']},"
                f"{item['glycemicIndex']},{item['fiberG']},{item['satietyIndex']},"
                f"'{esc(item['category'])}','{esc(item['region'])}',"
                f"{item['servingGrams']},'{esc(item['sourceTag'])}')"
            )
        f.write(
            "INSERT INTO food_references "
            "(foodId,foodName,defaultServing,calories,proteinG,carbsG,fatG,"
            "glycemicIndex,fiberG,satietyIndex,category,region,servingGrams,sourceTag) VALUES\n"
            + ",\n".join(vals) + ";\n\n"
        )

print(f"Written: {sql_out}  ({sql_out.stat().st_size // 1024} KB)")
print("\nDone!")
