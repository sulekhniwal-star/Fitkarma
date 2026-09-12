// Follow this setup guide to integrate the Deno language server with your editor:
// https://deno.land/manual/getting_started/setup_your_environment

import { serve } from "https://deno.land/std@0.168.0/http/server.ts";

const GROQ_API_KEY = Deno.env.get("GROQ_API_KEY") || "";

interface CoachRequest {
  session_id: string;
  message: string;
  context?: Record<string, any>;
}

serve(async (req: Request) => {
  // CORS Headers
  if (req.method === "OPTIONS") {
    return new Response("ok", {
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
      },
    });
  }

  try {
    const { session_id, message, context } = (await req.json()) as CoachRequest;

    if (!message || message.trim() === "") {
      return new Response(
        JSON.stringify({ error: { code: "INVALID_REQUEST", message: "Message cannot be empty." } }),
        { status: 400, headers: { "Content-Type": "application/json" } }
      );
    }

    // Build multi-modal system instruction
    const userMeta = context?.user_meta || {};
    const dosha = context?.ayurvedic_prakriti || {};
    const readiness = context?.daily_readiness || {};
    const metabolic = context?.metabolic_targets || {};

    const systemPrompt = `You are FitKarma Coach — India's intelligent, culturally-attuned, evidence-based AI Health & Fitness Coach.
User Profile: ${userMeta.gender || "User"}, ${userMeta.age || 26} yrs, ${userMeta.weight_kg || 70} kg.
Goal: ${userMeta.primary_goal || "fitness"}.
Ayurvedic Prakriti: ${dosha.dominant_dosha || "pitta"} dominant.
Readiness Score: ${readiness.score || 75}/100 (${readiness.state || "steady"}).
Daily Target: ${metabolic.target_calories || 2000} kcal (Protein: ${metabolic.protein_grams || 120}g).

RULES:
1. Provide actionable, concise, empathetic guidance grounded in Indian food (sattu, paneer, sprouts, dal) and practical lifestyle habits.
2. Adapt advice to readiness: if readiness < 60, focus on active recovery, sleep, and hydration.
3. Use natural bilingual English/Hindi terms where helpful.`;

    let reply = "";
    let modelUsed = "llama-3.3-70b";

    // If GROQ_API_KEY is configured in Supabase Secrets
    if (GROQ_API_KEY) {
      const groqResponse = await fetch("https://api.groq.com/openai/v1/chat/completions", {
        method: "POST",
        headers: {
          "Authorization": `Bearer ${GROQ_API_KEY}`,
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          model: "llama-3.3-70b-versatile",
          messages: [
            { role: "system", content: systemPrompt },
            { role: "user", content: message },
          ],
          temperature: 0.6,
          max_tokens: 500,
        }),
      });

      if (groqResponse.ok) {
        const groqData = await groqResponse.json();
        reply = groqData.choices?.[0]?.message?.content || "";
      }
    }

    // Fallback response if no Groq key or connection issue
    if (!reply) {
      modelUsed = "offline-fallback";
      if (message.toLowerCase().includes("protein") || message.toLowerCase().includes("food")) {
        reply = "For high-protein Indian options, consider Sattu drink (20g protein / 100g), Paneer bhurji (18g/100g), Sprouted Moong salad, or Soya chunks (52g/100g). What meal are you planning?";
      } else if (message.toLowerCase().includes("workout") || message.toLowerCase().includes("ready")) {
        reply = `With your current readiness score of ${readiness.score || 75}, your body is in ${readiness.state || "steady"} state. Maintain structured overload with standard rest intervals.`;
      } else {
        reply = `I am here to guide your training, Indian nutrition, and recovery. Based on your ${dosha.dominant_dosha || "pitta"} profile, how can I support your fitness goals today?`;
      }
    }

    return new Response(
      JSON.stringify({
        session_id,
        reply,
        model_used: modelUsed,
        timestamp: new Date().toISOString(),
      }),
      {
        status: 200,
        headers: {
          "Content-Type": "application/json",
          "Access-Control-Allow-Origin": "*",
        },
      }
    );
  } catch (error) {
    return new Response(
      JSON.stringify({ error: { code: "SERVER_ERROR", message: String(error) } }),
      { status: 500, headers: { "Content-Type": "application/json" } }
    );
  }
});
