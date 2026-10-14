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

// Configure a deployed backend URL here only after completing secure backend setup.
const FORM_ENDPOINT = '';
document.querySelectorAll('.contact-form').forEach(form => {
 const button=form.querySelector('button[type="submit"]');const status=form.querySelector('.form-status');
 if(!FORM_ENDPOINT){button.disabled=true;button.title='Secure message service not yet connected';return;}
 form.addEventListener('submit',async event=>{event.preventDefault();button.disabled=true;status.textContent='Sending…';
 const data=Object.fromEntries(new FormData(form).entries());data.marketing=Boolean(form.elements.marketing.checked);
 try{const response=await fetch(FORM_ENDPOINT,{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify(data)});if(!response.ok)throw new Error('Submission failed');form.reset();status.textContent='Your message was received. Thank you!';}
 catch(e){status.textContent='Message not delivered. Please try again later.';}finally{button.disabled=false;}
 });
});

// Public, experimental IRC web-client launch; no visitor data sent to this site.
const textLaunch=document.querySelector('#open-text');
if(textLaunch)textLaunch.addEventListener('click',()=>{
 const nick=document.querySelector('#chat-nick').value.trim().replace(/[^a-zA-Z0-9_\-\[\]{}^`|]/g,'').slice(0,24);
 const url='https://web.libera.chat/'+(nick?'?nick='+encodeURIComponent(nick):'')+'#intentionalnoise';
 window.open(url,'_blank','noopener,noreferrer');
});
