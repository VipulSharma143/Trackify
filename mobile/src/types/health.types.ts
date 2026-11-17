// Planned contract for GET /api/health and GET /api/health/database (see docs/api/API_DOCUMENTATION.md).
export type HealthResponse = {
  status: string;
  applicationName: string;
  version: string;
  timestamp: string;
};

export type DatabaseHealthResponse = {
  status: string;
  provider: string;
  timestamp: string;
};
