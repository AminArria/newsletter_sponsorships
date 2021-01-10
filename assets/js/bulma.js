document.addEventListener('DOMContentLoaded', () => {

  // ELEMENT: Navbar burger menu on mobile
  // Get all "navbar-burger" elements
  const $navbarBurgers = Array.prototype.slice.call(document.querySelectorAll('.navbar-burger'), 0);

  // Check if there are any navbar burgers
  if ($navbarBurgers.length > 0) {

    // Add a click event on each of them
    $navbarBurgers.forEach( el => {
      el.addEventListener('click', () => {

        // Get the target from the "data-target" attribute
        const target = el.dataset.target;
        const $target = document.getElementById(target);

        // Toggle the "is-active" class on both the "navbar-burger" and the "navbar-menu"
        el.classList.toggle('is-active');
        $target.classList.toggle('is-active');

      });
    });
  }

  // ELEMENT: close notifications pressing the X
  (document.querySelectorAll('.notification .delete') || []).forEach(($delete) => {
    var $notification = $delete.parentNode;

    $delete.addEventListener('click', () => {
      $notification.parentNode.removeChild($notification);
    });
  });

  // ELEMENT: cycle through tabs
  let tabs = (document.querySelectorAll('.tabs li') || [])
  let tabs_targets = (document.querySelectorAll('.tab-target') || [])
  tabs.forEach((tab) => {
    let target = document.getElementById(tab.dataset.target);

    tab.addEventListener('click', () => {
      if (tab.classList.contains('is-active')) return;

      tabs.forEach(toggle_tab => {
        toggle_tab.classList.remove('is-active');
        tab.classList.add('is-active');
      })

      tabs_targets.forEach(toggle_target => {
        toggle_target.classList.add('is-hidden');
        target.classList.remove('is-hidden');
      })
    })
  });

  // ELEMENT: open/close modals
  (document.querySelectorAll('.modal-trigger') || []).forEach((modalTrigger) => {
    let target = document.getElementById(modalTrigger.dataset.target);
    let html = document.querySelector('html');

    modalTrigger.addEventListener('click', e => {
      target.classList.add('is-active');
      html.classList.add('is-clipped');
    })

    target.addEventListener('click', e => {
      if (e.target.classList.contains('modal-background') || e.target.classList.contains('modal-close')  || e.target.classList.contains('modal-button-close')) {
        target.classList.remove('is-active');
        html.classList.remove('is-clipped');
      }
    });
  });
});
