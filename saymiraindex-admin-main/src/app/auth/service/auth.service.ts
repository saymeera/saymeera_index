import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import {HttpClient} from '@angular/common/http'
import { environment } from 'src/environments/environment'; 
import { jwtDecode } from 'jwt-decode';


@Injectable({
  providedIn: 'root'
})
export class AuthService {

  private baseurl = environment.apiUrl
  user:any
  constructor(private http:HttpClient) { }

  loginAdminId():any {
    const token = sessionStorage.getItem('token');
    return token ? jwtDecode(token) : null
  }

  hasPermissions(permission: string):boolean{
    this.user = this.loginAdminId();
    return this.user?.permissions?.includes(permission);
  }

  isSuperAdmin(): boolean {
    return this.loginAdminId()?.role === 'SUPER_ADMIN';
  }

  adminLogin(payload:any):Observable<any>{
    return this.http.post(`${this.baseurl}auth/admin/login`,payload)
  }

  isLoggedIn(): boolean {
     const token = sessionStorage.getItem('token');
     if(!token) return false
     try {
      const decoded: any = jwtDecode(token);
      const isExpired = decoded.exp*1000< Date.now();
      return !isExpired;
     } catch (error) {
      return false;
     }
  }
}
