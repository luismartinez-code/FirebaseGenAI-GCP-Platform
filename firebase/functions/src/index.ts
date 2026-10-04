import * as admin from "firebase-admin";
import { onCall, onRequest } from "firebase-functions/v2/https";

admin.initializeApp();

export const health = onRequest((req, res) => {
  res.status(200).json({
    status: "ok",
    service: "genai-platform-functions",
    environment: process.env.ENVIRONMENT ?? "dev"
  });
});

export const recommendationEngine = onCall(async (request) => {
  const userId = request.auth?.uid ?? "anonymous";
  const limit = Number(request.data?.limit ?? 5);

  return {
    userId,
    generatedAt: new Date().toISOString(),
    recommendations: [
      {
        id: "dash-001",
        title: "Revenue trend overview",
        type: "dashboard",
        score: 0.95
      },
      {
        id: "dash-002",
        title: "Customer health summary",
        type: "dashboard",
        score: 0.91
      }
    ].slice(0, limit)
  };
});
