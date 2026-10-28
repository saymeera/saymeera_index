import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { environment } from 'src/environments/environment';

@Injectable({
  providedIn: 'root'
})
export class CommonService {
  private baseUrl = environment.apiUrl
  constructor(private http:HttpClient) { }

  // quuiz section

  createNewQuiz(payload:any):Observable<any>{
    return this.http.post(`${this.baseUrl}admin/addquiz`,payload)
  }

  getQuizlist():Observable<any>{
    return this.http.get(`${this.baseUrl}admin/getquizlist`)
  }

  saveQuestion(payload:any):Observable<any>{
    return this.http.post(`${this.baseUrl}admin/addquistion`,payload)
  }

  getDefaultQuizQuestion(payload:any):Observable<any>{
    return this.http.post(`${this.baseUrl}admin/getDefaultQuizQuestion`,payload)
  }

  publishQuiz(payload:any):Observable<any>{
    return this.http.post(`${this.baseUrl}admin/quizpublish`,payload)
  }

  updateQuizBucket(quizid:any,payload:any):Observable<any>{
    return this.http.post(`${this.baseUrl}admin/updatequizbucket/${quizid}`,payload)
  }

  deleteQuizBucket(quizid:any):Observable<any>{
    return this.http.delete(`${this.baseUrl}admin/deletequizbucket/${quizid}`)
  }

  updateQuestion(queId:any,payload:any):Observable<any>{
    return this.http.post(`${this.baseUrl}admin/updatequestion/${queId}`,payload)
  }

  deleteQuestion(queId:any):Observable<any>{
    return this.http.delete(`${this.baseUrl}admin/deletequestion/${queId}`)
  }

  createAdmin(payload:any):Observable<any>{
    return this.http.post(`${this.baseUrl}auth/admin/addAdmin`,payload)
  }

  getAdminUsers():Observable<any>{
    return this.http.get(`${this.baseUrl}auth/admin/getAdminuser`)
  }

  // tips add section

  saveTips(payload:any):Observable<any>{
    return this.http.post(`${this.baseUrl}admin/tips/addtips`,payload)
  }

  getAlltips():Observable<any>{
    return this.http.get(`${this.baseUrl}admin/tips/gettips`)
  }

  updatetips(tipsId:any,payload:any):Observable<any>{
    return this.http.post(`${this.baseUrl}admin/tips/updatetips/${tipsId}`,payload)
  }
}
