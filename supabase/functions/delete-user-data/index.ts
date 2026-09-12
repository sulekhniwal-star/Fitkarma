import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    const authHeader = req.headers.get("Authorization");
    if (!authHeader) {
      return new Response(JSON.stringify({ error: "Missing Authorization header" }), {
        status: 401,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    // Service-role client to execute cascading deletion across all user-scoped tables
    const supabaseAdmin = createClient(
      Deno.env.get("SUPABASE_URL") ?? "",
      Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? ""
    );

    // Verify user JWT
    const supabaseClient = createClient(
      Deno.env.get("SUPABASE_URL") ?? "",
      Deno.env.get("SUPABASE_ANON_KEY") ?? "",
      { global: { headers: { Authorization: authHeader } } }
    );

    const {
      data: { user },
      error: userError,
    } = await supabaseClient.auth.getUser();

    if (userError || !user) {
      return new Response(JSON.stringify({ error: "Invalid user token" }), {
        status: 401,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    const userId = user.id;

    // DPDP Act 2023: Cascading deletion across all tables containing user personal data
    const userTables = [
      "user_profiles",
      "readiness_scores",
      "dosha_profiles",
      "cycle_tracking",
      "coach_sessions",
      "coach_messages",
      "biomarker_records",
      "cgm_telemetry",
      "meals",
      "grocery_lists",
      "workout_sessions",
      "karma_points",
      "habit_streaks",
      "transformation_milestones",
      "body_transformation_logs",
      "squad_members",
      "community_posts",
      "family_members",
      "biological_age_records",
      "clinical_lab_reports",
      "medications",
      "doctor_grants",
      "progress_photos",
      "body_composition_snapshots",
      "active_life_events",
      "wedding_plans",
      "entitlements",
      "coach_bookings",
      "affiliate_referrals",
    ];

    for (const table of userTables) {
      await supabaseAdmin.from(table).delete().eq("user_id", userId);
    }

    // Delete user storage artifacts (progress photos, lab reports, doctor dossiers)
    const storageBuckets = ["progress-photos", "lab-reports", "doctor-dossiers"];
    for (const bucket of storageBuckets) {
      const { data: files } = await supabaseAdmin.storage.from(bucket).list(userId);
      if (files && files.length > 0) {
        const filePaths = files.map((f) => `${userId}/${f.name}`);
        await supabaseAdmin.storage.from(bucket).remove(filePaths);
      }
    }

    // Generate cryptographic anonymized erasure receipt
    const receiptId = crypto.randomUUID();
    const anonymizedHash = await crypto.subtle.digest(
      "SHA-256",
      new TextEncoder().encode(`${userId}-${receiptId}-${Date.now()}`)
    );
    const hashHex = Array.from(new Uint8Array(anonymizedHash))
      .map((b) => b.toString(16).padStart(2, "0"))
      .join("");

    await supabaseAdmin.from("erasure_receipts").insert({
      receipt_id: receiptId,
      anonymized_hash: hashHex,
      deleted_at: new Date().toISOString(),
    });

    // Finally delete auth user record
    await supabaseAdmin.auth.admin.deleteUser(userId);

    return new Response(
      JSON.stringify({
        success: true,
        message: "All personal and health data permanently erased per DPDP Act 2023.",
        erasure_receipt_id: receiptId,
        anonymized_hash: hashHex,
      }),
      {
        status: 200,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      }
    );
  } catch (error) {
    return new Response(JSON.stringify({ error: error.message }), {
      status: 500,
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  }
});
