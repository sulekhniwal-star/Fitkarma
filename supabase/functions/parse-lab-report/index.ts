// supabase/functions/parse-lab-report/index.ts
// Receives:  { storagePath: string, userId: string }
// Returns:   { resultsJson: LabResult[], executiveSummary: string, executiveSummaryHindi: string }
// Uses Groq llama-3.2-11b-vision to OCR and structure a lab report PDF.

import { serve } from 'https://deno.land/std@0.168.0/http/server.ts';
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';
import Groq from 'https://esm.sh/groq-sdk';

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
};

const groq = new Groq({ apiKey: Deno.env.get('GROQ_API_KEY')! });
const supabase = createClient(
  Deno.env.get('SUPABASE_URL')!,
  Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!,
);

serve(async (req: Request) => {
  if (req.method === 'OPTIONS') return new Response('ok', { headers: corsHeaders });

  try {
    const authHeader = req.headers.get('Authorization');
    if (!authHeader) return errorResponse('AUTH_REQUIRED', 'Missing Authorization header', 401);

    const { data: { user }, error: authError } = await supabase.auth.getUser(
      authHeader.replace('Bearer ', ''),
    );
    if (authError || !user) return errorResponse('AUTH_REQUIRED', 'Invalid session', 401);

    const { storagePath, userId } = await req.json();
    if (!storagePath || !userId) return errorResponse('VALIDATION_FAILED', 'storagePath and userId are required', 400);
    if (!storagePath.startsWith(user.id + '/')) return errorResponse('AUTH_REQUIRED', 'Access denied to this file', 403);

    const { data: urlData, error: urlError } = await supabase.storage
      .from('clinical-dossiers')
      .createSignedUrl(storagePath, 120);

    if (urlError || !urlData?.signedUrl) return errorResponse('UPSTREAM_FAILURE', 'Could not access the uploaded file', 500);

    const completion = await groq.chat.completions.create({
      model: 'llama-3.2-11b-vision-preview',
      messages: [{
        role: 'user',
        content: [
          {
            type: 'text',
            text: 'You are a medical lab report parser for Indian patients. Extract ALL lab test values into structured JSON. Return ONLY valid JSON (no markdown): { "results": [{ "testName": "", "value": "", "unit": "", "referenceRange": "", "isAbnormal": false }], "executiveSummary": "", "executiveSummaryHindi": "" }',
          },
          { type: 'image_url', image_url: { url: urlData.signedUrl } },
        ],
      }],
      max_tokens: 2048,
      temperature: 0.1,
    });

    const rawContent = completion.choices[0]?.message?.content ?? '{}';
    let parsed: { results?: unknown[]; executiveSummary?: string; executiveSummaryHindi?: string; };
    try {
      parsed = JSON.parse(rawContent);
    } catch {
      const cleaned = rawContent.replace(/```json?\n?/g, '').replace(/```/g, '').trim();
      try { parsed = JSON.parse(cleaned); }
      catch { return errorResponse('UPSTREAM_FAILURE', 'Failed to parse AI response', 500); }
    }

    return new Response(
      JSON.stringify({ resultsJson: parsed.results ?? [], executiveSummary: parsed.executiveSummary ?? '', executiveSummaryHindi: parsed.executiveSummaryHindi ?? '' }),
      { headers: { ...corsHeaders, 'Content-Type': 'application/json' }, status: 200 },
    );
  } catch (err) {
    console.error('[parse-lab-report] error:', err);
    return errorResponse('INTERNAL', 'An internal error occurred', 500);
  }
});

function errorResponse(code: string, message: string, status: number): Response {
  return new Response(JSON.stringify({ error: { code, message } }), { headers: { ...corsHeaders, 'Content-Type': 'application/json' }, status });
}
