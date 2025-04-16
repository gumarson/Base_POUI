import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { PoPageDynamicTableComponent } from '@po-ui/ng-templates';

import { authGuard } from './authGuard';
import { environment } from './environments/environment';
import { LoginComponent } from './login/login.component';
import { DashProdComponent } from './dash-prod/dash-prod.component';
import { MasterPageComponent } from './master-page/master-page.component';

let rotas: Routes = [];

if(environment.ambiente === 'protheus'){
  rotas = 
  [
    { path: 'dash', component: DashProdComponent },
  ]
}else{
  rotas = 
  [
    {
      path: 'login',
      component: LoginComponent,
   },
   {
   path: '', component: MasterPageComponent, canActivate: [authGuard], children: [
    { path: 'dash', component: DashProdComponent },
   ]
   },
  //  {
  //     path: '**',
  //     component: ErrorPageComponent,
  //  },
  ]
}

@NgModule({
  imports: [RouterModule.forRoot(rotas)],
  exports: [RouterModule]
})
export class AppRoutingModule { }