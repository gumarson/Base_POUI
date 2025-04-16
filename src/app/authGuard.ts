import { inject } from '@angular/core';
import { CanActivateFn, Router } from '@angular/router';
import { environment } from './environments/environment';

export const authGuard: CanActivateFn = (route, state) => {
  let router = inject(Router)
  let username = localStorage.getItem('access_token')
  let url = state.url
  
  if(environment.ambiente === 'protheus'){
    return true
  }

  if(url !== '/login'){
    if(!username) {
      
      sessionStorage.setItem('url', url)
      router.navigate(['/login'])

      return false;
    }
  }
  return true;
};