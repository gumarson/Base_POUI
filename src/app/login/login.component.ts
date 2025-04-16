import { Component, inject } from '@angular/core';

import { environment } from '../environments/environment';
import { Router } from '@angular/router';
import { PoNotificationService } from '@po-ui/ng-components';
import { PoPageLogin, PoPageLoginComponent } from '@po-ui/ng-templates';
import { Subscription } from 'rxjs';
import { LoginAuthService } from '../login-auth.service';
import { LoginData } from '../classes/login';

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrl: './login.component.css'
})

export class LoginComponent {

  // private endPoint: string  = environment.sh7;
  // private endPoint2: string = environment.sh8;

  private loginService = inject(LoginAuthService);
  private loginData!: LoginData;
  private router = inject(Router);
  private notify = inject(PoNotificationService);


  public isHiddenLoading: boolean = true;

  public confirmLogin(loginPage: any) {

    this.isHiddenLoading = false;

    this.loginService.sendLogin(loginPage.login,loginPage.password)
    .subscribe({
      next: value => {

        console.log(value);
        console.log(loginPage.login);
        console.log("foi")

        let loginNow: number = Date.now();
        this.loginData = value; 

        localStorage.setItem('access_token',this.loginData.access_token);
        localStorage.setItem('refresh_token',this.loginData.refresh_token);
        localStorage.setItem('expires_in',(loginNow + (this.loginData.expires_in * 1000)).toString());
        localStorage.setItem('username',loginPage.login);

        this.isHiddenLoading = true;
        this.router.navigate(['dash']);

      },

      error: err => {
        let msgerror: string;
        err.error.code === 401 ? msgerror = 'Login inválido!!' : msgerror = err.error.message;
        this.notify.error({message: msgerror});
        this.isHiddenLoading = true;
      },

      complete: () => {},
    })

  }

}
