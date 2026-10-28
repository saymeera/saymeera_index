import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { DashboardRoutingModule } from './dashboard-routing.module';

import { MidSectionComponent } from './components/mid-section/mid-section.component';
import { LowerSectionComponent } from './components/lower-section/lower-section.component';
import { TopSectionComponent } from './components/top-section/top-section.component';
import { DashboardComponent } from './dashboard/dashboard.component';


@NgModule({
  declarations: [
    MidSectionComponent,
    LowerSectionComponent,
    TopSectionComponent,
    DashboardComponent
  ],
  imports: [
    CommonModule,
    DashboardRoutingModule
  ]
})
export class DashboardModule { }
