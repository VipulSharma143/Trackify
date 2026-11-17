import { ApiError } from '../types/api.types';
import type {
  DatabaseHealthResponse,
  HealthResponse,
} from '../types/health.types';
import { getJson } from './api';

export async function getHealth(): Promise<HealthResponse> {
  const { httpStatus, body } = await getJson<HealthResponse>('/api/health');
  if (httpStatus !== 200) {
    throw new ApiError('http', httpStatus);
  }
  return body;
}

/** A 503 still carries a body describing the database outage, so it is returned, not thrown. */
export async function getDatabaseHealth(): Promise<DatabaseHealthResponse> {
  const { httpStatus, body } = await getJson<DatabaseHealthResponse>(
    '/api/health/database',
  );
  if (httpStatus !== 200 && httpStatus !== 503) {
    throw new ApiError('http', httpStatus);
  }
  return body;
}
