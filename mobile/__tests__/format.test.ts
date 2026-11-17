import { formatTime } from '../src/utils/format';

test('formatTime returns "never" without a date', () => {
  expect(formatTime(null)).toBe('never');
});

test('formatTime pads hours, minutes and seconds', () => {
  expect(formatTime(new Date(2026, 0, 1, 3, 4, 5))).toBe('03:04:05');
});
