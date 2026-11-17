import { apiHost } from '../platform/apiHost';

export const API_PORT = 5000;

/**
 * Set to your computer's LAN IP (for example '192.168.1.20') to test on a physical device.
 * This is a non-secret development value. Never put secrets in app source.
 */
export const API_HOST_OVERRIDE: string | null = null;

export const API_BASE_URL = `http://${
  API_HOST_OVERRIDE ?? apiHost
}:${API_PORT}`;

export const REQUEST_TIMEOUT_MS = 8000;
