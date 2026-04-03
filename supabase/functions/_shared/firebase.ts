import admin from "npm:firebase-admin@11.10.1";

type FirebaseServiceAccount = {
  project_id?: string;
  client_email?: string;
  private_key?: string;
};

export function getFirebaseMessaging() {
  const serviceAccount = parseFirebaseServiceAccount();

  if (admin.apps.length === 0) {
    admin.initializeApp({
      credential: admin.credential.cert(serviceAccount),
    });
  }

  return admin.messaging();
}

function parseFirebaseServiceAccount(): FirebaseServiceAccount {
  const raw = Deno.env.get("FIREBASE_SERVICE_ACCOUNT");
  if (!raw || !raw.trim()) {
    throw new Error("FIREBASE_SERVICE_ACCOUNT is not configured");
  }

  const candidates = [raw.trim()];

  try {
    candidates.push(atob(raw.trim()));
  } catch (_) {
    // Ignore non-base64 values.
  }

  for (const candidate of candidates) {
    const parsed = tryParseServiceAccount(candidate);
    if (parsed != null) {
      return parsed;
    }
  }

  throw new Error(
    "FIREBASE_SERVICE_ACCOUNT is invalid. Use the full Firebase Admin SDK JSON, or a base64-encoded version of that JSON.",
  );
}

function tryParseServiceAccount(
  value: string,
): FirebaseServiceAccount | null {
  try {
    const parsed = JSON.parse(value);
    const normalized =
      typeof parsed === "string" ? JSON.parse(parsed) : parsed;

    if (
      normalized &&
      typeof normalized === "object" &&
      typeof normalized.client_email === "string" &&
      typeof normalized.private_key === "string"
    ) {
      return {
        ...normalized,
        private_key: normalized.private_key.replace(/\\n/g, "\n"),
      };
    }
  } catch (_) {
    return null;
  }

  return null;
}
