(() => {
  'use strict';

  const picker = document.getElementById('week-picker');
  if (!picker) return;

  const summary = picker.querySelector('summary');
  if (window.location.hash === '#week-picker') picker.open = true;

  document.querySelectorAll('[data-open-weeks]').forEach((link) => {
    link.addEventListener('click', (event) => {
      if (
        event.defaultPrevented || event.button !== 0 ||
        event.metaKey || event.ctrlKey || event.shiftKey || event.altKey
      ) return;

      picker.open = true;
      window.requestAnimationFrame(() => summary?.focus({ preventScroll: true }));
    });
  });
})();
