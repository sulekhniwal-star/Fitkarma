/// <reference types="@cloudflare/workers-types" />

import healthOsWorker from './fitkarma-health-os/index';
import socialWorker from './fitkarma-social/index';
import marketplaceWorker from './fitkarma-marketplace/index';
import coresWorker from './fitkarma-cores/index';
import coachWorker from './fitkarma-coach/index';
import mealVisionWorker from './fitkarma-meal-vision/index';
import insightsWorker from './fitkarma-insights/index';
import reportsWorker from './fitkarma-reports/index';
import whatsappWorker from './fitkarma-whatsapp/index';
import foodDbWorker from './fitkarma-food-db/index';

export interface Env {
  DB: D1Database;
  GROQ_API_KEY: string;
  WHATSAPP_API_TOKEN?: string;
  WHATSAPP_VERIFY_TOKEN?: string;
  ENVIRONMENT?: string;
}

export default {
  async fetch(request: Request, env: Env, ctx: ExecutionContext): Promise<Response> {
    const url = new URL(request.url);
    const path = url.pathname;

    // Master API Route Dispatcher
    if (path.startsWith('/health-os')) {
      return healthOsWorker.fetch(request, env, ctx);
    }
    if (path.startsWith('/social')) {
      return socialWorker.fetch(request, env, ctx);
    }
    if (path.startsWith('/marketplace')) {
      return marketplaceWorker.fetch(request, env, ctx);
    }
    if (path.startsWith('/cores')) {
      return coresWorker.fetch(request, env, ctx);
    }
    if (path.startsWith('/coach')) {
      return coachWorker.fetch(request, env, ctx);
    }
    if (path.startsWith('/meal-vision')) {
      return mealVisionWorker.fetch(request, env, ctx);
    }
    if (path.startsWith('/insights')) {
      return insightsWorker.fetch(request, env, ctx);
    }
    if (path.startsWith('/reports')) {
      return reportsWorker.fetch(request, env, ctx);
    }
    if (path.startsWith('/whatsapp')) {
      return whatsappWorker.fetch(request, env, ctx);
    }
    if (path.startsWith('/food-db')) {
      return foodDbWorker.fetch(request, env, ctx);
    }

    // Default Health Status
    return new Response(
      JSON.stringify({
        app: 'FitKarma Edge API',
        version: '1.0.0',
        environment: env.ENVIRONMENT ?? 'production',
        services: [
          'fitkarma-health-os',
          'fitkarma-social',
          'fitkarma-marketplace',
          'fitkarma-cores',
          'fitkarma-coach',
          'fitkarma-meal-vision',
          'fitkarma-insights',
          'fitkarma-reports',
          'fitkarma-whatsapp',
          'fitkarma-food-db',
        ],
      }),
      { headers: { 'Content-Type': 'application/json' } }
    );
  },

  async scheduled(event: ScheduledEvent, env: Env, ctx: ExecutionContext): Promise<void> {
    // Scheduled Cron Router
    const cron = event.cron;
    console.log(`[FitKarma Edge Scheduler] Cron triggered: ${cron}`);

    // Sweep 15-minute Health OS Workflow Fan-out
    await healthOsWorker.scheduled(event, env, ctx);

    // Insights daily 6 AM IST check
    if (cron === '30 0 * * *' || cron === '0 6 * * *') {
      await insightsWorker.scheduled(event, env, ctx);
    }

    // Monthly 1st of month report check
    if (cron === '0 0 1 * *') {
      await reportsWorker.scheduled(event, env, ctx);
    }
  },
};
