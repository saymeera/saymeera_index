import { Injectable } from '@angular/core';
import {
  HttpRequest,
  HttpHandler,
  HttpEvent,
  HttpInterceptor
} from '@angular/common/http';
import { catchError, Observable, switchMap, throwError } from 'rxjs';
import { AuthService } from 'src/app/modules/auth/services/auth.service';

@Injectable()
export class AuthInterceptor implements HttpInterceptor {

  constructor(private auth:AuthService) {}

  intercept(request: HttpRequest<unknown>, next: HttpHandler): Observable<HttpEvent<unknown>> {

    const accessToken = this.auth.getAccessToken()
    let authreq = request
    if(accessToken){
      authreq = request.clone({
        setHeaders:{
          Authorization : `Bearer ${accessToken}`
        }
      })
    }

    return next.handle(authreq).pipe(
      catchError(err => {
        if (err.status === 401) {
          return this.auth.refreshAccessToken().pipe(
            switchMap(res => {

              const newReq = request.clone({
                setHeaders: {
                  Authorization: `Bearer ${res.accessToken}`
                }
              });

              return next.handle(newReq);
            }),
            catchError(error => {
              // this.auth.logout();
              return throwError(() => error);
            })
          )
        }
        return throwError(() => err);
      })
    );
  }
}
