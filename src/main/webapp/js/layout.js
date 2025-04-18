// Accessibility: Add focus class when using keyboard
document.addEventListener('keydown', function(e) {
    if (e.key === 'Tab') {
        document.body.classList.add('keyboard-navigation');
    }
});
document.addEventListener('mousedown', function() {
    document.body.classList.remove('keyboard-navigation');
});

// DOM Ready
document.addEventListener("DOMContentLoaded", function () {
    const sidebar = document.getElementById("sidebar");
    const toggleBtn = document.getElementById("sidebarToggleButton");
    const mobileToggle = document.getElementById("sidebar-toggle");
    const closeSidebar = document.getElementById("close-sidebar");
    const contentWrapper = document.querySelector(".content-wrapper");

    // Auto-dismiss alerts
    setTimeout(function () {
        const alerts = document.querySelectorAll('.alert-dismissible');
        alerts.forEach(function (alert) {
            const bsAlert = new bootstrap.Alert(alert);
            bsAlert.close();
        });
    }, 5000);

    // Theme switcher icon
    const themeSwitcher = document.getElementById("themeSwitcher");
    if (themeSwitcher) {
        if (document.documentElement.getAttribute('data-bs-theme') === 'dark') {
            themeSwitcher.innerHTML = '<i class="fas fa-sun"></i>';
        } else {
            themeSwitcher.innerHTML = '<i class="fas fa-moon"></i>';
        }
    }

    // Toggle for desktop
    if (toggleBtn) {
        toggleBtn.addEventListener("click", function () {
            sidebar.classList.toggle("closed");
        });
    }

    // Toggle for mobile
    if (mobileToggle) {
        mobileToggle.addEventListener("click", function () {
            sidebar.classList.toggle("collapsed");
            contentWrapper?.classList.toggle("slide-content");
        });
    }

    if (closeSidebar) {
        closeSidebar.addEventListener("click", function () {
            sidebar.classList.add("collapsed");
        });
    }

    // Collapse by default on mobile
    if (window.innerWidth < 992) {
        sidebar.classList.add("collapsed");
    }
});
