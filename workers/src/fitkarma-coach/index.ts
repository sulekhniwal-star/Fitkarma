/// <reference types="@cloudflare/workers-types" />

export interface Env {
  DB: D1Database;
  GROQ_API_KEY: string;
}

export default {
  async fetch(request: Request, env: Env, ctx: ExecutionContext): Promise<Response> {
    if (request.method !== "POST") {
      return new Response("Method not allowed", { status: 405 });
    }

    try {
      const body: any = await request.json();
      const { prompt, modelTier } = body;

      let model = "llama3-8b-8192";
      if (modelTier === "medium") {
        model = "llama3-70b-8192";
      } else if (modelTier === "large") {
        model = "mixtral-8x22b-instruct";
      }

      return new Response(
        JSON.stringify({
          response: `AI Coach response for [${model}]: Processing "${prompt}"`,
          modelUsed: model,
          cached: false,
        }),
        { headers: { "Content-Type": "application/json" } }
      );
    } catch (error: any) {
      return new Response(JSON.stringify({ error: error.message }), { status: 500 });
    }
  },
};
