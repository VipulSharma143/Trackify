/** Formats a date as HH:MM:SS (24-hour), or 'never' when there is no date. */
export function formatTime(date: Date | null): string {
  if (date === null) {
    return 'never';
  }
  const two = (value: number): string => String(value).padStart(2, '0');
  return `${two(date.getHours())}:${two(date.getMinutes())}:${two(
    date.getSeconds(),
  )}`;
}
