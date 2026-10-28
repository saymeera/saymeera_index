import { inject } from '@angular/core';
import { CanActivateFn, Router } from '@angular/router';
import { AuthService } from 'src/app/auth/service/auth.service';

export const permissionGuard: CanActivateFn = (route, state) => {
  const authService = inject(AuthService)
  const router: any = inject(Router);
  console.log(route,"router")
  const requiredPermission = route.data?.['permission']

  if (authService.isSuperAdmin()) {
    console.log("check value")
    return true;
  }

  if (requiredPermission && authService.hasPermissions(requiredPermission)) {
    console.log("check value 12")
    return true;
  }
  router.navigate(['/admin/dashboard']); // ya access-denied page
  return false;
};
