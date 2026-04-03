type NotificationPayload = {
  title: string;
  body: string;
  data?: Record<string, string>;
};

type SendSummary = {
  successCount: number;
  failureCount: number;
  tokenCount: number;
  usedTopicFallback: boolean;
};

export async function fetchFcmTokens(
  supabase: any,
  userId?: string,
): Promise<string[]> {
  let query: any = supabase.from('user_fcm_tokens').select('fcm_token');

  if (userId) {
    query = query.eq('user_id', userId);
  }

  const { data, error } = await query;
  if (error) throw error;

  const tokens = (data ?? [])
    .map((row) => row.fcm_token?.trim())
    .filter((token): token is string => Boolean(token));

  return Array.from(new Set(tokens));
}

export async function sendToTokens(
  messaging: {
    sendEachForMulticast: (request: {
      tokens: string[];
      notification: {
        title: string;
        body: string;
      };
      data?: Record<string, string>;
      android?: {
        notification?: {
          channelId?: string;
        };
      };
      apns?: {
        payload?: {
          aps?: {
            sound?: string;
          };
        };
      };
    }) => Promise<{ successCount: number; failureCount: number }>;
    send: (request: {
      topic: string;
      notification: {
        title: string;
        body: string;
      };
      data?: Record<string, string>;
      android?: {
        notification?: {
          channelId?: string;
        };
      };
      apns?: {
        payload?: {
          aps?: {
            sound?: string;
          };
        };
      };
    }) => Promise<string>;
  },
  tokens: string[],
  payload: NotificationPayload,
  channelId: string,
  topicFallback = 'all',
): Promise<SendSummary> {
  if (tokens.length === 0) {
    await messaging.send({
      topic: topicFallback,
      notification: {
        title: payload.title,
        body: payload.body,
      },
      data: payload.data,
      android: {
        notification: {
          channelId,
        },
      },
      apns: {
        payload: {
          aps: {
            sound: 'default',
          },
        },
      },
    });

    return {
      successCount: 1,
      failureCount: 0,
      tokenCount: 0,
      usedTopicFallback: true,
    };
  }

  const chunkSize = 500;
  let successCount = 0;
  let failureCount = 0;

  for (let index = 0; index < tokens.length; index += chunkSize) {
    const chunk = tokens.slice(index, index + chunkSize);
    const response = await messaging.sendEachForMulticast({
      tokens: chunk,
      notification: {
        title: payload.title,
        body: payload.body,
      },
      data: payload.data,
      android: {
        notification: {
          channelId,
        },
      },
      apns: {
        payload: {
          aps: {
            sound: 'default',
          },
        },
      },
    });

    successCount += response.successCount;
    failureCount += response.failureCount;
  }

  return {
    successCount,
    failureCount,
    tokenCount: tokens.length,
    usedTopicFallback: false,
  };
}
