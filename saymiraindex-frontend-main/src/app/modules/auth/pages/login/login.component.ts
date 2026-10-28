import { Component } from '@angular/core';
import { FormBuilder, FormGroup } from '@angular/forms';
import { AuthService } from '../../services/auth.service';
import { Router } from '@angular/router';
import { ToastrService } from 'ngx-toastr';

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.scss']
})
export class LoginComponent {
  enableOtp: boolean = false
  enableLogin: boolean = true
  loginType: 'email' | 'mobile' | null = null;
  value: string = ''
  loginform: FormGroup;

  constructor(private fb: FormBuilder, private authApi: AuthService, private router: Router, private toastr: ToastrService) {
    this.loginform = this.fb.group({
      numberOrMail: [''],
      otp: ['']
    })
  }

  sendOtp() {
    this.value = this.loginform.value.numberOrMail?.trim();
    if (!this.value) {
      this.toastr.warning('Please enter email or mobile number');
      return;
    }

    let payload: any = {};

    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    const mobileRegex = /^[6-9]\d{9}$/;

    if (emailRegex.test(this.value)) {
      payload = {
        email: this.value
      };
      this.loginType = 'email';
    } else if (mobileRegex.test(this.value)) {
      payload = {
        mobile: this.value
      };
      this.loginType = 'mobile';
    } else {
    this.toastr.error('Please enter a valid email or mobile number');
      return;
    }
    this.authApi.sendOtp(payload).subscribe({
      next: (res) => {
        this.toastr.success('OTP sent successfully');
        this.enableOtp = true
        this.enableLogin = false
      },
      error: (err) => {
        this.toastr.error('Failed to send OTP');
        console.error('OTP Error', err);
      }
    })

  }

  login() {
    let payload: any = {
      otp: this.loginform.value.otp
    };

    if (this.loginType === 'email') {
      payload.email = this.value;
    }
    else if (this.loginType === 'mobile') {
      payload.mobile = this.value;
    }
    this.authApi.login(payload).subscribe({
      next: (res) => {
        this.toastr.success('login successfully');
        this.router.navigate([''])
      },
      error: (err) => {
        this.toastr.error('login Failed');
      }
    })
  }
}
