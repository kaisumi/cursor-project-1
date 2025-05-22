document.addEventListener('turbo:before-render', () => {
  gsap.to('main', { opacity: 0, duration: 0.2 });
});

document.addEventListener('turbo:render', () => {
  gsap.fromTo('main', 
    { opacity: 0, y: 20 }, 
    { opacity: 1, y: 0, duration: 0.3, ease: 'power1.out' }
  );
  
  animatePageElements();
});

function animatePageElements() {
  gsap.utils.toArray('.post').forEach((post, i) => {
    gsap.fromTo(post, 
      { opacity: 0, y: 20 }, 
      { 
        opacity: 1, 
        y: 0, 
        duration: 0.3, 
        delay: i * 0.1, 
        ease: 'power1.out' 
      }
    );
  });
  
  gsap.utils.toArray('.notification').forEach((notification, i) => {
    gsap.fromTo(notification, 
      { opacity: 0, x: -20 }, 
      { 
        opacity: 1, 
        x: 0, 
        duration: 0.3, 
        delay: i * 0.05, 
        ease: 'back.out(1.2)' 
      }
    );
  });
}

document.addEventListener('turbo:load', () => {
  const mobileMenuButton = document.getElementById('mobile-menu-button');
  const mobileMenu = document.getElementById('mobile-menu');
  
  if (mobileMenuButton && mobileMenu) {
    mobileMenuButton.addEventListener('click', () => {
      const expanded = mobileMenuButton.getAttribute('aria-expanded') === 'true';
      mobileMenuButton.setAttribute('aria-expanded', !expanded);
      
      if (expanded) {
        gsap.to(mobileMenu, { 
          height: 0, 
          opacity: 0, 
          duration: 0.3, 
          ease: 'power2.inOut',
          onComplete: () => {
            mobileMenu.classList.add('hidden');
          }
        });
      } else {
        mobileMenu.classList.remove('hidden');
        gsap.fromTo(mobileMenu, 
          { height: 0, opacity: 0 }, 
          { 
            height: 'auto', 
            opacity: 1, 
            duration: 0.3, 
            ease: 'power2.inOut' 
          }
        );
      }
    });
  }
});

document.addEventListener('turbo:load', () => {
  document.querySelectorAll('.like-button').forEach(button => {
    button.addEventListener('click', () => {
      const icon = button.querySelector('svg');
      gsap.fromTo(icon, 
        { scale: 1 }, 
        { 
          scale: 1.5, 
          duration: 0.2, 
          ease: 'back.out(3)', 
          yoyo: true, 
          repeat: 1 
        }
      );
    });
  });
});
