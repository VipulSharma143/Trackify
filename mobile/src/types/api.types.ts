export type ApiErrorKind = 'timeout' | 'network' | 'http' | 'invalid-response';

export class ApiError extends Error {
  readonly kind: ApiErrorKind;
  readonly httpStatus?: number;

  constructor(kind: ApiErrorKind, httpStatus?: number) {
    super(kind); // Deliberately generic: server error details are never surfaced.
    this.name = 'ApiError';
    this.kind = kind;
    this.httpStatus = httpStatus;
  }
}

export type ApiResponse<T> = { httpStatus: number; body: T };
