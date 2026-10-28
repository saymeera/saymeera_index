import { Injectable } from '@angular/core';
import {HttpClient} from '@angular/common/http'
import { Observable, tap } from 'rxjs';
import { environment } from 'src/environment/environment.prod';
import { SendMsgResponse, LoginResponse,RefreshTokenRequest,RefreshTokenResponse, MobileOtpPayload, verifyMobOtp, EmailOtpPayload, verifyMailOtp } from 'src/app/shared/models/auth.model';

@Injectable({
  providedIn: 'root'
})
export class AuthService {

  private baseurl = environment.apiUrl

  constructor(private http:HttpClient) { }

  sendOtp(payload:any):Observable<SendMsgResponse>{
    return this.http.post<SendMsgResponse>(`${this.baseurl}auth/sendloginOtp`,payload);
  }

  login(payload:any):Observable<LoginResponse>{
    return this.http.post<LoginResponse>(`${this.baseurl}auth/verifyloginOtp`,payload).pipe(tap(res=>this.storeAuthData(res)))
  }

  storeAuthData(res:LoginResponse){
    localStorage.setItem('accessToken', res.accessToken);
    localStorage.setItem('refreshToken', res.refreshToken);
  }

  getAccessToken() {
    return localStorage.getItem('accessToken');
  }

  getRefreshToken() {
    return localStorage.getItem('refreshToken');
  }

  refreshAccessToken():Observable<RefreshTokenResponse>{
    const payload:RefreshTokenRequest = {
      refreshToken: this.getRefreshToken()
    }
    return this.http.post<RefreshTokenResponse>(`${this.baseurl}auth/refresh-token`,payload)
    .pipe(
      tap(res =>{
        if(res.accessToken){
        localStorage.setItem('accessToken', res.accessToken)
        }
      }))
  }

  isLoggedIn(): boolean {
    return !!this.getRefreshToken();
  }



  

  register(payload:FormData):Observable<SendMsgResponse>{
    return this.http.post<SendMsgResponse>(`${this.baseurl}auth/register`,payload)
  }

  sendmobOtp(payload:MobileOtpPayload):Observable<SendMsgResponse>{
    return this.http.post<SendMsgResponse>(`${this.baseurl}auth/sendmobOtp`,payload)
  }
  
  verifymobOtp(payload:verifyMobOtp):Observable<SendMsgResponse>{
    return this.http.post<SendMsgResponse>(`${this.baseurl}auth/verifymobOtp`,payload)
  }

  getmailOtp(payload:EmailOtpPayload):Observable<SendMsgResponse>{
    return this.http.post<SendMsgResponse>(`${this.baseurl}auth/sendmailOtp`,payload)
  }

  verifymailOtp(payload:verifyMailOtp):Observable<SendMsgResponse>{
    return this.http.post<SendMsgResponse>(`${this.baseurl}auth/verifyMailOtp`,payload)
  }

}
