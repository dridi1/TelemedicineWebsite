document.querySelectorAll('.nav-link').forEach(link => {
    // compare full URL or just pathname
    if (link.href === window.location.href ||
        link.getAttribute('href') === window.location.pathname) {
      link.parentElement.classList.add('active');
    }
  });