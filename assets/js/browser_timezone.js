import jstz from 'jstz';

document.addEventListener("DOMContentLoaded", () => {
  document.cookie = `browser_timezone=${getTimezone()}; path=/`
});

function getTimezone() {
  const timezone = jstz.determine();
  return timezone.name();
}
