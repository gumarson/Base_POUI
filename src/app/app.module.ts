// import { NgModule } from '@angular/core';
// import { BrowserModule } from '@angular/platform-browser';

// import { AppRoutingModule } from './app-routing.module';
// import { AppComponent } from './app.component';
// import { PoModule } from '@po-ui/ng-components';
// import { HttpClientModule } from '@angular/common/http';
// import { RouterModule, Router } from '@angular/router';
// import { LoginComponent } from './login/login.component';
// import { PoPageLoginModule } from '@po-ui/ng-templates';
// import { DashProdComponent } from './dash-prod/dash-prod.component';
// import { MasterPageComponent } from './master-page/master-page.component';

// @NgModule({
//   declarations: [
//     AppComponent,
//     LoginComponent,
//     DashProdComponent,
//     MasterPageComponent
//   ],
//   imports: [
//     BrowserModule,
//     AppRoutingModule,
//     PoPageLoginModule,
//     PoModule,
//     HttpClientModule,
//     RouterModule.forRoot([])
//   ],
//   providers: [],
//   bootstrap: [AppComponent]
// })
// export class AppModule { }

import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import { FormsModule } from '@angular/forms'; // ✅ Necessário para ngModel

import { PoTemplatesModule } from '@po-ui/ng-templates';


import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';

import { PoModule } from '@po-ui/ng-components';
import { PoPageLoginModule } from '@po-ui/ng-templates';

import { HttpClientModule } from '@angular/common/http';
import { RouterModule } from '@angular/router';

import { AuthInterceptor } from './auth.interceptor';
import { HTTP_INTERCEPTORS } from '@angular/common/http';

import { LoginComponent } from './login/login.component';
import { DashProdComponent } from './dash-prod/dash-prod.component';
import { MasterPageComponent } from './master-page/master-page.component';


@NgModule({
  declarations: [
    AppComponent,
    LoginComponent,
    DashProdComponent,
    MasterPageComponent
  ],
  imports: [
    BrowserModule,
    FormsModule,              // ✅ Importado para ngModel
    PoTemplatesModule,
    AppRoutingModule,
    PoPageLoginModule,
    PoModule,
    HttpClientModule,
    RouterModule.forRoot([])
  ],
  providers: [
    {
      provide: HTTP_INTERCEPTORS,
      useClass: AuthInterceptor,
      multi: true
    }
  ],
  bootstrap: [AppComponent]
})
export class AppModule { }
