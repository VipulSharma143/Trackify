import { ApiError } from '../types/api.types';
import type { SystemInfoResponse } from '../types/system.types';
import { getJson } from './api';

export async function getSystemInfo(): Promise<SystemInfoResponse> {
  const { httpStatus, body } = await getJson<SystemInfoResponse>(
    '/api/system/info',
  );
  if (httpStatus !== 200) {
    throw new ApiError('http', httpStatus);
  }
  return body;
}
