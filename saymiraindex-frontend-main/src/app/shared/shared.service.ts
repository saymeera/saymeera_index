import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import {SendMsgResponse} from '../shared/models/auth.model'
import { HttpClient } from '@angular/common/http';
import { environment } from 'src/environment/environment.prod';

@Injectable({
  providedIn: 'root'
})
export class SharedService {
  private baseurl = environment.apiUrl
  constructor(private http:HttpClient) { }

  logout(payload:{refreshToken:string}):Observable<SendMsgResponse>{
    return this.http.post<SendMsgResponse>(`${this.baseurl}auth/logout`,payload)
  }
}
