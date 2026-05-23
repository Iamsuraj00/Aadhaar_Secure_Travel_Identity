/* Aadhaar Secure Travel Identity — Client JS */

document.addEventListener('DOMContentLoaded', () => {

  // ── Auto-format UID input (XXXX-XXXX-XXXX) ──
  document.querySelectorAll('input[name="uid"], input[placeholder*="XXXX-XXXX"]').forEach(input => {
    input.addEventListener('input', e => {
      let val = e.target.value.replace(/[^0-9]/g, '');
      if (val.length > 12) val = val.slice(0, 12);
      let formatted = '';
      for (let i = 0; i < val.length; i++) {
        if (i === 4 || i === 8) formatted += '-';
        formatted += val[i];
      }
      e.target.value = formatted;
    });
  });

  // ── Animate stat numbers ──
  document.querySelectorAll('.stat-value').forEach(el => {
    const target = parseInt(el.textContent, 10);
    if (isNaN(target) || target === 0) return;
    let current = 0;
    const step = Math.max(1, Math.ceil(target / 30));
    const timer = setInterval(() => {
      current = Math.min(current + step, target);
      el.textContent = current;
      if (current >= target) clearInterval(timer);
    }, 30);
  });

  // ── Module card stagger animation ──
  document.querySelectorAll('.module-card').forEach((card, i) => {
    card.style.animationDelay = `${i * 0.06}s`;
  });

  // ── Stat card stagger ──
  document.querySelectorAll('.stat-card').forEach((card, i) => {
    card.style.animationDelay = `${i * 0.08}s`;
  });

  // ── Active sidebar link highlight based on current URL ──
  const currentPath = window.location.pathname;
  document.querySelectorAll('.sidebar a').forEach(link => {
    if (link.getAttribute('href') && currentPath.includes(link.getAttribute('href').split('?')[0])) {
      link.classList.add('active');
    }
  });

  // ── Confirm on revoke buttons ──
  document.querySelectorAll('a[href*="revoke"]').forEach(btn => {
    btn.addEventListener('click', e => {
      if (!confirm('Are you sure you want to revoke this alert? This will lift any travel blocks.')) {
        e.preventDefault();
      }
    });
  });

  // ── Auto-dismiss alerts after 6s ──
  document.querySelectorAll('.alert.alert-success').forEach(el => {
    setTimeout(() => {
      el.style.transition = 'opacity 0.5s, max-height 0.5s';
      el.style.opacity = '0';
      el.style.maxHeight = '0';
      el.style.overflow = 'hidden';
      setTimeout(() => el.remove(), 500);
    }, 6000);
  });

  // ── Table row click to follow first link ──
  document.querySelectorAll('tbody tr').forEach(row => {
    const link = row.querySelector('a');
    if (link) {
      row.style.cursor = 'pointer';
      row.addEventListener('click', e => {
        if (!e.target.closest('a') && !e.target.closest('button')) {
          link.click();
        }
      });
    }
  });

  // ── PIN field: only allow digits ──
  document.querySelectorAll('input[name="pin"]').forEach(input => {
    input.addEventListener('input', e => {
      e.target.value = e.target.value.replace(/[^0-9]/g, '').slice(0, 4);
    });
  });

  // ── Dynamic UID lookup hint on apply/issue forms ──
  const uidInputs = document.querySelectorAll('input[name="uid"]');
  uidInputs.forEach(input => {
    const hint = document.createElement('div');
    hint.style.cssText = 'font-size:0.75rem;color:var(--muted);margin-top:4px;font-family:"JetBrains Mono",monospace';
    input.parentNode.appendChild(hint);
    input.addEventListener('blur', () => {
      const val = input.value.trim();
      if (val.match(/^\d{4}-\d{4}-\d{4}$/)) {
        hint.textContent = '✓ Valid UID format';
        hint.style.color = '#69f0ae';
      } else if (val.length > 0) {
        hint.textContent = '⚠ Format should be XXXX-XXXX-XXXX';
        hint.style.color = '#ffcc80';
      } else {
        hint.textContent = '';
      }
    });
  });

});
