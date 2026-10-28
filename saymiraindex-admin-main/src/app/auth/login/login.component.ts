import { Component } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { Router } from '@angular/router';
import { ToastrService } from 'ngx-toastr';
import { AuthService } from '../service/auth.service';
import { environment } from '../../../environments/environment';


@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.scss']
})
export class LoginComponent {

  loginForm: FormGroup
  sitekey: string = environment.RECAPTCHA_SECRET
  constructor(private router: Router, private fb: FormBuilder, private toastr: ToastrService, private authService: AuthService) {
    this.loginForm = this.fb.group({
      email: ['', [Validators.required, Validators.email]],
      password: ['', Validators.required],
      recaptcha: ['', Validators.required]
    })
  }

  login() {
    if (this.loginForm.invalid) {
      this.toastr.error('Please complete captcha & credentials');
      return;
    }

    const payload = {
      email: this.loginForm.value.email,
      password: this.loginForm.value.password,
      captchaToken: this.loginForm.value.recaptcha
    };

    this.authService.adminLogin(payload).subscribe({
      next: (res) => {
        if (res.status) {
          sessionStorage.setItem('token', res.accessToken);
          this.toastr.success('Login successful');
          this.router.navigate(['/admin/dashboard']);
        } else {
          this.toastr.error('Your Account is Currently Deactivated');
        }

      },
      error: () => {
        this.toastr.error('Invalid credentials');
      }
    });
  }



}
