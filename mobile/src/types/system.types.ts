// Planned contract for GET /api/system/info.
export type SystemInfoResponse = {
  applicationName: string;
  runtime: string;
  version: string;
  environment: string;
  apiVersion: string;
};
