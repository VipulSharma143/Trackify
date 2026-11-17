import { useCallback, useEffect, useState } from 'react';
import { getDatabaseHealth, getHealth } from '../services/health.service';
import { getSystemInfo } from '../services/system.service';
import { ApiError, type ApiErrorKind } from '../types/api.types';
import type {
  DatabaseHealthResponse,
  HealthResponse,
} from '../types/health.types';
import type { SystemInfoResponse } from '../types/system.types';

export type CheckState<T> =
  | { status: 'loading' }
  | { status: 'success'; data: T }
  | { status: 'error'; kind: ApiErrorKind };

type ApiHealthState = {
  api: CheckState<HealthResponse>;
  database: CheckState<DatabaseHealthResponse>;
  system: CheckState<SystemInfoResponse>;
  lastSuccessAt: Date | null;
  refresh: () => void;
};

async function runCheck<T>(call: () => Promise<T>): Promise<CheckState<T>> {
  try {
    return { status: 'success', data: await call() };
  } catch (error) {
    return {
      status: 'error',
      kind: error instanceof ApiError ? error.kind : 'network',
    };
  }
}

export function useApiHealth(): ApiHealthState {
  const [api, setApi] = useState<CheckState<HealthResponse>>({
    status: 'loading',
  });
  const [database, setDatabase] = useState<CheckState<DatabaseHealthResponse>>({
    status: 'loading',
  });
  const [system, setSystem] = useState<CheckState<SystemInfoResponse>>({
    status: 'loading',
  });
  const [lastSuccessAt, setLastSuccessAt] = useState<Date | null>(null);

  const refresh = useCallback((): void => {
    setApi({ status: 'loading' });
    setDatabase({ status: 'loading' });
    setSystem({ status: 'loading' });
    Promise.all([
      runCheck(getHealth),
      runCheck(getDatabaseHealth),
      runCheck(getSystemInfo),
    ]).then(([apiResult, dbResult, systemResult]) => {
      setApi(apiResult);
      setDatabase(dbResult);
      setSystem(systemResult);
      if (apiResult.status === 'success') {
        setLastSuccessAt(new Date());
      }
    });
  }, []);

  useEffect(() => {
    refresh();
  }, [refresh]);

  return { api, database, system, lastSuccessAt, refresh };
}
