import { Component } from '@angular/core';
import { FormBuilder, Validators } from '@angular/forms';
import { AuthService } from '../../services/auth.service';
import { SendMsgResponse, MobileOtpPayload, verifyMobOtp, EmailOtpPayload, verifyMailOtp } from '../../../../shared/models/auth.model'
import { ToastrService } from 'ngx-toastr';
import { Router } from '@angular/router';

@Component({
  selector: 'app-register',
  templateUrl: './register.component.html',
  styleUrls: ['./register.component.scss']
})
export class RegisterComponent {

  submitted: boolean = false
  isMobileOtpSent = false;
  isMobileVerified = false;

  isEmailOtpSent = false;
  isEmailVerified = false;


  registerForm = this.fb.group({
    subtype: ['individual', Validators.required],
    fullName: [''],
    corporateName: [''],
    type: [''],
    gender: [''],
    country: ['', Validators.required],
    state: ['', Validators.required],
    district: ['', Validators.required],
    mobile: ['', [Validators.required, Validators.pattern(/^[6-9]\d{9}$/)]],
    email: ['', [Validators.required, Validators.email]],
    discountCode: ['']
  })

  otpForm = this.fb.group({
    mobileOtp: [''],
    emailOtp: ['']
  });

  constructor(private fb: FormBuilder, private authApi: AuthService, private toastr: ToastrService, private router:Router) { }

  ngOnInit() {
    this.registerForm.get('subtype')?.valueChanges.subscribe(value => {
      if (value == 'individual') {
        this.registerForm.get('fullName')?.setValidators([Validators.required])
        this.registerForm.get('corporateName')?.clearValidators();
        this.registerForm.get('type')?.clearValidators();
        this.registerForm.get('corporateName')?.setValue('');
        this.registerForm.get('type')?.setValue('');
      } else {
        this.registerForm.get('corporateName')?.setValidators([Validators.required])
        this.registerForm.get('fullName')?.clearValidators();
        this.registerForm.get('gender')?.clearValidators();
        this.registerForm.get('fullName')?.setValue('')
        this.registerForm.get('gender')?.setValue('')
      }
      this.registerForm.get('fullName')?.updateValueAndValidity()
      this.registerForm.get('corporateName')?.updateValueAndValidity();
      this.registerForm.get('gender')?.updateValueAndValidity();
      this.registerForm.get('type')?.updateValueAndValidity();
    })
  }

  getMobOtp() {
    if (this.registerForm.get('mobile')?.invalid) {
      this.toastr.error("Please enter valid mobile number!!")
    };
    let obj: MobileOtpPayload = {
      mobile: this.registerForm.value.mobile?.trim()
    }
    this.authApi.sendmobOtp(obj).subscribe({
      next: (res) => {
        this.isMobileOtpSent = true;
        this.toastr.success("Otp has been sent on your device")
      },
      error: (err) => {
        this.toastr.error("Something went wrong!!")
      }
    })
    this.isMobileOtpSent = true;

  }

  verifyMobOtp() {
    if (this.otpForm.get('mobileOtp')?.value != '') {
      this.toastr.error('Please enter the otp!!')
    }
    let obj: verifyMobOtp = {
      mobile: this.registerForm.get('mobile')?.value,
      otp: this.otpForm.get('mobileOtp')?.value
    }
    this.authApi.verifymobOtp(obj).subscribe({
      next: (res) => {
        this.isMobileVerified = true;
        this.isMobileOtpSent = false;
        // this.registerForm.get('mobile')?.disable();
        this.toastr.success("Mobile number is verified")
      },
      error: (err) => {
        this.toastr.error('OTP expired or invalid!!')
      }
    })
  }

  getMailOtp() {
    if (this.registerForm.get('email')?.invalid) {
      this.toastr.error("Please enter valid emailId!!")
    }
    let obj: EmailOtpPayload = {
      email: this.registerForm.get('email')?.value
    }
    this.authApi.getmailOtp(obj).subscribe({
      next: (res) => {
        this.isEmailOtpSent = true;
        this.toastr.success("Otp has been sent on your EmailId")
      },
      error: (err) => {
        this.toastr.error("Something went wrong!!")
      }
    })
  }

  verifyMailOtp() {
    const email = this.registerForm.get('email')?.value;
    const otp = this.otpForm.get('emailOtp')?.value;
    if (!otp) {
      this.toastr.error('Please enter the OTP!');
      return;
    }
    if (!email) {
      this.toastr.error('Email not found!');
      return;
    }
    let obj: verifyMailOtp = {
      email,
      otp
    }
    this.authApi.verifymailOtp(obj).subscribe({
      next: (res) => {
        this.isEmailVerified = true;
        this.isEmailOtpSent = false;
        // this.registerForm.get('email')?.disable();
        this.toastr.success("EmailId is verified")
      },
      error: (err) => {
        this.toastr.error('OTP expired or invalid!!')
      }
    })
  }

  setDeafultValues() {
    this.registerForm.controls['subtype'].setValue('individual');
    this.registerForm.controls['gender'].setValue('')
    this.registerForm.controls['country'].setValue('')
    this.registerForm.controls['state'].setValue('')
    this.registerForm.controls['district'].setValue('')
  }

  registerUser() {
    this.submitted = true
    if (this.registerForm.invalid) {
      return
    }
    const formdata = new FormData();
    Object.entries(this.registerForm.value).forEach(([key, value]) => {
      if (value !== null && value !== undefined) {
        formdata.append(key, String(value))
      }
    })
    if (this.isEmailVerified && this.isMobileVerified) {
      this.authApi.register(formdata).subscribe({
        next: (res: SendMsgResponse) => {
          this.toastr.success('User registerd successfully')
          this.registerForm.reset()
          this.setDeafultValues()
          this.router.navigate(['index/app/login'])
        },
        error: (err) => {
          this.toastr.error('Registration Failed');
        }
      })
    } else {
      this.toastr.error('Please verify your Email and Mobile')
    }
  }

}
