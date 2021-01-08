import { getConfigInt, getConfigString } from './utils';

export const TOKEN_SECRET = getConfigString('TOKEN_SECRET');
export const COOKIE_SECRET = getConfigString('COOKIE_SECRET');
export const REFRESH_TOKEN_EXPIRES_DAYS = getConfigInt('REFRESH_TOKEN_EXPIRES_DAYS');
export const CLIENT_ORIGIN = getConfigString('CLIENT_ORIGIN');
export const PASSWORD_WORK_FACTOR = getConfigInt('PASSWORD_WORK_FACTOR');