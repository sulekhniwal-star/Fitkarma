-- ============================================================================
-- FitKarma Postgres Seed Data: Indian Nutrition DB, Badges & Communities
-- ============================================================================

-- ----------------------------------------------------------------------------
-- 1. Master Badges Catalog
-- ----------------------------------------------------------------------------
INSERT INTO public.badges (badge_key, name, hindi_name, description, icon_name, category, tier, karma_reward)
VALUES 
    ('streak_7_days', 'Sadhana Starter', 'साधना प्रारंभ', 'Completed 7 consecutive days of daily health rituals.', 'flame', 'streak', 'bronze', 100),
    ('streak_30_days', 'Tapasya Master', 'तपस्या सिद्ध', 'Completed 30 consecutive days of unwavering adherence.', 'trophy', 'streak', 'gold', 500),
    ('streak_100_days', 'Sankalpa Yogi', 'संकल्प योगी', 'Reached 100 days of consistent lifestyle discipline.', 'award', 'streak', 'diamond', 2000),
    ('protein_target_hit', 'Shakti Builder', 'शक्ति वर्धक', 'Hit daily vegetarian protein target using optimal Indian sources.', 'muscle', 'nutrition', 'silver', 150),
    ('ayurvedic_balance', 'Tridosha Harmony', 'त्रिदोष समता', 'Balanced daily meals adhering to your dominant dosha profile.', 'leaf', 'ayurveda', 'gold', 300),
    ('cgm_in_range_90', 'Glycemic Archer', 'ग्लूकोज रक्षक', 'Maintained glucose time-in-range above 90% for 48 hours.', 'activity', 'readiness', 'platinum', 400),
    ('workout_century', '100 Workouts', 'शतक वीर', 'Completed 100 logged workout sessions with progressive overload.', 'dumbbell', 'strength', 'platinum', 1000),
    ('squad_leader_win', 'Sangha Champion', 'संघ नायक', 'Led your squad to top rank in weekly step and fitness challenge.', 'users', 'community', 'gold', 350)
ON CONFLICT (badge_key) DO NOTHING;

-- ----------------------------------------------------------------------------
-- 2. Public Communities (Sanghas)
-- ----------------------------------------------------------------------------
INSERT INTO public.communities (name, slug, description, category, icon_url)
VALUES
    ('PCOS Warriors India', 'pcos-warriors-india', 'Evidence-based hormonal wellness, insulin-sensitizing Indian diets, and cycle-synced workouts.', 'pcos', 'https://fitkarma.sulekhniwal.com/assets/icons/pcos.png'),
    ('Vegetarian & Vegan Hypertrophy', 'veg-hypertrophy', 'High protein Indian vegetarian bodybuilding — Sattu, Soya chunks, Paneer, Whey, and Dal combinations.', 'hypertrophy', 'https://fitkarma.sulekhniwal.com/assets/icons/protein.png'),
    ('Ayurvedic Longevity & Dinacharya', 'ayurvedic-longevity', 'Daily circadian routines, seasonal ritu-charya, dosha balancing, and gut-friendly Indian cooking.', 'ayurveda_lifestyle', 'https://fitkarma.sulekhniwal.com/assets/icons/ayurveda.png'),
    ('Indian Runners & Marathoners', 'indian-runners', 'Endurance training, humid AQI adaptations, race day carbs (poha, banana, sattu), and recovery.', 'running', 'https://fitkarma.sulekhniwal.com/assets/icons/running.png'),
    ('CGM & Metabolic Freedom', 'cgm-metabolic-freedom', 'Real-time glucose telemetry sharing, post-prandial walk strategies, and street food spike mitigation.', 'diabetes_cgm', 'https://fitkarma.sulekhniwal.com/assets/icons/cgm.png')
ON CONFLICT (slug) DO NOTHING;

-- ----------------------------------------------------------------------------
-- 3. Indian Food & Recipe Database (High-protein, Regional, Street Food & Swaps)
-- ----------------------------------------------------------------------------
INSERT INTO public.food_items (name, hindi_name, region, category, serving_unit, serving_size_g, calories, protein_g, carbs_g, fats_g, fiber_g, glycemic_index, dosha_affinity, is_vegetarian, is_vegan, is_street_food, micronutrients, healthy_swaps, tags)
VALUES
    -- High Protein Vegetarian Heroes
    ('Sattu Drink (Roasted Chana Flour)', 'सत्तू नमकीन शरबत', 'east_india', 'beverage', 'glass', 250.0, 185.0, 14.5, 26.0, 2.8, 8.2, 28, 'pitta_pacifying', true, true, false, '{"iron_mg": 4.5, "magnesium_mg": 68.0}', '[{"name": "Add lemon and roasted jeera", "benefit": "Enhances iron absorption and digestion"}]', ARRAY['high_protein', 'desi_superfood', 'gut_friendly', 'summer_coolant']),
    ('Low-Fat Paneer Bhurji', 'पनीर भुर्जी', 'north_india', 'vegetable_curry', 'katori', 150.0, 195.0, 18.2, 5.4, 11.5, 2.1, 15, 'vata_pacifying', true, false, false, '{"calcium_mg": 380.0, "vitamin_d_iu": 15.0}', '[{"name": "Tofu Bhurji", "benefit": "Reduces saturated fat for lipid control"}]', ARRAY['high_protein', 'keto_friendly', 'low_carb']),
    ('Soya Chunks Curry', 'सोया चंक्स करी', 'pan_india', 'dal_pulse', 'katori', 150.0, 160.0, 22.5, 11.0, 3.2, 7.5, 20, 'kapha_pacifying', true, true, false, '{"iron_mg": 6.8, "zinc_mg": 2.4}', '[]', ARRAY['muscle_building', 'super_high_protein', 'budget_friendly']),
    ('Sprouted Moong Chaat', 'अंकुरित मूंग चाट', 'pan_india', 'snack', 'katori', 120.0, 138.0, 9.6, 22.0, 1.2, 5.8, 25, 'tridoshic', true, true, true, '{"vitamin_c_mg": 18.0, "folate_mcg": 90.0}', '[]', ARRAY['enzymes', 'high_fiber', 'clean_eating']),

    -- Everyday Indian Grains & Rotis
    ('Whole Wheat Phulka (without Ghee)', 'गेहूं की रोटी / फुल्का', 'north_india', 'grain_roti', 'roti', 35.0, 85.0, 3.2, 17.5, 0.4, 2.8, 55, 'vata_pacifying', true, true, false, '{"fiber_g": 2.8}', '[{"name": "Multigrain Roti (Wheat + Sattu + Oats)", "benefit": "Boosts protein and lowers GI"}]', ARRAY['staple', 'daily_grain']),
    ('Jowar Roti (Sorghum Flatbread)', 'ज्वार की रोटी', 'west_india', 'grain_roti', 'roti', 45.0, 110.0, 3.8, 22.4, 1.1, 4.2, 48, 'kapha_pacifying', true, true, false, '{"calcium_mg": 25.0, "iron_mg": 2.1}', '[]', ARRAY['gluten_free', 'diabetic_friendly', 'fiber_rich']),
    ('Ragi Mudde / Ragi Roti (Finger Millet)', 'रागी रोटी', 'south_india', 'grain_roti', 'piece', 50.0, 130.0, 3.5, 27.0, 0.8, 5.0, 52, 'pitta_pacifying', true, true, false, '{"calcium_mg": 344.0}', '[]', ARRAY['calcium_rich', 'bone_density', 'gluten_free']),

    -- Traditional Dals & Soups
    ('Yellow Moong Dal (Tadka)', 'पीली मूंग दाल', 'pan_india', 'dal_pulse', 'katori', 150.0, 140.0, 8.5, 20.0, 3.0, 4.5, 38, 'tridoshic', true, true, false, '{"potassium_mg": 310.0}', '[]', ARRAY['easy_digestion', 'ayurvedic_healing', 'sick_day']),
    ('Kala Chana Masala (Black Chickpeas)', 'काला चना मसाला', 'north_india', 'dal_pulse', 'katori', 150.0, 180.0, 10.2, 26.5, 3.8, 7.8, 32, 'kapha_pacifying', true, true, false, '{"iron_mg": 4.2, "fiber_g": 7.8}', '[]', ARRAY['slow_release_energy', 'low_gi', 'fiber_champion']),
    ('South Indian Sambar (Drumstick & Veg)', 'सांभर', 'south_india', 'dal_pulse', 'katori', 150.0, 115.0, 5.5, 18.0, 2.5, 4.2, 35, 'tridoshic', true, true, false, '{"vitamin_a_iu": 450.0}', '[]', ARRAY['polyphenols', 'antioxidant', 'tamarind_digestive']),

    -- South Indian Breakfast Classics
    ('Steamed Idli (2 pieces with Chutney)', 'इडली सांभर', 'south_india', 'grain_roti', 'plate', 140.0, 160.0, 5.2, 32.0, 1.2, 2.4, 60, 'pitta_pacifying', true, true, false, '{"gut_bacteria_cfu": "fermented"}', '[{"name": "Ragi Oats Idli", "benefit": "Lower glycemic impact"}]', ARRAY['fermented', 'gut_health', 'oil_free']),
    ('Plain Dosa (Crispy)', 'सादा डोसा', 'south_india', 'grain_roti', 'piece', 100.0, 165.0, 3.8, 28.0, 4.2, 1.8, 65, 'vata_pacifying', true, true, false, '{}', '[{"name": "Pesarattu (Green Moong Dosa)", "benefit": "Triples protein content to 14g"}]', ARRAY['breakfast_favorite', 'crispy']),

    -- Street Food & Smart Swaps
    ('Pani Puri / Golgappa (6 puris with mint water)', 'पानी पूरी / गोलगप्पा', 'pan_india', 'street_food', 'plate', 150.0, 210.0, 3.5, 36.0, 5.5, 2.8, 62, 'pitta_pacifying', true, true, true, '{"menthol_mg": 12.0}', '[{"name": "Moong Sprout filling & zero-sugar hing water", "benefit": "Lowers glycemic spike by 40%"}]', ARRAY['street_food', 'craving_buster']),
    ('Air-Fried Samosa (1 piece)', 'समोसा (एयर फ्राइड)', 'north_india', 'street_food', 'piece', 75.0, 140.0, 3.2, 21.0, 4.8, 2.2, 58, 'kapha_pacifying', true, true, true, '{}', '[{"name": "Baked Paneer Samosa", "benefit": "70% less oil compared to deep fried"}]', ARRAY['guilt_free_snack', 'air_fried']),
    ('Poha with Peanuts & Veggies', 'कांदा पोहा', 'west_india', 'grain_roti', 'katori', 150.0, 195.0, 5.4, 34.0, 4.5, 3.2, 55, 'vata_pacifying', true, true, false, '{"iron_mg": 3.8}', '[]', ARRAY['quick_energy', 'breakfast', 'iron_fortified'])
ON CONFLICT DO NOTHING;
