import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import {BlankLayoutComponent} from '../../layouts/blank-layout/blank-layout.component'
import {LoginComponent} from './pages/login/login.component'
import {RegisterComponent} from './pages/register/register.component'
import { HomeComponent } from './pages/home/home.component';
import { HomeLayoutComponent } from 'src/app/layouts/home-layout/home-layout.component';

const routes: Routes = [
  {
    path:'app',
    component:BlankLayoutComponent,
    children:[
      {path:'login',component:LoginComponent},
      {path:'register',component:RegisterComponent}
    ]
  },
  {
    path:'',
    component:HomeLayoutComponent,
    children:[
      {path:'',component:HomeComponent}
    ]
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class AuthRoutingModule { }
