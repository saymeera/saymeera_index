import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { ComponentsRoutingModule } from './components-routing.module';
import { UserPerformanceComponent } from './user-performance/user-performance.component';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { DashboardComponent } from './dashboard/dashboard.component';
import { QuizComponent } from './quiz/quiz.component';
import { TipsComponent } from './tips/tips.component';
import { SubadminComponent } from './subadmin/subadmin.component';



@NgModule({
  declarations: [
    UserPerformanceComponent,
    DashboardComponent,
    QuizComponent,
    TipsComponent,
    SubadminComponent,
  ],
  imports: [
    CommonModule,
    ComponentsRoutingModule,
    FormsModule,
    ReactiveFormsModule
  ]
})
export class ComponentsModule { }
