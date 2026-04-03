import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { createClient } from "npm:@supabase/supabase-js@2";

import { fetchFcmTokens, sendToTokens } from "../_shared/fcm.ts";
import { getFirebaseMessaging } from "../_shared/firebase.ts";

const PUBLIC_TOPIC = "all";
const PUSH_CHANNEL_ID = "push_notifications";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};

Deno.serve(async (req) => {
  try {
    if (req.method === "OPTIONS") {
      return new Response("ok", { headers: corsHeaders });
    }

    if (req.method !== "POST") {
      return jsonResponse({ error: "Method not allowed" }, 405);
    }

    const authHeader = req.headers.get("Authorization");
    if (!authHeader) {
      return jsonResponse({ error: "Missing Authorization header" }, 401);
    }

    const supabase = createClient(
      Deno.env.get("SUPABASE_URL") ?? "",
      Deno.env.get("SUPABASE_ANON_KEY") ?? "",
      { global: { headers: { Authorization: authHeader } } },
    );
    const serviceRoleClient = createServiceRoleClient();

    const { data: isAdmin, error: isAdminError } = await supabase.rpc(
      "is_admin",
    );

    if (isAdminError) throw isAdminError;
    if (!isAdmin) {
      return jsonResponse(
        { error: "Only admins can send notifications" },
        403,
      );
    }

    const { userId, title, body, payload } = await req.json();
    const resolvedPayload = payload
      ? String(payload)
      : JSON.stringify({
          type: "admin_notification",
          title,
          body,
        });

    if (!title || !body) {
      return jsonResponse({ error: "Missing title or body" }, 400);
    }

    const messaging = getFirebaseMessaging();

    if (userId) {
      const userTokens = await fetchFcmTokens(serviceRoleClient, userId);
      if (userTokens.length === 0) {
        return jsonResponse({ error: "User has no FCM tokens" }, 404);
      }

      const response = await sendToTokens(
        messaging,
        userTokens,
        {
          title,
          body,
          data: { payload: resolvedPayload },
        },
        PUSH_CHANNEL_ID,
      );

      if (response.successCount == 0) {
        return jsonResponse(
          {
            error: "Notification was not delivered to any device",
            ...response,
          },
          422,
        );
      }

      return jsonResponse(response);
    }

    const response = await sendToTokens(
      messaging,
      [],
      {
        title,
        body,
        data: { payload: resolvedPayload },
      },
      PUSH_CHANNEL_ID,
      PUBLIC_TOPIC,
    );

    if (response.successCount == 0) {
      return jsonResponse(
        {
          error: "Notification was not delivered to any device",
          ...response,
        },
        422,
      );
    }

    return jsonResponse(response);
  } catch (error) {
    const message = error instanceof Error ? error.message : String(error);
    console.error("send-push failed:", error);
    return jsonResponse({ error: message }, 500);
  }
});

function jsonResponse(body: unknown, status = 200) {
  return new Response(JSON.stringify(body), {
    status,
    headers: {
      ...corsHeaders,
      "Content-Type": "application/json",
    },
  });
}

function createServiceRoleClient() {
  const supabaseUrl = Deno.env.get("SUPABASE_URL") ?? "";
  const serviceRoleKey =
    Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ??
    Deno.env.get("SERVICE_ROLE_KEY") ??
    "";

  if (!supabaseUrl || !serviceRoleKey) {
    throw new Error("SUPABASE_SERVICE_ROLE_KEY is not configured");
  }

  return createClient(supabaseUrl, serviceRoleKey);
}
