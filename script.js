const menuButton = document.querySelector('.menu-toggle');
const nav = document.querySelector('#primary-nav');
if (menuButton && nav) {
  menuButton.addEventListener('click', () => {
    const isOpen = nav.classList.toggle('open');
    menuButton.setAttribute('aria-expanded', String(isOpen));
    menuButton.setAttribute('aria-label', isOpen ? 'Close navigation' : 'Open navigation');
  });
  nav.querySelectorAll('a').forEach(link => link.addEventListener('click', () => {
    nav.classList.remove('open');
    menuButton.setAttribute('aria-expanded', 'false');
    menuButton.setAttribute('aria-label', 'Open navigation');
  }));
}
const year = document.querySelector('#year');
if (year) year.textContent = String(new Date().getFullYear());

const themeButton=document.querySelector('.theme-toggle');
function syncThemeButton(){if(!themeButton)return;const dark=document.documentElement.dataset.theme==='dark';themeButton.querySelector('.theme-symbol').textContent=dark?'☀':'☾';themeButton.querySelector('.theme-label').textContent=dark?'Light':'Dark';themeButton.setAttribute('aria-label',dark?'Switch to light theme':'Switch to dark theme');}
syncThemeButton();
if(themeButton)themeButton.addEventListener('click',()=>{const next=document.documentElement.dataset.theme==='dark'?'light':'dark';document.documentElement.dataset.theme=next;try{localStorage.setItem('in-theme',next)}catch(e){}syncThemeButton();});
