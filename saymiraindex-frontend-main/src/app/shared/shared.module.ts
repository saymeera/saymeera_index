import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { NavbarComponent } from './components/navbar/navbar.component';
import { FooterComponent } from './components/footer/footer.component';
import { PublicNavbarComponent } from './components/public-navbar/public-navbar.component';
import { PubliFooterComponent } from './components/publi-footer/publi-footer.component';
import { RouterModule } from '@angular/router';



@NgModule({
  declarations: [
    NavbarComponent,
    FooterComponent,
    PublicNavbarComponent,
    PubliFooterComponent
  ],
  exports: [NavbarComponent, FooterComponent,PublicNavbarComponent,PubliFooterComponent],
  imports: [
    CommonModule,
    RouterModule
  ]
})
export class SharedModule { }
