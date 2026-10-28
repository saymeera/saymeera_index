import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { MainLayoutComponent } from '../layouts/main-layout/main-layout.component';
import { DashboardComponent } from './dashboard/dashboard.component';
import { QuizComponent } from './quiz/quiz.component';
import { TipsComponent } from './tips/tips.component';
import { UserPerformanceComponent } from './user-performance/user-performance.component';
import { authGuard } from '../core/guards/auth.guard';
import { permissionGuard } from '../core/guards/permission.guard';
import { SubadminComponent } from './subadmin/subadmin.component';

const routes: Routes = [
  {
      path:'',
      component:MainLayoutComponent,
      canActivate: [authGuard],
      children:[
        {path:'dashboard',component:DashboardComponent},
        {path:'quiz',component:QuizComponent,canActivate: [permissionGuard],data: { permission: 'quiz' }},
        {path:'tips',component:TipsComponent,canActivate:[permissionGuard], data: { permission: 'tips' }},
        {path:'user-performance',component:UserPerformanceComponent,canActivate:[permissionGuard], data: { permission: 'user-performance' }},
        {path:'sub-admin',component:SubadminComponent,canActivate:[permissionGuard], data: { permission: 'sub-admin' }},
        { path: '', redirectTo: 'dashboard', pathMatch: 'full' }
      ]
    },
    // { path: '**', redirectTo: '' }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class ComponentsRoutingModule { }
