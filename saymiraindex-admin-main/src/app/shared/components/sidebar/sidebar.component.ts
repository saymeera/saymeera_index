import { Component, EventEmitter, Output } from '@angular/core';
import { AuthService } from 'src/app/auth/service/auth.service';

@Component({
  selector: 'app-sidebar',
  templateUrl: './sidebar.component.html',
  styleUrls: ['./sidebar.component.scss']
})
export class SidebarComponent {

   active = 'dashboard';
  @Output() menuChange = new EventEmitter<string>();

  constructor(private authService:AuthService){}

  has(permission: string) {
  return this.authService.hasPermissions(permission);
}

  select(tab: string) {
    this.active = tab;
    this.menuChange.emit(tab);
  }
}
