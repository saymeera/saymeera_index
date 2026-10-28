import { Component } from '@angular/core';
import { AuthService } from 'src/app/modules/auth/services/auth.service';
import { SharedService } from '../../shared.service';
import { ToastrService } from 'ngx-toastr';
import { Router } from '@angular/router';

@Component({
  selector: 'app-navbar',
  templateUrl: './navbar.component.html',
  styleUrls: ['./navbar.component.scss']
})
export class NavbarComponent {
  isUserLogin:boolean = false
  constructor(private auth:AuthService, private sharedService:SharedService, private toastr:ToastrService, private router:Router){}
  ngOnInit(){
    this.isUserLogin = this.auth.isLoggedIn()
  }

  logOutUser(){
    const refreshToken = this.auth.getRefreshToken();
    if(!refreshToken){
      return;
    }
    let obj={
      refreshToken : refreshToken
    }
    this.sharedService.logout(obj).subscribe({
      next:(res) => {
        localStorage.removeItem('accessToken')
        localStorage.removeItem('refreshToken')
        this.toastr.success('User logOut successfully');
        this.router.navigate([''])
      },
      error:(err)=>{
         console.error('logOut Error', err);
      }
    })
    
  }
}
