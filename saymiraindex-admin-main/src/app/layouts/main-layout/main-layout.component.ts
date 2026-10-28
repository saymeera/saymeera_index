import { Component } from '@angular/core';
import { Router } from '@angular/router';

@Component({
  selector: 'app-main-layout',
  templateUrl: './main-layout.component.html',
  styleUrls: ['./main-layout.component.scss']
})
export class MainLayoutComponent {

  constructor(private router:Router){}

  handleLogout(){
    if(sessionStorage.getItem('token')){
      sessionStorage.removeItem('token')
      this.router.navigate([''])
    }
  }
}
