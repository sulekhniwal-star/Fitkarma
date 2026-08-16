-- §DB Food References — Migration 0002
-- Extends food_references table with richer nutritional columns and
-- adds FTS5 virtual table for fast full-text food name search in D1.
-- Run AFTER 0001_v17_d1_schema.sql

-- Drop old minimal table if it exists (schema upgrade)
DROP TABLE IF EXISTS food_references;

-- Recreate with extended schema
CREATE TABLE IF NOT EXISTS food_references (
    foodId          TEXT    NOT NULL,
    foodName        TEXT    NOT NULL,
    defaultServing  TEXT    NOT NULL DEFAULT '100g',
    calories        REAL    NOT NULL DEFAULT 0.0,
    proteinG        REAL    NOT NULL DEFAULT 0.0,
    carbsG          REAL    NOT NULL DEFAULT 0.0,
    fatG            REAL    NOT NULL DEFAULT 0.0,
    glycemicIndex   INTEGER NOT NULL DEFAULT 50,
    fiberG          REAL    NOT NULL DEFAULT 0.0,
    satietyIndex    INTEGER NOT NULL DEFAULT 60,
    -- Extended columns (v18)
    category        TEXT    NOT NULL DEFAULT 'Indian',
    region          TEXT    NOT NULL DEFAULT '',
    servingGrams    REAL    NOT NULL DEFAULT 100.0,
    sourceTag       TEXT    NOT NULL DEFAULT 'unknown',
    CONSTRAINT PK_food_references PRIMARY KEY (foodId)
);

CREATE INDEX IF NOT EXISTS IX_food_references_name
    ON food_references (foodName COLLATE NOCASE);

CREATE INDEX IF NOT EXISTS IX_food_references_category
    ON food_references (category);

-- FTS5 virtual table for full-text food name search
-- D1 supports SQLite FTS5 natively
CREATE VIRTUAL TABLE IF NOT EXISTS food_fts
    USING fts5(
        foodId UNINDEXED,
        foodName,
        category,
        content='food_references',
        content_rowid='rowid'
    );

-- Trigger to keep FTS in sync on INSERT
CREATE TRIGGER IF NOT EXISTS food_fts_ai
    AFTER INSERT ON food_references BEGIN
        INSERT INTO food_fts(rowid, foodId, foodName, category)
        VALUES (new.rowid, new.foodId, new.foodName, new.category);
    END;

-- Trigger to keep FTS in sync on UPDATE
CREATE TRIGGER IF NOT EXISTS food_fts_au
    AFTER UPDATE ON food_references BEGIN
        INSERT INTO food_fts(food_fts, rowid, foodId, foodName, category)
        VALUES ('delete', old.rowid, old.foodId, old.foodName, old.category);
        INSERT INTO food_fts(rowid, foodId, foodName, category)
        VALUES (new.rowid, new.foodId, new.foodName, new.category);
    END;

-- Trigger to keep FTS in sync on DELETE
CREATE TRIGGER IF NOT EXISTS food_fts_ad
    AFTER DELETE ON food_references BEGIN
        INSERT INTO food_fts(food_fts, rowid, foodId, foodName, category)
        VALUES ('delete', old.rowid, old.foodId, old.foodName, old.category);
    END;
