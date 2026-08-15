/// <reference types="@cloudflare/workers-types" />

export interface GroqMessage {
  role: 'system' | 'user' | 'assistant';
  content: string | Array<{ type: string; text?: string; image_url?: { url: string } }>;
}

export interface GroqRequestOptions {
  model?: string;
  messages: GroqMessage[];
  response_format?: { type: 'json_object' | 'text' };
  max_tokens?: number;
  temperature?: number;
  apiKey: string;
}

export interface GroqResponse {
  content: string;
  model: string;
  usage?: {
    prompt_tokens: number;
    completion_tokens: number;
    total_tokens: number;
  };
}

/**
 * Executes LLM / Vision call to Groq API with JSON mode guarantees
 */
export async function callGroq(options: GroqRequestOptions): Promise<GroqResponse> {
  const model = options.model ?? 'llama-3.1-70b-versatile';
  const apiKey = options.apiKey;

  if (!apiKey) {
    throw new Error('GROQ_API_KEY is not configured in environment bindings');
  }

  const payload: Record<string, unknown> = {
    model,
    messages: options.messages,
    max_tokens: options.max_tokens ?? 350,
    temperature: options.temperature ?? 0.2,
  };

  if (options.response_format) {
    payload.response_format = options.response_format;
  }

  const res = await fetch('https://api.groq.com/openai/v1/chat/completions', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      Authorization: `Bearer ${apiKey}`,
    },
    body: JSON.stringify(payload),
  });

  if (!res.ok) {
    const errorText = await res.text();
    throw new Error(`Groq API error (${res.status}): ${errorText}`);
  }

  const data = (await res.json()) as {
    choices?: Array<{ message?: { content?: string } }>;
    model?: string;
    usage?: { prompt_tokens: number; completion_tokens: number; total_tokens: number };
  };

  const content = data.choices?.[0]?.message?.content ?? '';
  return {
    content,
    model: data.model ?? model,
    usage: data.usage,
  };
}
