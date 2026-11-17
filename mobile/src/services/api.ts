import { API_BASE_URL, REQUEST_TIMEOUT_MS } from '../constants/config';
import { ApiError, type ApiResponse } from '../types/api.types';

/** Single HTTP entry point. Returns the parsed JSON body for any HTTP status; throws ApiError otherwise. */
export async function getJson<T>(path: string): Promise<ApiResponse<T>> {
  const controller = new AbortController();
  const timer = setTimeout(() => controller.abort(), REQUEST_TIMEOUT_MS);
  try {
    const response = await fetch(`${API_BASE_URL}${path}`, {
      headers: { Accept: 'application/json' },
      signal: controller.signal,
    });
    let body: T;
    try {
      body = (await response.json()) as T;
    } catch {
      throw new ApiError('invalid-response', response.status);
    }
    return { httpStatus: response.status, body };
  } catch (error) {
    if (error instanceof ApiError) {
      throw error;
    }
    if (controller.signal.aborted) {
      throw new ApiError('timeout');
    }
    throw new ApiError('network');
  } finally {
    clearTimeout(timer);
  }
}
