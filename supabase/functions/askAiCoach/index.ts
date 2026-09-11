// FitKarma AI Coach Edge Function (Groq Multi-Model Routing)
import { serve } from 'https://deno.land/std@0.177.0/http/server.ts';
import { corsHeaders, handleCors } from '../_shared/cors.ts';

interface RequestBody {
  tier?: 'TINY' | 'MEDIUM' | 'LARGE';
  messages?: Array<{ role: string; content: string }>;
  prompt?: string;
  context?: Record<string, unknown>;
}

const GROQ_API_URL = 'https://api.groq.com/openai/v1/chat/completions';

// Model mapping based on FitKarma tier architecture
const MODEL_TIERS: Record<string, string> = {
  TINY: 'llama-3.1-8b-instant',
  MEDIUM: 'mixtral-8x7b-32768',
  LARGE: 'llama-3.3-70b-versatile',
};

serve(async (req: Request) => {
  const corsResponse = handleCors(req);
  if (corsResponse) return corsResponse;

  try {
    const body: RequestBody = await req.json();
    const tier = body.tier || 'MEDIUM';
    const model = MODEL_TIERS[tier] || MODEL_TIERS.MEDIUM;

    const groqApiKey = Deno.env.get('GROQ_API_KEY');

    let messages = body.messages;
    if (!messages || messages.length === 0) {
      messages = [
        {
          role: 'system',
          content:
            'You are FitKarma AI Coach, India’s intelligent health OS coach. Provide actionable, culturally tailored health, nutrition, and fitness advice for Indian lifestyles, doshas, and regional diets.',
        },
        {
          role: 'user',
          content: body.prompt || 'How can I optimize my daily health routine?',
        },
      ];
    }

    if (groqApiKey) {
      const groqResponse = await fetch(GROQ_API_URL, {
        method: 'POST',
        headers: {
          'Authorization': `Bearer ${groqApiKey}`,
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          model,
          messages,
          temperature: 0.7,
          max_tokens: 800,
        }),
      });

      if (groqResponse.ok) {
        const groqData = await groqResponse.json();
        const responseText =
          groqData.choices?.[0]?.message?.content ||
          'Focus on balanced vegetarian protein (Sattu, Paneer, Moong Dal) and progressive overload today.';

        return new Response(
          JSON.stringify({
            status: 'success',
            model,
            response: responseText,
          }),
          {
            headers: { ...corsHeaders, 'Content-Type': 'application/json' },
            status: 200,
          },
        );
      }
    }

    // Fallback response if Groq API key is not configured or rate-limited
    const userQuery = messages[messages.length - 1]?.content || '';
    const fallbackText = `[FitKarma AI Coach] Based on your Indian nutritional profile and readiness score, focus on: 1) Prioritizing 25g+ protein per meal via Paneer, Sattu, or Moong Sprouts, 2) Staying hydrated with electrolyte-rich water, and 3) Completing your planned progressive overload session today.`;

    return new Response(
      JSON.stringify({
        status: 'success',
        model: 'fitkarma-deterministic-fallback',
        response: fallbackText,
      }),
      {
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        status: 200,
      },
    );
  } catch (error) {
    return new Response(
      JSON.stringify({
        status: 'error',
        message: error instanceof Error ? error.message : 'Internal error',
      }),
      {
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        status: 500,
      },
    );
  }
});
