import "jsr:@supabase/functions-js/edge-runtime.d.ts";

import { sendToTokens } from "../_shared/fcm.ts";
import { getFirebaseMessaging } from "../_shared/firebase.ts";

const PUBLIC_TOPIC = "all";
const PUSH_CHANNEL_ID = "push_notifications";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type, x-webhook-secret",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};

const WEBHOOK_SECRET =
  Deno.env.get("FAKE_AHADITH_WEBHOOK_SECRET") ??
  "ahadith-fake-ahadith-alert-v1";

Deno.serve(async (req) => {
  try {
    if (req.method === "OPTIONS") {
      return new Response("ok", { headers: corsHeaders });
    }

    if (req.method !== "POST") {
      return jsonResponse({ error: "Method not allowed" }, 405);
    }

    const secret = req.headers.get("x-webhook-secret");
    if (secret !== WEBHOOK_SECRET) {
      return jsonResponse({ error: "Unauthorized" }, 401);
    }

    const payload = await req.json();
    const fakeAhadithId = String(payload.fake_ahadith_id ?? "").trim();
    const title = String(payload.title ?? "انتبه حديث منتشر لا يصح").trim();
    const text = String(payload.text ?? "").trim();
    const degree = String(payload.degree ?? "").trim();
    const subValidText = String(payload.sub_valid_text ?? "").trim();

    if (!fakeAhadithId || !text) {
      return jsonResponse({ error: "Missing fake hadith payload" }, 400);
    }

    const lines = [`نص الحديث: "${text}"`];
    lines.push(`الدرجة: "${degree}"`);
    if (subValidText.length > 0) {
      lines.push(`الصحيح البديل: "${subValidText}"`);
    }

    const payloadData = JSON.stringify({
      type: "fake_ahadith",
      fake_ahadith_id: fakeAhadithId,
    });
    const body = lines.join("\n");

    console.log("Broadcasting fake hadith alert", {
      fakeAhadithId,
      topic: PUBLIC_TOPIC,
      bodyLength: body.length,
      hasAlternative: subValidText.length > 0,
    });

    const messaging = getFirebaseMessaging();
    const response = await sendToTokens(
      messaging,
      [],
      {
        title,
        body,
        data: {
          payload: payloadData,
        },
      },
      PUSH_CHANNEL_ID,
      PUBLIC_TOPIC,
    );

    console.log("Fake hadith alert broadcast summary", response);

    if (response.successCount === 0) {
      return jsonResponse(
        {
          error: "Notification was not delivered to any subscribed device",
          ...response,
        },
        422,
      );
    }

    return jsonResponse({
      success: true,
      deliveryMode: "topic",
      topic: PUBLIC_TOPIC,
      ...response,
    });
  } catch (error) {
    const message = error instanceof Error ? error.message : String(error);
    console.error("send-fake-ahadith-alert failed:", error);
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
